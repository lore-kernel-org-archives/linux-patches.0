Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20273ED3C1;
	Wed, 20 May 2026 11:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276032; cv=none; b=rYKXclA7cuSxCEheSMIZR7TVGRMJaGf3xFXK7PcwlzMwTkUAUUwm1/lGjnz7LSojvRFHhcMPlh8hHM/exY9VkptdPQbxww7CN/4LaexdvWnjI12xUUvl8BoQWIfdJ95HBRBWRASDsoCcbJKyUJ/YMaucNZxnZCanYX4YfLJS0FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276032; c=relaxed/simple;
	bh=6G8mJUruCA7qk3la4XjD6mES1+LbZxcjEMGxXtoDUQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=euQYRDxhylRV+I46NiAsYSgyR80FzF7QMRAikTBySv+rg2m3xqHAscV48aatN2mg60pk+MOgXCKZAJGUDY4SOVp5RQbDy4bGePLHB71dUuW2XHizXoWs+slFWJsZgGX9L9jjUZyQdPoqAZOdl544dxxoQMVlswOGXYePAlCktXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur9V40zZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur9V40zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA101F00897;
	Wed, 20 May 2026 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276030;
	bh=ytUTrqgPtCXZ91Xi5mCBiWhz2KSy2GNakoWUqvng6so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ur9V40zZMiYAKdlT/lKKN5blp+ZTHZyIm/Q0hFYKWfvacgXggxMpCxyZifgt3Sv5q
	 W/rIIk/D0VNUtf3VmTUtn+SqQCgMNVHzIjzoB11EV1VEb+FIn9e2WJZJPsN3uNRXit
	 XHsv8u1Iu4v1ZXOI5RQSlpCwqft9GXsbQmZeVPbRXKEGHBBSI2CXoZL2sKWv9CxtCf
	 vaed2olmyL8cEXAABShURhBW/PeEgxPmR5pSMPc1BYLftSUK+hCIQ+35l0WCXDWS6f
	 1qt6Vd/EoPOjmj3TWf8IzIddChoIC8wj6T8a1NE5vnkinR6jGa0PE0Fosh/m1UzuEg
	 VDahAGp16fbMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ninad Naik <ninadnaik07@gmail.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] Documentation: kvm: update links in the references section of AMD Memory Encryption
Date: Wed, 20 May 2026 07:19:04 -0400
Message-ID: <20260520111944.3424570-32-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ninad Naik <ninadnaik07@gmail.com>

[ Upstream commit 80f4a7b8ce7513c203562191426e4d4cc635b095 ]

Replace non-working links in the reference section with the working ones.

Signed-off-by: Ninad Naik <ninadnaik07@gmail.com>
Link: https://patch.msgid.link/20260511174302.811918-1-ninadnaik07@gmail.com/
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: Subsystem `Documentation: kvm`; action verb `update` /
body verb `Replace`; intent is to replace non-working AMD Memory
Encryption reference links with working links.

Step 1.2 Record: Tags found: `Signed-off-by: Ninad Naik
<ninadnaik07@gmail.com>`, `Link: https://patch.msgid.link/20260511174302
.811918-1-ninadnaik07@gmail.com/`, `Reviewed-by: Liam Merwick
<liam.merwick@oracle.com>`, `Signed-off-by: Paolo Bonzini
<pbonzini@redhat.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Acked-by:`, or `Cc: stable@vger.kernel.org`.

Step 1.3 Record: The commit body describes a documentation issue only:
reference links in `Documentation/virt/kvm/x86/amd-memory-
encryption.rst` no longer work as intended. The user-visible symptom is
stale/broken documentation references for AMD SEV/SEV-SNP material. No
runtime failure, crash, data corruption, or kernel version note is
described.

Step 1.4 Record: This is not a hidden runtime bug fix. It is a direct
documentation fix, which is an allowed stable exception category due to
zero runtime risk.

## Phase 2: Diff Analysis

Step 2.1 Record: One file changed: `Documentation/virt/kvm/x86/amd-
memory-encryption.rst`, 4 insertions and 4 deletions. No functions are
modified. Scope classification: single-file surgical documentation
update.

Step 2.2 Record: Before, four reference labels pointed to older AMD
URLs. After, those labels point to current AMD Technical Information
Portal URLs, and the SNP firmware ABI reference points to a current AMD
PDF path. Only the `References` section is affected.

Step 2.3 Record: Bug category is documentation correctness, specifically
stale external references. No synchronization, memory safety, reference
counting, initialization, type, logic, or hardware workaround code is
involved.

