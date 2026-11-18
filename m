Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029055;
	b=BVGPMqAkSp4OL3N41VmcEB+UlTQH8bnoK9l8TA5CVCs3bxm4vFaIyYepVclNJKO3bF1i
	 Y4LJjii2oGxSN7dMLlaUAqeD9kJMxgl5egg7yAhT/e8XpzUhcZz1Tt0vIke3i0hAYIA4t
	 3akmSX7ywu7gQoYqGBU+2bIk6SnMhxWAKmHrYtlkeccVcQetPTRwofvHpofPH+qMCy8P4
	 N75/+MR6FV3JvmEYz+u6+Rbl9tgkM7sFJxPaX+mTn0YrM1i6dnwYz/QK5YYqTVnkLI4Gb
	 I7QuyQNbcO/Zfv7b/Uf08WurBDJFT68QiWjFBULy+yDB8Rr0obOg1pV5s/WEfbY4GSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVM0FETOnPJmzCvNDxMclbqghjELHPHQKGNMIgQP1SI=;
	b=vQkd2AovjHZ2DMvQj4xDDLg4HStq1/92ADUiX0mPBvIIvaaXkkzyKrRTAaAYEljoM9l1
	 Uo6n4RZHbIz4jYkg/MBly3t3nb6eXsAMZSgZfrIH6sN2ha4aQXybQIQX4QLaFcPsZ3UAr
	 eIXOKUboNlDg57Os0Slq1ogdFv8bUQ55mP/y6eujYKFwBAErt+phMqXr72At4XrLvH8cd
	 YCIJ2zFR+0sGyFYOUaRykF7adneUYmodK8ciDlaOi2qqnbZpJZsnrQVDTZPq6O5Sw02oU
	 dUY1Sjt0XUEXkUFpMvigS2IID+9XOgsMI8hvO5IFeQc7lJXKVpdsj2d9ToSo/B5OBAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwP3I6X2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081E0606A32F;
	Wed, 18 Nov 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwP3I6X2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE31F000CC;
	Wed, 18 Nov 2026 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029054;
	bh=SVM0FETOnPJmzCvNDxMclbqghjELHPHQKGNMIgQP1SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwP3I6X2GxXPikEMTEFvV+42PvEdohPuAhVCk/HjMuRIv05UC+vMYAoqhAw21NG0h
	 t/lSzPHD3DlAoyMwD1GhFqzcjRAz5gutK3TWQpCAn71+TxYSa0qNhg74xN9xp+9njz
	 Lo1DA25kZaHq+aHVg1FPkHlCyI7+b+opBc5wO3PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0211/1756] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118150016.739879468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit afe2aa9dc93d904730bab63f5ccb514a318e6464 ]

vntb_epf_mw_set_trans() programs the memory-window BAR through
pci_epc_set_bar() with hardcoded function numbers (0, 0), so the BAR
lands on the wrong function whenever the vNTB EPF is bound to anything
but PF0. The other BAR programming sites in the vNTB driver already pass
the EPF's own numbers.

Pass the EPF's own func_no/vfunc_no here as well.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260728172306.2751813-2-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 710bddc30cdfc..ea96174cc5110 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1065,7 +1065,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	epf_bar->barno = barno;
 	epf_bar->size = size;
 
-	ret = pci_epc_set_bar(ntb->epf->epc, 0, 0, epf_bar);
+	ret = pci_epc_set_bar(ntb->epf->epc, ntb->epf->func_no,
+			      ntb->epf->vfunc_no, epf_bar);
 	if (ret) {
 		dev_err(dev, "failure set mw trans\n");
 		return ret;
-- 
2.53.0



