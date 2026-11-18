Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045171;
	b=puZCKT0ronD94lCjUmBrO6b6F9Jeo0/n8ABL5RXq+1/X1FvYDf0eDMeiBzIb5SZYu12t
	 3N2sMvpDLuAcE22wYyvVaossRwkKEC1g4C4ToXV889LKhzpXtGfesFXZVty1k+e4JtFgp
	 TzK10fxW1/3IvDytRgU1pmwZEc+/eOlAqCo4LQXq90Bi0SZKASLhDekH/6UQRV7bj3k6J
	 83gsI0AnTgtN52Xij+AAIVqO03aCWD4XQZefZUXTMI8iszkYEksnYv1kywsRG/lGpe0um
	 wcmk7+vkwms8Sk92MO1YZ5Y5baYCM2Lk2esymxoRUiY4iaHLkYL6h//uAcReHZeQ4cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wsWLRCNV7J0jt8Jcs0l5B1A6q32aa4PNW8+xd4h8xIM=;
	b=CBAfLXDJj1EKqpR7ViqbSc3Xtawh7FZ0NxRwxkrQbIQugxX4gcOinZHXgOZFqMNNaaD4
	 36fhwOmCDgu8fD0j4SoAfbIzktlbcMJxafwIH2cV6zu7dpaAIppC375Br83YuavA4T6Go
	 jgbPmc8g6m05dmtTL14Bd9MyszrYDOkPUBTYiJOuE7OsN3cbOYvjxetxFksGH5ywgf12u
	 eHCtoUbsyoc1fAQBdpe+A0Pk/gTFKdRWwtqSir777FsAr1F3TRd47MSJN1LvS/9n/gWQM
	 DjQ6K+mpbWQ0nvNkJeQhfZf9DetctXxqSyLPji39dHEKE50IzMVbNWYQIegnMrhKaPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIu14y3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38805606A32F;
	Wed, 18 Nov 2026 23:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIu14y3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD451F000C4;
	Wed, 18 Nov 2026 23:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045171;
	bh=wsWLRCNV7J0jt8Jcs0l5B1A6q32aa4PNW8+xd4h8xIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIu14y3lg2PvUHKJ2WhpoNsbTx95/ZDqeQK6BATKzbl2LiKy3zCJbVBwFuO5tTiLE
	 lO1gwgv0IfyhS2YVpFWSeXssSVnciTpOHY2Rw9OPDluv8O/Tnk4sMBZsdeJ0CV0PGj
	 SpgWF8sEW/vxkUVgN2wzE6xiK5VBWv56JJrGuFAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0826/2857] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Wed, 18 Nov 2026 15:31:00 +0100
Message-ID: <20261118150231.313430353@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e6ca524ee5b2705be30ea19ce2e55122d9f9ed8f ]

The PIIX4 PM device reference taken with pci_get_device() is dropped
again before the iobase resource is allocated.  If pci_assign_resource()
fails, the error path calls pci_dev_put() on pm_dev a second time,
releasing a reference that is no longer owned and underflowing the
reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 85cd273ce0654..1df5ea5fafcac 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
 			return -ENXIO;
-- 
2.53.0



