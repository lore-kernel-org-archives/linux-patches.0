Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9E4205AB6;
	Sat, 25 Oct 2025 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408635; cv=none; b=cEaIPo1jRcc5fi1ap7oU4ZS62OG5H5swvkYXBj1y9IwNt+06hzPykn3vvbJALhZjNlIB82RFUWXFPf2HLUOhJpPNqj+vag4pExxJx1JxwpduRgnLRR2oMSiF22cRyjfAcm5lC3tq7v7kg/AQBskrLmAThqy6+JFbRADrjMjDhLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408635; c=relaxed/simple;
	bh=Qqeh+a/uAh3IR7ymoARPEAMo/VUDPwtqSwVnWOwjuEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVUeNLlUEIT1dMWeLBtSxuss3H/1IfeftzHXCBj84x3T5JOGJuXVmN5FWmmYUkSJuIe7aAeBSeb7BL+eIdssRBqSwopxh2dVtpjCBkLbrSfayAID118EVMYaqXzEySTkELHaiSJA+IKHL9u8YQEm4KGxCMzFtaOzBBxhVUnUZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaVTRW2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaVTRW2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082C7C4CEF5;
	Sat, 25 Oct 2025 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408635;
	bh=Qqeh+a/uAh3IR7ymoARPEAMo/VUDPwtqSwVnWOwjuEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaVTRW2s9WlcXTr7snAJog8FqDi5I2mbYvQRSayUki08x+Owob+siATuUyjyXB4vI
	 kTBP6k7PB+5ATuWfFmWhaR+KOrFs/MJJNvn5WwZSYHykzfnhR1bQJdtzux5Jb1fkBb
	 RAlDi8XeZlwIUpr6gb7yPSYGirJJdj9fLp5TdW23L0zzccVu2l5CjBoyPXtOhGfPhO
	 93BG5xWt8/Zy2Wpss620mXZ5CX6QABssyKi5t9KP2KspMfUKm9ITJf4jeVv9xX1xAw
	 Yc0EYox8Wq3qDFDRwVhWAhjnmEw2VMweE+qfvSq6DJj7DxV8yueqf3ULBsJRhknqib
	 mtWsFF40RYfeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	daniel.gabay@intel.com,
	pagadala.yesu.anjaneyulu@intel.com,
	yedidya.ben.shimol@intel.com,
	shaul.triebitz@intel.com
Subject: [PATCH AUTOSEL 6.17] wifi: iwlwifi: mld: trigger mlo scan only when not in EMLSR
Date: Sat, 25 Oct 2025 11:54:20 -0400
Message-ID: <20251025160905.3857885-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>

[ Upstream commit 14a4aca568f6e78af7564c6fc5f1ecc1a5a32c33 ]

When beacon loss happens or the RSSI drops, trigger MLO scan only
if not in EMLSR. The link switch was meant to be done when we are
not in EMLSR and we can try to switch to a better link.
If in EMLSR, we exit first and then trigger MLO scan.

Signed-off-by: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250826184046.f6ae8e3882cf.I60901c16487371b8e62019bd0bf25c45ab23752f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real logic bug: The driver was triggering internal MLO scans
  even when EMLSR was active, which is the wrong phase for link
  selection. The commit defers scanning until EMLSR is exited, aligning
  behavior with the intended state machine (stay in EMLSR, decide if
  exit is required, then scan and try switching). This prevents out-of-
  order operations that can cause ineffective scans or state churn
  during EMLSR.

- Precise code changes
  - Beacon loss path:
    `drivers/net/wireless/intel/iwlwifi/mld/link.c:568-576` changes the
    unconditional MLO scan after beacon loss to only happen when not in
    EMLSR:
    - Before: always `iwl_mld_int_mlo_scan(mld, vif)` when
      `missed_bcon_since_rx > IWL_MLD_MISSED_BEACONS_THRESHOLD`.
    - After: guarded by `if (!iwl_mld_emlsr_active(vif))
      iwl_mld_int_mlo_scan(mld, vif);`
  - Low RSSI path:
    `drivers/net/wireless/intel/iwlwifi/mld/stats.c:382-389` similarly
    gates scans on poor signal only when not in EMLSR, and returns
    early. If EMLSR is active, it computes an exit threshold and exits
    EMLSR instead:
    - Guarded scan when not in EMLSR: `if (sig <
      IWL_MLD_LOW_RSSI_MLO_SCAN_THRESH) iwl_mld_int_mlo_scan(mld, vif);`
    - EMLSR exit evaluation:
      `drivers/net/wireless/intel/iwlwifi/mld/stats.c:391-399` calls
      `iwl_mld_exit_emlsr(...)` if `sig < exit_emlsr_thresh`.
  - EMLSR-aware flow consistency: The link.c path continues to handle
    EMLSR exit conditions via missed beacon thresholds after the gated
    scan decision
    (`drivers/net/wireless/intel/iwlwifi/mld/link.c:578-596`),
    preventing scans while still in EMLSR.

