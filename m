Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024263;
	b=20lXe1C9CvsAQPH/tpXi1qtzu7KIweMfZWhPH7kkrx0tR5ZyGzyZNrOQSokrvCY+Z07b
	 7MDnoGeohu7Jqf7wMe6p0TjbNo/ApGONj4svLEVQuuTMMtG8VuXP60E7t180SlWbBjGpg
	 20xXZXr380F5jzOiuncqeycKB+VhZx3N+8NwApMabHLc4upBQ3HDO46B6dYJ/tDVlzzjG
	 vPCN4kU1cGDrJPYrFQg/gfiP0Z27KsxaIz8cR/wQROJaCXzr6vxkVApFhjtLcurz2B+H9
	 Yoy8/ATF1XvbJNVbywvYpkjpMY7IP1H7fOC2TX/kFU7umNZFvvkLvvKECTYgVmTVQpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zX3ZNB3hIXVrkJTkFLpLbQiOq4mS9XoRok6M8qBppb4=;
	b=raDR1BrmhioFzHusHVbbHk1ulNtWBjHXX64N5I1u7u7R7UkpVcEgVJ/9rljK5MuVmm2y
	 gxdhNaaVvu/JNUVnyxr6GskKnIOX1LXHOZDyz7nlqiI4YogC+16l+yj6DVHuOLQVrx2rR
	 sdz+adVLgqGWuu02SujS1iDiDrvYPzqz0D1kuuq3G1qoKsGRZcHgTctWVxGYWK0xCgHvZ
	 OjC7SUOWuJ+U4hUUICkBruN6+jn+KzQj0EqWM3MOZgn1DCb55WSwO460aG7dGlOvOv0Ee
	 8hlB3fgwuCkylV5ki/pZjsCINnkjjI1IFQAnLq5rwsw95RqpHMctOLGyPoycGKS+gCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ix7CO/FK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EF9606A31C;
	Wed, 18 Nov 2026 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ix7CO/FK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824281F000C5;
	Wed, 18 Nov 2026 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024263;
	bh=zX3ZNB3hIXVrkJTkFLpLbQiOq4mS9XoRok6M8qBppb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ix7CO/FK72sulsv8n1f8bVv3cukMeCJ+HynBBXYvwp1T1N7l/D/J9VyaN/mcIsuDv
	 zC2Lqo4BtuOo0PS2++nK109/OyW3Prc55BXtxldCnSQjJTMNHIDLhPZq8HtcQ4qUA4
	 AElWWiHBx2VqwjkLysn4GwTW7Aoj0arsrled/YSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0664/2151] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:39:59 +0100
Message-ID: <20261118150146.021057205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 110d676131922..5d76f04736260 100644
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



