Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830991;
	b=3BTaXr2T52sVx/S78R7jWkXMRXllIjYDkMSjzx59S+8pagE+8yAfiq8skMJuhzoilRTs
	 YAvE+prPaMtqWxUcQJ8yCFTYWBBQ7Zl75YRSennPrRexHBI+KE4h3PjZA8HiZ1C/bS1vV
	 np2bkPNDrBt2VagZ2C6t5RD8tct1gDJgx8fb/DjJrk6GMjq3w7TKmecRAlYOIEy5/rHIq
	 Umzm5fRo33dWjcHUXEs7okjPZiCKxaAEsq7rDdZy4bhujUkqnEQt8w8+43JuUMUmYVZUw
	 k8oEjwPm4wuBm8nTy32T988vKngfrIIktBgfAhtxPfgVRtZ8Wu5EmQ9F31ACo+XtTmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dcxRPNYsQ+s68yqloONTDEJUrXLxQQVHAKONIKVVT+o=;
	b=hCyoLT8EE4V3NyA+LsRFuEoE3pXBaKJr7Klshpza1jZ0lh9DipQGK0s5pAsoayBw1zLM
	 BDI/DLe0ovUTCLzAHtAVJbfN15p746CXSFPhUrormQoZis+X6NcjljAZiGKAQvJuB0X33
	 iJV1pzRLR7I0KrDnuUNZ4gi8ecnM1lSn0uBcxaccBcQg68md6LzjBhYQub887k2QmCEUc
	 bt/TrxRyTB+2jq8D1N4I/XBIu6tbxlQE1fRM22qZh1sObbbOgUOlZnLsyk0LiaxzRacSa
	 gN9Gm4fw9hDFPZgBtze9sAu1DxCbajMX7VTpG3vDGR2FPZ5T/H1iC4yKZrUH/jbn6VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9dLT6OW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77951606AB3E;
	Wed,  4 Nov 2026 22:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9dLT6OW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119011F0093A;
	Wed,  4 Nov 2026 22:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830991;
	bh=dcxRPNYsQ+s68yqloONTDEJUrXLxQQVHAKONIKVVT+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9dLT6OWAXtIeLfC94rVYzloDSQF8crqIt18oK3of0u4JEwAjUbhlyUF9uLeHPRwX
	 Ege5sES1ara7tMrcbAVAmk3OvOgz1EfPq24Vd6501NoV+iODEuhUYjfObhX3Qk19dY
	 2qvcL3AFm0uopffEnCD4Ae0X034b1pD9okvWBteQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0443/1005] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 16:02:56 -0500
Message-ID: <20261104211056.478897543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index fb47c32ab5ff4..55c15aad42cff 100644
--- a/drivers/rtc/rtc-brcmstb-waketimer.c
+++ b/drivers/rtc/rtc-brcmstb-waketimer.c
@@ -413,6 +413,7 @@ static const __maybe_unused struct of_device_id brcmstb_waketmr_of_match[] = {
 	{ .compatible = "brcm,brcmstb-waketimer" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match);
 
 static struct platform_driver brcmstb_waketmr_driver = {
 	.probe			= brcmstb_waketmr_probe,
-- 
2.53.0



