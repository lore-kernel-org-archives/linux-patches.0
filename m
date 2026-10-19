Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79E856F596;
	Mon, 19 Oct 2026 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418292; cv=none; b=RpOllWfsCC6VsdWr4LZ3lAJQ6JniksUBLDOqqvNbhpfNtCvuprk66BwzQq302eGV8IfrhrPURKJrL4fnxl5DXszzqJck5nGUy19YAh/nmh9jd0ALrH43WQbDgx6guKzWHOn1AbWOAqw3BrrRLY07Ngrzs/rRuWhEuEkT2Hr5FhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418292; c=relaxed/simple;
	bh=YpOkIw5PdAs/6BqswdxjKokAVxgcEM9k62TOVOhU4YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRhgq0bLmamgrWxJvJPDljJpBYwKxJvg2y5dNTwKzIzlf9A842kcnW0UG0lEtzdjQgtKSbWg5TN5YKiIHmSbMmVGmIkhmhadcyrplDQwtlWNs5g3mvCLXUODOkI7H2qB+U/ILw2aUS2RXiAo0Ag5J85ek8pMgPmJy91dQg6kb4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdsDWIpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdsDWIpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C9F1F000C4;
	Mon, 19 Oct 2026 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418289;
	bh=g4t47SO9W2O0FAJkfkLRuHHaB72xfpzSs9Rvl8v0L8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdsDWIpE6/zvamRRqNIIjmMNHSyHcm3+rlDTpchawC+QqejzjlTc/QkWs1OC6g/eX
	 dPhndyD6HAzfJ1wJXSbJcjwJmh/eW8bYen+HvCYDZi6iugYT4wm6Bd5hsYplXkfD/5
	 z2apziAt8r9JgXT0kyqU0u14Ml+VNGwoAIuQr3i69ovRTQGGkq+9yEzu5wx3aNVlEG
	 /lEF6AzquW5aYpk0FdWrhxTh4CFjkRWm58GZnLKzZG3KMgTzDvwczWcDWBL/kAP0/q
	 Mjso0AMC9Ri0m1CF+LBLq356Dy3WXsp3FEVSCuxtpDW7LuxDa+m2CEEm3qdb4Dayv2
	 caj1r9jSUPHqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO
Date: Mon, 19 Oct 2026 09:47:13 -0400
Message-ID: <20261019135441.1420968-142-sashal@kernel.org>
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

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 03a963f4aeda538acad50806e94ef25d95b78743 ]

Some MLO APs expect WoWLAN ARP response frames to be transmitted as
QoS data frames and may discard frames that do not contain a QoS
Control field.

Add a QoS Control field and use the QoS Data subtype when generating
WoWLAN ARP responses for MLD vifs. Keep the existing frame format
unchanged for non-MLO connections.

This allows WoWLAN ARP responses to be accepted by MLO APs while
preserving compatibility with legacy APs.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260625061545.44808-10-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[wifi: rtw89: wow:] [add] [QoS Control field on WoWLAN ARP
responses for MLO]**
Subsystem is Realtek rtw89 WoWLAN. The verb is “add”, but the body is
interoperability: MLO APs drop ARP frames that are not QoS Data.

**Step 1.2: Tags**
Record:
- Signed-off-by: Chin-Yen Lee \<timlee@realtek.com\> (author)
- Signed-off-by: Ping-Ke Shih \<pkshih@realtek.com\> (rtw89 maintainer)
- Link:
  https://patch.msgid.link/20260625061545.44808-10-pkshih@realtek.com
  (msgid `…44808-10…` → patch 09/10 of a 10-patch `rtw-next` series;
  1-based msgid index)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected here)
- Ignore pipeline SOBs such as Sasha Levin (none on the real commit)

**Step 1.3: Body**
Record:
- **Bug:** Some MLO APs require WoWLAN ARP responses as QoS Data and
  discard frames without a QoS Control field.
- **Symptom:** ARP keep-alive / ARP offload during WoWLAN is ignored →
  AP can drop the STA while suspend/WoWLAN is active.
- **Root cause:** `rtw89_arp_response_get()` always built a non-QoS Data
  3-address frame.
- **Fix:** For MLD vifs, set `IEEE80211_STYPE_QOS_DATA` and insert a
  2-byte QoS Control field; leave non-MLO frames unchanged.