Step 2.4 Record: Fix quality is high: the diff only swaps URL strings,
preserves labels, and does not touch kernel code or public APIs.
Regression risk is effectively limited to the possibility of choosing a
less useful URL, not runtime behavior.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` on the reference section showed the white-
paper line came from `fbabc2eaef9fd7` in v6.3-rc1, the SNP firmware ABI
line came from `136d8bc931c84f` in v6.11-rc1, and older reference lines
are present in stable branches back to at least `v5.15` by direct branch
grep. Some blame output for pre-rename lines hit a boundary attribution,
so I did not rely on that boundary commit as the true source.

Step 3.2 Record: No `Fixes:` tag is present, so there is no specific
introducing commit to follow.

Step 3.3 Record: Recent file history on `origin/master` includes KVM
SEV/SNP documentation and API additions, including `20c3c4108d58f`,
`dcbcc2323c806`, `ad27ce155566f`, `dee5a47cc7a45`, and `136d8bc931c84f`.
The candidate is standalone because it only changes URL strings and does
not depend on those code/API changes to be meaningful where the same
reference lines exist.

Step 3.4 Record: `git log --author='Ninad Naik'` showed this author has
other documentation link/spelling style commits, including
`a362ae6e7e85b` for `amd-pstate` dead links and `5ed26ffe57ffc` for a
`hwmon` link. I did not verify the author as a KVM maintainer; Paolo
Bonzini committed/applied it and Liam Merwick reviewed it.

Step 3.5 Record: No code symbols or function dependencies exist. The
patch can apply standalone where the same documentation reference block
exists; older stable branches may need context/path adjustments.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 80f4a7b8ce751` found the original patch
thread at `https://patch.msgid.link/20260511174302.811918-1-
ninadnaik07@gmail.com`. `b4 dig -a` found only v1; `b4 am -c` found no
newer revision.

Step 4.2 Record: `b4 dig -w` showed the patch was sent to KVM and docs
maintainers/lists, including Paolo Bonzini, Jonathan Corbet, Sean
Christopherson, Michael Roth, Liam Merwick, `kvm@vger.kernel.org`, and
`linux-doc@vger.kernel.org`.

Step 4.3 Record: There is no separate bug report or reporter tag. The
thread contains Liam Merwick’s `Reviewed-by` and Paolo Bonzini’s
“Applied, thanks.” I found no NAKs or concerns in the fetched thread.

Step 4.4 Record: The patch is a one-patch series. No related required
patches were identified.

Step 4.5 Record: Web search did not find stable-specific discussion for
this exact subject/hash. Direct WebFetch of lore stable search was
blocked by Anubis, so stable-list search is partially unverified.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: No functions are modified.

Step 5.2 Record: No callers exist because this is documentation.
Documentation references to this file exist from
`Documentation/virt/kvm/api.rst`, `Documentation/admin-guide/kernel-
parameters.txt`, `Documentation/virt/kvm/x86/index.rst`, and related
documentation pages.

Step 5.3 Record: No callees exist. The changed labels are consumed by
Sphinx/ReST documentation rendering.

Step 5.4 Record: No runtime call chain exists. User impact is
documentation usability for KVM SEV/SEV-SNP developers/users.

Step 5.5 Record: Similar pattern exists in prior documentation link
fixes, including `fbabc2eaef9fd7` for an AMD memory encryption white-
paper URL and `bad0524e24201` for an x86 SEV documentation URL.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: Stable branches contain affected references.
`stable/linux-5.15.y` and `stable/linux-6.1.y` contain the old KVM AMD
memory encryption doc with three AMD references. `stable/linux-6.6.y`
contains the three current old references. `stable/linux-6.12.y` through
`stable/linux-7.0.y` contain all four references, including the SNP
firmware ABI link.

Step 6.2 Record: Backport difficulty is clean for the current
`linux-7.0.y`-based tree: `git apply --check` succeeded. Older trees
likely need small manual adjustment: `5.15.y` uses the pre-`x86/` path,
`5.15.y`/`6.1.y` have an older white-paper URL, and `6.6.y` lacks the
SNP firmware ABI line.

Step 6.3 Record: `stable/linux-7.0.y` does not contain this candidate
commit by subject. I found prior related doc-link fixes, but not this
exact KVM reference update in stable branches checked.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: Subsystem is KVM x86 documentation for AMD SEV/SEV-SNP.
Criticality is peripheral for runtime kernel stability, but relevant to
KVM confidential-computing documentation users.

Step 7.2 Record: File history shows active KVM SEV/SNP documentation
churn due to recent SEV-SNP commands and API documentation. The touched
change itself is isolated documentation.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: Affected population is documentation users, especially
KVM/SEV/SEV-SNP developers and operators consulting AMD specs from
stable kernel docs.

Step 8.2 Record: Trigger condition is reading the documentation
references. It is not syscall- or runtime-triggered, and unprivileged
runtime triggering is not applicable.

Step 8.3 Record: Failure mode is stale/non-direct documentation links.
Severity is LOW for runtime stability, but valid under the
documentation-fix exception.

