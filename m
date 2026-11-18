Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058309;
	b=sMu/v6IvPjJEsT39J0AvX2fQefaMF2YciZ4EE00qta5YKeqdRhrXwu73QnwdHJ0HQpZR
	 N38FBCOFxRwmp84WdvgCn6q2lFe5rLfb6P6ywtKh7I+UONxu5Zv4u5uDqXY9RE0t7IePr
	 XZd0zjV/f+PbO3xhsqnOea/+852fQMgdnZAU7yTWV5NWlvn5YknXPxLsEwxWuRvBw9wiU
	 dYQEU5wQvnlMHNp7+rd34GKdfPlG794mxCykm/rmNfX3NsvVgwo3unhEVpU3u/4WDr7Qh
	 RC+78WL3m6In8s77CBDfDzmsihoGUGDozK5krUjlONy8CNvcQD+StV6rJyFTNkc/0Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EtjOGqOYafAP7ceQJ2xn6ARAXWbrMYy85uvYQwRnsok=;
	b=aBG56AVaF8dUiMwKOxTIgxpF3Os0BZ5wPiz/E9SlN/asOSZxznpq6xt9isqquGSW04Li
	 zpFw+9tG7v8sVtJF7FDZZojKYeguM+inyquLg+LdSQoTYTPCq1Q6A0JFllldQuG6aW9d+
	 jMaMqnSxOu80k1sKzPOSIVVovhp+2ZZznvNyDbMBj5CF9lErku/i+Em+4RacO4IO/1Cn9
	 1L5PquapUxUR7s0dvOBU0BpW5GuDV1iQZDfH4rY5xErxmv+4V6RmDLHfThc9LWEUAdqeJ
	 Q9aHzV6rlu62Cy8oI20GdpBtdPTzGy3fpw6gHMQuO3xGcztfeeWFZXai4nZ4hO9J7BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1ngEU5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D665E606A31C;
	Thu, 19 Nov 2026 03:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1ngEU5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3815A1F000C4;
	Thu, 19 Nov 2026 03:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058309;
	bh=EtjOGqOYafAP7ceQJ2xn6ARAXWbrMYy85uvYQwRnsok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1ngEU5sprC1W39plrxb3eNK+aM6Iyzt8gGwgQ6RipZvmbiGUBoZ/4FWyWCFWfUqq
	 U0XRvf5wt8FHOtjfnTujnEreezAUVLS1aJczEeYnzxDzZ4gX2apgLBHcxY/Wk9REq6
	 hvjV0rhOLJOJy8GLxfdQxyqgnFhXHiuX7OEwE7hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0438/1848] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Wed, 18 Nov 2026 15:41:16 +0100
Message-ID: <20261118145932.418567682@linuxfoundation.org>
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
index 42a95ba40f2cb..64b090e9d991c 100644
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



