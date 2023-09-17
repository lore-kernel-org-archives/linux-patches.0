Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113776FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7587BC433C7;
	Sun, 17 Sep 2023 20:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981650;
	bh=CVIwwutxgDHdkJ8nD3HtEkv+2oJhrxQXGwSEiMlMeoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrkACxKr8d5075k1P6HGfVXiJMpLLln2zDmusyaFuX8nEzAT6hB2Qk26EDKMcvw1l
	 88GiDYrkZZ3H9DC9xixNxe7RRbFFA/WHAAV1PTGwODklDkfbs2sMFNXIZM/Dk3sM0b
	 ZIXHIpSX1S9fzPDvGBz3Jf1+M5cXqNeZQhk8VyO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 152/219] ata: sata_gemini: Add missing MODULE_DESCRIPTION
Date: Sun, 17 Sep 2023 21:14:39 +0200
Message-ID: <20230917191046.509823543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 8566572bf3b4d6e416a4bf2110dbb4817d11ba59 upstream.

Add the missing MODULE_DESCRIPTION() to avoid warnings such as:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/ata/sata_gemini.o

when compiling with W=1.

Fixes: be4e456ed3a5 ("ata: Add driver for Faraday Technology FTIDE010")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_gemini.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -428,6 +428,7 @@ static struct platform_driver gemini_sat
 };
 module_platform_driver(gemini_sata_driver);
 
+MODULE_DESCRIPTION("low level driver for Cortina Systems Gemini SATA bridge");
 MODULE_AUTHOR("Linus Walleij <linus.walleij@linaro.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);


