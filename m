Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626113;
	b=jqY3tFZuMHhxEqyTHPPMY6Y9V8f+9CewdF20POu01B1/hCJ7QKX7/4QzEkLMVHs6QL50
	 oHn5/hgGUa9OToNZqEotRllEq8mgk3jllHCDB9osR4K6ioJMpBT83hYejxZJa9zJOHJy5
	 W0FWjoUczvh5Wvt2WzjiimdG2izoCiMYvsxgwIYXV91b83MQwPo1ncvFN9E8Jd0WpVN8l
	 /joD153p7IJ2jnkyJOTMIQE5YlF008khlXQgdYqytl/aD5u4zpdfESs9wDmYyvjArUkJB
	 a/+Fz55tZRas6t8t1xXs0Feb0PEx1fXvPhL+6l/P65yKseLUpYcEaL0rIW9NS5aFXJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wcY5lGJZruFeq2RKU0I77RUGAl/JF4+8ano9SL5m6Xs=;
	b=pP1TEqK/Fl85INj5YTPfGd1fYcIQI7HFf7/auBPQDDuGTIbfoRDxrpsdlHApZ1YubNNJ
	 0KFMgXJrVc2/ACcrziMJBhhRtOEaumnCyj+aSqr1NGDHzg9BB3gpbe4l1BYULtMQZz6nJ
	 0EdV3jfUBweDMRWTMji9FRtYt1zWu8FJCkAaGIuI5sbDi61qfxsi3z4xVeIcF7PHbyx3Y
	 nVAD8DIRP9VWnEDCLZXBDdD/uhTENYBk06vhlv/graCR3Zj7Z5zAgDzdXmSzsWOrxhVJu
	 JK96G+KJeLns5Xz1czcJI6zUAXYP5CwzG7zKfSWwvZbUNy5ROU4Emc9oO8fyStA89+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIOIz5HO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424BF606A332;
	Wed, 25 Nov 2026 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIOIz5HO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EE61F000D0;
	Wed, 25 Nov 2026 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626113;
	bh=wcY5lGJZruFeq2RKU0I77RUGAl/JF4+8ano9SL5m6Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIOIz5HOjBm+TpX/mmJO0xcEfncp6CfO0iRVtGEKCm4BUHXFZgbisn8dL6A8BCuC0
	 aBpAxgG18e9P+SiC77VqYZqo7/5tEK0zRLlWqfRREkJvxdUAFicE8NnXUyLwmiDZaQ
	 V17/5PSNnbDmcNx1LU3X8OzQnP2ugIdEThdwrGRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 735/816] serial: samsung: put the previous baud clock
Date: Wed, 25 Nov 2026 15:38:03 +0100
Message-ID: <20261125143906.192081495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit eedf2cf3505c1562a2fb24f8b997056f023d242b upstream.

s3c24xx_serial_getclk() returns the best baud clock with the reference
which clk_get() has taken.  s3c24xx_serial_set_termios() stores it in
ourport->baudclk and disables the clock which was there before, but does
not put it.

clk_get() hands out a new handle on every call, so the new clock never
equals the old one, and every call of ->set_termios() leaks a handle: a
struct clk and a copy of the connection name.  Whoever has the port open
can repeat that at will with tcsetattr().

Put the old clock when it is replaced, and the new one in case it is not
stored.

Fixes: 5f5a7a5578c5 ("serial: samsung: switch to clkdev based clock lookup")
Cc: stable <stable@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-22-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -1496,11 +1496,14 @@ static void s3c24xx_serial_set_termios(s
 
 		if (!IS_ERR(ourport->baudclk)) {
 			clk_disable_unprepare(ourport->baudclk);
+			clk_put(ourport->baudclk);
 			ourport->baudclk = ERR_PTR(-EINVAL);
 		}
 
 		ourport->baudclk = clk;
 		ourport->baudclk_rate = clk ? clk_get_rate(clk) : 0;
+	} else {
+		clk_put(clk);
 	}
 
 	if (ourport->info->has_divslot) {


