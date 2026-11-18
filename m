Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054779;
	b=a43m7tIDt9bo1FogZfD4gyVhkPvx9Ug9amAnnscH9x0Fyp8XLt9uTjQEOGOjohGtWI0p
	 XLL1xeIn88LJho9rryA1gL3dvO3lyRybR1qldejI3NV03VKtqM7JpIsAToBVh3g2o50Vs
	 /yR1uWoGzdmqwernmhmhIvYOW2N5LlZw2bhcDLpvbaaUjyT+dnPvpdNiLiX7rB22sBjlP
	 ZB7KBh2UO9syznEe6jOVn17IECnf2cWdvZfPDpITnqliGNtWPi9rCj629W+bFCi/HYJGe
	 HFBxY3lgWlkrYHtzdPnYoMElA3zJEJaU/mIcm6QfQFI1fKSq9SAzJL+5+aU0yW+vRiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L21MTKrk7lpAob/0xC3SGenI57bzPqyJPoJHto9MCrc=;
	b=X4u5VyJgjjZBSGGfnaKP8N2crvZHpUOux/Qwo70NsPo3+dpPu7SGkJs040izILK7xHJH
	 MDWzcUlIEWlVoRrMxR4EAVK1BvpLNyQEjUTYHdwTgk1rvvTJ0AvZq5V2bk1qML24F/qIL
	 fN/T/5janpB6q4qj9HL6vcXHPTH9J1KT24KkgL0LtKYG1NdsoLb3lzAqP67J7KXSXgEQz
	 i79rgj/JtZenPg0B3iPIXl4Mgx9v4TJYmVLucumP+GH5yHwO8kDvyFlY8OzjSn/Qb+hEg
	 YU7eh3Vuae5YXHa7BBPPQTwyogBCAED+Ew6kqNsfgvlqjn5DVnOTpgNIdgi9Q8yOj0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIANvqqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E794606A31C;
	Thu, 19 Nov 2026 02:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIANvqqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9273B1F000C4;
	Thu, 19 Nov 2026 02:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054779;
	bh=L21MTKrk7lpAob/0xC3SGenI57bzPqyJPoJHto9MCrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIANvqqIU4Y4EwqrGTvWbV510muz+iXUsskjzm0uF2kGsqzBRwMOW/evfrrv9FreS
	 Y8jCO6lTok/ZFYcNJ6HQcsMp1oPEJvCCld63NGuVJ3AznpmHEARX9aAzutTOiGAl+D
	 BcyG8w7978Mvsi+j+GyAVpRjojvSb/RGaFQicukE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1396/2214] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:51:12 +0100
Message-ID: <20261118150107.141471102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c48a82c240873..5e47c6ae20e2d 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -384,3 +384,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



