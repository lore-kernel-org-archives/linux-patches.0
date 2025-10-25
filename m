Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B807B3064B8;
	Sat, 25 Oct 2025 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409092; cv=none; b=Ogp+n9YocfiG/nNB8fqCeVilfBqLVPoLhYGR+kexllyeMCfYOJvnfeLCPo0Eu5aAhf5dee4XI47e8b2XXxuA4ybJ+MEuQZh5rILIojw7R6w1PmuOdvHz0RTQKLjo1Qqg8cIXb0IrE2aP3KLmI/TOcZ9604k/saGG81kxrZfIVdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409092; c=relaxed/simple;
	bh=nTxO7X31FpijljNR2zZ4Ppp0tK8MEtpSt/YrYPIW/wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ibz3BY9uXOl543NGGBDgMeP1PHuSTIvik+PaQQNf6gQFvwDFQqasPxM0GpFyXqgyG6A+aOi7Pjf65BrdVi1frIctCP16WOyE8zPBTxGdTXV3Z+6wdKlH94tv4pLLnJxTEzzy1VINcTe6eZQSnv/z5pMZn4D4U0G4/edIEJs++bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJxg9GPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJxg9GPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DCFC4CEFB;
	Sat, 25 Oct 2025 16:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409092;
	bh=nTxO7X31FpijljNR2zZ4Ppp0tK8MEtpSt/YrYPIW/wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJxg9GPol7xilamtrWRn+PHhG/DBmqoB4w7w2J9VlHacB/fyaVeJ7Kw1snjg4MyPo
	 gKspNo6V69/cFHVX+kj1vujbQ8Fvp7Ubpx087y9SuNGhmYZphhcX6MYB0KVbcMbILf
	 VqvPUHegK5YYSDj5aJczyEe4E9uq0WtN1e8vOHFSG7kBIuOUe/Al75oOJFifc5I2ej
	 Ba6GZoFOUj2cD5DJVrrQLDdEC3LC4foNRtNaX0sybeX+euF1Mpv8uWWShxyxqDz6io
	 ZTUWg6vQhM69u5csZzmqcgBETHwLWpQnAwVG67WkHdMvJ7GXvxLsT1lT9a2CmHnaO7
	 /iqCvuXD8Gl7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nidhish A N <nidhish.a.n@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] wifi: iwlwifi: fw: Add ASUS to PPAG and TAS list
Date: Sat, 25 Oct 2025 11:57:11 -0400
Message-ID: <20251025160905.3857885-200-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nidhish A N <nidhish.a.n@intel.com>

[ Upstream commit c5318e6e1c6436ce35ba521d96975e13cc5119f7 ]

Add ASUS to the list of OEMs that are allowed to use
the PPAG and TAS feature.

Signed-off-by: Nidhish A N <nidhish.a.n@intel.com>
Reviewed-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250909061931.499af6568e89.Iafb2cb1c83ff82712c0e9d5529f76bc226ed12dd@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds a new DMI allowlist entry for `DMI_SYS_VENDOR == "ASUS"`
    alongside the existing `ASUSTeK COMPUTER INC.` entry for both PPAG
    and TAS:
    - PPAG list: drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:46
      adds an `ASUSTEK` entry for `"ASUSTeK COMPUTER INC."` and a new
      `ASUS` entry for `"ASUS"` at
      drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:67.
    - TAS list: mirrors the same pattern at
      drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:149 (ASUSTEK)
      and drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:154 (ASUS).
  - The `.ident` strings are only labels; matching logic depends on
    `.matches`.

- How the lists are used
  - PPAG gating: `iwl_is_ppag_approved()` checks
    `dmi_ppag_approved_list` and, if not approved, disables PPAG by
    clearing `fwrt->ppag_flags`
    (drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:427–439).
    Callers gate PPAG setup on this:
    - MVM: drivers/net/wireless/intel/iwlwifi/mvm/fw.c:1068
    - MLD: drivers/net/wireless/intel/iwlwifi/mld/regulatory.c:203
  - TAS gating: `iwl_is_tas_approved()` checks `dmi_tas_approved_list`
    (drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:441–445). If not
    approved, MVM/MLD explicitly add US and Canada to the TAS block list
    to disable the feature there:
    - MVM: drivers/net/wireless/intel/iwlwifi/mvm/fw.c:1110–1120
    - MLD: drivers/net/wireless/intel/iwlwifi/mld/regulatory.c:352–366

- Why this fits stable backport criteria
  - User-visible bug fix: On some ASUS systems the DMI vendor is
    reported as `"ASUS"` (not `"ASUSTeK COMPUTER INC."`). Without this
    change, those systems are treated as unapproved, which disables PPAG
    and restricts TAS (notably in US/CA), reducing performance or
    altering behavior despite the OEM providing valid BIOS/UEFI tables.
    This is a real-world mismatch rather than a new feature.
  - Small and contained: The patch is limited to two allowlist arrays in
    a single file and adds no new code paths or APIs.
  - Low regression risk:
    - Enabling PPAG/TAS still depends on valid BIOS/UEFI data and
      firmware capabilities. If tables are missing/invalid, the driver
      already logs and exits gracefully (e.g.,
      `iwl_bios_get_ppag_table()` and `iwl_fill_ppag_table()` validation
      flows). No change for non-ASUS systems.
    - The allowlist pattern is established (e.g., other OEMs like HP,
      SAMSUNG, DELL, HONOR, WIKO are present at
      drivers/net/wireless/intel/iwlwifi/fw/regulatory.c:46–116 and
      :118–177).
  - No architectural changes: Only DMI matching tables are updated; the
    control flow and firmware interfaces are unchanged.

- Backport notes
  - The change is a straightforward data addition and typically applies
    cleanly. If older stable trees differ slightly in array
    ordering/naming, the same two additions can be adapted with no logic
    changes.

Given the minimal, well-scoped nature of this OEM allowlist fix, its
clear user impact for affected ASUS systems, and the existing safety
checks around BIOS/UEFI data and firmware capabilities, it is a good
candidate for backporting.

 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 3d6d1a85bb51b..a59f7f6b24da0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -59,11 +59,16 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 		},
 	},
-	{ .ident = "ASUS",
+	{ .ident = "ASUSTEK",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		},
 	},
+	{ .ident = "ASUS",
+	  .matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+		},
+	},
 	{ .ident = "GOOGLE-HP",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
@@ -141,11 +146,16 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 		},
 	},
-	{ .ident = "ASUS",
+	{ .ident = "ASUSTEK",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 		},
 	},
+	{ .ident = "ASUS",
+	  .matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+		},
+	},
 	{ .ident = "GOOGLE-HP",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
-- 
2.51.0

