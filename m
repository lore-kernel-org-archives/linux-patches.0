Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043591;
	b=GjrMnfvCGsb52nr37WP+Fx/aUL5K3a4a0ETi6q7JPQTEk3tDiqMG3XYldpEgu1woVjbD
	 VxyOslAFEfc6FgHCHlzE3WqmBoV75s9Lrys+Yk1k48j6e2xwK1o/OruzJ8/yk3LpLcrPS
	 y3v1iRLEzkmgs81kP0ZUwDQ7a1KsPsvlGvTybORh7DMrIyBVk65J7cXG9of9HK0tuxqND
	 FLg1gfp3sbFksjcvcgLMoRsP3LwV27sdWMyNdNseEL9ORw6SoKvTjFK4+MH4zYpiVCK0C
	 qKF42CP3xjNEQ/+TkHDXj1N5uRD06+9Mk9aDtKJZyjYVBo1Ly0e5YkielMQHQVokvIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoG1t5S9FvkNhe7XEuYLwBaoeXce3xcfOi2JC99COj0=;
	b=w3XIV1OsrapoNSRAbYQg7cZgMaCR07gP+vCSX4cbh6k7JTBFl0sCYpkSaWh5w31HLNKm
	 L6kU28XvrxbA4v5xUbY9/O2c/p0SaCEauHxc4THSMG2oV7T+lxS1YD7+DETbggrtSOne9
	 0b2HNegr5yk70T07a9OKRRWy53P8ZIb+LChuiH8Kr5Mwu9CgAAiOzvY0fPA37i/3zjYm1
	 9j1ZKNijF7jeaZxZKsqh2nx9OQr8lGkgSTona/icTFp01ZPGw48t6ZwippOJd0FeVZge5
	 0BLW8XuvCj53YBnn43axMUA1W1jo6sEoUQD1zS36Z6fZ/5+BFR/4e8V/dSkLPLkheSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r7dxaHth;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBFB606A330;
	Wed, 18 Nov 2026 23:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r7dxaHth
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200DC1F000C4;
	Wed, 18 Nov 2026 23:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043591;
	bh=OoG1t5S9FvkNhe7XEuYLwBaoeXce3xcfOi2JC99COj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7dxaHthdz8V1u2doYK8azyM10rIH4sbVJVR/dVdsMg/oFi4KCzslNe1zxWI+FHvu
	 sbbxqv9OUtTS/wrvGKAJQFSAcxB4Tjn8sNHU36UBvhQYnBQu2xaTF7qLQHCH8gFDUM
	 9VAbjFv8qe0F9aVvbPYJLA9aLAPf7EJrPf2fEmrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0264/2857] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:21:38 +0100
Message-ID: <20261118150210.936970337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



