Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CBE3F5BD0;
	Wed, 20 May 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296080; cv=none; b=QlFoa5speMWTdK4e6lsu01IAdY+6UaYb9bch66eeiSuLAZ6XuBaGMwV7VRTfweisjHqtEVs7bn+L9QFMY098WZgyOd00fNEXgjGDiwMfkFdqkWIfR54q/qD17C7n7aoNZBp7mSi1YkB+ptez14fKWcWzH7E+GS60tHA4uiefkNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296080; c=relaxed/simple;
	bh=+nVTMlxgXqU0dhb9PuHLmERirFdIz44wvTn+tiBThoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S72JW8jzM30PNLS1CyVEqXBZLAH+JIeM5rcv4BwuTkFfE10An1ZUDYjduHEcHuN9Pp0RJw/fBsW7y5YARiseQ0Y4iGSma5p08+glAszrV5AfCKRnrjqMwBOCYA9hoWOTxLtj8w+UGe7M3/nCqj2rC4qKAaM2jcnOX0QzWsgZpp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWxXMo7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWxXMo7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592D71F000E9;
	Wed, 20 May 2026 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296078;
	bh=9FCWGi7qvAr/KJcj3gQhRqbWm2LZxb6Ph5Kk3/WyPj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWxXMo7//gYiKjP1Vy1segZubAquGwlkv4fgyrV6bD0Nc/fHLkPBbG582K3j7ilpQ
	 ZcquvAyLcWc6QNnqjBXyS8glkw7Lvlpv6IvYEjeNtKQ/30hxbRniTKxyM3lVYZZtWe
	 KsElE8UvXRqzDg7fwA73QMcPKaDTZBdoaQRYIXiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0664/1146] backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()
Date: Wed, 20 May 2026 18:15:14 +0200
Message-ID: <20260520162203.212768361@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 797cc011ae02bda26f93d25a4442d7a1a77d84df ]

The devm_gpiod_get_optional() function may return an ERR_PTR in case of
genuine GPIO acquisition errors, not just NULL which indicates the
legitimate absence of an optional GPIO.

Add an IS_ERR() check after the call in sky81452_bl_parse_dt(). On
error, return the error code to ensure proper failure handling rather
than proceeding with invalid pointers.

Fixes: e1915eec54a6 ("backlight: sky81452: Convert to GPIO descriptors")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260203021625.578678-1-nichen@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/sky81452-backlight.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
index 2749231f03854..b2679b24de14b 100644
--- a/drivers/video/backlight/sky81452-backlight.c
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -202,6 +202,9 @@ static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
 	pdata->dpwm_mode = of_property_read_bool(np, "skyworks,dpwm-mode");
 	pdata->phase_shift = of_property_read_bool(np, "skyworks,phase-shift");
 	pdata->gpiod_enable = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);
+	if (IS_ERR(pdata->gpiod_enable))
+		return dev_err_cast_probe(dev, pdata->gpiod_enable,
+					  "failed to get gpio\n");
 
 	ret = of_property_count_u32_elems(np, "led-sources");
 	if (ret < 0) {
-- 
2.53.0



