Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029159;
	b=vX3uXq1SxOiJGEAQmn8lXoyGtGXQc/jyE1Uf9cIE7xv9Q7gqrkjlTwt0bq00jNHzNq4A
	 IJvvxpm2IAhrFKanZex8UlMV8vchkhNC+wGi2FaqGqHl5ZMU3cmCMWvAhAKJHoK5mVTsP
	 FR0Ft3hSnJhcBuBdEU0CKAA1Uq69iD8XJc6qA+IO5owW9fzTjc9Qts2PLqU6ZrUzbHk2v
	 f49VZZ1fbp6qs9ntGM2Wpwxk/8W5a6rZIag8JSJPwmE333+RqZeZcDqYVCGZaKAWwVrtL
	 PQB/YswGhsRLh1oG3hu64sKmHTJLYnmq8dEMcq4l+WB0qAI0KvZm3GWTN9aMs/tcWMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kzgKsP9UjVuo82re2sCD4hUHToIftCaKbIeV3fSzw4A=;
	b=oHspXvOO3bk+vDL6Ol8VN+y0gOoB7VqpG1H93iXxPQykAs5abnyo0BW9q+nxS1TXpPw6
	 kQcSG3DGZis0ntEKlzaq4d0XmQIZSCGNQpmQwWOTFLTx/JUx/VHstzbby6/M9LaCCIroZ
	 bDddSlkfsmptfXCRoD0PFnFZxfSTdWf2CqRvu0PO+a+DY9s3/GP5AROkLcxa/KJkZmeIQ
	 FVEpAOY8w9i5OhPvD3BXYC9pfrJO8lWMLJhXWxmZK7LkW7Q6p4wul3B2wg170dFrcj+5L
	 yEecrcZIfhRPkoAX7ocDfa28VlxJKbi5eTyiy/C8oGlQuWLtOFpk8lhmvNucUOcE3Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6gykhBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962CE606A31C;
	Wed, 18 Nov 2026 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6gykhBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA99B1F000C6;
	Wed, 18 Nov 2026 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029159;
	bh=kzgKsP9UjVuo82re2sCD4hUHToIftCaKbIeV3fSzw4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6gykhBF/EH8V5rOcyQaZLu5wr6UmsoBg6m2gCNdVBVmGI4s65GswvLJCGcoOJ8WB
	 j2xuMSyUBk6Xyl72V4azKELfxCqjeDyxwMhh/ioVJeXeD5Rfm+cfdHbrRoT1JwZOOw
	 oznewN4xrjH56PS2ema4HEYsPzFjLXeOXZIV0KX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0250/1756] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150018.338527103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



