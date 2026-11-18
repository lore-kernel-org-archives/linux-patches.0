Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047853;
	b=ar54t0MptgkM9iuhA9X9jZvqUvpCa/vbYs0z25fGZ2WqZ3tjyI7hMyoW1vuaZ0oawBFN
	 HwdTwJTGneUkJ/k3DG5Qd/DYklBFFipsprMMpaYtQ2+LyGukbEDaEpwKb1OVtyKvti+uq
	 YkXMYe4LXbJFu1i+QfOoh/pyZqU9Xw/CrJeu/44M8aE1/dK42WRlds2PUf2WbJwSn3Eqs
	 Za6Z2JWa95nYasezYJDHySY6P/kzuqbDhF6lDKU3rUji+1uunNnSf7SoZsp0+2JlGMYez
	 TJajqGvUq5qLacvuGfzTgHvzGNudJ+4WmsLrvG7QPUuF5pcaz8GXNQ9PVUPnXBqGC+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUYWe7Qj7PCgpVbqAjj/z1CAkX1UbEvLuVXKsp0kef0=;
	b=J1dM6Jbnz6ifzjoUc/bu61e/Lgcm/tJBT3ImARLr9ETbn/qB72B49yT/Kt8NgjHF0kxg
	 0eDuTqnLgCYSFWskmKYbQi4ZRvZXY1sVwieCBqwxEB1jefgz+To/wIlqmBcXaSWMyxXvG
	 xSkmy3gaGXn2WBU6PT2lF5OL/YBeWSMuH+KIb6hz3U7+1MK/0xRr1Dg5TVGxj8Dn82SX8
	 FdHHw3+39Cjs1yL0SjJcmFxbtj9niX2Fj/pk4SMbkSON9y2zToRJ2v81qh0cpc81Mw3Uf
	 htgP5NGvhwdlLd1tdhn83JK0ABbf6NkcVydfcKgrym9NZkhe3DOsqoXxQNHq1TdcuJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhal56+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DB606A31C;
	Thu, 19 Nov 2026 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mhal56+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8831F000C7;
	Thu, 19 Nov 2026 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047853;
	bh=bUYWe7Qj7PCgpVbqAjj/z1CAkX1UbEvLuVXKsp0kef0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mhal56+jMWFpEKQETXQGDJrcgDtpU7i1mICAhgCQUHyAJ13RU0i9HQW7AOGKa8npb
	 FLzlzLvM/9YIwHMdbLM2+mc1NredkyHKWD1NFQvNJzuc1m3LYy4uk/om3vN68V+JtH
	 l8d9SoPVjmdmuCH1dkrhwqpDPY/k/NOBak20i7I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1788/2857] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118150305.647638350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa5f96e3ef74f..f43e14d9d1175 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1079,7 +1079,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
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



