Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705698;
	b=etUNRkMytPKyIAbDzqj6QzOG5igJjFCXHzJUGVhTCSyiXHmkir8syusaDh6z9JyRDKZ/
	 9ZRaOTdcWp5geFNE+Lq9oSLaX7man/LXWMRtg9Rl7+9Bd7wGvr8t1t+EzX9+L8vjfZ0nG
	 VsmlOL47kk9/8PD3IBB52+/G1+AJCQ9yPMX6kM13Vszm5kAsGXCDPGWb3UvIBXZgj40UM
	 3qWWIbgEIYRF58Ty+D9LZ2UZhCL3Wo8kwdRSYWvzpJCvqBPwNwC9iXQ9z1iqE+Q9uYP7A
	 krd/c2+8ZT9Yvb1+d+AmDX1Mgo576VIBXG+CYB+DyDhlnTGXFkKLoPRrG9Fp2TlseKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcZwQt0m0Uzvl1JuO+eXDOq8ru6QSitDZSviC0oP/mk=;
	b=DIL2YPqoPhPVBhd7b8qfRGIwpF9I3JopMd9LWTL8CgdGGlBi016ZQGOkTbujpn8I9F8H
	 3QKeCFW4peQOG/kjGM6zbr7n5H6k4Et48/h/kws4fF5emu3SLPWxbMsJh/rdheOzHRECW
	 nDoNuQteW7IYghgYtyZ3pXL6QbaduxiFTTOVTbM+N0nzngawmqlG5hinpYjOXXopa911V
	 cC457ziKxXgQs4Vj+7RJtr2Es/F/Z2wz1TNyeZJruwfP1vHMWqm0+gEdHXutoAnTSNaPO
	 qy/8Fly/hCuNcbg4ZnygsfBKcRmVooWr7acY6C3pnAEnJhKPLKjEnCxB2MdzZtNWD1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7yNpb6D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4D0606A327;
	Thu, 26 Nov 2026 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7yNpb6D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4A21F000CF;
	Thu, 26 Nov 2026 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705697;
	bh=DcZwQt0m0Uzvl1JuO+eXDOq8ru6QSitDZSviC0oP/mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7yNpb6DqdHE5SlwHb4gEZzr1Bsa/Qmob5rJ7854sgKig20u5+pV1YK0ncFRf0YFx
	 vmC86Z6rzcvGoKyU4W3Rg+xxciD6VBrzE5431zBLS12kv9TQX+TB1evwxK+Z9Y3gH4
	 EPNTDmgMomOL6avuakJHziE3QD2IZVSF1pboXUlY=
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
Subject: [PATCH 5.15 268/319] serial: samsung: put the previous baud clock
Date: Thu, 26 Nov 2026 15:40:36 +0100
Message-ID: <20261126144012.797917860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1580,11 +1580,14 @@ static void s3c24xx_serial_set_termios(s
 
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