Step 8.4 Record: Benefit is modest but real: stable documentation points
users at current AMD references. Risk is very low: 4 URL replacements in
one `.rst` file, no code, no ABI, no behavior change. Risk-benefit ratio
is favorable because runtime regression risk is effectively zero.

## Phase 9: Final Synthesis

Step 9.1 Record: Evidence for backporting: documentation fix exception
applies; patch is tiny; reviewed; applied by KVM maintainer Paolo
Bonzini; no NAKs found; affected references exist in stable trees;
current `7.0.y` patch application check succeeds. Evidence against: no
runtime bug, no crash/security/data-loss impact, and older stable
branches need minor backport adjustment. Unresolved: lore stable search
was blocked by Anubis, so I could not fully verify stable-list
discussion.

Step 9.2 Record: Stable rules checklist: obviously correct and reviewed:
yes; fixes a real issue: yes, stale documentation references; important
runtime issue: no, but documentation fixes are an allowed exception;
small and contained: yes, 4 lines changed in one file; no new
features/APIs: yes; can apply to stable: yes for current `7.0.y`, likely
clean for `6.12.y+`, minor adjustment for older branches.

Step 9.3 Record: Exception category: documentation fix. This is
explicitly the kind of zero-runtime-risk update that can be accepted
even though it is not a runtime correctness fix.

Step 9.4 Record: Decision is YES. Backporting is appropriate for stable
trees that carry the affected documentation, with minor manual
adjustment where older branch context differs.

## Verification

- [Phase 1] `git show --format=fuller --stat --patch 80f4a7b8ce751`:
  confirmed subject, tags, one-file documentation diff, and no runtime-
  code changes.
- [Phase 2] Diff inspection: confirmed 4 URL replacements only in
  `Documentation/virt/kvm/x86/amd-memory-encryption.rst`.
- [Phase 3] `git blame -L 652,664`: confirmed local history for the
  reference block, including `fbabc2eaef9fd7` and `136d8bc931c84f`.
- [Phase 3] `git describe --contains`: confirmed `fbabc2eaef9fd7` first
  appears by v6.3-rc1 and `136d8bc931c84f` by v6.11-rc1.
- [Phase 3] `git log origin/master --oneline -20 --
  Documentation/virt/kvm/x86/amd-memory-encryption.rst`: confirmed
  recent KVM SEV/SNP doc history and candidate placement.
- [Phase 4] `b4 dig -c 80f4a7b8ce751`: found original patch thread by
  patch-id.
- [Phase 4] `b4 dig -c 80f4a7b8ce751 -a`: confirmed only v1 series.
- [Phase 4] `b4 dig -c 80f4a7b8ce751 -w`: confirmed KVM/docs maintainers
  and lists were included.
- [Phase 4] `b4 mbox`/saved thread plus `rg`: confirmed `Reviewed-by:
  Liam Merwick` and Paolo’s “Applied, thanks”; found no NAK/stable
  request text.
- [Phase 4] WebFetch of lore/patch URLs was blocked by Anubis; b4
  successfully fetched the thread.
- [Phase 5] `rg` in the doc file: confirmed changed labels are
  referenced by SEV/SNP documentation text.
- [Phase 5] `rg` under `Documentation`: confirmed documentation pages
  link to `amd-memory-encryption.rst`.
- [Phase 6] `git grep` across `stable/linux-5.15.y`, `6.1.y`, `6.6.y`,
  `6.12.y`, `6.15.y`, `6.16.y`, `6.17.y`, `6.18.y`, `6.19.y`, and
  `7.0.y`: confirmed affected old references exist and identified branch
  differences.
- [Phase 6] `git diff 80f4a7b8ce751^ 80f4a7b8ce751 | git apply --check`:
  confirmed clean application to the current `7.0.y`-based working tree.
- [Phase 8] URL checks with Python HEAD/WebFetch: confirmed old direct
  AMD URLs no longer behave as direct PDF references in several cases,
  while the new SNP ABI URL returns an AMD PDF; other new AMD TIP URLs
  resolve to AMD documentation portal pages.
- UNVERIFIED: full stable mailing-list history, because direct lore
  stable WebFetch was blocked by Anubis and web search found no exact
  stable discussion.

**YES**

 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index b2395dd4769de..bd04a908a8dbd 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -656,8 +656,8 @@ References
 See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi]_
 for more info.
 
-.. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
-.. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
-.. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
+.. [white-paper] https://docs.amd.com/v/u/en-US/memory-encryption-white-paper
+.. [api-spec] https://docs.amd.com/v/u/en-US/55766_PUB_3.24_SEV_API
+.. [amd-apm] https://docs.amd.com/v/u/en-US/24593_3.44_APM_Vol2 (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
-.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
+.. [snp-fw-abi] https://www.amd.com/content/dam/amd/en/documents/developer/56860.pdf
-- 
2.53.0

