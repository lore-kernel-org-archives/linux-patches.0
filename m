Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017132;
	b=TeH0+FxP9Sw7qYLUc/0TCrsILBzhJOOA8L+QixXd/6BMqSeLV89fuGwjpFb+HqpfGgJK
	 fJlf1AANQLB/tjzQ4KN/YsLybBmsJWj1x4U4R0RpVcEag8IP0jUFK+p+IRzjqbjMxAYPq
	 Wpu7zG27ZYQiybYurA/l9LwIGodEvDZHykJRp1+3zQtf+uX8tRoLIGl2DuSgtxQFw0Rqu
	 +FZkA4r198i3AIxyAW+zHL1VbNDAjcHlOho2dTygFFeusXo444x1+Vz37cz5RpF953Fjm
	 EwrJlpWLUkTOi0787ZKs8cTBFlNADN8DZvEFO8PZxBIINQO8P2oVlAoYAD0kEHHn4ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ylimjiv+T+dRyRFMGgSXFNJSM10UwZ2Xz0reHGFlLC0=;
	b=wiWQKusb1faftRqr6NvtQhe9YE3JI+XY5AiTOF68M2QbFpMGKqAqo2jaFQrXQmpD1ovZ
	 /rSy4a50l49Iw4ve73Epzrs+89SsL/i3rQbneSTOH/iVoGrLLfU93qooetgCYWQo3Wz8s
	 +pjrObiIvTzkTAM44nl4aa5Os1SxayKYMD1IiT5OGcazPY1Oqx9g7VbqjxdCcIjeaTd0X
	 RtoExHODrO/NiPvPdjIbHyUA9qNlYccQ9tbyfaMs46b/NXGK9PYM7IfV5qTk6u3qjEvcv
	 h2qu52LtOlKy9+T3UKkjvjkk7PuYy2KGzJ3HShY8zAxqx7XZDT5uzq5ik2Vm+WyOTlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm6s2qJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E4F606A31C;
	Wed, 18 Nov 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm6s2qJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA851F000C4;
	Wed, 18 Nov 2026 15:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017132;
	bh=Ylimjiv+T+dRyRFMGgSXFNJSM10UwZ2Xz0reHGFlLC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gm6s2qJwdj1EwIoY5H4ghfYrE1IDw0ZflJo2+h0jVB3noVy175qh4C1Ss5MYZrjhs
	 nrQdFlj7eqTfWZYwsUAFXbKqfBcY05hEqiBj1moxrZMaiXY/peEIXZ37IX6HD8h/+i
	 qTnRkHgUJGbtWvofxMvKq9PYXjYusvxrTna8prnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0738/2651] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:32:58 +0100
Message-ID: <20261118150314.443376528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index f615701fceb7d..c720e9888416b 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -999,7 +999,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



