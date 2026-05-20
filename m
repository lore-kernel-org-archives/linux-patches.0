Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BBD3F1ADA;
	Wed, 20 May 2026 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276046; cv=none; b=lXdGoBUUrHrOVulO3rSEOKGNo8eZjhoHc8Tu7NDVWKnWqoo/HFLxmSaaQShkAzWawj0aduKmPV2M9pjBHTZJPel6IPLlBEkCzaMyvoGDEFJPNy/cIIxEgB1unaHgL2OzmGCqF4TQhlth+9zXWiHUxY/j2nQCYqQsClmti6+MRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276046; c=relaxed/simple;
	bh=LfOAwOz8yVnxt7gMco0xSAVndRQYWkX2g2DIigaBpX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdKtPaoLEErgg+48NEXsQjRCwEp6ZaUcQQ75AD4IRbj6yBD1QyVQYzjDms86mS3syJkhKONtwfK8m1VFVx3vFF2Drt+BJOhnuttmEzvBN3eaBKPzKDqny4rYu6RxEVo8WnbEA5wgDYkkx84AZAzZjwDMceo+cVl/P6k/1C1JU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRp/TAaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRp/TAaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A211B1F00894;
	Wed, 20 May 2026 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276044;
	bh=8j0cJMCUXJlGiq8MxJJW1kWEAF8S79W7aKUQS1zE4Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FRp/TAaSxjjGi7+T5/IEYg3xySY0tUEAgPHORpFmPq3URKqwqvaD17SHFz45lVrgs
	 7A4iqufm060RCIrGMCYcHyok7iYtVOwdp1zkW6ITrwnkH8C0FrtZw7oMbpwVWXN6se
	 W5VWdz2d3o5oW06AtKa51rt/+SdOu03eWkkLAphjFhpWECQaFHAlBiJtrTEWXHXGFV
	 4TQ8eSVbMXQ5nbeg8mGaVg8fjGkB6mMsbiIrCkpRcEY5R5/h4zMlLb3nB9w0NkOb9J
	 X71oa+1Yr+m1T2EWFJ6pzqd+g4nT50xCM1yUeRFCQ73SlbBREpUowHRF7fV59ifVue
	 GEAYWPi7/2PbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stanislav Fomichev <sdf.kernel@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	donald.hunter@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] tools/ynl: add missing uapi header deps in Makefile.deps
Date: Wed, 20 May 2026 07:19:14 -0400
Message-ID: <20260520111944.3424570-42-sashal@kernel.org>
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

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 46e9b0224475abc739612ef72c35b7c90211a0c1 ]

ethtool.h includes linux/typelimits.h which is a relatively new header
not yet shipped in most distro kernel-header packages. Without the
explicit entry, the build silently falls through to -idirafter.

dev_energymodel.h is a new YNL family whose uapi header is not in
system paths at all and was missing a CFLAGS entry entirely.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260508204114.205896-2-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit
`46e9b0224475` `tools/ynl: add missing uapi header deps in
Makefile.deps`

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record 1.1: Subsystem `tools/ynl`; action verb `add`; intent is to add
missing YNL uAPI header dependency entries.

Record 1.2: Tags present: `Signed-off-by: Stanislav Fomichev
<sdf@fomichev.me>`, `Link:
https://patch.msgid.link/20260508204114.205896-2-sdf@fomichev.me`,
`Signed-off-by: Jakub Kicinski <kuba@kernel.org>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by`, `Cc: stable`.

Record 1.3: The described problem is incomplete `Makefile.deps`:
`ethtool.h` includes the newer `linux/typelimits.h`, and
`dev_energymodel.h` has a YNL family/spec but no `CFLAGS_dev-
energymodel` entry. Symptom is YNL tools/header dependency build
correctness with distro kernel headers; no crash/security/data-
corruption symptom is described.

Record 1.4: This is a build/tooling correctness fix, not a hidden
runtime bug fix.

### Phase 2: Diff Analysis
Record 2.1: One file changed: `tools/net/ynl/Makefile.deps`, `+3/-1`. No
functions; Makefile variables only. Scope is single-file surgical.

