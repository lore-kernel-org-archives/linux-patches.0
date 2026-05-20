Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B4E36CE19;
	Wed, 20 May 2026 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295983; cv=none; b=Unk8kCSJlgVr0IAKoKjKYqNxN7e1pk6p3EEbqYoViFAD/5TTnKMmdCBT+KR38hfmUn9UJ9pOUh1lWeaGSzGaGcOMtgt+UT4vVYxiWUeOEtQBsnXluRbvIZyu6t7Klp6efrGMda6AZ11hkTLL36R5rIb9/pcUEd/9IPOxJxQZ9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295983; c=relaxed/simple;
	bh=foOEBN3CMSM8us5ze1afgL7OFO/Wx/Ni0nXOOPrKkkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhAY8k+T2wGRwvsE6eJlmWSifJBgYK4S4xOuvfLMWyGAGyhbYTEh0LNskwkbxJs55G7syQzruB9bts2vmIYWzwKrPT2p2Mtb076rOFeLSLxJqLG0B8D/dib5ueqZrIECbSfDEF6f6yf2hx8HxYugTVxUpWat4n6YZDzpQxcOyxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw47xWGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw47xWGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73691F000E9;
	Wed, 20 May 2026 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295981;
	bh=jzncwUhCTc0ZyNFK1DJCbOS5XWcIL5imP1PBofT+9fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw47xWGqTIsIEM7JDZp46Jfk+/xhy9NGs3fnPC5C+2FT2w0ezpFCVeWOrRrsRWe4Y
	 2iWhxEqpKYQTqNWGkplkxEQM0BGUjqb+9qlqcLADOeKp9S3Auijay35R6ox3Q4f+EA
	 2bDTqh401bJx7HjmExiHSX7kqAKBYvqd9SC6PRew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0626/1146] pinctrl: microchip-mssio: Fix missing return in probe
Date: Wed, 20 May 2026 18:14:36 +0200
Message-ID: <20260520162202.352372969@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 8f72335002db29fb593f8c2c25761feb3b947eb3 ]

In mpfs_pinctrl_probe(), when pctrl->regmap fails, it just print out an
error message without return, which could lead serious errors.

Fixes: 488d704ed7b7 ("pinctrl: add polarfire soc mssio pinctrl driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
index 3d5ffd6cb14b6..15d73ea1028cf 100644
--- a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
+++ b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
@@ -686,7 +686,7 @@ static int mpfs_pinctrl_probe(struct platform_device *pdev)
 
 	pctrl->regmap = device_node_to_regmap(pdev->dev.parent->of_node);
 	if (IS_ERR(pctrl->regmap))
-		dev_err_probe(dev, PTR_ERR(pctrl->regmap), "Failed to find syscon regmap\n");
+		return dev_err_probe(dev, PTR_ERR(pctrl->regmap), "Failed to find syscon regmap\n");
 
 	pctrl->sysreg_regmap = syscon_regmap_lookup_by_compatible("microchip,mpfs-sysreg-scb");
 	if (IS_ERR(pctrl->sysreg_regmap))
-- 
2.53.0



