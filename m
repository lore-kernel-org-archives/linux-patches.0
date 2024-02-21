Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8839B7F460;
	Wed, 21 Feb 2024 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524826; cv=none; b=VHfgXKJ79MzxbbbFx702aMm9fY4yZ0Kq9Yk2YZuha4rjlX6arBqIXEwCKnrKSyGuppLzjytXd1MXQ2hxlc/xmWWjXRZVTgqI50X13zimIl6i/toEjFL4VwhuPci2DElwXF8jdtjd4Y6ECyoReYPAdaO9AwCY69K0OaLHj7b2P14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524826; c=relaxed/simple;
	bh=x6lzv86DwD6AovrllV/p8JKUqnQ4PsSZBOj2Z/jY1Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7+Ii3GfqM89xFGeNXqdrTP5WCKNbyfbyHOy9oUhEHe4drUwfRqgie8LbfpeginI2a4/WiVG6qLipHlPdpRFDRF/HwMGYRmrEmQqBAfmTJhb31Nivj7yzgGt9Ku/4swZ0SQyixgaLw+KPtzcRVowyLsscE2qKzirkKFiDBS4dKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1whfpiJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1whfpiJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D5AC433A6;
	Wed, 21 Feb 2024 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524826;
	bh=x6lzv86DwD6AovrllV/p8JKUqnQ4PsSZBOj2Z/jY1Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1whfpiJAKfCfuN+gftfDsxxv4STobRqZpyAGLnA1Q2OTMuwro21gJOITnkWnyUjjh
	 wnx55SnUqZa+7QdI3qw4O6d0MEMK7OeFy2R7xOhkwdk3YjQQIDiBLFfvzL0bZcRri4
	 SSVMu6xyE3Lonr6eoImgN9IvYephLDOwv25QHZOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/379] serial: 8250_exar: Set missing rs485_supported flag
Date: Wed, 21 Feb 2024 14:08:59 +0100
Message-ID: <20240221130005.716935037@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19de9f535c67..6e33c74e569f 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -425,7 +425,7 @@ static int generic_rs485_config(struct uart_port *port,
 }
 
 static const struct serial_rs485 generic_rs485_supported = {
-	.flags = SER_RS485_ENABLED,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND,
 };
 
 static const struct exar8250_platform exar8250_default_platform = {
@@ -468,7 +468,8 @@ static int iot2040_rs485_config(struct uart_port *port,
 }
 
 static const struct serial_rs485 iot2040_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND |
+		 SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
 };
 
 static const struct property_entry iot2040_gpio_properties[] = {
-- 
2.43.0