Record 2.2: Before: `ethtool` force-included `ethtool.h`,
`ethtool_netlink.h`, and generated ethtool netlink headers, but not
`typelimits.h`; `dev-energymodel` had no per-family CFLAGS. After:
`typelimits.h` is explicitly force-included before `ethtool.h`, and
`CFLAGS_dev-energymodel` force-includes `dev_energymodel.h`.

Record 2.3: Bug category is build/tooling dependency correctness. It is
not memory safety, locking, refcounting, or runtime logic.

Record 2.4: Fix quality is high: tiny, declarative Makefile-only change.
Regression risk is low for `v7.0.y`; but not suitable unmodified for
older trees lacking `include/uapi/linux/typelimits.h`.

### Phase 3: Git History
Record 3.1: Blame showed the affected `CFLAGS_ethtool` line came from
`46fb3ba95b93`, later ethtool deps from `0bdcfaf84a942`; `get_hdr_inc2`
came from `db6b35cffe59`.

Record 3.2: No `Fixes:` tag, so no target commit to follow.

Record 3.3: Related history includes prior YNL old-header/build fixes:
`db6b35cffe59 tools: ynl: fix build on systems with old kernel headers`,
`0bdcfaf84a942 tools: ynl: add all headers to makefile deps`, and
several YNL family additions.

Record 3.4: Author Stanislav Fomichev has related net/YNL commits; Jakub
Kicinski committed it and is a netdev maintainer.

Record 3.5: Dependency check: `dev_energymodel.h` and `dev-
energymodel.yaml` exist in `v6.19+`; `typelimits.h` and the ethtool
include of it exist in `v7.0+`. The full patch is therefore appropriate
as-is for `v7.0.y`, not for `v6.19.y`.

### Phase 4: Mailing List
Record 4.1: `b4 dig` found the original submission at the provided patch
link. It was `[PATCH net-next 1/2]`.

Record 4.2: `b4 dig -w` showed netdev maintainers/lists were included:
`netdev`, `davem`, `edumazet`, `kuba`, `pabeni`, Donald Hunter, Simon
Horman, and `linux-kernel`.

Record 4.3: No separate bug report, syzbot report, or user crash report
was found. WebFetch of the patch URL was blocked by Anubis, but `b4`
retrieved the lore thread.

Record 4.4: It was part of a 2-patch series. Patch 1 was applied to
`netdev/net.git`; patch 2, the check-deps target, was not applied.
Jakub’s concern was about patch 2 being better as a NIPA check, not
about patch 1.

Record 4.5: No stable-specific discussion or stable nomination found.

### Phase 5: Code Semantic Analysis
Record 5.1: No C functions modified; key Makefile variables are
`CFLAGS_ethtool` and new `CFLAGS_dev-energymodel`.

Record 5.2: `tools/net/ynl/generated/Makefile` uses `$(CFLAGS_$*)` when
compiling `%-user.o`; dry-run confirmed `ethtool-user.o` and `dev-
energymodel-user.o` are affected.

Record 5.3: The YNL generator uses each spec’s `uapi-header`; `dev-
energymodel.yaml` declares `uapi-header: linux/dev_energymodel.h`.

Record 5.4: This is reachable through building generated YNL userspace
protocol objects, not through runtime kernel execution or syscalls.

Record 5.5: Similar pattern exists throughout `Makefile.deps`: YNL
families have explicit `CFLAGS_<family>` entries to force the in-tree
uAPI header and avoid stale/missing system headers.

### Phase 6: Stable Tree Analysis
Record 6.1: `v7.0`/`v7.0.9` contain both prerequisites:
`dev_energymodel.h`, `dev-energymodel.yaml`, `typelimits.h`, and
`ethtool.h` including `typelimits.h`. Older checked tags before `v6.19`
do not contain the dev-energymodel pieces; `v6.19` lacks `typelimits.h`.

Record 6.2: Patch applies cleanly to current `7.0.y` workspace. Backport
difficulty for `v7.0.y`: clean. For `v6.19.y`: needs adjustment or
should not take the `typelimits` hunk.

Record 6.3: No equivalent related fix was found already in
`stable/linux-7.0.y`.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is `tools/net/ynl`, userspace tooling for netlink
YAML-generated helpers. Criticality is peripheral to kernel runtime but
relevant to building kernel tools.

