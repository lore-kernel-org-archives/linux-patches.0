Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0605D8BFF;
	Mon,  9 Jun 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476669; cv=none; b=bxKT8fR8xQ/5Y4yMbJlF5l1w3YhOAegixnvVdIqiBuzjx4t4HpSwFtQzNEOGaqwT4pIH9GsBZPyR8JOrCuYjw/qQ7oeaZ2XdFZEMtSAEXDtY7wLE3KUqhfWbHCTp3bTfMuPB6Z2gtxsBXlLWqk5X7yiPxVDTQfgHxtJeEu4O5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476669; c=relaxed/simple;
	bh=Fkdc2mrIKFlmhNNbP0Mzr8cDWF6yzWl7vUyue4xveOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tbiRhuS4GLJ9fyCRsr8Y05Bc8dPm9zi+GTQXcp+B1cKE7wOAkYainR68RBCnpeFa9vELds8CJ9cpP8BurRKuIJplIfeL3XGUREZ9shmlncAhSmxez06jhp+T9VEkezHzIloAqJ8DrC7ZZF58QyR06OoluWGhtfd9c+Vu3Ed6kbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1YmTzY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1YmTzY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D334C4CEED;
	Mon,  9 Jun 2025 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476668;
	bh=Fkdc2mrIKFlmhNNbP0Mzr8cDWF6yzWl7vUyue4xveOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1YmTzY3pgnja4cqx5oAc9MhNcT9UrllRH8D4jKOgudNqZ+U1g8tfnxtHg0T7Rxeo
	 E43anRlbkhR0KMnYpFLhYNvF0sccOzufbRaEV7RCaOkp+4GFmZPK+x67yU0NtSQd8d
	 6PI1t1OwJnpOGEnUYLJtjNQaucgmyzKU3Ysn2TtN846VnmVkrq5jkbO1xexcSCZfqi
	 gFd1MfCurp0f1JP452trI4pV8e11US9YDUUoq8ey8bS15CL1xd7B1AsD0FVANCH6Je
	 2dQdBoqeV9TmZQ48zjbZ7hP702sMnYG5B6NutCZCY49aRKeJhOyX7QvfrZQ28laS4E
	 6R+3n1+5hnsYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	mani@kernel.org,
	slark_xiao@163.com,
	mingo@kernel.org,
	johan+linaro@kernel.org,
	tglx@linutronix.de,
	quic_vpernami@quicinc.com,
	mank.wang@netprisma.us,
	quic_msarkar@quicinc.com,
	quic_skananth@quicinc.com
Subject: [PATCH AUTOSEL 6.15 14/35] bus: mhi: host: pci_generic: Add Telit FN920C04 modem support
Date: Mon,  9 Jun 2025 09:43:30 -0400
Message-Id: <20250609134355.1341953-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 6348f62ef7ecc5855b710a7d4ea682425c38bb80 ]

Add SDX35 based modem Telit FN920C04.

$ lspci -vv
01:00.0 Unassigned class [ff00]: Qualcomm Device 011a
        Subsystem: Device 1c5d:2020

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250401093458.2953872-1-dnlplm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## Analysis

**YES**

This commit should be backported to stable kernel trees. Here's my
analysis:

**Reasons supporting backport:**

1. **Clear Hardware Support Pattern**: This commit follows the exact
   same pattern as the similar commits marked "YES" in the reference
   examples. It adds support for a new Telit modem (FN920C04) by:
   - Adding channel configuration (`mhi_telit_fn920c04_channels[]`)
   - Adding controller configuration (`modem_telit_fn920c04_config`)
   - Adding device info structure (`mhi_telit_fn920c04_info`)
   - Adding PCI device ID entry in the table

2. **Hardware Enablement**: The commit enables a specific hardware
   device (Telit FN920C04 with PCI ID 0x011a/subsystem 0x1c5d:0x2020)
   that users may already have but cannot use without this support. This
   is precisely the type of hardware enablement that benefits stable
   users.

3. **Minimal Risk**: The changes are entirely additive - no existing
   code paths are modified. The commit only:
   - Adds new data structures specific to this device
   - Adds one new entry to the PCI device table
   - Uses existing, well-tested infrastructure (reuses
     `mhi_telit_fn990_events` for events)

4. **Pattern Consistency**: All five reference commits adding Telit
   modem support were marked as "YES" for backporting, demonstrating
   this is an accepted pattern for stable inclusion.

5. **Well-Contained Changes**: The 39-line addition is self-contained
   and doesn't affect any other device configurations. The new device
   uses standard MHI patterns already present in the driver.

6. **Same Author/Maintainer**: The commit is from Daniele Palmas, the
   same author as the other Telit commits that were successfully
   backported, suggesting familiarity with stable backport requirements.

**Key specifics from the code changes:**
- Device uses new PCI ID `0x011a` with subsystem `0x1c5d:0x2020`
- Based on SDX35 chipset (newer hardware that users may encounter)
- Uses standard MHI channel configuration patterns
- Timeout increased to 50000ms (vs 20000ms for FN990) - device-specific
  tuning
- Includes `edl_trigger = true` for emergency download mode support
- Reuses proven event configuration from FN990

The commit represents exactly the type of hardware enablement change
that stable trees accept: low-risk, additive hardware support that helps
users with existing hardware.

 drivers/bus/mhi/host/pci_generic.c | 39 ++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 03aa887952098..059cfd77382f0 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -782,6 +782,42 @@ static const struct mhi_pci_dev_info mhi_telit_fe990a_info = {
 	.mru_default = 32768,
 };
 
+static const struct mhi_channel_config mhi_telit_fn920c04_channels[] = {
+	MHI_CHANNEL_CONFIG_UL_SBL(2, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(4, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_DL(5, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(92, "DUN2", 32, 1),
+	MHI_CHANNEL_CONFIG_DL(93, "DUN2", 32, 1),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 3),
+};
+
+static const struct mhi_controller_config modem_telit_fn920c04_config = {
+	.max_channels = 128,
+	.timeout_ms = 50000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn920c04_channels),
+	.ch_cfg = mhi_telit_fn920c04_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn990_events),
+	.event_cfg = mhi_telit_fn990_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn920c04_info = {
+	.name = "telit-fn920c04",
+	.config = &modem_telit_fn920c04_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+	.edl_trigger = true,
+};
+
 static const struct mhi_pci_dev_info mhi_netprisma_lcur57_info = {
 	.name = "netprisma-lcur57",
 	.edl = "qcom/prog_firehose_sdx24.mbn",
@@ -806,6 +842,9 @@ static const struct mhi_pci_dev_info mhi_netprisma_fcun69_info = {
 static const struct pci_device_id mhi_pci_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0116),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sa8775p_info },
+	/* Telit FN920C04 (sdx35) */
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x011a, 0x1c5d, 0x2020),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn920c04_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx24_info },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, PCI_VENDOR_ID_QCOM, 0x010c),
-- 
2.39.5

