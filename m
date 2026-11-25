Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623553;
	b=gTSpfexdnGCBMkshBaJAWLQubyYMVvqhyQEvDHofYZt6gMLlmVFm1MQUtX7XeiIVKHzJ
	 +NSb3s7aUXalwPFcnLKtxigtCY9oXjmtXCgD18DtdKOVTM2xZKjhnMKEeDnrii1Od4+zW
	 EcweHsbb7qAsRmT0J4j4jn4agXIPhmNdVsj5q0bhWae9kr4Ms0pcnPJJcMJJ29SP3JD4k
	 kL10qeFDWzcQi/vqwViXR/JVUhN1DKHCPKdI2WGK/uMnEJyEIUsR8/Erd9bk2HDnVZNM1
	 DGk+37/mYf2UEaZtkGL238BRO3/eldgOPRy7OlFhXlFbIXDp1hidn3ykcW2sasSUljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8L6/CEJwnq9LAOjWBWI8KOOsnWHMVUFKic06YImsIMA=;
	b=pyXvfmuPfskAl5V0u2YDqh3I5y0XEca9SOxVfSDkFGB1HFiE3epDeTSvAlT6iBa/IxVS
	 U3sq1RZo3TIXy0oPpI392R/JCFeZn7ja9IdrAYDMWx7D0ypONhe1cWRnHoBAjcF2i09zu
	 vquLJLV0L0F+D7Ja30l83DbMDwNE0B6s0nFtQAJ0SF2X2ef9uVYGxkGlue5atrOjSkGkt
	 jdQIPuXaEcNAXoQnRIWnNEpdd1y/BkqkCrYHAWZrWzxGhQzGTjjPG8Xzzzu0h6eDNS21S
	 A+1Q1KZhaTv5TQ3AeX5MqFze8Mgi+cJSvH5r3eU1g9SPtou7Km631dWomzhUYQwpcfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGg9WJS5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D14606A321;
	Wed, 25 Nov 2026 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGg9WJS5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB481F000C6;
	Wed, 25 Nov 2026 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623553;
	bh=8L6/CEJwnq9LAOjWBWI8KOOsnWHMVUFKic06YImsIMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGg9WJS5qiBIvoofxnYjEKjQae8/t3XLhzpypHkokDzt/xrq1f95sy/CCIj6PGxNV
	 wGXXKOVsRvFAZNIH2Z6H1yA0Ezz/MQrhBpmQimFO5QcSxFr9obkSgJodJzs5AuEr0T
	 ElzwaIytL74C+ElNm3k6iHGmDoqmQnzrIF1O7pLQ=
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
Subject: [PATCH 6.18 898/990] serial: samsung: put the previous baud clock
Date: Wed, 25 Nov 2026 15:37:45 +0100
Message-ID: <20261125143843.046808816@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1498,11 +1498,14 @@ static void s3c24xx_serial_set_termios(s
 
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


