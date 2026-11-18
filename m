Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045165;
	b=cDgg9lYin9O2MKMxQauSc9Zt3dJ87xkqxcKZKJBign1obt9iVdYP1MFXaUxkfCRrs1hb
	 ENZj7+8JiEAwYgBoooXqkU9s3xhPC6B3uYMqwPYF8xh1pf1sf9gdaMb6jgyX7U3HxRw8o
	 TxwAHgFgHa4A7ZxN1rODKKM4z3BoiREgCz3kjHv+22/SIHOPWhNA4aXmM5xEZZ7Bf/Gh/
	 8S3AUCjmOOCEsC6ZO4oXCRe/5MTCkxEv0sjVZGshv18jo/ZwTSp0P/0NiAeyQ2bddd1rS
	 G6YK99MZChpKiYM7KSP5JoaJI6+meWLEZVNtolzywNIEF3H5rhZ4SZ8a63s9DtzOByQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dUzSJNh3nXjiS1UrJQv8VAnI1FD+KoAfhOxjY5auA5U=;
	b=tcziaMtHZF7X7zvw9DeyaxuQof7dTmgh4OPE6SnJlsTj36ffQ63NbrxFU6Hw095SsPQ5
	 IK8jvoVHBK824EOG9Hbi41blqhNs5QC0oXbA64DOfXJfnSaWIUo5CAwSuW85EB8nNYORq
	 M7IUxrSTsJx7DO6fq4+fEOyGpb+mSy4Lare//zpF6JPXge/ZPyXGYi87r+M3OJDoXDkNk
	 3+6NQTF2md95yw/XCJ0MUoSBGWxHZ8o/y4wb/Q+PNcpbWbiu5imLkHCf+294TTgPSr8Kc
	 wu1y6hga7nrZCHwkQiZj/GYCHVTf6uV+mrEOi1j5weKAvqSwBwoBU1H6R4AhBvBuo6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gk9u2rRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD275606A325;
	Wed, 18 Nov 2026 23:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gk9u2rRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD851F000C5;
	Wed, 18 Nov 2026 23:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045165;
	bh=dUzSJNh3nXjiS1UrJQv8VAnI1FD+KoAfhOxjY5auA5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gk9u2rRBBR5l2UoYrpxGGwJ3CvOgnpF/WQfWcmtd7ls1XGtCDNDSR66FBsnpvok0K
	 1aDGAugEdMvo0KY/EfrxaVnBNPxL5gnn/wS7goPaL+6e1d1wwEIH3olyu29lLTR5hG
	 xzVBCOtMlp3BFuUmELbhgVJ1RHtJMtycqK12ytlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0824/2857] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Wed, 18 Nov 2026 15:30:58 +0100
Message-ID: <20261118150231.241032771@linuxfoundation.org>
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

[ Upstream commit 1a122f5fecbabd47b81b1be3f0934f57b78aad42 ]

init_amd76xrom() obtains the PCI device with pci_get_device() and
hands the reference over to amd76xrom_init_one(), which stores it in
window->pdev.  When reserving the ROM window fails, that function
returns -EBUSY directly instead of going through amd76xrom_cleanup(),
so the reference is neither released nor cleared.

Drop the reference and clear window->pdev on that path.

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/amd76xrom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 281fcbaa74e70..43411ec02ed59 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -152,6 +152,8 @@ static int amd76xrom_init_one(struct pci_dev *pdev,
 		printk(KERN_ERR MOD_NAME
 		       " %s(): Unable to register resource %pR - kernel bug?\n",
 		       __func__, &window->rsrc);
+		pci_dev_put(window->pdev);
+		window->pdev = NULL;
 		return -EBUSY;
 	}
 
-- 
2.53.0



