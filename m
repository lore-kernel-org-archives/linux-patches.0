Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051483;
	b=i8ObQ3e03tNmO6XVqa+GpoOFrqoX78hmIVVmOZvrGLjfUlFy92uzcv+Z3LGPE6VdEmLv
	 6W73XRJRQ3JFcbuK+ID/TKsrfY8mTS3H7p5EkeyXJFaEn08AV1ab4rXo7LMGMOvZvndbl
	 Wq4kSdwh2hYXwgG0H0NDU3K+xSCo5potoYOiEs4SXRWpA8y9qynvavWcg0GkYfyYpOaWq
	 tI1cIh8uAMz2WpWgqxb/Xi190gURsQ7cSkmZBvdHOVVg5qCJ5IlMMnZVdYtt98z0B+ZKi
	 ajNlqbEM6UH9wLN4Zms3u28cfyZzicnyTPdiu9/CJ7GvtdnMZ320ynD14+1hCd1TYyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfLXt/t2W20b7Os3uGtVQuy3551pqdDuQyx0ANPHC8U=;
	b=c/F31IETuge/bPKUxvXJcwZg+1dUwEGZlwlmx9B3A02uKdiqJb61XH1rUWq0rsx3ak+3
	 Uaa1wdxEnfmXkScJpCbDZDhM8MSL+oTYMqMwpMibtWzydUQM4V2vQeOZOgtbWVIruLIWQ
	 jY3XcFd1G8dnwbbvsh6PBSmEPACE7EXIsJwDZX80Jz3w4nthAqtODBPSz5mK1FmAxiHKD
	 vOWtOnuvqwrKXdlDDsbTPfTQnNqb+lKs1E5TcSybV5JhBn3V+SA3sorasI95zT0X/nNhk
	 3TjJMMNxivYNTIiqID/W506b0xLD8xto9qxSQWjp8wHL6mgR6iLpGRA/w2dJcCaCqUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKP29QMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672D606A31C;
	Thu, 19 Nov 2026 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKP29QMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B16B1F000C4;
	Thu, 19 Nov 2026 01:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051482;
	bh=bfLXt/t2W20b7Os3uGtVQuy3551pqdDuQyx0ANPHC8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKP29QMSQXPKeF5PD6YycNBaxXJ4dfPBtZKoKSRa1XmW9GV9EQSh9u0Rw0mK7e5Oo
	 j4ZW5t4PJPR2rfzTGlW7vMPXB0Xp7oGzKwtACCiOvprVpb5ALaiG9umNwT2voIhXvY
	 VQU7/DDDWEn2s5AFElFoqRyh/0CqbK2IDAZYKCJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0225/2214] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:31:41 +0100
Message-ID: <20261118150019.242918782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 402c89d28fecd28652a4bfe997f08f6544836381 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-brcmstb-waketimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-brcmstb-waketimer.c b/drivers/rtc/rtc-brcmstb-waketimer.c
index c74130e8f496d..6e865b33de7a1 100644
--- a/drivers/rtc/rtc-brcmstb-waketimer.c
+++ b/drivers/rtc/rtc-brcmstb-waketimer.c
@@ -310,6 +310,7 @@ static const __maybe_unused struct of_device_id brcmstb_waketmr_of_match[] = {
 	{ .compatible = "brcm,brcmstb-waketimer" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match);
 
 static struct platform_driver brcmstb_waketmr_driver = {
 	.probe			= brcmstb_waketmr_probe,
-- 
2.53.0



