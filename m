Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D786747AF75;
	Thu, 20 Aug 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243757; cv=none; b=oAQwhgayvo4b0UEMEvLll87W8xmKJXplWl22v5eRmNdH8ddawbMhLpJapA2VDlYtP8ZgmeWP/31WcjbZbuwgdIQpojSi21EiRE00u5QpxndezAa/a4jcOe1fVwI80r4SssU2aO8aKzZRKeQD4ALNhYB457lo4516ZTl/igd+0j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243757; c=relaxed/simple;
	bh=bmBvNefFurzlrV4b2RiBrnXmQoH+b9ZsHO0wWZPEm4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yn48dd5YA4Xslkdxd0MTY39xtPsoKNq4kLlYf/jeYGQ8LtpBRm7AeId9nOAP/mmxmldCJHNS52GSturhVoEUV0/vR/5XII/xxXlcqWr+mbLrHEHpjY3QALWm6vkmJFUoF7W91bLqUeQ+GbsObsrxIPD/P7BRVyJ6rxmxqc4qlWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LG6w2Ecp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LG6w2Ecp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD971F000E9;
	Thu, 20 Aug 2026 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243755;
	bh=+BkqTPW59GUt/hqsCWgLOHpZRthvavT95+yURknAqqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LG6w2Ecp5q7C7K9BI2p54vU54sTwky13KNdbyjm3/uv1q5CF9oHFNqJzh4FcFDTZO
	 yNP/jQTPmwah8tc8wiDNqw3xBqyRQ0hEiyi5/f7L41GE6T2CdGnBbRvsJTJ5o2xUWR
	 Idw14xfYRfbbtOfqfo5yqS0zx1XLi0OrldEbfLag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/272] serial: sc16is7xx: Fill in rs485_supported
Date: Thu, 20 Aug 2026 16:56:22 +0200
Message-ID: <20260820145237.414726699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 267913ecf73745ca3e8fc8282671b0b4f24df5fe ]

Add information on supported serial_rs485 features.

This driver does not support delay_rts_after_send but the pre-existing
behavior is to return -EINVAL if delay_rts_after_send is non-zero. In
contrast, other drivers that do not support delay_rts_after_send either
zero delay_rts_after_send or do not care (leave the inaccurate value).
As changing this would cause userspace visible impact, the change is
not attempted here. But perhaps it should be still tried (maybe nobody
finds that kind of API oddity significant)?

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-21-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: af071d9e07e5 ("serial: sc16is7xx: implement gpio get_direction() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1239,6 +1239,12 @@ static int sc16is7xx_gpio_direction_outp
 }
 #endif
 
+static const struct serial_rs485 sc16is7xx_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_AFTER_SEND,
+	.delay_rts_before_send = 1,
+	.delay_rts_after_send = 1,	/* Not supported but keep returning -EINVAL */
+};
+
 static int sc16is7xx_probe(struct device *dev,
 			   const struct sc16is7xx_devtype *devtype,
 			   struct regmap *regmap, int irq)
@@ -1328,6 +1334,7 @@ static int sc16is7xx_probe(struct device
 		s->p[i].port.iotype	= UPIO_PORT;
 		s->p[i].port.uartclk	= freq;
 		s->p[i].port.rs485_config = sc16is7xx_config_rs485;
+		s->p[i].port.rs485_supported = &sc16is7xx_rs485_supported;
 		s->p[i].port.ops	= &sc16is7xx_ops;
 		s->p[i].port.line	= sc16is7xx_alloc_line();
 		if (s->p[i].port.line >= SC16IS7XX_MAX_DEVS) {


