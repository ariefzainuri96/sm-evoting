import { VoteCast } from '../generated/Evoting/Evoting';
import { Vote } from '../generated/schema';

export function handleVoteCast(event: VoteCast): void {
    let vote = new Vote(event.transaction.hash.toHex());

    vote.voter = event.params.voter;
    vote.voteId = event.params.voteId;
    vote.timestamp = event.block.timestamp;

    vote.save();
}
