Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039277;
	b=M0cwUInXVnNKcSTqSQxETjlN5VQWrc1NyLB/QFqBJeBFnUdsdxxAEtbIo+dNLLPxzD0G
	 EG5D30mNzCFFD7VeF75N8E/1v8v84FJmhxHXrNyydjrwkH475bUqgQ+Ss0lX7pl76J0ud
	 c7kj6Ct6z8wxd1u3K3xA3LkDJ5SV0UGlP7BswXWM4/5dXul8jhm7dTHwjXcDcRyRc1CvS
	 PJzDe37t7LVagnqmSUBIU7SiIS5UvCc4DWOAboEWJstkTlK/vcGgLrtT4QVZO/ydbolGz
	 OYXThor0KGyM9gQiHWxng2yBa44XMvhGGt4HEcWebsAxZM+lz1pOrl2heqZJNwh7V2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0sy2E82sPh40cYWiMbn7pGDakR9gnamAJMv6jinFAU=;
	b=4lA3EclBfOEKKRE6w68V2MsJ1hANlq/qmxfhwoUiEs8QXn1PV4Qh0Q1QrMsIBbM6adNz
	 IUK8Xj97mXynlUE6CaTQe3TDU8zReanaB3IeaLuEIH0l+ca1QnnMWiFo0mLx5kHChsBvB
	 iMkriN0yv2XQzha5QYAstt8Qj6EhcT2A0U9D1mwlt+45htgwvS4EpB9WtBR/rDeS4I5wx
	 01xNXG5i47e5Oqm3NgeBIzSM5zKMhSUZANMDgG9sKMKz72/FV+HYmvknvz/2qOnAonBaa
	 I5O8+pPoe8wLIdkPbM6pOiWgXEGYgbLgAfJR+Ggic40fogy83K9MxyqwFlsLcMk56WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFLi1yp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E1606A335;
	Wed, 18 Nov 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFLi1yp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70B31F000C5;
	Wed, 18 Nov 2026 22:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039277;
	bh=z0sy2E82sPh40cYWiMbn7pGDakR9gnamAJMv6jinFAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFLi1yp7Dv5nKbJYxdhoF1RiOOGKhey6nzRtv7MKpi07iv4NFfn5eBFRPUpZy4hkL
	 hN/VSjNPSecQcP0zEdI7xzEiUQI6cVrulI14Bj/2+AZARDP/OKXpOcFfmC0XLnIT0p
	 3ag6CEdbwSHzjXdiRtDYgZkiH7kSlDGpwkyBkQcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2042/3318] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:44:24 +0100
Message-ID: <20261118150423.303716426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3de4269155f67..64732f1d704c9 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1076,7 +1076,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
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



