Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFF38398;
	Wed, 21 Feb 2024 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523471; cv=none; b=jqYRjUWCMII2/K3bb+0Z9NyBmTD+Z9mPueHkm4sAjwTMtnTYH5Pk3Upw2vFllAVk39+ME/sMIQLsDxq3A9z/MQWgnjCgWZZl4IZZIzQYU/25C79/hFr7U/s8uSbrK1ayNi/HpyuML/GHaIYoESaJRHLHfKdHlWIrbJl3OL6ZbVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523471; c=relaxed/simple;
	bh=DOYq0PFJIrd9UNg5uyXZzF14rpl+NH1cfd3qzKiifE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xnp5ymTyvqFMXWEM7YorUJKZzXgYnbpcavb+AEbWkUoKGCl75obttAG1M/2eXdUX2FIfZ/dQP2FU/tMG0RTjVWMpTpvpesh9LJwjQoCuwd4x+DAEv48Gljvt/FtXliVaOxKaPJRx+KAzaoB5vowa4FjOlrHM+3G7lmqscz6uviE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVHaRjXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVHaRjXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8C2C433F1;
	Wed, 21 Feb 2024 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523471;
	bh=DOYq0PFJIrd9UNg5uyXZzF14rpl+NH1cfd3qzKiifE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVHaRjXvy3cK1Lo/iRUK27ewaoFMm3yC4owvRyWw9hk2PHbROG+Rl+87owfBOCxHc
	 DJvCeLsT704SSnxOnUb1MhVzS+k31iARA4ugHYvmQMkx8ut6uBSycPqQRoFdDwFt+8
	 HLTnOPhaFTKLkLSrStrAWlASq2a08hKRHhvKXE0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/476] serial: 8250_exar: Set missing rs485_supported flag
Date: Wed, 21 Feb 2024 14:08:16 +0100
Message-ID: <20240221130024.481406348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit 0c2a5f471ce58bca8f8ab5fcb911aff91eaaa5eb ]

The UART supports an auto-RTS mode in which the RTS pin is automatically
activated during transmission. So mark this mode as being supported even
if RTS is not controlled by the driver but the UART.

Also the serial core expects now at least one of both modes rts-on-send or
rts-after-send to be supported. This is since during sanitization
unsupported flags are deleted from a RS485 configuration set by userspace.
However if the configuration ends up with both flags unset, the core prints
a warning since it considers such a configuration invalid (see
uart_sanitize_serial_rs485()).

Cc:  <stable@vger.kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-8-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 24878d5a6a05..ada9666f5988 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -443,7 +443,7 @@ static int generic_rs485_config(struct uart_port *port,
 }
 
 static const struct serial_rs485 generic_rs485_supported = {
-	.flags = SER_RS485_ENABLED,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
 };
 
 static const struct exar8250_platform exar8250_default_platform = {
@@ -487,7 +487,8 @@ static int iot2040_rs485_config(struct uart_port *port,
 }
 
 static const struct serial_rs485 iot2040_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
 };
 
 static const struct property_entry iot2040_gpio_properties[] = {
-- 
2.43.0



