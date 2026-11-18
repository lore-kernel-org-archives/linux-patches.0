Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029993;
	b=jGE3eztzwd2DFo4UFsZKvpUh+lkCwSvltRT57KhxBlXeeUvrsGdlg/xWNQus6JDYz58n
	 OhqhBTssEQFAML1UIpf62Ku1KR7RZXEq6Yi7AtbML/PAA5phYFcO/VLhxnZoRLrIK4hPR
	 dA/sImPaYVa1fzwD+eMxIno/QNLoa3rQ80SP6queL3+0DP//Y9JH1ApJAlCHSIksezYbm
	 sNvJH4HqJpHqbJ1X6q00sjZpdWZVuoL6mEvZCHN/G47yQdn0nkvAxwA0UWlOmRHB/BHnc
	 KYQFFyCow0rWmjIS2bu+ZvjrifYpAIAe3N3qN+9jPEAoIsWNxuBMSFJboVebqT6HspQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/DmG5qBcg4NwfmSaF9ROC7W4FDkBJBq1Pm6IgZ31iE=;
	b=WWUQKh/fGjjvBDVLU5AvoIlEJTp6snL2HOdz8IMweBjKAotmZVsQI2TM6nJ5iTrZ6+D0
	 hNZhWMbNHsBF+dJCATkjX4JpwMh3PMEeQAbmzjPo/EY/x/Z+G60m9I0fgFtTy+HunJkYQ
	 qinTgl8iLTE8hVino5pISjuddh533tCFVf9cbbtCDqyA1dteyWKdET7Mq4Y9JQGzYI1aA
	 UFZKCuOWbPXFC9mXxIATTxG5hEGtEdw0/H5g/rbj8pWqvPsqU0Wdp39BXNU2GZZjMLE/p
	 LTAD+blpsPmbJ7yss/U0BiD7xgyuOwTX7YGrZUSxdBr1PdnYeLObOfF32mSPSB1oizg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vN9SH+Uz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE92606A325;
	Wed, 18 Nov 2026 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vN9SH+Uz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A1B1F000C4;
	Wed, 18 Nov 2026 19:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029993;
	bh=8/DmG5qBcg4NwfmSaF9ROC7W4FDkBJBq1Pm6IgZ31iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vN9SH+UzxIo1I1GZ1lHTBSSZecmhctk3O3tYC2Ssu5qSvnNea3Nh0m9/ZqNDQOQkS
	 wpVy+bRY3quRVbR1uh/ey8yfrxfBwwqLsa7nNeB1CUxr/r9nyt3kkf2FO4EZTC9NjH
	 YTZN28kkf3VIvW+wQzb5KfBvnBiE/TTgSpTURnmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0546/1756] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:44:33 +0100
Message-ID: <20261118150030.868681403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 054a8e630acea..1046ada8be444 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -937,7 +937,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