Record 7.2: Subsystem is active; recent history shows several generated
YNL family and Makefile dependency changes.

### Phase 8: Impact And Risk
Record 8.1: Affected users are developers/distributions/build systems
building `tools/net/ynl/generated`, especially with distro kernel-header
packages that lack newer headers.

Record 8.2: Trigger is building generated YNL objects for `ethtool` or
`dev-energymodel`. No unprivileged runtime trigger.

Record 8.3: Failure mode is build/tooling header dependency
inconsistency, not kernel crash or data corruption. Severity: medium as
a tools build fix.

Record 8.4: Benefit is moderate for `v7.0.y` build correctness; risk is
very low because this is a tiny Makefile-only dependency addition. Risk
rises only if applied blindly to older trees missing `typelimits.h`.

### Phase 9: Final Synthesis
Evidence for backporting: small contained build fix; applies cleanly to
`v7.0.y`; fixes incomplete YNL uAPI dependency declarations; netdev
maintainer applied patch 1; no runtime behavior or API change.

Evidence against: no crash/security/data-corruption issue; no stable
nomination; not appropriate unmodified for all older stable trees.

Stable rules: obviously correct yes; fixes a real build/tooling
dependency issue yes; important enough under build-fix exception for
`v7.0.y` yes; small/contained yes; no new API/feature yes; applies to
`v7.0.y` yes.

## Verification
- [Phase 1] `git show 46e9b0224475` verified subject, body, tags,
  author, committer, and `+3/-1` diff.
- [Phase 2] Diff verified only `tools/net/ynl/Makefile.deps` changes.
- [Phase 3] `git blame` and `git log` verified changed-line history and
  related YNL dependency fixes.
- [Phase 4] `b4 dig`, `b4 dig -a`, `b4 dig -w`, and saved mbox verified
  original lore thread, recipients, one revision, and patch 1
  application.
- [Phase 5] `rg`, `git grep`, `ReadFile`, and `make -n` verified how
  `CFLAGS_$*` reaches generated object builds.
- [Phase 6] Tag/ref checks verified affected code in `v7.0.y`; `git
  apply --check` verified clean application to current tree.
- [Phase 8] No runtime reachability was found; impact is limited to
  tools build/header dependency behavior.

Backport this to `v7.0.y`; avoid applying it unmodified to older stable
trees that lack `typelimits.h`.

**YES**

 tools/net/ynl/Makefile.deps | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/Makefile.deps b/tools/net/ynl/Makefile.deps
index 08205f9fc5257..cc53b2f21c444 100644
--- a/tools/net/ynl/Makefile.deps
+++ b/tools/net/ynl/Makefile.deps
@@ -15,9 +15,11 @@ UAPI_PATH:=../../../../include/uapi/
 get_hdr_inc=-D$(1) -include $(UAPI_PATH)/linux/$(2)
 get_hdr_inc2=-D$(1) -D$(2) -include $(UAPI_PATH)/linux/$(3)
 
+CFLAGS_dev-energymodel:=$(call get_hdr_inc,_LINUX_DEV_ENERGYMODEL_H,dev_energymodel.h)
 CFLAGS_devlink:=$(call get_hdr_inc,_LINUX_DEVLINK_H_,devlink.h)
 CFLAGS_dpll:=$(call get_hdr_inc,_LINUX_DPLL_H,dpll.h)
-CFLAGS_ethtool:=$(call get_hdr_inc,_LINUX_ETHTOOL_H,ethtool.h) \
+CFLAGS_ethtool:=$(call get_hdr_inc,_LINUX_TYPELIMITS_H,typelimits.h) \
+	$(call get_hdr_inc,_LINUX_ETHTOOL_H,ethtool.h) \
 	$(call get_hdr_inc,_LINUX_ETHTOOL_NETLINK_H_,ethtool_netlink.h) \
 	$(call get_hdr_inc,_LINUX_ETHTOOL_NETLINK_GENERATED_H,ethtool_netlink_generated.h)
 CFLAGS_handshake:=$(call get_hdr_inc,_LINUX_HANDSHAKE_H,handshake.h)
-- 
2.53.0

