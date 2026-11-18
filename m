Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015729;
	b=OxlQzVkL1V5y3o8yVZiZDGNakxWt+yqI1w/fdrObTpVYOqNQI9qyTnMU7BD/CmDw+FHN
	 8usrd6735h/iWmri303ybRhVtPs0x7Wn2LHLD5bDy1RdvKF0mFbLfNsfiatCX/Ckye67I
	 4xY1HVlcziqIsXTrKCt103wMBCxqD/SF3lbtc+rGw2WxNxIwwMJZh+FiQ8Fh8hI9jp7cl
	 pw2EAENXhxtjPeRTbsnzmLfdqbNBRGB8r3wCxU4RATQCjAmxGeQTnS0soaSg5gOTeMCRf
	 uE9Xdy3pnOAtXpAC6ZdtGPDMllnJGPewOXy3RVNWEw0pEdCafLm707hQvBrkkSUClIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEi26uZNNEZNhX+Ah1N45aaVqD1t4H9VFtRvod0jCxk=;
	b=CF+YTwCRQCIcgfHnt/m+ni4/ZTJbn1cDTNiy9JASvV1m2eDzUfr+bCIZ0WWYMBzEb1tp
	 QQCRkrHykmXzE4TXOGPWeRo5vdN89vcAaE8hXbovbAWgtJy2rMUqeHp6HMVToBrDcVy8y
	 XTrWyVgotW8JzfEZmy88V2DhQyvSgc4/qGO9O6QEWTiaCjVTtLI+NdiOK3y9dsA2inwTC
	 sqIuY9hsXFuowpYa+IhtfMMD4HEj2TJbN1cRfwEfgYI2keUAjLqXyXY7c5xvTJL6P0Zos
	 9/q6wPR3re0U/+g+mIZr+od7yb9v/pn+6Wk/ONZa0GtCSVmX0Ga6SGqRSl5ngPOhO+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nlf4on0D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20C5606A33A;
	Wed, 18 Nov 2026 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nlf4on0D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3B41F000C4;
	Wed, 18 Nov 2026 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015729;
	bh=yEi26uZNNEZNhX+Ah1N45aaVqD1t4H9VFtRvod0jCxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nlf4on0D36ViG3p/JZhZTYHthFwhZFvXZ6mgRUI7NADDzx/2dpH4FQIZD9NRTj8+l
	 q6p/p8Wy7BGcuNNtNSoSKpM3OVV9oT5DbXrjFOP8KuLRqqYv0WJ399F+8E78BRV82l
	 FN5m3FCiuzwKeAE7HY7oEQrCQpk+Rz+Db0+cVqlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0250/2651] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:24:50 +0100
Message-ID: <20261118150256.861734988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 32c7f7f80e5f7f2764682fd456054478fc11c8d9 ]

The crystalcove GPIO driver lacks a MODULE_ALIAS() to allow it to be
auto-loaded.

Fix this by adding the missing platform alias.

Fixes: 104fb1d5153c ("gpio: Add support for Intel Crystal Cove PMIC")
Assisted-by: LLM
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 0fb5c06d08863..ab7fab5b97545 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -396,3 +396,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



