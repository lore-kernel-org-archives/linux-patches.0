Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060775;
	b=p9L4YEZxsnQ7529TjLO0Ra4VdlW8TWUDY38yNCfdkPQ8MP4afQf28NNsTismrC3rNp5E
	 ZvMep+yenXauFZAPFuh1/q6BOIF/HQB53oUNpQ4cgU3GHVtXehz52rQjb0tnzKgqvzVAm
	 4C/3SpuObV8UD96GZLII1RLI8G2dR0pAb1xl8tP6aTpJsYBT1HgqT4Ocd7wkTKL6HhG65
	 S/O9kbfCjY5CTzTbkSU/ML6zzgfylG1OxsoLzWCKBjJ8FdH7C4cAgR8FTtcWUOm+wVPAg
	 SpJztNimWWW5fbbzdReTSjO4aCvgMTz+4b23f1WKzsBn8nbCxRO2Y4qwgSGU1pnO9Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bbqFvjLYkyDEID1nX3YklFQdF29s2d9ypE3MqdkwpVA=;
	b=UUZgAEF/webs2liFf4+PkVf4r7MI0Lc+oD99ukTOCNFV8N9CQymD/+XoLcCv0pqclSbb
	 aV4wPdy5ErlN0v0Qk9fxIlpVwBEsy4ubvPD1cqwmf5nqlx36x5/BWYSelZqtta0LbIB9l
	 vAhfykBdIgqaDXXfxKEuCyCsoKvRj8qG8IW8LZIjGO3zizgJJGKv1FOaVWnKA0dgecSSv
	 q8hGgUensI9+GJqxYtY7lQpQ6ClfnRrHs3n8FF+WaM8Mb65hE6HcYWXJGLx5/wE51syn8
	 NPwBNnfa/ulDsffkcg0JTP4X4uu2P87lPkZayPJJINiN3B/ejSkQMLBMt12eK80sN+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1uNe/7aK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D265606A320;
	Thu, 19 Nov 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uNe/7aK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67741F000C4;
	Thu, 19 Nov 2026 03:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060775;
	bh=bbqFvjLYkyDEID1nX3YklFQdF29s2d9ypE3MqdkwpVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uNe/7aKwNG0ipgmrRiD/gI3sryXAYC3g7Dp7uaqjwMyGFDLA9jZECIwiIY8L76Fb
	 NBuUUItu9e32phRaEq+hu8ZFmH93FNyJ4r8p/FkCC8T2EfaVCz+ikx/WL9bgvjkhWC
	 6eeTPgv1iwe89I8UaUlHO2SAYaLG58Z761tDEjh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1319/1848] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150014.808099863@linuxfoundation.org>
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

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit bf961847813d9edcb5a9c089714069428d141fa9 ]

sifive_serial_console_ports[] is sized SIFIVE_SERIAL_MAX_PORTS (8), so
valid indices are 0..7. The bounds check in sifive_serial_probe() uses
"id > SIFIVE_SERIAL_MAX_PORTS", which lets id == 8 pass and causes an
out-of-bounds write in __ssp_add_console_port() through
sifive_serial_console_ports[ssp->port.line].

Fix the check to use >= instead, matching the check already used in
sifive_serial_console_setup().

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260827014524.19375-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 34b38795096f6..9177e2eec44a1 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -976,7 +976,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



