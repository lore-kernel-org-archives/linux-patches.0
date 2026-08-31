Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B5C47F2E3;
	Mon, 31 Aug 2026 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183461; cv=none; b=leiKV9hNWPD06U0Dm05xezrOZp1GNJBLzAR9bsFh85IFz5hoNX5aWsIpURQAZ/CHHlN9eo02nHlG250shee1gtT32L68Vce5fdUV/zNygPqfudqYysr8H/DerqFyBWX1S8j+8stEDVCEia7XLRKrYmkLHf5cAXedH9u6EUYCviM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183461; c=relaxed/simple;
	bh=8VPxtfSlRUHY5G+fPIFqRw1vaMMoRz+Tfff0qauBYzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diJKKzqLn8jEpBybOT2T0cd5TZLyCp+oOBKM0RpUGcG2o48ChaoXk7MhICCrRih1D7A3UU07YtZyQmw8wZoyWciAEnhHD5xSH0XWEWNBDcMtPCtOqGpmWbu0/PugjYtx2J5B+gNTsZTSAwTg4lCR47DsAcgdYyxtAY7IEoAeMnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxV5sCBt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxV5sCBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9538D1F00A3F;
	Mon, 31 Aug 2026 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183459;
	bh=cKW1lC59ijxXc2RsUKC7oPoZoJx3cUcjjgpppx5Ff4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxV5sCBtTQ5AYgl4p50StEfI70d8Aemd+jMfnIhpwPkJmn17EmvryUfWPI7XsLHUh
	 OzxzKLlTrikKdfjUomaLeoed9WUF6OeAkynxsiC/y2OqAckuM1X7fpOlB3olATL6uQ
	 vV8ND2dG0Mr5TPSL15+0B7EGTdMJJYOfmgqJcBYDF87XK66ND5KFbsLeAHF4z8KXXB
	 b+mjiwKgjnY01GSQbDf1F98xxQyC+u8j85/x09oZrmJD8G24vrStbOfaZAWQwkCM+9
	 hfwlVqob89ejKR4VA7oUyy8ZDJ+oT/h2RjoX/Bfc+F5wh+4jihEJsVMvlRg6SBZQkH
	 z0pFuUb1dD/cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Evgenii Burenchev <evg28bur@yandex.ru>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()
Date: Mon, 31 Aug 2026 09:22:17 -0400
Message-ID: <20260831133314.4125787-109-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit 4c653e85857b41a7148917f2628fae1d04a9c251 ]

dev_set_name() may fail and return an error, but its return value
is currently ignored and overwritten by _vdpa_register_device().

Abort device creation if dev_set_name() fails and release the
device reference to avoid continuing with an improperly initialized
struct device.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260226152924.38790-1-evg28bur@yandex.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `vdpa/ifcvf: handle dev_set_name() failure
in ifcvf_vdpa_dev_add()`

