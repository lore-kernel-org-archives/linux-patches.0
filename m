Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623540;
	b=RJ83qJBpqfsuu0j8zsbh7wKtJ7QJwm4jd6YD+ZzILaVHDbNBRxwwFJIdjjrFr0Mi+Efd
	 V9HqRE269MFijbOnrLjfg7kGBaPNMERcxErUWHdtCfKGF/uRF1xZW4AQZRFg8m05BGY7m
	 U/qc4Oj9uh98reYEO6UUWGmuRIRGcUeuyJxtivR724gIfEV9DetkmmadwCeQzTB8yKeBS
	 y2pZCF5TkTUAM7br2Ucc1fgaOLVAtA/o5Li3gOp9JJdHOshoR+upojNwKE10Etbo7hyWo
	 xdb6thtDIuFz/aQh0wHUz8041Jl1xBIzzJGcPNgPNbx9rAhAfh3Eqtc4BnWNvznONHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=75UIagnz1FWtYfohHTjrZo83dpRYQa+qjJcR5Czfs5k=;
	b=VXwkQJTdpqSIvx7yijFlBeprFcowToLQmQEljk9kmdkCUrS5xdgqLUUIJ5/IWRKG5D3w
	 EdIKhe7+dwVKfVoG8Oyl2JCU1CSjmLFWajD73uE+pimLFmOnJKt4/UJ/n6YhmwkLjUixB
	 75gR0FeNxEMvCNGXywRe12gQvknhTPhfXH+oz6GFmctfu3SIRTNlO770GSsXFH3iQQh0Y
	 9RDhbReaMVzmNdaeNZlA7F2nh27fFsUm9YTmiy9+BPvy2OUc1e082blfQXiaHy/7+4ujE
	 9W/vYPUZMqKckFa2euvHGKB0PvQEZOL87rrKDfVuMucGscbPFtd3wI203laJUaSaI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCUZ00qf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044D606A330;
	Wed, 25 Nov 2026 16:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCUZ00qf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E541F000C0;
	Wed, 25 Nov 2026 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623540;
	bh=75UIagnz1FWtYfohHTjrZo83dpRYQa+qjJcR5Czfs5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCUZ00qf/BNpv50OKAEDxN1XoTzwxComnRrn/PwXADdpF9sggsIjTvNJLCt5H4gzu
	 ieqQUNkGH0SJSUDDWzFEE1HkIfgXU9eiWPuomlCbSdotYrhgBcY7d6buru9kgxfBfL
	 8rKZHIrZdzELLd0tgwS9VTagdFLECuzzLlmBJUUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 894/990] serial: 8250_lpss: dont divide by 0 above 6.25 Mbaud
Date: Wed, 25 Nov 2026 15:37:41 +0100
Message-ID: <20261125143842.952733145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 08daebfd63e9054e097eb2653eff9381de43a422 upstream.

byt_set_termios() derives the clock of the UART from the baud rate in
the termios, which nobody has looked at yet:

	fuart = baud * 16;
	...
	fuart *= rounddown_pow_of_two(fref / fuart);
	...
	p->uartclk = fuart;

fref is 100 MHz. For a baud rate above 6250000, which BOTHER allows,
fref / fuart is 0, and rounddown_pow_of_two(0) shifts 1UL by -1. On x86
that is 1UL << 63, the product with a multiple of 16 is 0, and so is
uartclk. serial8250_get_baud_rate() then passes 0 for both limits,
uart_get_baud_rate() finds no rate which fits, WARNs and returns 0, and
uart_get_divisor() or dw8250_get_divisor() divide by 16 * 0.

Everybody who may open the tty can oops the kernel with one TCSETS2.

Don't ask for more than fref. The limits are those of a 100 MHz clock
then, and uart_get_baud_rate() falls back to the old rate as for any
other rate that the port cannot do. 8250_mid, which has the same
formula, treats this case separately.

Fixes: 21947ba654a6 ("serial: 8250_pci: replace switch-case by formula")
Cc: stable <stable@kernel.org>
Cc: "Ilpo Järvinen" <ilpo.jarvinen@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-16-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_lpss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -82,6 +82,9 @@ static void byt_set_termios(struct uart_
 	/* Gracefully handle the B0 case: fall back to B9600 */
 	fuart = fuart ? fuart : 9600 * 16;
 
+	/* Fuart <= Fref: leave it to the core to refuse a higher baud rate */
+	fuart = min(fuart, fref);
+
 	/* Get Fuart closer to Fref */
 	fuart *= rounddown_pow_of_two(fref / fuart);
 


