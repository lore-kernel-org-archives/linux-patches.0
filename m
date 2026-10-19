Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E751538417;
	Mon, 19 Oct 2026 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418664; cv=none; b=AdsOr6r45XydT1+DilJPYXtVAC7uNl70J6DtJWbFKAyDyrk1jc+Qa1wdbkTG6/tH9KfD2fDn4DxyPe2aDrv/fby9WzU/e7UqALQp0OYH6fvTWQn0M31o+aPgZYqm4CJOKPIJH0xjm8JxfxASkGwrrZSrK/qGLT7x+wUjqvSv71E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418664; c=relaxed/simple;
	bh=LE3JPqDGwGhoRfpPz0vwGuQ6HNGK9eJCkU92GHD2l0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPuDMXnCCl1XEzrSmBAz6TrhntYvXTkDXFTwF8z4BSU80i7ikXJBqZ7Acr46HbFWUkveSkVWi6LrbirxHXV3alTRRqYSz+fCMKSWgHcQqg5dd/sAV4FKJGD47YaLa/zlDk72s4PaNupnfdP+/Ik7KkNA1Vg2GUmi+1DmasEtpxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yp6uKwub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yp6uKwub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B031F000C5;
	Mon, 19 Oct 2026 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418662;
	bh=UwV13SqKp8xXq1YdgsdEkpN3Vi9YtAHZxUsmJFad4cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yp6uKwubcXyYDtYYYASynp5rQO//L/3YYkfXk41YhI845aif/mZgjpIlMeyloaLwo
	 SkBLqzi4X1wbq7WYKcQ9wuJmxnuOVPWEFrdxeJsEB53WBYq6z+4qEBTEtAlys66OYm
	 pjvnEg2mURvpckEIS1sBIjKieylGtH1/h+PfmXaozwBj/cCUdKUkChqIojkhPplF3d
	 BunHA3zqvT+6OZa5UkFtdiWxKVTj9KkTD8gAO24WKBAoOUz9nVCgiOI+R7wY0KRuds
	 crz1ebPeI1aR7Kc/8xKKEqGJeCO0BFw0qC6TXKLhRML5Je1q4Tz6XtoCQcX2+gcTJ6
	 DJoLCgM+xQEag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: validate wake packet crypto overhead
Date: Mon, 19 Oct 2026 09:51:39 -0400
Message-ID: <20261019135441.1420968-408-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit c5cb9dd220ba9fdcf4ba485ce3d1d36ca32ac00b ]

Wake packet parsing only accounted for FCS and missed per-key
IV/ICV overhead for protected data frames.

Prevent size underflow and bad packet trimming when
notifications are malformed or truncated.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.e06595623533.Ie09494b7e34e5872b750fd90e325648ee469d0da@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **Linux 7.3.0-rc4**. The iwlwifi MLD WoWLAN path
is present here, and this commit is a real memory-safety plus wake-
packet correctness fix for that path.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iwlwifi/mld]** **[validate]** — account for per-key IV/ICV
when parsing WoWLAN wake packets, and reject truncated/malformed sizes.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (author; long-time iwlwifi developer)
- `Link: https://patch.msgid.link/20260717172958.e06595623533.Ie09494b7e
  34e5872b750fd90e325648ee469d0da@changeid`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (iwlwifi maintainer, committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of Fixes/Cc:stable is expected for this
  review)
- No syzbot / KASAN / user crash tags

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** wake-packet parsing only subtracted FCS (4 bytes). It did not
  add the PTK/GTK IV and ICV lengths for protected data frames.
- **Symptom:** size underflow and incorrect trimming when the firmware
  wake-packet notification is malformed or truncated; userspace can get
  a bad or missing wakeup packet.
- **Version info:** none in the message. Code was introduced with iwlmld
  (`d1e879ec600f9`, v6.15).
- **Root cause (author):** missing per-key crypto overhead in
  `iwl_mld_set_wake_packet()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit validation/correctness fix.
“Validate” plus “prevent size underflow” is a memory-safety fix, not a
cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mld/d3.c` — **+57 / −6**
- New: `struct iwl_mld_wake_pkt_iter_data`,
  `iwl_mld_wake_pkt_key_iter()`
