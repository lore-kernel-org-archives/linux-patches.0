Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809547DF8D;
	Thu, 20 Aug 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244451; cv=none; b=rMk2p1p9JMjnrxFu2PjNtutoudRj+l0Qizu0J78QBpURvVJjfActrgt5K5St6pf6QnvcBxRd9LlEMV+MaX29s9fE9qthHORoPIYUwbdS0PQmZlQzgI0h9Stc54cJIxflVboUq9TDuTjL82t1Idc4vgVbF0RpxljbxevKOZmnNvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244451; c=relaxed/simple;
	bh=7Yg1NoyftVz5WvYNlMq4uOo/NMj1w8aFqTdVFPlBtg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdgstReUkKnhN+oPsh8i8DmH14xoVo48x/JIjf+2zwKSynbG6o9OZsofaP0ijm2Q8qrbyzkuvu9fn3AbAttgb7+n7taFEVSy1s/vIKAcS+A8Hxc97/RvUweTo6UwFMJ9PI6U5r0kU37FPu5U+hZ/L5V91N8R87v4abNHdDJRRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/izK3Rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/izK3Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7141F000E9;
	Thu, 20 Aug 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244450;
	bh=49E4TOS3aKzM+KoxlQ6Uj+3cut3OOxJtU6js3vIKI0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/izK3RtczDTZ0BwqXCGiMl0GI/O4Zton1p1z8C61pgGJuv7IQA/7Xk+TJhJJ22Xf
	 NYaYvwg6JP+T7JDqVWRvzOFbxIgCnZwRo87EEQDMtehF18msN+yZS8pQFy61CzzcYV
	 MSBzPqre54s/MUAJkt3huuqkWY7TPxsg4nwoajkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/235] serial: sc16is7xx: Fill in rs485_supported
Date: Thu, 20 Aug 2026 16:56:48 +0200
Message-ID: <20260820145221.720535366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1326,6 +1332,7 @@ static int sc16is7xx_probe(struct device
 		s->p[i].port.iotype	= UPIO_PORT;
 		s->p[i].port.uartclk	= freq;
 		s->p[i].port.rs485_config = sc16is7xx_config_rs485;
+		s->p[i].port.rs485_supported = &sc16is7xx_rs485_supported;
 		s->p[i].port.ops	= &sc16is7xx_ops;
 		s->p[i].port.line	= sc16is7xx_alloc_line();
 		if (s->p[i].port.line >= SC16IS7XX_MAX_DEVS) {


