Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021665;
	b=fG+amXcl99TWUn7bwDyiizI8nEt1NvmUKlmsMSf4C0iJOB+c2Xnd6UvwzNfjqRt9Curc
	 ugF45us0eCsvC4nLdnlOcin0zY0EKgmvTggliVDvSpC7u/Kgk2GOW9MYmbbkykR1LXxem
	 Z4MoBJe/mEjQnVc/AP/71US9PEuTuGF1W9jsy4LmHE+98UNsd5+vRPbi5Wmdaf0gNMUbY
	 v39o0yhU0TXPuXSpBVCtKw5a21IZwt60XVuWlMdxaLiyNKvsf5goGiO09qpyyz6hAvR92
	 eoSSfol14hZJ1pjCf7umbUvpLAeeSlDMQ0cPHN7YxsNIqt+//bkCEHEZxa/55nCp3gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91J5X5ZX0Po9hYp/jx+D2EmI4Ymjm+HLENaQ676EaBI=;
	b=F1aAT+Qc8BAUzqJdcz+axqQtx1YnAWHdMUULB10iyF/+WfNFl2Psdj7jbsdLOQcMfgaz
	 syCSDPN+6vIDyzgqArsdsJidphLK+LGq+RXvzwsyVPC5lzsFZY9Vi0UfMQIzPEcQ4bHHM
	 bx/zXsdf9abNUYDb+v9/qZNkn/V7cFbPACt3t0Z1p3ANE/e3srMyPh2HLTU9KHm2YTUSC
	 mp+bLdaVr6BYePSg08q6RoeE6Eug4jqvme8E3QmxT/lh40MJMDyK/rUSRCMm6mZLkm9Vg
	 fblgccJYda9pbnxJn/AzN6dSRb6rj8H/I28oAspQWQFRoxFYlyN+8u+yOf+Fro+BMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7RXPU0X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA090606A31C;
	Wed, 18 Nov 2026 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7RXPU0X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E439F1F000C5;
	Wed, 18 Nov 2026 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021665;
	bh=91J5X5ZX0Po9hYp/jx+D2EmI4Ymjm+HLENaQ676EaBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7RXPU0XAOJL2mN53sOplDygS2k7G5Ou9mz4nnImUZ6b1fVdPoa1NoNOonCF5Ehut
	 Tt5l8ptGNf0M4hpv6XJs8uGamc4FeSyJeFTQL5JiKDBRvF7F5jVog09kzHc/KZe9GN
	 WkPEJzfBsav6WFAvAlnPzHl/gEm+8xTZrYMIrlT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2388/2651] scsi: ufs: qcom: Power down UFS during system suspend on Milos
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150411.379087389@linuxfoundation.org>
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

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit fb2a238f15f0fc2dacd12f8847b0ec0a1cf7ccac ]

On Milos the UFS PHY GDSC is turned off on every system suspend and the PHY
loses its register state, so exiting hibern8 on resume fails:

ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x18 with (MIBattribute 0x0, mode 0x0) failed, host upmcrs:0x5
ufshcd-qcom 1d84000.ufshc: ufshcd_uic_hibern8_exit: hibern8 exit failed. ret = 5
ufshcd-qcom 1d84000.ufshc: __ufshcd_wl_resume: hibern8 exit failed 5

Set no_phy_retention so the controller and device are powered down during
system suspend and the link is brought up again on resume.

Fixes: 04bb37433330 ("arm64: dts: qcom: milos: Add UFS nodes")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Tested-by: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
Link: https://patch.msgid.link/20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 954be9343f42a..08f83d789e46e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -3001,6 +3001,10 @@ static void ufs_qcom_remove(struct platform_device *pdev)
 		platform_device_msi_free_irqs_all(hba->dev);
 }
 
+static const struct ufs_qcom_drvdata ufs_qcom_milos_drvdata = {
+	.no_phy_retention = true,
+};
+
 static const struct ufs_qcom_drvdata ufs_qcom_sm8550_drvdata = {
 	.quirks = UFSHCD_QUIRK_BROKEN_LSDBS_CAP,
 	.no_phy_retention = true,
@@ -3012,6 +3016,7 @@ static const struct ufs_qcom_drvdata ufs_qcom_sa8255p_drvdata = {
 
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,ufshc" },
+	{ .compatible = "qcom,milos-ufshc", .data = &ufs_qcom_milos_drvdata },
 	{ .compatible = "qcom,sm8550-ufshc", .data = &ufs_qcom_sm8550_drvdata },
 	{ .compatible = "qcom,sm8650-ufshc", .data = &ufs_qcom_sm8550_drvdata },
 	{ .compatible = "qcom,sa8255p-ufshc", .data = &ufs_qcom_sa8255p_drvdata },
-- 
2.53.0



