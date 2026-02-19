Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803AF284896;
	Thu, 19 Feb 2026 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466672; cv=none; b=KGidQqO3GazTQL2H0Vf5/CWpEzvUJ6N/m8aR7oo4gm09pYicf9vD0ycGdw3xzL9MMbKS7YFWiwAOBTQhqZuqYZ5TQZC0UXkARnMpjpn+TOQMZmloBy4qEHUuPKZxAjpT1xSU1+OPPdher7oRM6zbWpH1lV7kexxe0IXBPQggx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466672; c=relaxed/simple;
	bh=rAe4ps5q6e4DIfaR9GY8Om27+K6JRSY5/98vs/RSyi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J22L617/3foSABykOy1oFrpJql2XnGmkenSOVE/KsFedHV01Ei1r/URHAdA4VajuAp9jNAMVqEBeua3uLEIqy0xaxh7fNBBgfZQtuSM0yqjh8otGoh7JJaMk/K+k4c020U0AzQqntfCmH+IUlqWbZBzBV/M9zupneUDDFNvIP5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pd9HYyjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pd9HYyjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B65C4AF09;
	Thu, 19 Feb 2026 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466672;
	bh=rAe4ps5q6e4DIfaR9GY8Om27+K6JRSY5/98vs/RSyi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pd9HYyjRhEdTc2I1fuOCVF1zPUp3TrM+OWkFiILZwxW20HvMaTp0WK8tLs0lyLose
	 E/DqJgseLHMC64FM3hwl9PUtl8ojIeh09W0T1K8/vU7cMczotafWTr5rY3mz4x8inA
	 QdB8W+Hf2emk5Zfh4piHw4Uxei4PXZT8AwPH6CBskKBFJSEfL27dkBQtlpuqrmcVu2
	 4Gmgz44nTfmrTNmNESRzCqqkdnFAdCXoBhx9N4vt7U6bkacxTLuyjfh0Tzi6YLiAw0
	 Qt58a6XeOxVmq9VKci0aKYgdS9pFoKv+KIrME2h5yx7agDOHy3VUfpWaliOudRxqap
	 9KbIhHmZKHt6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	ulf.hansson@linaro.org,
	linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] mmc: rtsx_pci: add quirk to disable MMC_CAP_AGGRESSIVE_PM for RTS525A
Date: Wed, 18 Feb 2026 21:03:43 -0500
Message-ID: <20260219020422.1539798-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 5f0bf80cc5e04d31eeb201683e0b477c24bd18e7 ]

Using MMC_CAP_AGGRESSIVE_PM on RTS525A card readers causes game
performance issues when the card reader comes back from idle into active
use. This can be observed in Hades II when loading new sections of the
game or menu after the card reader puts itself into idle, and presents
as a 1-2 second hang.

Add EXTRA_CAPS_NO_AGGRESSIVE_PM quirk to allow cardreader drivers to
opt-out of aggressive PM, and set it for RTS525A.

Closes: https://lore.kernel.org/linux-mmc/ff9a7c20-f465-4afa-bf29-708d4a52974a@linux.dev/
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260103204226.71752-1-matthew.schwartz@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Summary Analysis

**What the commit does:**
This commit adds a device-specific quirk for the Realtek RTS525A card
reader to disable `MMC_CAP_AGGRESSIVE_PM`. When aggressive PM is enabled
on this device, it powers down the card reader after 10 seconds of idle,
and re-tuning when waking up causes 1-2 second hangs that are user-
visible and impact performance.

**Does it fix a real bug?**
Yes. The aggressive PM behavior on RTS525A causes real, user-observable
1-2 second hangs during normal use. This was reported by a real user
with concrete reproduction steps (playing a game that loads data from a
micro SD card). The "Closes:" tag links to a real mailing list report.

**Stable kernel criteria assessment:**

1. **Obviously correct and tested**: The change follows an existing
   pattern (`EXTRA_CAPS_NO_MMC` is the exact same kind of quirk flag).
   The author tested it on affected hardware.

2. **Fixes a real bug**: Yes - user-visible performance degradation (1-2
   second hangs) on specific hardware.

3. **Important issue**: It's a usability issue rather than a
   crash/security issue. However, hardware quirks for broken behavior
   are explicitly allowed in stable.

4. **Small and contained**: The change is minimal - 3 new lines of code
   plus a new flag definition. It only affects RTS525A devices and
   doesn't change behavior for any other hardware.

5. **No new features**: This is a hardware quirk/workaround, which is an
   explicitly allowed exception to the "no new features" rule.

6. **Clean application**: The change builds on existing infrastructure
   (`extra_caps` flags) that exists in all stable trees since v5.11.