- **Versions:** none named in the message.

**Step 1.4: Hidden bug fix?**
Record: Yes. “Add QoS control field” is a protocol-format fix for an
existing WoWLAN ARP template, not a new userspace API. Cover letter
language (“support WoWLAN with MLO AP”) is feature-ish, but the driver
already had MLO WoWLAN and ARP offload/keep-alive; this corrects the
template those paths upload.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/net/wireless/realtek/rtw89/fw.c` (+24 / −7; `git show
  --stat` matches)
- Function: `rtw89_arp_response_get()` only
- Scope: single-file, single-function, surgical

**Step 2.2: Control flow**
Record (before → after):
- Allocate skb sized for 3-addr header + security header + ARP body →
  also reserve 2 bytes when `ieee80211_vif_is_mld(vif)`.
- Frame control: Data+ToDS (+Protected if PTK) → same, plus QoS Data
  subtype for MLO, Data subtype for legacy.
- Always `skb_put_zero(sec_hdr_len)` → insert QoS Control (zeros) before
  IV if MLO; skip security bytes when `sec_hdr_len == 0` (equivalent to
  `skb_put_zero(0)`).
- Debug print via `str_yes_no(with_qos)`.

802.11 order is correct: 3-addr MAC header, QoS Control, IV, LLC+ARP.
QoS Control of 0 is TID 0 / normal ACK, which is appropriate for ARP.

**Step 2.3: Bug mechanism**
Record: **Logic / protocol correctness + hardware interoperability.**
MLO (802.11be) APs expect QoS Data; non-QoS keep-alive/offload templates
are discarded. Not UAF, leak, race, or NULL deref.

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. Non-MLO path is unchanged in
substance (`IEEE80211_STYPE_DATA` is 0). Regression risk is low and
confined to MLO WoWLAN ARP: a wrong QoS field could still be dropped,
but zeroed QoS Control is the standard default. No public API or struct
layout change.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Function introduced in `58ed86e1666b3` (“wifi: rtw89: wow: add ARP
  offload feature”, 2024-05-02) — contained in `v6.11-rc1` era (`git
  describe --contains` → `x86_boot_for_v6.11_rc1~…`).
- Link-aware `rtwvif_link` args: `2f7dae17c48cd1` (2024-09).
- Security header: `0065199f4303bc` (2024-06).
- Keep-alive uses this template: `dcf5c7262bffa` (2026-05-25, in
  **v7.2-rc1**).
- MLD MAC in ARP: parent `76edcedda6437` (same series 08/10).
- This commit: `03a963f4aeda5`, **contained in v7.3-rc1**.

**Step 3.2: Fixes: tag**
Record: None. Buggy behavior is the original ARP template never emitting
QoS Data for MLD vifs after MLO WoWLAN existed.

**Step 3.3: Related file history**
Record: Same-day series (msgid `20260625061545.44808-*`):
1. MAC finish active TX
2. pass chip version to FW
3. lower UDM1 debug level
4. drop pkt offload on H2C failure
5. disable sniffer RX filter (Wi-Fi 7)
6. PCI phy error / refclk
7. LPS MLO link ID fix
8. **MLD address in WoWLAN ARP** (parent)
9. **this patch**
10. RF init only on Wi-Fi 6 in WoW

This patch does not call or require patches 1–8/10. 08/10 only changes
ARP hw addresses; 09/10 only changes frame control + QoS bytes.
Standalone at the code level.

**Step 3.4: Author**
Record: Chin-Yen Lee (Realtek); maintainer Ping-Ke Shih signed off and
applied the whole series to `rtw-next`. Nearby author work is other
rtw89 WoWLAN/MLO fixes.

**Step 3.5: Prerequisites in this tree**
Record: Present here:
- `rtwvif_to_vif()` in `core.h`
- `ieee80211_vif_is_mld()` in `include/net/mac80211.h`
- `str_yes_no()` in `include/linux/string_choices.h`
- ARP offload + keep-alive both call `rtw89_fw_h2c_add_general_pkt(…,
  RTW89_PKT_OFLD_TYPE_ARP_RSP, …)`
Can apply standalone on this tree.

---

## Phase 4: Mailing list / external

**Step 4.1: b4 dig**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260625061545.44808-10-pkshih@realtek.com
- Subject: `[PATCH rtw-next 09/10] wifi: rtw89: wow: add QoS control
  field to WoWLAN ARP response for MLO`
- Series: v1 only (`b4 dig -a`); no v2/v3.
- Cover letter (`00/10`): “update some MAC, FW and WoWLAN settings”;
  “The last three patches are related to WoWLAN, and the first two are
  to support WoWLAN with MLO AP that uses MLD address.”
- Only reply in the saved mbox: Ping-Ke applying all 10 to `rtw-next`
  (no NAK, no reviewer comments on 09/10).
- No Cc: stable in the thread.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Ping-Ke Shih, linux-wireless, gary.chang@realtek.com,
timlee@realtek.com, dian_syuan0116@realtek.com, kevin_yang@realtek.com.
Maintainer was To/Cc and applied it. No external review tags.

**Step 4.3: Bug report**
Record: No Reported-by, bugzilla, or syzbot. Vendor-described AP
behavior only. Specific AP models for *this* QoS issue are not named
(keep-alive predecessor named TP-Link Archer BE800).

**Step 4.4: Series**
Record: Mixed MAC/FW/WoW settings. 09/10 is self-contained; 08/10 is a
related but independent MLO ARP address fix.

**Step 4.5: stable@**
Record: **UNVERIFIED** (lore.kernel.org/stable blocked by Anubis).
Thread mbox has no stable discussion.

WebFetch of lore/msgid also returned 403; discussion was recovered via
`b4 dig -m`.

---

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `rtw89_arp_response_get()` only.

**Step 5.2: Callers**
Record:
- `rtw89_fw_h2c_add_general_pkt()` → `RTW89_PKT_OFLD_TYPE_ARP_RSP`
- `rtw89_fw_h2c_keep_alive()` (WoW keep-alive enable)
- `rtw89_fw_h2c_arp_offload()` (WoW ARP offload enable)
- `rtw89_wow_fw_start()` in `wow.c` enables both when the interface is
  linked

Path is WoWLAN firmware start on suspend (`CONFIG_PM`), not a syscall
hot path.

**Step 5.3: Callees**
Record: `rtwvif_to_vif`, `ieee80211_vif_is_mld`,
`rtw89_wow_get_sec_hdr_len`, `dev_alloc_skb`, `skb_put_zero`,
`cpu_to_le16`, `ether_addr_copy`, `str_yes_no` (debug only).

**Step 5.4: Reachability**
Record: Userspace-reachable via suspend with WoWLAN on an rtw89 STA
associated as an MLD. Not unprivileged kernel-memory corruption; it is a
normal power-management / offload path.

**Step 5.5: Similar patterns**
Record: `rtw89_sa_query_get()` still builds a non-QoS mgmt action frame
(correct for SA Query). No sibling ARP builders. Keep-alive commit
`dcf5c7262bffa` is the same interoperability class (APs ignoring Null
keep-alives).

---

## Phase 6: This checkout

**Step 6.1: Local tree and whether the bug exists**
Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4**
- `rtw89_arp_response_get()` exists; MLO (`ieee80211_vif_is_mld`), WoW
  keep-alive, and ARP offload all exist.
- Without this change, MLO ARP templates are non-QoS Data. That is the
  bug this tree’s rtw89 WoW+MLO users hit.
- Commit `03a963f4aeda5` is an ancestor of HEAD (`git merge-base --is-
  ancestor` → yes) because it landed in **v7.3-rc1**. That is not used
  as “already selected for stable”; it only confirms the code and
  helpers are in this series.

**Step 6.2: Backport difficulty**
Record: Clean apply on this tree (hunk matches current `fw.c`). No
refactor blocking it.

**Step 6.3: Other fixes here**
Record: No later follow-up rewriting this QoS logic (`git log` after the
commit on this function is unrelated fw/coex/scan work). Parent MLD-
address fix is already here and independent.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **drivers/net/wireless/realtek/rtw89** — important (common Wi-Fi
6/7 laptops), not core mm/fs. WoWLAN is `CONFIG_PM`.

**Step 7.2**
Record: Very active (frequent coex/MLO/WoW commits). This is a late
correction to existing MLO WoW, not a brand-new subsystem.

---

## Phase 8: Impact and risk

**Step 8.1: Who**
Record: Driver-specific + config-specific: rtw89, MLO association,
WoWLAN/suspend. Not universal.

**Step 8.2: Trigger**
Record: Suspend with WoWLAN while associated to an MLO AP that rejects
non-QoS Data. Common for Wi-Fi 7 + lid-close. Unprivileged in the sense
of normal laptop suspend, not an exploit primitive.

**Step 8.3: Failure mode**
Record: AP discards keep-alive and/or ARP offload → association can drop
in suspend. **Severity: MEDIUM** (connectivity / suspend Wi-Fi, not
oops/corruption). Matches stable-rules “hardware quirk” / “oh, that’s
not good”, not crash/UAF.

**Step 8.4: Risk–benefit**
Record:
- Benefit: MLO WoWLAN keep-alive and ARP offload actually accepted;
  avoids silent disconnect on suspend for Wi-Fi 7 rtw89.
- Risk: ~24 lines, MLO-only, no locking/API. Low.
- Ratio: favorable for this tree, which already has MLO WoW + ARP
  templates.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real interoperability bug on an existing path (WoW ARP template), not
  a new driver or API.
- This 7.3 tree has MLO, `rtw89_arp_response_get()`, keep-alive, and ARP
  offload.
- Small, obviously correct, non-MLO behavior preserved.
- Maintainer SOB + applied to rtw.git.
- Official stable rules allow hardware quirks and “oh, that’s not good”
  issues; this is AP-side discard of malformed/non-QoS MLO data.
- Suspend/WoWLAN disconnect is user-visible on shipping Realtek Wi-Fi 7
  hardware.

Against:
- Not oops/deadlock/corruption/security.
- `rtw-next` series titled “update some MAC, FW and WoWLAN settings”;
  cover letter says “support WoWLAN with MLO AP”.
- No external reporters, Tested-by, or Fixes: tag.
- Affects only MLO + WoWLAN.

Unresolved:
- Stable-list history (lore bot wall).
- Which exact APs need QoS (commit says “some MLO APs”).

**Step 9.2: Stable rules checklist** (`Documentation/process/stable-
kernel-rules.rst`)
1. Obviously correct and tested? **PASS** — vendor + maintainer, tiny,
   protocol order verified in tree.
2. Real bug that bothers users? **PASS** — WoWLAN ARP ignored, possible
   disconnect in suspend on MLO.
3. Important (crash/security/corruption/deadlock **or** quirk / “oh
   that’s not good”)? **PASS** — quirk / connectivity, not CRITICAL
   crash.
4. Small and contained? **PASS** — one function, well under 100 lines.
5. No new features/APIs? **PASS** — frame format fix for existing
   offload, no new uAPI.
6. Applies to this tree? **PASS** — helpers and callers exist; hunk
   matches `fw.c`.

**Step 9.3: Exception category**
Record: Hardware/protocol quirk (MLO APs dropping non-QoS WoW ARP),
analogous to other driver workarounds. Not a device-ID one-liner, but
the same class.

**Step 9.4: Decision**
This tree is **7.3.0-rc4**. rtw89 already implements MLO WoWLAN and
uploads ARP templates for keep-alive and ARP offload. Sending those as
non-QoS Data is wrong for MLO APs and can drop the link in suspend. The
patch is a small, MLO-only frame-format fix with low regression risk and
no extra series dependencies. That is appropriate to have in this tree’s
stable line.

### What it solves for users of this tree
WoWLAN keep-alive and ARP offload on rtw89 MLD vifs were built as
ordinary Data frames. Some MLO APs drop those, so the AP may age out the
STA during suspend. Adding QoS Control + QoS Data subtype makes those
firmware-transmitted frames acceptable while leaving legacy associations
unchanged.

### Risk vs benefit
Benefit is restoring Wi-Fi 7 WoWLAN connectivity on Realtek rtw89. Risk
is a 2-byte header on the MLO path only. Non-MLO frame control stays
Data+ToDS.

### Concerns
Cover letter frames this as MLO WoW “support” in a mixed `rtw-next`
series, and there is no public reproducer. On this 7.3 tree those
features already exist, so this is a contained correctness fix, not a
new subsystem.

---

Verification:
- [Phase 1] Parsed subject/tags/body from `git log -1 --format=fuller
  03a963f4aeda5`; msgid is 09/10 of `20260625061545.44808`.
- [Phase 2] Diff vs current `fw.c` `rtw89_arp_response_get()`; +24/−7 in
  one function; QoS inserted after 3-addr header, before IV.
- [Phase 3] `git merge-base --is-ancestor 03a963f4aeda5 HEAD` → yes;
  `git describe --contains` → `v7.3-rc1~…`; blame shows intro
  `58ed86e1666b3`; parent `76edcedda6437` is address-only.
- [Phase 3] `git log --oneline --grep=20260625061545.44808 --
  drivers/net/wireless/realtek/rtw89/` listed all 10 series commits.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 `rtw-next` 10-patch series; applied
  by Ping-Ke; no NAK; no stable Cc. WebFetch lore 403; curl stable list
  Anubis-blocked.
- [Phase 5] Grep: ARP_RSP used from keep-alive and ARP offload;
  `rtw89_wow_fw_start()` enables both.
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-g…; `VERSION/PATCHLEVEL`
  7.3.0-rc4; MLO/WoW/ARP code present.
- [Phase 7] rtw89 Wi-Fi 6/7 driver, active history on `fw.c`.
- [Phase 8] Failure mode: AP drops WoW ARP → disconnect in suspend; not
  a kernel oops.
- [Phase 9] Checked `Documentation/process/stable-kernel-rules.rst`
  (quirk / “oh that’s not good”, ≤100 lines).
- UNVERIFIED: lore.kernel.org/stable archives (bot challenge).
- UNVERIFIED: exact AP models for the QoS requirement (not named in
  commit or mbox).

**YES**

 drivers/net/wireless/realtek/rtw89/fw.c | 31 +++++++++++++++++++------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index c6533a085c7fe..299526220380f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2701,6 +2701,7 @@ static struct sk_buff *rtw89_sa_query_get(struct rtw89_dev *rtwdev,
 static struct sk_buff *rtw89_arp_response_get(struct rtw89_dev *rtwdev,
 					      struct rtw89_vif_link *rtwvif_link)
 {
+	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif_link->rtwvif);
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	u8 sec_hdr_len = rtw89_wow_get_sec_hdr_len(rtwdev);
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
@@ -2708,26 +2709,42 @@ static struct sk_buff *rtw89_arp_response_get(struct rtw89_dev *rtwdev,
 	struct rtw89_arp_rsp *arp_skb;
 	struct arphdr *arp_hdr;
 	struct sk_buff *skb;
-	__le16 fc;
+	bool with_qos;
+	u16 fc;
 
-	skb = dev_alloc_skb(sizeof(*hdr) + sec_hdr_len + sizeof(*arp_skb));
+	with_qos = ieee80211_vif_is_mld(vif);
+
+	rtw89_debug(rtwdev, RTW89_DBG_WOW, "[arp_reply] with qos field: %s\n",
+		    str_yes_no(with_qos));
+
+	skb = dev_alloc_skb(sizeof(*hdr) + sec_hdr_len + sizeof(*arp_skb) +
+			    (with_qos ? 2 : 0));
 	if (!skb)
 		return NULL;
 
 	hdr = skb_put_zero(skb, sizeof(*hdr));
 
+	fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS;
+
 	if (rtw_wow->ptk_alg)
-		fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS |
-				 IEEE80211_FCTL_PROTECTED);
+		fc |= IEEE80211_FCTL_PROTECTED;
+
+	if (with_qos)
+		fc |= IEEE80211_STYPE_QOS_DATA;
 	else
-		fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS);
+		fc |= IEEE80211_STYPE_DATA;
+
+	hdr->frame_control = cpu_to_le16(fc);
 
-	hdr->frame_control = fc;
 	ether_addr_copy(hdr->addr1, rtwvif_link->bssid);
 	ether_addr_copy(hdr->addr2, rtwvif_link->mac_addr);
 	ether_addr_copy(hdr->addr3, rtwvif_link->bssid);
 
-	skb_put_zero(skb, sec_hdr_len);
+	if (with_qos)
+		skb_put_zero(skb, sizeof(__le16));
+
+	if (sec_hdr_len)
+		skb_put_zero(skb, sec_hdr_len);
 
 	arp_skb = skb_put_zero(skb, sizeof(*arp_skb));
 	memcpy(arp_skb->llc_hdr, rfc1042_header, sizeof(rfc1042_header));
-- 
2.53.0

