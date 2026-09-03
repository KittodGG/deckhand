# Narrative — semi-technical, per audience

The deck exists so a room can make a decision or feel informed. Not so the
engineer can prove the sprint was busy.

## The register: semi-technical

Semi-technical means a manager follows every slide without asking what a word
means, and an engineer in the same room does not feel talked down to. The way
you get both is the **effect-first, mechanism-second** sentence.

```
[what a person can now do or stop worrying about].
[the mechanism, one clause, named in real terms].
```

Examples:

> Approvals no longer die when one approver rejects a step. The flow now stores
> each step's state separately instead of one status field on the parent record.

> Loading the knowledge index dropped from 13 seconds to under a second. The
> query was scanning every chunk; it now hits an index on the document id.

> Attachment uploads accept old Office files and CAD drawings. Conversion runs
> on the server through LibreOffice and LibreDWG before the file is indexed.

What that pattern rules out: a slide that says only "refactored the approval
service", and a slide that says only "improved user experience". The first has
no effect, the second has no mechanism.

Never define a term in a parenthesis on the slide. Either the term is
understandable in context or it belongs in the speaker's mouth, not the slide.

## Depth per audience

**Management / non-technical stakeholders.** They want: is it on track, what
does it cost, what should worry me, what do you need from me. Name technologies
at most once per slide and always attached to an outcome. Money, time, risk, and
headcount are the units they think in. Put open risks on their own slide with
dates, not buried in a bullet.

**Client.** Same as above, plus: scope. Every item maps to something they asked
for, or is explicitly marked as work you chose to do. Never present internal
refactoring as a deliverable. If something they asked for is not done, it gets a
slide, not a footnote.

**Internal engineering team.** Mechanism can lead. Show the actual shape of the
change, the tradeoff you took, and the debt you left behind. File paths and
function names are fine here and nowhere else.

**Mixed room.** Write for the least technical person present and let the
speaker notes carry the depth. The template has a `<aside class="notes">` block
per slide, hidden on screen, visible in print. Put the engineering detail there.

## Language modes

**Full Indonesian.** Every sentence Indonesian. Keep English technical nouns
that have no natural Indonesian equivalent: endpoint, deploy, cache, migration,
commit, query, index, build. Translating them produces something nobody says
out loud.

**Full English.** Straightforward. Watch for translated-Indonesian syntax
sneaking in ("which is where the problem is located").

**Mixed.** Indonesian sentence structure, English technical terms. This is how
the room actually talks, so it usually reads best. Be consistent: pick the
English form for a concept once and keep it for the whole deck. Do not write
"basis data" on slide 4 and "database" on slide 9.

Whatever the mode, headline fragments in Playfair italic must scan naturally in
that language. An English italic accent inside an Indonesian headline is fine
when the word is genuinely borrowed, jarring when it is not.

## Slide-level rules

- One claim per slide. The title states it. Everything else supports it.
- Titles are sentences with a verb, not labels. "Approval survives a rejection"
  beats "Approval Module".
- Maximum six lines of body text on a slide. Past that, split or cut.
- No bullet list longer than four items. Four items with substance beat eight
  fragments.
- Numbers get context: "13s to 175ms" not "faster"; "58 duplicate companies
  merged, 1030 down to 980" not "cleaned up data".
- Every number traceable to the log, a diff, or a measurement you ran.

## Handling bad news

There is always something that slipped. A deck without it is a deck nobody
believes.

Structure: what did not land, why, what it blocks, what happens next and when.
Four sentences, plainly stated, no cushioning. "The staging deploy has been
failing since 24 July because the GitHub billing limit blocks the job from
starting. Nothing merges to staging until the limit is raised. That needs a
billing change from your side; the code is ready."

Do not bury it mid-deck. Late enough that context exists, early enough that
people are still listening: roughly two-thirds through.

## The closing slide

End with the ask. One decision, one approval, one unblocking. A deck that ends
on "thank you" wastes the only moment the room is fully paying attention.
