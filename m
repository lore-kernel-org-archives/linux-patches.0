Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060368;
	b=1XmJwDFgAQP+PukAY1GgV7WY+vmHXYXbIOSHHRYTSuH4C5IPCANN/7Vu45CLh/tMuiI6
	 pAxSHy3PkOCvU2zcBatH0LNpa1v2DXqX+j8cr4+QR6OSQKcR2gVwtXGHAE8XJg3JA5m/A
	 eoHcGfxhKNAlzxqmY+5FA0mQ/lb3o0ZqkJ5eHqgr4TEwlMd5pJU2hchbANO5gTTBDW1PJ
	 jqbdm/HHxtuuXFZsIUM8y8WZDoqSZg+F1YzMt7Leop52Bt060By3i8oNFfo7W3tb6eu6p
	 KrftYJpvzYPRmbWwMFAHMl8K8OpYD+vbH4mdegEul724TxAHyrOYhhs7r/1m/FNTEiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wOU+31YtTNUF+PL0GE31RCApbTI9MyhFVt5m3uq4qA=;
	b=fbyLTsHUp9GmRsM27OFfK3nzlyd4X+3r+VtuoxzLrphZHFQvDqH/L5/0YXSp1z7UPUSA
	 +uLcHXGKgi4CITvSQsSrqxCFsJTTQHjGMaMnwevJJdkWef5VAr5cYj4IMNNvjjWP9RLqw
	 9Hds7/1qfz8BMGdh1DLzcBDmtA/eWguUhDT3VsxesrHna7VCZCbgdBrlg96s0IY0xSBW3
	 NLNmTwscjW1kS+6NNGsKL+2PSTrf8tIFFeJ+eIwmbnKya6UmxSUAcUlxmIc2SiDkTIQOU
	 J/WPHZv1iGTQkxoOA3XeEWiaiyA5tqTAdx0PwlmVjND4IcIaOh/yzWv4arWwiayl0UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdHETLyd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F42606A333;
	Thu, 19 Nov 2026 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdHETLyd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310881F000C8;
	Thu, 19 Nov 2026 03:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060368;
	bh=/wOU+31YtTNUF+PL0GE31RCApbTI9MyhFVt5m3uq4qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdHETLydiPpbEcIsT9sLP2OSf1os2G20amXqxvG0Da5CZ3H6vjdlwf1O6LkgCZ7QR
	 o6KePo5RgCMp/cNc8maLdnn8kDg+0YJoWOgkUAv7UyJ20oqlvWd8/aZVNyh6rpiwtB
	 dqfnUe0w4XO8ZIociIbgKX51347UkCGf1eZq/oGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1174/1848] gpio: crystalcove: add missing MODULE_ALIAS()
Date: Wed, 18 Nov 2026 15:53:32 +0100
Message-ID: <20261118150008.751250000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0f0b4edaa4865..b421394b23a16 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -392,3 +392,4 @@ module_platform_driver(crystalcove_gpio_driver);
 MODULE_AUTHOR("Yang, Bin <bin.yang@intel.com>");
 MODULE_DESCRIPTION("Intel Crystal Cove GPIO Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:crystal_cove_gpio");
-- 
2.53.0



