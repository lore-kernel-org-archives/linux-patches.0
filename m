Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054832;
	b=r3S+DqpgT29mRrgK4C8On4snfCKOsslUJpGaI93gl+WmFmJaloELkL36/cmdmQl84hqv
	 52/FRgt+2N89J2y0+w+O0OqyRx6ItOuEHjGdVJNm4k4q3FZQDRnJdO43S3c0arEbhrjdM
	 s6zgSZH9cyLvycWIzJjEYwKyWvdwXVGzc0UUhw41azcgy/VTJ3C/h24TNJ9KcVroQF891
	 7zxJgosjbCfQOwihlunW/bWuQRMHArERhwz5z6aYUEMJWgte4gUZu+UTM83oYtDJs18DS
	 z2VTdmVoMfrJnn2gQS4w7e68w2Ibj8LeGeHdY6thg4LIeFNW9lnC5td1KwkyJaBhC4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXZwYLEWJvXp1mowIb8QEyWl7ypMqAWatwNr+hWFh2o=;
	b=QW5t0sckPFSj+V+Q8MzvO55VyPLURLU4fbpXPnXpxQB4xac6C7bwrQd35uanBwt7Ke4S
	 cpFjDLOEq7HKf1Muph+6zLd/UjifNCVE6OaLFiKAvnZtoJKvEUQ01iamL0MIeMEWUh7DS
	 q2oB6xNwJnFPrMTt+ghVJ4OjqxVwSlOsklIvhOYb/inaf9u0Q3hK/dKeoBfcSViKtDeNP
	 p5SD1GQTrkTTsMFuuY06dHIgVt1vzd7cp1FLp2mYqxY9hi1aEMB+/jznLX9S7S1DPFcnG
	 Ix9aPcppWohuRmaDA+UUofeKQemVQSZaQ60QBLEAr5UBcZIvwGp6LhXD1QFOCsR9nKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwIzkPeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E51606A31C;
	Thu, 19 Nov 2026 02:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwIzkPeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F201F000C4;
	Thu, 19 Nov 2026 02:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054832;
	bh=VXZwYLEWJvXp1mowIb8QEyWl7ypMqAWatwNr+hWFh2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwIzkPeMxKmaN+w8FG6kZaWCtROx5UW4Iq8S+JixHt6p0Pw0K3XD2Ifhz+oBzr7AI
	 3D2cytYeYawZ0kBxkUpg5TmL+4pXpMaJpZqybIkAzpshG01Yf2OsVL2xpZdUmIx2hl
	 KqVavfDd0Udvl3pSGW9P0kiHc9wRvvhcWQJdFvLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1378/2214] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150106.509801312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48e4bfe6f32fa..30c003d8b0dd6 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1033,7 +1033,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
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



