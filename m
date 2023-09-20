Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AAB15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336D8C433C8;
	Wed, 20 Sep 2023 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213553;
	bh=d1LT4ytxiURTh4G/HcXVdxBeSrtZDLQLwLiyapnNtU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/98MeGxuZECbBkVFjQzz68KWOcEed1fK86LBYCYpEyi4vkN9gZUUHJFKyU4sGxno
	 gCE51tYJLmZ//2GYMdIYUq7coGtCXZQDDTP54Ead+ulw4VBG8WXIMJPInfJFbhhdWP
	 60p01i7dvs9pzIHh/stC+K8N0GWWqyOihx3SHO9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 280/367] ata: pata_ftide010: Add missing MODULE_DESCRIPTION
Date: Wed, 20 Sep 2023 13:30:57 +0200
Message-ID: <20230920112905.809366181@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 7274eef5729037300f29d14edeb334a47a098f65 upstream.

Add the missing MODULE_DESCRIPTION() to avoid warnings such as:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ata/pata_ftide010.o

when compiling with W=1.

Fixes: be4e456ed3a5 ("ata: Add driver for Faraday Technology FTIDE010")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_ftide010.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/pata_ftide010.c
+++ b/drivers/ata/pata_ftide010.c
@@ -570,6 +570,7 @@ static struct platform_driver pata_ftide
 };
 module_platform_driver(pata_ftide010_driver);
 
+MODULE_DESCRIPTION("low level driver for Faraday Technology FTIDE010");
 MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);


