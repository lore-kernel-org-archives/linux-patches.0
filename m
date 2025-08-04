Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E0126C1E;
	Mon,  4 Aug 2025 00:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267057; cv=none; b=fJ9lWXWsNeGMCtFfIKJpXtSS+opsnoktMh0X/qvB8KV5g3LTHeJ36O+JrtiaEKb1q7N45b/QlzSCyz4dnHJsH+bGnDDFTDWPRD3SnPFfPMYI0bSP0Lmq9CN0aA2fYaSpO9s40M3vXcqUAViFGgtcTUu7aBryDSQJ0xo1Pl63NqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267057; c=relaxed/simple;
	bh=igAIPrncz/syFf7vh1UHv9op5KalexTtLvFe6mvlw9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ba67REyWZQ+mQ0crVCCuJqog4PclokaDbkA8lJa0LZv02iHvrZ8sTzpe6vZ60L8Lf1oWRZ6ky8+WGbkPMEZ5mHZviL46xp9A3tcPpxS8WWgf38q0NvS/TEXbcU60V19doBnuXz8NEz+MIQH7PALQ38ILwYdIoznN83SntRlKlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9yGKKTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9yGKKTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F9AC4CEF8;
	Mon,  4 Aug 2025 00:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267057;
	bh=igAIPrncz/syFf7vh1UHv9op5KalexTtLvFe6mvlw9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9yGKKTb8Ck9HMBeJ1QHP2ATVAEeni359UtPdxT2PWZKfz2mxO2zlW5V/EOargX6P
	 iHx9tu45Eb0RmATrtc0lecxF39RIMl5K1VJTTQEAfoO18WjyZQ87OhEMGp77VJrcLb
	 JEhCDmAo20kZ71/KGNzRlXQn1qe3V39BKEkpehbSrnlojJBmyMz1Gu9VBnANYPE8wR
	 FctEHGVtXq41cAHvG9NfdgF5JLHvyv8DqL7ksx2azqFRp7K0jatDfmmFSEvh86uM4a
	 uv4xNQjsOF7VeAgyYECj6oTZuqBghN4PlrbS+Yr5AJc5NUVPEmHUtwm1Dt6dPE1i+D
	 tbKD3fcI2a4GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vivek Pernamitta <quic_vpernami@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	slark_xiao@163.com,
	johan+linaro@kernel.org,
	dnlplm@gmail.com,
	mank.wang@netprisma.us,
	quic_msarkar@quicinc.com,
	tglx@linutronix.de,
	quic_skananth@quicinc.com
Subject: [PATCH AUTOSEL 6.16 10/85] bus: mhi: host: pci_generic: Disable runtime PM for QDU100
Date: Sun,  3 Aug 2025 20:22:19 -0400
Message-Id: <20250804002335.3613254-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Vivek Pernamitta <quic_vpernami@quicinc.com>

[ Upstream commit 0494cf9793b7c250f63fdb2cb6b648473e9d4ae6 ]

The QDU100 device does not support the MHI M3 state, necessitating the
disabling of runtime PM for this device. It is essential to disable
runtime PM if the device does not support M3 state.

Signed-off-by: Vivek Pernamitta <quic_vpernami@quicinc.com>
[mani: Fixed the kdoc comment for no_m3]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Link: https://patch.msgid.link/20250425-vdev_next-20250411_pm_disable-v4-1-d4870a73ebf9@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Hardware Limitation**: The commit fixes a real issue
   where the QDU100 device does not support MHI M3 state (the suspend
   state), but runtime PM was being enabled for it. Looking at line 1478
   in `mhi_pci_runtime_suspend()`, the driver attempts to transition to
   M3 state via `mhi_pm_suspend(mhi_cntrl)`. For a device that doesn't
   support M3, this would fail and prevent proper runtime suspend/resume
   operations.

2. **Small, Contained Fix**: The change is minimal and well-contained:
   - Adds a single boolean field `no_m3` to the device info structure
   - Sets it to true only for the QDU100 device configuration
   - Modifies the runtime PM enablement condition from checking only
     `pci_pme_capable(pdev, PCI_D3hot)` to also checking
     `!(info->no_m3)`

3. **Prevents Runtime PM Issues**: Without this fix, QDU100 devices
   would have runtime PM enabled but would fail to properly suspend,
   leading to:
   - Error messages ("failed to suspend device")
   - Potential power management issues
   - The device getting stuck in an inconsistent PM state

4. **Device-Specific Fix**: The fix is specific to QDU100 hardware that
   was recently added (commit 9241459b3cc2 in December 2024), meaning it
   affects users of this specific 5G RAN accelerator card.

5. **Clear Root Cause**: The commit message clearly explains that "The
   QDU100 device does not support the MHI M3 state" and that "It is
   essential to disable runtime PM if the device does not support M3
   state."

6. **No Architectural Changes**: This is a straightforward hardware
   quirk handling - no new features, no API changes, just preventing
   runtime PM for a device that cannot support it.

The fix follows stable kernel rules by addressing a real bug that
affects users (runtime PM failures on QDU100 devices), is small and
self-contained, and has minimal risk of regression since it only affects
the specific QDU100 device configuration.

 drivers/bus/mhi/host/pci_generic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 3fde90fe660d..9fc1f014767a 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -43,6 +43,7 @@
  * @mru_default: default MRU size for MBIM network packets
  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup instead
  *		   of inband wake support (such as sdx24)
+ * @no_m3: M3 not supported
  */
 struct mhi_pci_dev_info {
 	const struct mhi_controller_config *config;
@@ -54,6 +55,7 @@ struct mhi_pci_dev_info {
 	unsigned int dma_data_width;
 	unsigned int mru_default;
 	bool sideband_wake;
+	bool no_m3;
 };
 
 #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
@@ -295,6 +297,7 @@ static const struct mhi_pci_dev_info mhi_qcom_qdu100_info = {
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
 	.sideband_wake = false,
+	.no_m3 = true,
 };
 
 static const struct mhi_channel_config mhi_qcom_sa8775p_channels[] = {
@@ -1319,8 +1322,8 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* start health check */
 	mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
-	/* Only allow runtime-suspend if PME capable (for wakeup) */
-	if (pci_pme_capable(pdev, PCI_D3hot)) {
+	/* Allow runtime suspend only if both PME from D3Hot and M3 are supported */
+	if (pci_pme_capable(pdev, PCI_D3hot) && !(info->no_m3)) {
 		pm_runtime_set_autosuspend_delay(&pdev->dev, 2000);
 		pm_runtime_use_autosuspend(&pdev->dev);
 		pm_runtime_mark_last_busy(&pdev->dev);
-- 
2.39.5

