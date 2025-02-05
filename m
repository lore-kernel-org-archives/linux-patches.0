Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149258634E;
	Wed,  5 Feb 2025 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765635; cv=none; b=Bi6eHFqphWYAlhBzsrXy10T082Lv+5j3p1/gRam5PxW3Q/fYZaWrt/X2DdAtYGc9HmbXqPS11HiekbTd1zzHmQjyXJDbUZLhawMEMD/1MR5V/GywUerqHgVM0p3jTi6TLxjaeu0YPw5pLAq5H2QyB8CL6scbv+C7PZqiU5eY1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765635; c=relaxed/simple;
	bh=LDlNqh749KSdojMQfNN2t1JMFbZqL6TohjCEj8d0a0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjCTncnN84jA6ZJ64SWmAf0CvnpL+/N8yRFGWDSmhR/ZYqbKQ3/0qMSkt8Of7d15VqTxvTcoIwGD/kM9v6MZYC8ezwarEvXd4FX+QNim/eRvB1U8vXE6wfUa1atS7zg16PzThilNQEu+P6b7wB5xFebCEQ+b7fIkZxL1+OIV4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkEgfLYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkEgfLYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727B6C4CED1;
	Wed,  5 Feb 2025 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765634;
	bh=LDlNqh749KSdojMQfNN2t1JMFbZqL6TohjCEj8d0a0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkEgfLYGm13jRz9MmiQsTJbeCcux0zyflY9tYybsYJdb7kLO/P3Pie2MApQGjtOpD
	 mvyCxybh8GFlK57ff6tLrLWlcAX42IBIdKjEThxwfIlYXvAGNf82iisYzUmE7mSRjF
	 Y442iGqoK2TBRPRVcR0rRaUxbVEW79egnTiwVxAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/393] media: i2c: imx290: Register 0x3011 varies between imx327 and imx290
Date: Wed,  5 Feb 2025 14:43:24 +0100
Message-ID: <20250205134431.218155074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit f2055c1d62d6dfd25a31d1d1923883f21305aea5 ]

Reviewing the datasheets, register 0x3011 is meant to be 0x02 on imx327
and 0x00 on imx290.

Move it out of the common registers, and set it appropriately in the
sensor specific sections. (Included for imx290 to be explicit, rather
than relying on the default value).

Fixes: 2d41947ec2c0 ("media: i2c: imx290: Add support for imx327 variant")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx290.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx290.c b/drivers/media/i2c/imx290.c
index 6dacd38ae947a..f8ada6c1ef65b 100644
--- a/drivers/media/i2c/imx290.c
+++ b/drivers/media/i2c/imx290.c
@@ -269,7 +269,6 @@ static const struct cci_reg_sequence imx290_global_init_settings[] = {
 	{ IMX290_WINWV, 1097 },
 	{ IMX290_XSOUTSEL, IMX290_XSOUTSEL_XVSOUTSEL_VSYNC |
 			   IMX290_XSOUTSEL_XHSOUTSEL_HSYNC },
-	{ CCI_REG8(0x3011), 0x02 },
 	{ CCI_REG8(0x3012), 0x64 },
 	{ CCI_REG8(0x3013), 0x00 },
 };
@@ -277,6 +276,7 @@ static const struct cci_reg_sequence imx290_global_init_settings[] = {
 static const struct cci_reg_sequence imx290_global_init_settings_290[] = {
 	{ CCI_REG8(0x300f), 0x00 },
 	{ CCI_REG8(0x3010), 0x21 },
+	{ CCI_REG8(0x3011), 0x00 },
 	{ CCI_REG8(0x3016), 0x09 },
 	{ CCI_REG8(0x3070), 0x02 },
 	{ CCI_REG8(0x3071), 0x11 },
@@ -330,6 +330,7 @@ static const struct cci_reg_sequence xclk_regs[][IMX290_NUM_CLK_REGS] = {
 };
 
 static const struct cci_reg_sequence imx290_global_init_settings_327[] = {
+	{ CCI_REG8(0x3011), 0x02 },
 	{ CCI_REG8(0x309e), 0x4A },
 	{ CCI_REG8(0x309f), 0x4A },
 	{ CCI_REG8(0x313b), 0x61 },
-- 
2.39.5