- Correctness and architectural rationale
  - EMLSR indicates multi-link operation is active; link switching via
    MLO scan is intended when not in EMLSR. Triggering scans during
    EMLSR can be pointless or lead to race/ordering issues.
  - After EMLSR exit, scanning is still triggered by existing
    mechanisms. For example, when EMLSR is unblocked the code explicitly
    kicks off an internal MLO scan
    (`drivers/net/wireless/intel/iwlwifi/mld/mlo.c:352` calls
    `iwl_mld_int_mlo_scan(mld, vif)`), and subsequent low-RSSI/beacon-
    loss events will also trigger scans since
    `iwl_mld_emlsr_active(vif)` will be false.

- Scope and risk
  - Small, contained change with clear semantics: two guarded call
    sites, no API/UAPI changes, no cross-subsystem impact.
  - Uses existing, well-scoped helper `iwl_mld_emlsr_active(vif)`
    (`drivers/net/wireless/intel/iwlwifi/mld/mlo.h:22`) as the gate.
  - Behavior when EMLSR is not supported/active is unchanged (guard
    evaluates false and scans proceed as before).
  - EMLSR exit logic remains intact and already handles when to leave
    EMLSR and then allow link selection.

- User impact
  - Prevents unnecessary or ill-timed scans during EMLSR, reducing
    potential instability, wasted cycles, or incorrect link switching
    attempts when multi-link is in use.
  - Improves robustness in beacon-loss and low-RSSI scenarios for MLO-
    capable Intel devices.

- Stable backport suitability
  - Bug fix that corrects state machine behavior in iwlwifi MLO/EMLSR
    flows.
  - Minimal risk of regression; very small patch touching only Intel
    iwlwifi MLD driver.
  - No architectural changes, no new features, no ABI changes.
  - Addresses conditions (missed beacons, low RSSI) that affect real
    users on MLO/EMLSR-capable hardware.

Given the above, this is a good candidate for stable backport to trees
that include iwlwifi MLO/EMLSR support.

 drivers/net/wireless/intel/iwlwifi/mld/link.c  |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/mld/stats.c | 11 +++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 782fc41aa1c31..dfaa6fbf8a54d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -572,8 +572,11 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 	if (missed_bcon_since_rx > IWL_MLD_MISSED_BEACONS_THRESHOLD) {
 		ieee80211_cqm_beacon_loss_notify(vif, GFP_ATOMIC);
 
-		/* try to switch links, no-op if we don't have MLO */
-		iwl_mld_int_mlo_scan(mld, vif);
+		/* Not in EMLSR and we can't hear the link.
+		 * Try to switch to a better link. EMLSR case is handled below.
+		 */
+		if (!iwl_mld_emlsr_active(vif))
+			iwl_mld_int_mlo_scan(mld, vif);
 	}
 
 	/* no more logic if we're not in EMLSR */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/stats.c b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
index cbc64db5eab6f..7b8709716324a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/stats.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
@@ -379,11 +379,14 @@ static void iwl_mld_update_link_sig(struct ieee80211_vif *vif, int sig,
 
 	/* TODO: task=statistics handle CQM notifications */
 
-	if (sig < IWL_MLD_LOW_RSSI_MLO_SCAN_THRESH)
-		iwl_mld_int_mlo_scan(mld, vif);
-
-	if (!iwl_mld_emlsr_active(vif))
+	if (!iwl_mld_emlsr_active(vif)) {
+		/* We're not in EMLSR and our signal is bad,
+		 * try to switch link maybe. EMLSR will be handled below.
+		 */
+		if (sig < IWL_MLD_LOW_RSSI_MLO_SCAN_THRESH)
+			iwl_mld_int_mlo_scan(mld, vif);
 		return;
+	}
 
 	/* We are in EMLSR, check if we need to exit */
 	exit_emlsr_thresh =
-- 
2.51.0

