Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B2B9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33640C433C8;
	Sun, 13 Aug 2023 21:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962705;
	bh=pjfQf6Fajl/wmswnw31HV7Q0igLas9B8mGMqTzwdd5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXxF1reRwKtCuLwwGHHleANdHboELoehNAsbWQW/0lH5R1qnR0OgKXtwdUqaYurFw
	 hcBibl0xKzwNfSTSBb53R/fCRGkVqFofOrLu3ynoZntF9jYpWjmqdVIasX9POweHpW
	 7v2osFz1yeRIou4uJHL5t6sjUWiSIS+hJarS+2NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Demetrotion <pdemetrotion@winsystems.com>,
	William Breathitt Gray <william.gray@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 125/149] gpio: ws16c48: Fix off-by-one error in WS16C48 resource region extent
Date: Sun, 13 Aug 2023 23:19:30 +0200
Message-ID: <20230813211722.466998883@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <william.gray@linaro.org>

commit 33f83d13ded164cd49ce2a3bd2770115abc64e6f upstream.

The WinSystems WS16C48 I/O address region spans offsets 0x0 through 0xA,
which is a total of 11 bytes. Fix the WS16C48_EXTENT define to the
correct value of 11 so that access to necessary device registers is
properly requested in the ws16c48_probe() callback by the
devm_request_region() function call.

Fixes: 2c05a0f29f41 ("gpio: ws16c48: Implement and utilize register structures")
Cc: stable@vger.kernel.org
Cc: Paul Demetrotion <pdemetrotion@winsystems.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ws16c48.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-ws16c48.c
+++ b/drivers/gpio/gpio-ws16c48.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
-#define WS16C48_EXTENT 10
+#define WS16C48_EXTENT 11
 #define MAX_NUM_WS16C48 max_num_isa_dev(WS16C48_EXTENT)
 
 static unsigned int base[MAX_NUM_WS16C48];


