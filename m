Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0771FE468;
	Tue, 29 Apr 2025 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946176; cv=none; b=oOJ0SfMoPmllA0/LYFXtu3stQEM1orj2B9o+dowj4F88eJuH14eNh0YZa3TpSHoza0nXtBETVLK4+ACMMZlXsDHV/QzdtCZ1scEvqBLRdw1WJbEgpatmQRPNKLDDLj5D4AvpFDTOn54sl4caCCt6nu06r1jHhXFBHTd9VQ3889A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946176; c=relaxed/simple;
	bh=l8fRDIY0Dr5oAPLOdiOFk/w34WVYlT0w0WdIGHe2B7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdcmRU/ivF7ng6/+UWfAJYd7dTSiHd2Q9CzIgKdbkMaRcjEmceuMZNee3D1IYSPpXoO5InARnFFoGcMg3tAKUJNjaEC9909YyY8afgWsKFkfUwvUA/3SvJH32OKIexcg9TGe65A3jNTroLUtLg5uPUDz2tJ8iHp9/yeCDqJtZEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6BkxCBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6BkxCBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D108AC4CEE3;
	Tue, 29 Apr 2025 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946176;
	bh=l8fRDIY0Dr5oAPLOdiOFk/w34WVYlT0w0WdIGHe2B7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6BkxCBRVNsrdE1enJYANkpCNuQX2zEX/tPPdAwmLWyEECbyXCQqXQtV7ZL4oHwJb
	 nWifaHSfsPqt3pywv7NZM8znuqDy4RHjKWXbopKWyPoWR3wtiPaV3Di2Vdk0nz1z6a
	 Ezn1FUURYXTnzCNLE0HrqDqEfWNnt87Cp8TkzpBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 179/311] pinctrl: renesas: rza2: Fix potential NULL pointer dereference
Date: Tue, 29 Apr 2025 18:40:16 +0200
Message-ID: <20250429161128.357783319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit f752ee5b5b86b5f88a5687c9eb0ef9b39859b908 ]

`chip.label` in rza2_gpio_register() could be NULL.
Add the missing check.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/20250210232552.1545887-1-chenyuan0y@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index 8b36161c7c502..3b58129638500 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -246,6 +246,9 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 	int ret;
 
 	chip.label = devm_kasprintf(priv->dev, GFP_KERNEL, "%pOFn", np);
+	if (!chip.label)
+		return -ENOMEM;
+
 	chip.parent = priv->dev;
 	chip.ngpio = priv->npins;
 
-- 
2.39.5



