Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022987;
	b=EvFd5cgVA0a+6d8ga8UKaLk55jF+gPyxXsmsnFyjUWay6LOxcVzhFQiYbrz/E8rfC+NH
	 OR1kcQgWyyaYSerbXciXf6NsDOEuhdx8MfqmxOMrJ2400OtZsNmiMS7DtdvYoiRa2Dr8S
	 JvV12YUahVfWibnHcCNV6dSEaFrJXKzHgFKH24DGTEYRulqhDnsbVhSvdH5JNOj5styGD
	 t1hMHKUstzXR/aElmtUyAA0kzkWeH257/t6OcNZu8bHTPQKlXSp7DAynAf51JY15Fvpvl
	 1eOlSD2MG8D5s3HH1eCs4wglwr75v34AwSNu5ogdn7nPiv/E0TvQNxI/0cX/5LTE6HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NzGbzI9OXjjdN9q1L6aYSCiieQws2VOsEL8S43MJg3c=;
	b=DEW3E0nIQDxmy20+hlU3P2yOfgWDn7PZIbNdLRC0fA0xc0O96a0HAy53NmUv/tcHFujH
	 fLJ3+JBDrrGKz8DMYvRe+XgLP8kiI5yRBS6OgSN6F75+G97kzokEc9/hYHKqUJwjq1+kX
	 wA9v+0LARjkSP67EflCPrN+vi5oysMnPE2ZSiKAi/BS0/1eIyQmi0iE0KPoJPcdQEJv0I
	 N3RhdWu7bWcdSZBVjBb0Sdc1R8iFhpRMyzr/IzWRHT2+ehXI6jOjrztuJjyD+YASodeft
	 vxz8t6O4WkMh8DZf6+vWH/Ex4AMRxnC/y4nQ3+nLuKhb79fH1frWL6q4SlYHgUCIbOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4bwU9vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24D606A31C;
	Wed, 18 Nov 2026 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4bwU9vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ACC1F000C4;
	Wed, 18 Nov 2026 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022987;
	bh=NzGbzI9OXjjdN9q1L6aYSCiieQws2VOsEL8S43MJg3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4bwU9vfuCtzF6k953EAOYXOOPQy3i3X5xNu03TK7aoqisjRs6zlzznMMQ+Q7W4po
	 v80KMXsxRuiA72UQ8MIim24/egPQPVOgcRDtXvIVrdV4tz5b4iG9B14eLMp6WhsZut
	 gcREUa1rlG8ZbMheoNqfr6/oAXSBZxMJZCIY1DBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0208/2151] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:32:23 +0100
Message-ID: <20261118150129.359767993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 39d9844873f53..eef9d0e724381 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1156,7 +1156,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
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



