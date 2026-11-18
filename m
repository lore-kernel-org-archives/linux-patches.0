Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036100;
	b=rKkPlV7mN6Jfa0dsprqab9kC40tBn8GaSuhzsVRACTpQOd+zd+23y0ZbhWV9HiJJJhf8
	 pbNNhQ1cCoB0pYg9ihaS+6hLKjEM2OVhSvoLCN7KBwRPVCEqPRAmETk4IsUKKAmmy1j7z
	 K1l4lQjVjEkZzgCWNhX+Uiokl+LrhQgQAKit9z+qSvEZ1CHQtSRW9A4vGMoXDcGJh2Asl
	 vxs130Aa1invlsMqV7ENZd3XnTZQJv6tkd4AzVqbaqTp7/NtuMBbHWrXp2p8P/Q2BTfcX
	 7Nizea/3m6p8iTRIRzjT6nPTqPhOfZGxcuW0+MKps68UbYZmgbHnabnTv5pzpy5y1+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+sSxiRarzD5idXL29BAuklvf49vLxBWHR8Jivnk0oc8=;
	b=Q0rDzQ6+w3AOOp96vDQiOS/rJkuAtpllXHFsjDOstWFr8Jg0wCjIskTqJZWr8nFt5eB4
	 iy5kvyFD7IgUuUQlQrQ3jAIAtHSJvA4TqMJY56lGg4AZOwitlPaYOpMTvYeZcaoVGRdlE
	 TvFgESNhO6QedgnkchLuWzdeD1xgUSS+8UvNBRdnPMPQCV7AamGWWPBBNdFPXgaCmQqOb
	 KkvJQuBQ5uMM6qo1byvnk+MmVU/k4RUVeMcxZevB+rVYf0IdR74Xyo0YQvSBAE5PsVt40
	 XaxFYdHO4Nj5O1HM5quji2xy0r9XV6ocYb7mXK51ICwartldMnJ4YpoRLaYBu7VmKlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOQ5fISY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CE606A31C;
	Wed, 18 Nov 2026 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOQ5fISY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C501F000C7;
	Wed, 18 Nov 2026 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036100;
	bh=+sSxiRarzD5idXL29BAuklvf49vLxBWHR8Jivnk0oc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOQ5fISY5A/oUnisxKwOIfDYVuqeBOgqIttB6zez2MQ8dOQyVIlrvKKUnS6w2AXx7
	 kHBpxOgda1InhHAKUN+MoF0VWEg85Qz3YUviaN8lww9zetDW07FI5peTMjeNYBBDra
	 c/vJfR2hhfdU7JmzCO8ma6t630aRX3nN9vqR1NG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0940/3318] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Wed, 18 Nov 2026 15:26:02 +0100
Message-ID: <20261118150347.768600459@linuxfoundation.org>
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



