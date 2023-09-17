Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202336FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAF2C433C7;
	Sun, 17 Sep 2023 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980566;
	bh=Pqx9bHbfjVNdMey1gA84ugcwSUY1Kd8BWlu/xiUg9io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfG8eEXbLLwQfQkbMGk5/+2KniXcnCh2R0KcgyinTYRgYcQyhZxrA1LQa8S/n35jV
	 yrxTVN9PiYh7lrtdPvSGpSeYofdtm6VZ66n3ABO25X0BVtINn9yVS5fCuSpidAGVrD
	 hI87S0tZ7TWoqU1l8WpdmaebERe7pouCqXSez8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.5 199/285] ata: sata_gemini: Add missing MODULE_DESCRIPTION
Date: Sun, 17 Sep 2023 21:13:19 +0200
Message-ID: <20230917191058.473569293@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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


