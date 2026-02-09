Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4070B3783A1;
	Mon,  9 Feb 2026 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647857; cv=none; b=Wk0kuYHLpFR7lkVRKio05nhRX9Ok1uXQf8qcruWDia60kM0kUu32+liop55scBBre0LlFz9Qo0K/RWtUWC/AIsZkh8tQ75xsDNEP5RmkC8DhdjvBmU8NpQ1Pr0+YyorG7mUhBqsybKabbr5nvYaYCObabOuy9bv8DVtmxJwtphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647857; c=relaxed/simple;
	bh=GwUSIXi4Uimpin0J6bxnqnHgmtcbpWp7DuUU8Z+gakk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akyKOQkN5GQnuJutMivoMMBBDzLrXOIEw7eqCma9m/WPlqLj2v3t+l/hvYcQ0FUk50DXsuMs8zLCuhwF35tLsvcTO1darqx/0w5T8sXsCyCT8C5H+EgjfL/S7k7j+16QNRRwqY+wbrXXpcz55QXYUEvKAVKZydjF8fsso7Nw0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjig2Q26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjig2Q26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2626C116C6;
	Mon,  9 Feb 2026 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647857;
	bh=GwUSIXi4Uimpin0J6bxnqnHgmtcbpWp7DuUU8Z+gakk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjig2Q26U71Qz4E2VkN6neKXroXQMH9uk+rsPhNgo4LAFqKRIRapeaUnL2426InCx
	 QNo2pi1rzmUGTAb6Ch968f6OnqtGpY91zX2iU5www3WBA9vWVx8or5i+2i1KxEEnqL
	 /V+qOuhnkNOh7tkBX/WfpAvobBw8ZpoCaJHe64Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/113] PCI: qcom: Remove ASPM L0s support for MSM8996 SoC
Date: Mon,  9 Feb 2026 15:23:17 +0100
Message-ID: <20260209142311.929163000@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 0cc13256b60510936c34098ee7b929098eed823b ]

Though I couldn't confirm ASPM L0s support with the Qcom hardware team, a
bug report from Dmitry suggests that L0s is broken on this legacy SoC.
Hence, remove L0s support from the Root Port Link Capabilities in this SoC.

Since qcom_pcie_clear_aspm_l0s() is now used by more than one SoC config,
call it from qcom_pcie_host_init() instead.

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-pci/4cp5pzmlkkht2ni7us6p3edidnk25l45xrp6w3fxguqcvhq2id@wjqqrdpkypkf
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20251126081718.8239-1-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 4c141e05f84e9..2fca35dd72a76 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1010,7 +1010,6 @@ static int qcom_pcie_post_init_2_7_0(struct qcom_pcie *pcie)
 		writel(WR_NO_SNOOP_OVERIDE_EN | RD_NO_SNOOP_OVERIDE_EN,
 				pcie->parf + PARF_NO_SNOOP_OVERIDE);
 
-	qcom_pcie_clear_aspm_l0s(pcie->pci);
 	qcom_pcie_clear_hpc(pcie->pci);
 
 	return 0;
@@ -1255,6 +1254,8 @@ static int qcom_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_disable_phy;
 	}
 
+	qcom_pcie_clear_aspm_l0s(pcie->pci);
+
 	qcom_ep_reset_deassert(pcie);
 
 	if (pcie->cfg->ops->config_sid) {
@@ -1393,6 +1394,7 @@ static const struct qcom_pcie_cfg cfg_2_1_0 = {
 
 static const struct qcom_pcie_cfg cfg_2_3_2 = {
 	.ops = &ops_2_3_2,
+	.no_l0s = true,
 };
 
 static const struct qcom_pcie_cfg cfg_2_3_3 = {
-- 
2.51.0



