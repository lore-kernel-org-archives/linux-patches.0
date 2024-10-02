Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3080817B421;
	Wed,  2 Oct 2024 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877007; cv=none; b=Og3MLHNypDJVgfZVHVAv0ccqgEX6L2rAHIHnBKkdcj0A1FEssJp9Lu0Ha9mrkfn6tAGiJhUE16Qi7CAm+LwKYUsv40kGzVzuB2V5fBWhQLdLdempCvqW6m/3Ami1vX0f7RG2Wo4gLefo7PhbNXnnLXJ9A1jtT956irpxSb46uZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877007; c=relaxed/simple;
	bh=t/Af4udjVTtVxvkA7qO35Wm8pQB1KRAlcPfN/69Laug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlplbHrfnG9YMw1Pd7U30xzaFRs07fSsMRYkG+AOp3uCANtmrtNgy52blmtCGUr/mP4YIjaD02INE53Zl4DzJYKdTRZs5FSWniSbWfkANAUz9VE6T3pgt/cRg+ycCnXHBdXBnv+x5rmtd2PgkDiNQg6LwLzoOihJa1fnxfY7Dgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJWt56Sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJWt56Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668A6C4CEC2;
	Wed,  2 Oct 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877006;
	bh=t/Af4udjVTtVxvkA7qO35Wm8pQB1KRAlcPfN/69Laug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJWt56Sjnno1m4hyFpvfcjWZ0TXT7qFX9nuaJEgzQT7HasNs9+RKh4Qu7qA1/mmKm
	 MjwklxHZKzBnoW1w5BUU4rHvNHlPAWWTv7qPhcFGOTriWYKCaR6FdAbJs69jpbtOI6
	 /WHpGZeUjq2US7LzBWeHZpRsizwagjFFZy5meAB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.11 591/695] bus: mhi: host: pci_generic: Update EDL firmware path for Foxconn modems
Date: Wed,  2 Oct 2024 14:59:49 +0200
Message-ID: <20241002125846.100508169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

commit a7bc66fe8093b48e86386cf73dd601feaaa7949c upstream.

Foxconn uses a unique firmware for their MHI based modems. So the generic
firmware from Qcom won't work. Hence, update the EDL firmware path to
include the 'foxconn' subdirectory based on the modem SoC so that the
Foxconn specific firmware could be used.

Respective firmware will be upstreamed to linux-firmware repo.

Cc: stable@vger.kernel.org # 6.11
Fixes: bf30a75e6e00 ("bus: mhi: host: Add support for Foxconn SDX72 modems")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240725022941.65948-1-slark_xiao@163.com
[mani: Reworded the subject and description]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -433,8 +433,7 @@ static const struct mhi_controller_confi
 
 static const struct mhi_pci_dev_info mhi_foxconn_sdx55_info = {
 	.name = "foxconn-sdx55",
-	.fw = "qcom/sdx55m/sbl1.mbn",
-	.edl = "qcom/sdx55m/edl.mbn",
+	.edl = "qcom/sdx55m/foxconn/prog_firehose_sdx55.mbn",
 	.config = &modem_foxconn_sdx55_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
@@ -444,8 +443,7 @@ static const struct mhi_pci_dev_info mhi
 
 static const struct mhi_pci_dev_info mhi_foxconn_t99w175_info = {
 	.name = "foxconn-t99w175",
-	.fw = "qcom/sdx55m/sbl1.mbn",
-	.edl = "qcom/sdx55m/edl.mbn",
+	.edl = "qcom/sdx55m/foxconn/prog_firehose_sdx55.mbn",
 	.config = &modem_foxconn_sdx55_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
@@ -455,8 +453,7 @@ static const struct mhi_pci_dev_info mhi
 
 static const struct mhi_pci_dev_info mhi_foxconn_dw5930e_info = {
 	.name = "foxconn-dw5930e",
-	.fw = "qcom/sdx55m/sbl1.mbn",
-	.edl = "qcom/sdx55m/edl.mbn",
+	.edl = "qcom/sdx55m/foxconn/prog_firehose_sdx55.mbn",
 	.config = &modem_foxconn_sdx55_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
@@ -502,7 +499,7 @@ static const struct mhi_pci_dev_info mhi
 
 static const struct mhi_pci_dev_info mhi_foxconn_t99w515_info = {
 	.name = "foxconn-t99w515",
-	.edl = "fox/sdx72m/edl.mbn",
+	.edl = "qcom/sdx72m/foxconn/edl.mbn",
 	.edl_trigger = true,
 	.config = &modem_foxconn_sdx72_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
@@ -513,7 +510,7 @@ static const struct mhi_pci_dev_info mhi
 
 static const struct mhi_pci_dev_info mhi_foxconn_dw5934e_info = {
 	.name = "foxconn-dw5934e",
-	.edl = "fox/sdx72m/edl.mbn",
+	.edl = "qcom/sdx72m/foxconn/edl.mbn",
 	.edl_trigger = true,
 	.config = &modem_foxconn_sdx72_config,
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,