**Risk assessment:**
- **Very low risk**: The quirk only affects RTS525A devices
  (`PID_525A`). All other devices are completely unaffected.
- The code pattern is identical to existing quirks
  (`EXTRA_CAPS_NO_MMC`).
- The worst case if the quirk is wrong is slightly higher power
  consumption on RTS525A (no aggressive PM = card reader stays powered).

**Dependencies:**
None. The change uses existing infrastructure (`extra_caps`,
`CHK_PCI_PID`, `PID_525A`) that has been present since before v5.11.

### Verification

- **git log** showed `rtd3_en` / `MMC_CAP_AGGRESSIVE_PM` was introduced
  in commit `5b4258f6721f4` (v5.11), confirming all current stable trees
  have the affected code.
- **git tag --contains** confirmed the runtime PM commit is in stable
  trees (p-5.15, p-6.1, p-6.12).
- **Grep for EXTRA_CAPS_** confirmed the existing quirk flag pattern
  (NO_MMC at bit 7, SD_EXPRESS at bit 8, new flag at bit 9 - clean
  progression).
- **lore.kernel.org fetch** confirmed the bug report describes real
  user-reported 1-2 second hangs on RTS525A with concrete reproduction
  steps.
- **Code review** verified the change only adds a condition check and
  flag - no behavioral change for non-RTS525A devices.
- The commit was signed off by Greg Kroah-Hartman, the stable tree
  maintainer, indicating it went through proper review.
- Could NOT verify whether any stable tree has already picked this up
  (unverified, but not relevant to the YES/NO decision).

### Conclusion

This is a textbook hardware quirk for a specific device with a real,
user-reported issue. It follows existing patterns in the codebase, is
minimal in scope, and has zero risk to other devices. Hardware quirks
are explicitly listed as appropriate for stable backporting. The
affected code exists in all current stable trees (5.15+).

**YES**

 drivers/misc/cardreader/rts5249.c | 3 +++
 drivers/mmc/host/rtsx_pci_sdmmc.c | 4 ++--
 include/linux/rtsx_pci.h          | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/cardreader/rts5249.c b/drivers/misc/cardreader/rts5249.c
index 38aefd8db452a..87d576a03e68e 100644
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -78,6 +78,9 @@ static void rtsx_base_fetch_vendor_settings(struct rtsx_pcr *pcr)
 	if (CHK_PCI_PID(pcr, PID_524A) || CHK_PCI_PID(pcr, PID_525A))
 		pcr->rtd3_en = rtsx_reg_to_rtd3_uhsii(reg);
 
+	if (CHK_PCI_PID(pcr, PID_525A))
+		pcr->extra_caps |= EXTRA_CAPS_NO_AGGRESSIVE_PM;
+
 	if (rtsx_check_mmc_support(reg))
 		pcr->extra_caps |= EXTRA_CAPS_NO_MMC;
 	pcr->sd30_drive_sel_3v3 = rtsx_reg_to_sd30_drive_sel_3v3(reg);
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 4db3328f46dfb..8df60000b5b41 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1497,8 +1497,8 @@ static void realtek_init_host(struct realtek_pci_sdmmc *host)
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SD_HIGHSPEED |
 		MMC_CAP_MMC_HIGHSPEED | MMC_CAP_BUS_WIDTH_TEST |
 		MMC_CAP_UHS_SDR12 | MMC_CAP_UHS_SDR25;
-	if (pcr->rtd3_en)
-		mmc->caps = mmc->caps | MMC_CAP_AGGRESSIVE_PM;
+	if (pcr->rtd3_en && !(pcr->extra_caps & EXTRA_CAPS_NO_AGGRESSIVE_PM))
+		mmc->caps |= MMC_CAP_AGGRESSIVE_PM;
 	mmc->caps2 = MMC_CAP2_NO_PRESCAN_POWERUP | MMC_CAP2_FULL_PWR_CYCLE |
 		MMC_CAP2_NO_SDIO;
 	mmc->max_current_330 = 400;
diff --git a/include/linux/rtsx_pci.h b/include/linux/rtsx_pci.h
index 3c5689356004e..f6122349c00ec 100644
--- a/include/linux/rtsx_pci.h
+++ b/include/linux/rtsx_pci.h
@@ -1230,6 +1230,7 @@ struct rtsx_pcr {
 #define EXTRA_CAPS_MMC_8BIT		(1 << 5)
 #define EXTRA_CAPS_NO_MMC		(1 << 7)
 #define EXTRA_CAPS_SD_EXPRESS		(1 << 8)
+#define EXTRA_CAPS_NO_AGGRESSIVE_PM	(1 << 9)
 	u32				extra_caps;
 
 #define IC_VER_A			0
-- 
2.51.0

