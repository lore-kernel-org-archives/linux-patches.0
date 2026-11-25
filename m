Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620418;
	b=PRyxd/g7fBYvQSRAV+sFGc2JMu6J3te/keWUipjEeFlOwW8iBWQ5syaku7aEscwqMkoR
	 q+rVSNxtQn53ZLnUv70O2b+bEF5exMIBQkVFxIfL3aqGqN2rpbyEhC6Ffi7ZKNz8u3Weu
	 XLPHWXYHGzrf3lajWhV6MO9pS5fRuturDBoMLFzdWY5FTn6SyCzq+cJ8N2OXtmx4CcOR/
	 EL95TifaEfxN+zp08fN+MtvO+1/4bNsr6ZB8I13D9F2qnSz6Iq26WTFSkY5rLRtGhhGoP
	 JastAvzSoNizon7usOQeGZGKYSYC9+3+OvLb7Mk4sDJWjqRUwUoO06cOkkaThd1cvrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qK7KEjysv134WDqM+yYiv6RL5M8t+zjAXvaYSrFmPkQ=;
	b=dS/zsy6u9mIiD7Ei5oJydzrX8EpWiWCv7gSLFALeGGPxDnsVmv5zm482fL4S2za6IFHL
	 jlghQd4AvikIyCeHjkh30F80uVwHo/eHaRku9PQCzEVLPdbapP8OkxSnpX8ATHN3kpwsY
	 zjN1MpqSXpI/DM07vG8jPORL8nSAbGUIOkJP0DpWYbgbtCi3e5XDFRxm7o4sG4U66EL/N
	 swfBCNllCMwWepTiE2roGgAkBmALRw0KdGWOX0tf6eaODDQg/LNLBEomZ7SxqmMlatr3c
	 MaocKMW9VMwSRzyEfX76tQCwykwNoF4RlddDdZN9O4qJr8fHJu1kIiXHa3MTmjOcuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUhxqBPQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81018606A326;
	Wed, 25 Nov 2026 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUhxqBPQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D941F000C6;
	Wed, 25 Nov 2026 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620418;
	bh=qK7KEjysv134WDqM+yYiv6RL5M8t+zjAXvaYSrFmPkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUhxqBPQ1QslWQWzjWjBHlmRKx0gjiOrjUMU/popWpR9SF46EvhXdHBENb5sOMbzl
	 DLor260chYZCg8H5dvQr2nQtD1I+msr6mIuUPlxwPzZpWkXq/FHC8LvV94iP3vuSbH
	 5p54I1xUYConm6ig/p4sLzA+bPSl6zs8U1nwG5sQ=
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
Subject: [PATCH 7.3 0911/1005] serial: samsung: put the previous baud clock
Date: Wed, 25 Nov 2026 15:37:29 +0100
Message-ID: <20261125143843.033652402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


