Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036095;
	b=maor3fQUJZo/sazPf9w06GM1kckIYL0KCvSHHBNR1XmGH92N1ljyGrJvyBRdMY1nQ3DL
	 /EhcOkiFH5qX5GaQkv2gRYCXq+vWtUEIj8RwmEwwjsqXPsR5KiVKUhn6X0aeMklIKDr16
	 t+hAq7Kw8NG9w4sraWlzLf6R3K4FIPG9bLuhoT4h0k6o2zIAG2+B85LSSVkEA5bKuDScZ
	 e7+2RMCAUV5XRQYhGq3iVpmi0oOV6LmofCizlyyXlUxcN3E2XTMhzkgt2/ZhiLHPe2lDW
	 mzoenwYcPUF1Z7dLxoR+ixD1Jfi0Sf4yer1/AqmQ6sj5PmrJutCMqsFvsVOHTopQ3GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLPqPBOdaYsOuvKemy+j5qdajKqefrTxzFZeb94PF38=;
	b=xY9dzqwVuKfKz2ZrLzKOSbgo3JtxROSaYP9jt8uIvh0s2LcZ7vyvSYVIzxdzYcM1x9T6
	 1hYNvPt5PCE+IJ2H7K6eYiH3dp7M63UDvN1qaeRKfKzI0HOE+M9GwAa73xeGdhD6LMqU5
	 Hq/6LM9bCtfbseiK88Dc/WRhQsQXoh1HVgmS5DniNJrZrqKj5dq+y6dcPzuimCFJFy7VN
	 ynAjkHv3O71Zj3OvZ+Di4sLPPQ2+QNgZqtDarFjqm/8VlZ7S7K/dLiD94j+WG3EUNWvX0
	 KMCFeTo56tKYtgv+sTGayi54Q86qT5d+nkMH10/8DR4lDU5hYwFMaFZwJt+mAH2j0Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViX04Qi6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD0606A325;
	Wed, 18 Nov 2026 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ViX04Qi6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829C91F000C4;
	Wed, 18 Nov 2026 21:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036095;
	bh=xLPqPBOdaYsOuvKemy+j5qdajKqefrTxzFZeb94PF38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViX04Qi6p7BvwvTHfVkwzg9Hokd01X5mYSnumQCthbsCuTYPnJcE+qxs4EcXX+yYt
	 KIWgMc8UGRyBYCb04E7Xt84RibZD0zIw7YiKSvAuc4YKdFd/wb3rolqYDBKkDmh4kJ
	 KelgGFiPUZM8Hkub04KsDOi5hHyDsHmElAOKGfY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0938/3318] mtd: maps: pci: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:26:00 +0100
Message-ID: <20261118150347.704189738@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 3be16e5d4990bf96309ac5ba35cb369c6015bce7 ]

mtd_pci_probe() leaves the PCI device enabled on later probe failure and
mtd_pci_remove() does not disable it either. Use pcim_enable_device() to
release the enable reference after the existing map and region cleanup.

The imbalance is already present in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index ca00d211e73e4..c6bbce6aed417 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -256,7 +256,7 @@ static int mtd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct mtd_info *mtd = NULL;
 	int err;
 
-	err = pci_enable_device(dev);
+	err = pcim_enable_device(dev);
 	if (err)
 		goto out;
 
-- 
2.53.0



