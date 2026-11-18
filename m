Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061534;
	b=gMaCyI7kLcNrETyVx1Ofr2WCTDJfMKi+IhqmVkNesXkcb0VOyQbm/NaP9TKhS3maPUxw
	 XRycF6rMWj+3JzpHqWJ6mtePIO8bSpfIfWMRdet7a1AKsv2V1kUngVJ45YwnvPEsqrtjL
	 eHWt97+pn7JX3rp3UnBbzisJgnPq8QnouB51A3Lf8hQz89fTtcqJfc4ypsUpPl+6eONMJ
	 KPGLBpC0LnIpo8sfKDXdH+wauWiwUw9z5+lS/2SszcogJl26WR7pxM2UKZcgE6QnSsBr+
	 cnbMX5Dv75XOApM2u0avyl91QPZZAn7IHkbsFrmepq9j50EyR27iRGeR6AUNyC8YeSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZqOsLGwPNe8mIGwBcLBz1bl0OIJahRmY4zZ2dFcN24=;
	b=BuU3loAoXWgSrumXllV6dNmww5mGQOg84jX5u2AnwJwi/4n+BVYPmAUnPPRG0KNJiei4
	 JGOpOURivy/7ZKgPCwameExf/OkGR5fb8NNe1gxYGhDg95aafI8HgvwXhD+QPcBfClETp
	 nEb8L79cNLNDv2LwLogibKgGYnMOfGGNVt1mENnEle02pCtGAqOJ2vEOISmXWpGt1cbNE
	 F7enSQ6ek/UgvB3aFXZxOeZlvJHavZ77qc3t53GqWr356UhJLzjGWUHj6vbhFqIpfDjKW
	 K/+imW6qfVQa5Tqm35tC22Tvywvv1hGNGimYw/Xw6S1t/CYtIdJcXAyRv9ZPz3vfG7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtxCYno+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8D4606A32A;
	Thu, 19 Nov 2026 04:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jtxCYno+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1871C1F000C6;
	Thu, 19 Nov 2026 04:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061534;
	bh=RZqOsLGwPNe8mIGwBcLBz1bl0OIJahRmY4zZ2dFcN24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtxCYno+suqBdj4/pjIOz2IUKqPTYo+5SC/p5cdvPQs6W8auJ19uWgjwsLJpgCu3d
	 xj9usX/sGxbyDDccIv3UvMdrw7YA07gfWG36A8X4x0XtUQh4AuQViepEskuzSxgev2
	 h5TNfaMf3K7gZ9nzwjV2v3eGscLjKaFSNiJcXv1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1586/1848] serial: max310x: simplify probe() and remove() error handling
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150025.943182407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 5d888f1c32e2281843d58eef963e3ebd625b77a9 ]

Simplify error handling and only call uart_remove_one_port() if line bit
is set, instead of having to manually set s->p[i].port.dev to NULL.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-10-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 15b0ad92d7264..b58278d0b8308 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1450,10 +1450,9 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 		/* Register port */
 		ret = uart_add_one_port(&max310x_uart, &s->p[i].port);
-		if (ret) {
-			s->p[i].port.dev = NULL;
+		if (ret)
 			goto out_uart;
-		}
+
 		set_bit(line, max310x_lines);
 
 		/* Go to suspend mode */
@@ -1489,10 +1488,8 @@ static int max310x_probe(struct device *dev, const struct max310x_devtype *devty
 
 out_uart:
 	for (i = 0; i < devtype->nr; i++) {
-		if (s->p[i].port.dev) {
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
 			uart_remove_one_port(&max310x_uart, &s->p[i].port);
-			clear_bit(s->p[i].port.line, max310x_lines);
-		}
 	}
 
 out_clk:
@@ -1510,8 +1507,10 @@ static int max310x_remove(struct device *dev)
 		cancel_work_sync(&s->p[i].tx_work);
 		cancel_work_sync(&s->p[i].md_work);
 		cancel_work_sync(&s->p[i].rs_work);
-		uart_remove_one_port(&max310x_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, max310x_lines);
+
+		if (test_and_clear_bit(s->p[i].port.line, max310x_lines))
+			uart_remove_one_port(&max310x_uart, &s->p[i].port);
+
 		s->devtype->power(&s->p[i].port, 0);
 	}
 
-- 
2.53.0