- Modified: `iwl_mld_set_wake_packet()`
- Scope: **single-file surgical fix** in the MLD D3/WoWLAN resume path

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. **Header size:** previously cast `wake_packet` to `ieee80211_hdr`
   with no length check. Now `IWL_FW_CHECK` if `pkt_bufsize <
   sizeof(*hdr)` and return.
2. **Protected data frames:** previously `ivlen = 0`, `icvlen = 4` (FCS
   only). Now, if `ieee80211_has_protected()`, iterate keys and add
   `key->iv_len` / `key->icv_len`.
3. **Before `skb_put_data`:** new check `pkt_bufsize <= hdrlen + ivlen +
   icvlen`; skip copy if the buffer is too small.
4. **Non-data frames:** new check `pkt_bufsize <= fcslen` before
   subtracting FCS.
5. **Types:** `pkt_bufsize` / `expected_pktlen` / `truncated` changed
   from `int` to `u32` so underflow cannot go negative and then be
   passed as a huge `unsigned int` length.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety (OOB / integer underflow) + logic/correctness**

Before, `skb_put_data()` takes `unsigned int len`. A signed
`pkt_bufsize` that goes negative after `pkt_bufsize -= hdrlen` or `-=
ivlen + icvlen` becomes a huge copy. `skb_put()` panics if `hdrlen`
exceeds the skb tailroom (`alloc_skb(pkt_bufsize)` then
`skb_put_data(..., hdrlen)`). Unchecked `hdr->frame_control` is an OOB
read if the firmware buffer is shorter than an 802.11 header.

Missing IV/ICV on protected frames (the common WPA2/WPA3 case) also mis-
trims the packet: `ieee80211_data_to_8023()` can fail, or userspace gets
a corrupted wake packet.

