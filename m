Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020141;
	b=Yqz0MUGEwTNi6Gjrm5/3rWjwTWjjD/7B5N+7GhxfK8fjvFTlUyw7Gg60X/1FOCy4rkqW
	 i0x2+a+cpLMz0eBP+TTe211aEjasFBxfSdE39NDI5MhznZ8buAGUZ5Yzd6yeiBi3CCW0/
	 qME8h7ZsGvZg0dRSNZgcscngKfzGN2S0G0edIHdZvK8k88t0bFrZukGl7oM4qP0fONGex
	 CWQ8slQjD4VSE3DN0GskXM/lP1V4X6ykKlzUC3VIdN7NgtVTPrifRNXwCB6ipt03s9F83
	 bNyHBdk9qyU5hNsdIbrF6ldyGeqq9Lz0p1m1jRzTfh4+r0snHrWuxwkcCHUEbkLahdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PkTNFO+sGV2w4HtA2t4BWCokDKBfuUxGhBMS4LtGkrM=;
	b=SPKP1lyuVJfACOdxHOdtYlVf3n3h+xZ/V7W1EbKOeFHfzYju3femUjjNYapSlS1ZqpVs
	 rgIr2j/NebIr1kyuiz7kQyn+eEuxIGroMsHTQF/LqRRxsxK/ZCxAhCVzPGF2jO5knk327
	 AtzbDvBTj7HLt/+JfoPqHhCcHEibCqAw8GqMraVoNZfdprSgoAVL3mP2UuqtSgvkvkco+
	 0AXAblvyS3WMf0dBo2MsjjkClIlyWG6gX0Wx2L9LTSn0gdIGJw6BXKzWKKl/AfmRLneKa
	 yYRNTiFH4ruX5aB2AjJS+leP9fpbK/6k60hzxQLDf0SGlkQufSEE/YQUc3dzJ4GKl7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYkGgpdj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0770606A334;
	Wed, 18 Nov 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYkGgpdj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F01B1F000C5;
	Wed, 18 Nov 2026 16:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020140;
	bh=PkTNFO+sGV2w4HtA2t4BWCokDKBfuUxGhBMS4LtGkrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYkGgpdjRh+2XmFkAD9iAWEID7AJB36Rxf6OY0y3D2qkzxmNKSXELBSIp16Tcw4Q6
	 8YZBQEsl5MMGRjyM+8oSIY0XFRGB7NtYmUBY68QvQBLcsTJZVEsZgvyi1iGmF2jLDP
	 HRv8yT06pb/GXE/kg1qiOqr4Axs/0bYcJxPU7V+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1847/2651] PCI: eswin: Publish the platform driver OF alias
Date: Wed, 18 Nov 2026 15:51:27 +0100
Message-ID: <20261118150353.547084768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit e564a064a2d61641d6c5068d41e677e6180aa5b8 ]

PCIE_ESWIN is tristate and eswin_pcie_driver uses an OF match table, but
the table is not exported. The resulting module lacks the OF alias
needed for automatic loading on an ESWIN PCIe host controller.

Export the OF table. Keep builtin_platform_driver() and the intentional
absence of an unregister path unchanged; module alias publication does
not require making this interrupt-controller driver unloadable.

The issue was found by our static-analysis tool.

Assisted-by: LLM
Fixes: b593c26d081a ("PCI: eswin: Add ESWIN PCIe Root Complex driver")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260920033737.13957-1-hppiscas@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-eswin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-eswin.c b/drivers/pci/controller/dwc/pcie-eswin.c
index ce8d64f8a3957..1bb44696057e4 100644
--- a/drivers/pci/controller/dwc/pcie-eswin.c
+++ b/drivers/pci/controller/dwc/pcie-eswin.c
@@ -388,6 +388,7 @@ static const struct of_device_id eswin_pcie_of_match[] = {
 	{ .compatible = "eswin,eic7700-pcie", .data = &eswin_eic7700_data },
 	{}
 };
+MODULE_DEVICE_TABLE(of, eswin_pcie_of_match);
 
 static struct platform_driver eswin_pcie_driver = {
 	.probe = eswin_pcie_probe,
-- 
2.53.0



