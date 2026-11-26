Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704709;
	b=u3d1zew+054JB8oxoAwk6DWx/N8pKvuKfXqxiKYWEHWrXdu5GY9XnFUBWv83sqbg8Xyl
	 rbPT7vKDs8X0ImVx+82VEHAgxR8QTiuejLOAPOQpAccEKfp1EBwvpP2wxs51UcLUTaFOs
	 F4JvKnWXS/Kyn+oVuVlXWKU4559Mk2NktfKjv3cuvYvATwuAxAzl+K9cHIowC385si93w
	 ujC472+6nD+V1crRzDWoB4aFz0WAAJlDwWj1N/TGaWPp6b7NGVFpyQTUI9eAEwSsNP+c3
	 dg/YXOCjWFhFiYr1M4EvWc1zelae5knCtlvnZqJ3uTX4hpFqOibaU0KgLa03gpvr5bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VrYLBQsNtlLAKyKY6VuGIWokRXCPXS+eSh/GeH5pK0Q=;
	b=mYj/7n964hj0t3cT1hLVog3dKScbwB5kwQALyynglquGnhXQMPpwB72BymVokEGsl5m4
	 /dE2E537L7ZFEbe0m6e7Z3cghWY/SYMSlN181JzMlQu1ZbYCVyfvdhiHHOtZMhxz7Ea0O
	 F218+75VKZqW3+ITlvYj6zRy9daWPRdpuiCSKxUge9Rneo2g2iLkdgOR07qctcZ5/OqPt
	 9e3D1JQTbQReYOSvXFvwHE8lncfZaeAITbDDBe3seC0a1aMzP2lRBtpgwIETPLkQQG1Bm
	 uGNQtFDc0i9/Z/IYELwSLt0IQwAUmelWphDfr0lQHvmfonJqIjDNUlITjivA7hKl+3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AXOKisK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D8E606A32A;
	Thu, 26 Nov 2026 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AXOKisK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5233F1F0093C;
	Thu, 26 Nov 2026 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704708;
	bh=VrYLBQsNtlLAKyKY6VuGIWokRXCPXS+eSh/GeH5pK0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AXOKisKSi9YSxwGVoW5Q60T8GJclK6pbMUFbgqSiq7ejdcQCc1ti7pa2hyXyrr02
	 GHm+0pFSb64Ykro4KEMlbvA+gQ1QBmn7RxU0RDmQvoV2yRpCGm4RLqn2z/1WKqWWLN
	 LBP2+PJlCiZnyIa4sfOMgOPuCegOmYG1oZUqSsfM=
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
Subject: [PATCH 5.10 217/265] serial: 8250_lpss: dont divide by 0 above 6.25 Mbaud
Date: Thu, 26 Nov 2026 15:39:07 +0100
Message-ID: <20261126143620.410757289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


