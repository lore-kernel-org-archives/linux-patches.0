Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960263B8
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A43C433C8;
	Sun, 17 Sep 2023 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983192;
	bh=lzFvtkv/uc3oc0akaFE2Ro2ekVwfMpmlzlXwiSCcvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPgD0DhDdovIMCsYIvccOFnUjFowuNQASosuk6uWsRJlYi0B/p0MvHY2ZCo01ZC8u
	 LwV3G0gRSUloCAmM9uZf72lIUGAxabCEcSKo7N6tSlHrfuJubbw52Wgd7KgX8PUTio
	 ck3d8O7tK9LSDiwrdaIH8E+w8mWhfRAQtldB+PxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 472/511] ata: pata_ftide010: Add missing MODULE_DESCRIPTION
Date: Sun, 17 Sep 2023 21:14:59 +0200
Message-ID: <20230917191125.142799171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