The fix matches the long-standing MVM path in
`drivers/net/wireless/intel/iwlwifi/mvm/d3.c` (IV/ICV from PTK vs GTK,
plus `IWL_FW_CHECK` on size). MLD uses `ieee80211_iter_keys()` because
it does not cache `gtk_ivlen`/`ptk_ivlen` like MVM.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct, minimal, low regression risk.** It copies
proven MVM logic. `ieee80211_iter_keys()` requires the wiphy mutex;
`iwl_mld_wowlan_resume()` already has `lockdep_assert_wiphy()`, and the
same resume path already calls `ieee80211_iter_keys()` in
`iwl_mld_update_sec_keys()`. If no matching key is found, `ivlen` stays
0 and `icvlen` stays 4 — same as the old path. Early return after
`alloc_skb` still sets `*_pkt`, and the caller `kfree_skb()`s it. No
public API change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy `iwl_mld_set_wake_packet()` came in **`d1e879ec600f9`**
(“wifi: iwlwifi: add iwlmld sub-driver”, 2025-02-16). Present since
**v6.15**. Not recent one-off code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introduction commit is `d1e879ec600f9`. `git
merge-base --is-ancestor d1e879ec600f9 HEAD` succeeds. Related later fix
in the same file: `c5aeb11489150` (“fix read in wake packet notification
handler”) is an **ancestor** of this commit and is independent (it only
reorders a length check in `iwl_mld_handle_wake_pkt_notif()`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby D3 validation commits (`validate WoWLAN notif header`,
`validate D3_END notif size`) are separate. This patch is **1/8** of an
iwlwifi-next “updates” series; the other seven patches are unrelated
(scan-abort init, time-sync, BIOS move, MCC v2, etc.). **Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Emmanuel Grumbach is a core iwlwifi author. Same week he also
fixed MVM D3 FCS truncation (`9119aeeddc210`). Miri Korenblit committed
the patch. Strong maintainer provenance.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs existing `IWL_FW_CHECK`, `ieee80211_iter_keys()`, and
`iwl_mld_set_wake_packet()`. All exist in this tree. **Can apply
standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c c5cb9dd220ba9` → https://patch.msgid.link/20260717172958.e0
  6595623533.Ie09494b7e34e5872b750fd90e325648ee469d0da@changeid
- `b4 dig -a`: **v1 only** (`[PATCH iwlwifi-next 1/8]`)
- Cover: “A couple of fixes, features and cleanups.” This patch is one
  of the fixes.
- Saved mbox: **9 messages = cover + 8 patches, no review replies, no
  NAKs, no Cc: stable**
- HTTP lore fetch returned 403 (Anubis); discussion taken from the b4
  mbox instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Miri Korenblit, Johannes Berg
(`johannes@sipsolutions.net`), `linux-wireless@vger.kernel.org`,
Emmanuel Grumbach. Right lists/maintainers. Committed by Korenblit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by:` or bugzilla/syzbot link. Bug is described from
code inspection, not a user crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Mixed 8-patch iwlwifi-next series. This hunk does not depend on
2/8–8/8. Related but independent: `c5aeb11489150` (wake-pkt notif
length), MVM D3 FCS fix `9119aeeddc210`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned **403**. **UNVERIFIED**
whether stable@ already discussed this.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `iwl_mld_wake_pkt_key_iter` (new), `iwl_mld_set_wake_packet`
(modified).

**Step 5.2: TRACE CALLERS**
Record:
- `iwl_mld_set_wake_packet()` ← `iwl_mld_report_wowlan_wakeup()` ←
  `iwl_mld_process_wowlan_status()` ← D3/WoWLAN resume
- Driver resume: `iwl_mld_resume()` → `iwl_mld_wowlan_resume()`
- mac80211: `ieee80211_reconfig()` → `drv_resume()` under
  `lockdep_assert_wiphy()`
- Context: process context on suspend/resume, not hardirq

**Step 5.3: TRACE CALLEES**
Record: `ieee80211_iter_keys`, `ieee80211_hdrlen`,
`ieee80211_has_protected`, `alloc_skb` / `skb_put_data`,
`ieee80211_data_to_8023`, `IWL_FW_CHECK` (log + boolean).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from userspace via WoWLAN (suspend with wowlan
enabled, then a wake packet). Needs `CONFIG_IWLMLD` and
`CONFIG_PM_SLEEP` (`iwlmld-$(CONFIG_PM_SLEEP) += d3.o`). Intel WiFi 7 /
MLD hardware. Not a syscall fuzz path; **laptop suspend/resume**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: MVM `mvm/d3.c` already applied IV/ICV + size check. MLD was a
port that omitted that logic.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Tree is `v7.3-rc4-27-gf0100363d8c37` / `7.3.0-rc4`.
File `drivers/net/wireless/intel/iwlwifi/mld/d3.c` exists. Bug present
from v6.15 (`d1e879ec600f9`) until this fix. `git merge-base --is-
ancestor d1e879ec600f9 HEAD` is true. `v7.2` has MLD but **not** this
fix (`c5cb9dd220ba9` is not an ancestor of `v7.2`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree. Surrounding
`iwl_mld_set_wake_packet()` matches the parent hunk. `IWL_FW_CHECK`
already used in this file.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `c5aeb11489150` is in HEAD (notif length). No alternate fix for
IV/ICV in MLD `set_wake_packet`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **drivers/net/wireless/intel/iwlwifi/mld** — **IMPORTANT** (not
core mm/fs, but a widely used Intel WiFi opmode for current silicon).
WoWLAN is a production laptop path.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: **Active.** Many 2026 iwlwifi mld/mvm firmware-validation fixes.
Mature enough that MVM already had this logic; MLD lagged.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG_IWLMLD=y/m` +
`CONFIG_PM_SLEEP`, Intel MLD firmware devices, WoWLAN users.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- Common functional bug: WoWLAN wakeup by a **protected data frame**
  (typical on WPA2/WPA3). Unprivileged users do not inject firmware
  notifications; they can suspend with wowlan.
- Memory-safety path: truncated/malformed `WOWLAN_WAKE_PKT` notification
  (buggy firmware or short DMA). Intel FW is signed, so this is
  robustness vs. firmware bugs, not a generic local exploit.
- How common: every encrypted wake-packet resume hits the IV/ICV miss;
  overflow needs a short/inconsistent notification.

**Step 8.3: FAILURE MODE SEVERITY**
Record:
- Short buffer + `skb_put_data(hdrlen)` → **skb over-panic / OOB** —
  **HIGH**
- Signed underflow into `skb_put_data` → **memory corruption** —
  **HIGH**
- Unchecked header parse → **OOB read** — **HIGH**
- Wrong/missing wakeup packet to cfg80211 — **MEDIUM** (userspace WoWLAN
  diagnostics)

**Step 8.4: RISK-BENEFIT RATIO**
Record: **Benefit: high** for Intel MLD WoWLAN (crash/corruption
avoided, correct packet). **Risk: low** (one file, ~60 lines, same
pattern as MVM, wiphy lock already held). Ratio favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real underflow/OOB in firmware wake-packet parsing (`skb_put` /
  `memcpy`)
- Protected-frame IV/ICV omitted since iwlmld was added (v6.15)
- Same logic already used and proven in MVM `d3.c`
- Small, one file, no new APIs
- Maintainer-authored and maintainer-committed
- Standalone (1/8 of a mixed series, no deps on the rest)
- Code exists in this 7.3-rc4 tree; `IWL_FW_CHECK` and
  `ieee80211_iter_keys` already used on this path

**AGAINST:**
- No user `Reported-by` / syzbot
- WoWLAN-only; overflow needs a bad/truncated notification
- ~57 lines, new helper (still contained)
- Cover letter mixed fixes with features (this patch itself is a fix)

**UNRESOLVED:**
- lore.kernel.org HTTP 403; no extra review mail beyond the b4 mbox
- Whether stable@ already discussed it

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mirrors MVM; maintainer SOB;
   used `IWL_FW_CHECK` consistently
2. Fixes a real bug that affects users? **PASS** — wrong crypto
   stripping on encrypted wake packets; OOB on short buffers
3. Important issue? **PASS** — skb overflow / underflow is crash or
   memory corruption; HIGH
4. Small and contained? **PASS** — one file, +57/−6
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file and helpers present,
   hunk matches

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc exception). Ordinary
driver bugfix.

**Step 9.4: DECISION**
This tree has the buggy MLD D3 path. The patch is a small, correct fix
for integer underflow and bad wake-packet trimming. It should be applied
here.

---

### What the commit solves for users of this tree

On Intel MLD (WiFi 7) WoWLAN resume, `iwl_mld_set_wake_packet()` treated
every data frame as having only a 4-byte FCS and never skipped 802.11
IV/ICV. Encrypted wake packets were mis-trimmed. Short or inconsistent
firmware notifications could make `pkt_bufsize` go negative (`int`) and
then be passed to `skb_put_data(..., unsigned int)`, or `skb_put` more
than `alloc_skb` reserved — kernel panic or memory corruption. The patch
adds per-key IV/ICV (via `ieee80211_iter_keys`) and `IWL_FW_CHECK` size
guards, matching MVM.

### Risk vs benefit

Low risk: one file, existing primitives, wiphy lock already asserted.
Benefit: avoid resume-path memory corruption and deliver a correct
wakeup packet on encrypted networks.

### Concerns

No external reproducer; trigger for the overflow is a truncated FW
notification. The IV/ICV miss still hits normal encrypted WoWLAN. No
series dependency. Apply is clean on this tree.

---

### Verification
- **[Phase 1]** Parsed commit `c5cb9dd220ba9`: SOB Grumbach + Korenblit;
  Link msgid; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: `mld/d3.c` +57/−6; new key iterator; size checks;
  `int`→`u32`; IV/ICV from `key->iv_len`/`icv_len` (`u8` in
  `ieee80211_key_conf`)
- **[Phase 2]** Confirmed `skb_put_data()` uses `unsigned int len` and
  `skb_put()` (`include/linux/skbuff.h`)
- **[Phase 2]** Compared to `mvm/d3.c` ~1516–1555: same IV/ICV +
  `IWL_FW_CHECK` pattern
- **[Phase 3]** `git blame` on parent: buggy function from
  `d1e879ec600f9` (2025-02-16)
- **[Phase 3]** `git merge-base --is-ancestor d1e879ec600f9 HEAD` true;
  `c5cb9dd220ba9` not in `v7.2`; MLD present from `v6.15`
- **[Phase 3]** `c5aeb11489150` is ancestor, independent notif-length
  fix
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v1 1/8 iwlwifi-next; recipients
  Korenblit/Berg/linux-wireless; mbox has no replies/NAKs
- **[Phase 4]** WebFetch/curl lore: 403 — UNVERIFIED extra
  review/stable@ mail
- **[Phase 5]** Call chain: `ieee80211_reconfig` → `drv_resume` →
  `iwl_mld_wowlan_resume` (`lockdep_assert_wiphy`) →
  `iwl_mld_set_wake_packet`
- **[Phase 5]** `ieee80211_iter_keys` docs: wiphy mutex; already used in
  `iwl_mld_update_sec_keys()`
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`; file present; `d3.o` behind
  `CONFIG_PM_SLEEP`
- **[Phase 7]** `CONFIG_IWLMLD` “Intel Wireless WiFi MLD Firmware
  support”
- **[Phase 8]** Failure mode verified from parent source: no
  `pkt_bufsize < sizeof(*hdr)` check; signed subtract then
  `skb_put_data`

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 63 +++++++++++++++++++--
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 73fd4c69357ca..b75936125b46d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -53,6 +53,30 @@ struct iwl_mld_suspend_key_iter_data {
 	__le32 bigtk_cipher;
 };
 
+struct iwl_mld_wake_pkt_iter_data {
+	bool multicast;
+	u32 ivlen;
+	u32 icvlen;
+};
+
+static void
+iwl_mld_wake_pkt_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key, void *_data)
+{
+	struct iwl_mld_wake_pkt_iter_data *data = _data;
+	bool is_group_key = !sta;
+
+	/* ignore anything that is not a PTK / GTK */
+	if (key->keyidx > 3)
+		return;
+	if (is_group_key != data->multicast)
+		return;
+
+	data->ivlen = key->iv_len;
+	data->icvlen = key->icv_len;
+}
+
 struct iwl_mld_mcast_key_data {
 	u8 key[WOWLAN_KEY_MAX_SIZE];
 	u8 len;
@@ -707,11 +731,17 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			struct cfg80211_wowlan_wakeup *wakeup,
 			struct sk_buff **_pkt)
 {
-	int pkt_bufsize = wowlan_status->wake_packet_bufsize;
-	int expected_pktlen = wowlan_status->wake_packet_length;
+	u32 pkt_bufsize = wowlan_status->wake_packet_bufsize;
+	u32 expected_pktlen = wowlan_status->wake_packet_length;
 	const u8 *pktdata = wowlan_status->wake_packet;
 	const struct ieee80211_hdr *hdr = (const void *)pktdata;
-	int truncated = expected_pktlen - pkt_bufsize;
+	u32 truncated;
+
+	if (IWL_FW_CHECK(mld, pkt_bufsize < sizeof(*hdr),
+			 "pkt_bufsize is too short: %u\n", pkt_bufsize))
+		return;
+
+	truncated = expected_pktlen - pkt_bufsize;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		int hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -722,9 +752,18 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 		if (!pkt)
 			return;
 
-		skb_put_data(pkt, pktdata, hdrlen);
-		pktdata += hdrlen;
-		pkt_bufsize -= hdrlen;
+		if (ieee80211_has_protected(hdr->frame_control)) {
+			struct iwl_mld_wake_pkt_iter_data iter_data = {
+				.multicast =
+					is_multicast_ether_addr(hdr->addr1),
+			};
+
+			ieee80211_iter_keys(mld->hw, vif,
+					    iwl_mld_wake_pkt_key_iter,
+					    &iter_data);
+			ivlen = iter_data.ivlen;
+			icvlen += iter_data.icvlen;
+		}
 
 		/* if truncated, FCS/ICV is (partially) gone */
 		if (truncated >= icvlen) {
@@ -735,6 +774,13 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			truncated = 0;
 		}
 
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= hdrlen + ivlen + icvlen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
+		skb_put_data(pkt, pktdata, hdrlen);
+		pktdata += hdrlen;
+		pkt_bufsize -= hdrlen;
 		pkt_bufsize -= ivlen + icvlen;
 		pktdata += ivlen;
 
@@ -756,6 +802,11 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			fcslen -= truncated;
 			truncated = 0;
 		}
+
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= fcslen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
 		pkt_bufsize -= fcslen;
 		wakeup->packet = wowlan_status->wake_packet;
 		wakeup->packet_present_len = pkt_bufsize;
-- 
2.53.0

