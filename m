Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039340;
	b=HckwF6ybMpiqFeTq20FbslT3yDLUr6EniDiiFWOVQGPXJPt1lApzL1tlLCa/2LdLE0k1
	 gDJTgHlegkjPmo2f+uX+KVNaG87xCUjUXkl1ZON7ywKzanUThHwOM1sDnIMaF0+jONQEb
	 nbQ/y0uIdarh/mXdDIRN/93gbQueBYWJ3C8Bu4Pij6eJxHUTyL/7mh3BrR+EJ4WU4cKiR
	 STpGmnd6V3J1ECQq7aAoL9Ab9VFlQtqNbKN0UFTTldc8DejztGGQ97iQZx9v4y8HQq8N7
	 OXLPk28Fg/oTj5EfN5OKRovskLmoJXX/mHlKp2RcpBRnQKa6oXVf7oaNDT8/Aun57mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T1zOmbkIae+gl+AZA+pw34QneRxdj8biBkYxsV3jpQw=;
	b=aFUAl0GQR3OfoyBn5fPppYYiCTomAYytL4+qY7yIcDk9YEJyoPKT04A9igYcb4K4JjmL
	 G7fC4ZOW/tvTnwSf2HXFDI19KU0FL5A1R2M004yQCF7S5k8uSGw4bSQhBHJerQl6im+70
	 VxV3T2G9YbhcqbUCJyW6FBbVpcvErUDr6Y2V4hS85Jm9rhGyHDKrnB4ZGeW3tWEfe9sCf
	 BkmuIWgg4e1zWj29r+sILL0J2SdAxzjvdZ2CDrNg/cvimbyi58LTsaUaSW4f0SlhJntIf
	 bAd+U69tnXJ9AySp2fv8c7sdre1cxTRwqVOhkQl5+StwqxECZcQsjfECSMY5QdBqicQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFJiKQgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B1606A33B;
	Wed, 18 Nov 2026 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFJiKQgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD291F000C4;
	Wed, 18 Nov 2026 22:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039340;
	bh=T1zOmbkIae+gl+AZA+pw34QneRxdj8biBkYxsV3jpQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFJiKQgRVDL5C+3dC4zjhedvaI8LHNeYMPXJZCVdd7k6SeeWKMFLiKc0IbsW5hyeC
	 NhvNgxg4VEH/EPWHyGG2zFtB2bk0abq6Blp57ZzDhOKrJ2WVRUx5uxWSrRUZm81wke
	 aF20ye5d8d0iqLPSHFwSasu1VglpVQKHhOamqR/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2066/3318] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118150424.057779453@linuxfoundation.org>
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
index 25db014494a4d..636e4d3f990b1 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -395,3 +395,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



