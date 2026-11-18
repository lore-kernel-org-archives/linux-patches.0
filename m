Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058304;
	b=aF5dZIWYqb30XXSamilbl6OhFDfV0/0pvc8nCy047+ZKbJ5tHK8/3j03RJCDnmBCwg7m
	 8JfJhUEqru7aAoGiGe5PgN2bC8hiEsWryKxIqjrmkFvlmro4LmPX7/WvgMoYhRf1+Rcbv
	 MR4BM7ezPX6w/yup/XWYLdyxBX/Uk7ApA1oHBczAIVurDG60m1lqUmBs59IGezDhMLSW7
	 F5duNvHsjdxrqP3/AxtkQBT7wA02ALGMphmCVxGVIBreqlosYCYVJtGpktuWr+/MjF2z0
	 NCsnupqOO1qeE+zYWme1pZnerhsXxJRjfVY+TRAm5SmB4RUM4a9Lfk7gdwoxTx+9sOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4zYxtlXz3pX7TawfNu022wxF/58J7Rx9ZnQt/pI4DA=;
	b=Dq+tiXPldM0xHV9g5lPlkroNPVFBlKiv+Mh6HpEUJxnMv3NmtkULXull2XwiMbzHEQS3
	 P/pnz1ZTUsPHpRofB6Af3elV4a0d+o9F9e+R4I2y2czv5L/MG4SaGen7d8tIKLazvjl/e
	 DGCQmwePmiViUhCnDyPihi3HaQnC4phCoON66vySsRpFTrs1vmrmZQ9927SYGiCgiA2Le
	 bAxn/DXilJrFrmMs7wXa+T6DGLl+A5qlK+aGuHumoMyhiX4IHDWibuMmAZP4stbT3147R
	 98zX5mP1/hcKe02alzgTo8+3m/iYeGQ3IeMBAH7iafJeH6+H/V/hAe5XMM4YpxaWOUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMs+D15+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42257606A31C;
	Thu, 19 Nov 2026 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMs+D15+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9501F000C4;
	Thu, 19 Nov 2026 03:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058304;
	bh=S4zYxtlXz3pX7TawfNu022wxF/58J7Rx9ZnQt/pI4DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMs+D15+vr6AXPIT1bsVWrTRR+mAVBniRT06PX1MU/eZJH5pBuOYdu73eVMMaeFzx
	 Fw5G6mvqWoIBIHGnpj0uBZ+DEAk3dZeIHzJEo1db5T62pS4doYeaplBLj08lX9Hf5c
	 OA6zEDG64G6/cdiWfnw4FuMdQKT+TOfxXjF5n3+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0436/1848] mtd: maps: pci: balance PCI enable on cleanup
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118145932.354933326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 377ef0fc4e3ef..ad175759c867f 100644
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