**Local tree:** `v6.18.44` (Makefile: VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44)
**Upstream fix commit:** `4c653e85857b41a7148917f2628fae1d04a9c251` (on
`origin/master`, **not** in this checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[vdpa/ifcvf]` `[handle]` — handle `dev_set_name()` failure
in `ifcvf_vdpa_dev_add()`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Evgenii Burenchev `<evg28bur@yandex.ru>` (author)
- **Acked-by:** Jason Wang `<jasowang@redhat.com>` (vDPA maintainer)
- **Acked-by:** Zhu Lingshan `<lingshan.zhu@kernel.org>` (ifcvf
  author/maintainer)
- **Signed-off-by:** Michael S. Tsirkin `<mst@redhat.com>` (vDPA
  maintainer)
- **Message-ID:** `<20260226152924.38790-1-evg28bur@yandex.ru>`
- No `Fixes:` tag (expected for manual review)
- No `Reported-by:` tag
- No `Cc: stable@vger.kernel.org` in commit message (present in patch
  submission recipients)
- Notable: Found by Linux Verification Center (linuxtesting.org) with
  SVACE static analysis

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `dev_set_name()` can return an error, but its return value is
  overwritten by the subsequent `_vdpa_register_device()` call.
- **Symptom:** Device creation continues after a name-setting failure;
  callers may see success when renaming failed, or error codes from
  registration mask the real `dev_set_name()` failure.
- **Root cause:** Missing check between `dev_set_name()` and
  `_vdpa_register_device()`.
- **Fix approach:** Check `dev_set_name()` return value, abort on
  failure, and consolidate cleanup via a shared `err:` label calling
  `put_device()`.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — described as error handling, but it is a real bug fix:
ignored return value on an allocation path (`dev_set_name()` →
`kobject_set_name_vargs()` → `kvasprintf`, which can return `-ENOMEM`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/vdpa/ifcvf/ifcvf_main.c` (+9 / -2 lines)
- **Function modified:** `ifcvf_vdpa_dev_add()`
- **Scope:** Single-file, surgical error-path fix

### Step 2.2: Code flow change per hunk
**Record:**
- **Hunk 1 (after `dev_set_name`):** Before → return value ignored,
  immediately overwritten. After → check `ret`, log error, `goto err`.
- **Hunk 2 (`_vdpa_register_device` failure):** Before → inline
  `put_device()` + `return ret`. After → `goto err` (same cleanup,
  unified path).
- **Hunk 3 (new `err:` label):** `put_device(&adapter->vdpa.dev); return
  ret;`

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path / resource-management fix.
**Mechanism:** `dev_set_name()` failure (typically `-ENOMEM`) was
masked. Without the fix, registration may proceed and return `0` even
when a user-requested rename failed, leaving a device with the auto-
generated name from `vdpa_alloc_device()` instead of the requested name.
The fix aborts creation and releases the device reference via
`put_device()`.

### Step 2.4: Fix quality assessment
**Record:** Obviously correct; mirrors the pattern already used in
`__vdpa_alloc_device()` in `drivers/vdpa/vdpa.c` (lines 160–165).
Minimal diff, no API changes. Regression risk is very low — only adds an
earlier error exit with proper cleanup.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** `dev_set_name()` calls introduced in commit `378b2e956820ff`
(Zhu Lingshan, 2022-07-22, "vDPA/ifcvf: support userspace to query
features and MQ of a management device"). The ignored-return-value
pattern has been present since then. `ifcvf_vdpa_dev_add()` itself dates
to 2020.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: File history for related changes
**Record:** Recent `ifcvf_main.c` changes are feature work (map ops, vq
accessors). No prior fix for this specific issue. Standalone patch (not
part of a series).

### Step 3.4: Author's other commits
**Record:** Evgenii Burenchev has no other commits in `drivers/vdpa/` in
this tree. This appears to be a one-off static-analysis-driven fix,
acked by subsystem maintainers.

### Step 3.5: Dependencies
**Record:** No dependencies. Self-contained; uses existing
`put_device()` / `IFCVF_ERR()` patterns. `git apply --check` against
upstream patch succeeds on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c 4c653e85857b4` →
https://patch.msgid.link/20260226152924.38790-1-evg28bur@yandex.ru
Single v1 patch, no revisions. Thread saved to
`/tmp/ifcvf_dev_set_name.mbox`.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` recipients include `stable@vger.kernel.org`,
Greg Kroah-Hartman, Jason Wang, Zhu Lingshan, Michael Tsirkin,
virtualization@lists.linux.dev. Zhu Lingshan and Jason Wang both Acked-
by on the thread.

### Step 4.3: Bug report
**Record:** Found by SVACE static analysis (Linux Verification Center).
No syzbot/KASAN report, no user crash report. Failure mode is `-ENOMEM`
on name allocation under memory pressure.

### Step 4.4: Related patches
**Record:** `octep_vdpa_main.c` has the same unchecked pattern (lines
557–561), but that is out of scope for this commit. `vduse_dev.c`
already checks `dev_set_name()` failure correctly.

### Step 4.5: Stable mailing list history
**Record:** Patch was submitted with `Cc: stable@vger.kernel.org`. Zhu
Lingshan replied on the stable list with Acked-by. No NAKs found in the
mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `ifcvf_vdpa_dev_add()` only.

### Step 5.2: Trace callers
**Record:** `ifcvf_vdpa_dev_add` is registered as `.dev_add` in
`ifcvf_vdpa_mgmt_dev_ops` (line 758). Called from
`vdpa_nl_cmd_dev_set_doit()` in `drivers/vdpa/vdpa.c` (line 663) under
`vdpa_dev_lock`, triggered by netlink when userspace creates a vDPA
device on an IFCVF management device.

### Step 5.3: Trace callees
**Record:** `vdpa_alloc_device()` (already calls `dev_set_name()` once
with auto name), `dev_set_name()` (may return `-ENOMEM`),
`_vdpa_register_device()` → `device_add()`, `put_device()` →
`vdpa_release_dev()` → `kfree()`.

### Step 5.4: Call chain / reachability
**Record:** Userspace (CAP_NET_ADMIN) → netlink `VDPA_CMD_DEV_NEW` →
`vdpa_nl_cmd_dev_set_doit()` → `ifcvf_vdpa_dev_add()`. Reachable from
userspace on systems with `CONFIG_IFCVF` and IFCVF hardware present.

### Step 5.5: Similar patterns
**Record:** `__vdpa_alloc_device()` correctly checks `dev_set_name()`
failure (vdpa.c:164–165). ifcvf redundantly calls `dev_set_name()` again
in `dev_add()` to apply a user-provided name — that second call was
unchecked.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** In `drivers/vdpa/ifcvf/ifcvf_main.c` lines 733–738,
`dev_set_name()` return value is immediately overwritten by
`_vdpa_register_device()`. Bug present since 2022 in this tree. Fix
commit `4c653e85857b4` is **not** an ancestor of HEAD.

### Step 6.2: Backport complications
**Record:** Clean apply verified (`git apply --check` passes). No
refactoring conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found in this tree (`git grep` for this
subject returned nothing).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** **Subsystem:** `drivers/vdpa/ifcvf` (Intel IFC VF vDPA
driver). **Criticality:** PERIPHERAL — hardware-specific, `CONFIG_IFCVF`
tristate module.

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y (recent commits for map ops,
vq accessors, MODULE_DESCRIPTION). Driver has been in-tree since ~2020.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Intel IFC VF vDPA hardware who create vDPA devices
via netlink. Config-specific (`CONFIG_IFCVF`), not universal.

### Step 8.2: Trigger conditions
**Record:** `dev_set_name()` fails (typically `-ENOMEM` under memory
pressure) during device creation with a user-specified name. Uncommon
but realistic. Requires `CAP_NET_ADMIN` to trigger the netlink path.

### Step 8.3: Failure mode severity
**Record:** Without fix: silent success with wrong device name, or
masked error code. Not a crash, UAF, or data corruption in the analyzed
path. **Severity: MEDIUM** (incorrect error handling / improper device
state reporting). Resource cleanup on `dev_set_name()` failure is also
incorrect without the fix — registration is attempted instead of
aborting with `put_device()`.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** MEDIUM — correct error propagation and cleanup on a real,
  reachable error path; maintainer-approved.
- **Risk:** VERY LOW — 9-line localized change, no behavior change on
  success path.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real bug: ignored `dev_set_name()` return value (verified in tree)
- Small, surgical, obviously correct fix
- Acked by Jason Wang and Zhu Lingshan (subsystem maintainers)
- Submitted to stable list with maintainer ack
- Applies cleanly to v6.18.44
- Found by static analysis (SVACE) — legitimate defect pattern
- Matches established pattern in core vDPA code

**AGAINST backport:**
- Failure requires memory pressure (`-ENOMEM`) — rare
- No crash, security issue, or data corruption demonstrated
- Niche driver (`CONFIG_IFCVF`, Intel IFC VF hardware only)
- Impact is incorrect error reporting / masked failure, not system
  instability

**Unresolved:** No runtime crash report or user-reported production
incident.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer acked; no Tested-by but pattern is standard.
2. Fixes a real bug? **PASS** — ignored error return on allocation path.
3. Important issue? **PASS (borderline)** — error-path resource
   management on a userspace-reachable path; not crash-level but real
   defect with incorrect success reporting.
4. Small and contained? **PASS** — 1 file, 9 lines added.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception categories
**Record:** N/A — not a device ID, quirk, DT, build fix, or
documentation fix. Standard error-handling bug fix.

### Step 9.4: Decision rationale

For **v6.18.44**, the buggy code is present, the driver is supported,
and the fix is minimal and maintainer-endorsed. While severity is
moderate rather than critical, this is exactly the kind of small,
obviously-correct error-path fix stable trees routinely accept —
especially with maintainer acks and stable-list nomination. The fix
prevents masking `dev_set_name()` failures and ensures proper
`put_device()` cleanup when renaming fails, rather than proceeding to
registration with an improperly set name.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified SVACE static-analysis
  origin
- [Phase 1] Confirmed no `Fixes:` tag; ignored pipeline SOB markers per
  instructions
- [Phase 2] Read diff: +9/-2 lines in `ifcvf_vdpa_dev_add()`, unified
  `err:` cleanup
- [Phase 2] Read `dev_set_name()` in `drivers/base/core.c:3553-3561` —
  returns `kobject_set_name_vargs()` error
- [Phase 2] Read `kobject_set_name_vargs()` in `lib/kobject.c:266-296` —
  returns `-ENOMEM` on allocation failure
- [Phase 3] `git blame`: `dev_set_name` calls introduced in
  `378b2e956820ff` (2022-07-22)
- [Phase 3] `git log -20 -- drivers/vdpa/ifcvf/ifcvf_main.c`: no prior
  fix for this issue
- [Phase 3] `git apply --check` on upstream patch: **passes cleanly**
- [Phase 4] `b4 dig -c 4c653e85857b4`: lore URL found
- [Phase 4] `b4 dig -w`: stable@vger.kernel.org CC'd; maintainers on
  recipient list
- [Phase 4] `b4 dig -a`: single v1 patch, no later revisions
- [Phase 4] `b4 dig -m /tmp/ifcvf_dev_set_name.mbox`: Zhu Lingshan
  Acked-by on stable thread; Jason Wang Acked-by in thread
- [Phase 5] Traced caller: `vdpa_nl_cmd_dev_set_doit()` →
  `mdev->ops->dev_add()` at `vdpa.c:663`
- [Phase 5] Compared with `__vdpa_alloc_device()` error handling at
  `vdpa.c:160-165`
- [Phase 5] Found same unchecked pattern in `octep_vdpa_main.c:557-561`
  (separate driver)
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Confirmed buggy code at `ifcvf_main.c:733-738` in current
  checkout
- [Phase 6] `git merge-base --is-ancestor 4c653e85857b4 HEAD`: exit 1 —
  fix **not** in tree
- [Phase 6] `git merge-base --is-ancestor 378b2e956820ff HEAD`: buggy
  code **is** in tree
- [Phase 7] `CONFIG_IFCVF` exists in `drivers/vdpa/Kconfig:44-51`
- [Phase 8] Failure mode: `-ENOMEM` on rename, masked error / silent
  wrong name; severity MEDIUM

**YES**

 drivers/vdpa/ifcvf/ifcvf_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 6658dc74d9150..56ed03dc918db 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -734,15 +734,22 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 		ret = dev_set_name(&vdpa_dev->dev, "%s", name);
 	else
 		ret = dev_set_name(&vdpa_dev->dev, "vdpa%u", vdpa_dev->index);
+	if (ret) {
+		IFCVF_ERR(pdev, "Failed to set device name");
+		goto err;
+	}
 
 	ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
 	if (ret) {
-		put_device(&adapter->vdpa.dev);
 		IFCVF_ERR(pdev, "Failed to register to vDPA bus");
-		return ret;
+		goto err;
 	}
 
 	return 0;
+
+err:
+	put_device(&adapter->vdpa.dev);
+	return ret;
 }
 
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
-- 
2.53.0

