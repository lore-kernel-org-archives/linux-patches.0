Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830978;
	b=BZJm5hzdgLFW7IgTskuNNBM58qulp1lAn1qpQ3/d1XaSwBd42a7PWaDYoqFpkFpFD4yB
	 lt5U0Rg3g7hYRRJnLrwjHbuZqVr66bwox2OZxQcn+zmHz5XFw/FWWSRdwDG8sMqWC1Z9U
	 /gFp2ag2hf00f4xl8BllJJtBg3XsLcl7NOpPKTpo7ef0OxuSaZwKwg5nKId9wJ6tMugpB
	 JUG1UWTOj0PF1PaS6w1FLjE0avfqY0oHrFUiMydrWl2JMx9SSPqObMJUcyL0Ofp4uvXcC
	 lEx+SYLt3bnahvGpeCEBWLix3VYGOiyK2TN4LHtdxQ4mLwrCtcb3/TBfb9MeghWK9ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aiYJ6A2IkPYrIeI9lW6woLRxoay2TsOc30lmKhBmCgE=;
	b=f9EMo64XDWFDJjnbY3xmpHB+BNXEyyLF24bSsNDJURAq35HoMgPCQA+eMPmEtErVrCyW
	 URZMvX3V+UW0AEgm2HqkZGX4eDyrxEQFSeapQJjs/i+JbIhvpQ22PhmycJFlx4BFUSHdl
	 9w2NXWv5dvKfVXawsOKQicc6qqjXedIaVVMJzNXxXWSz9uyTFAZUyNRp7MiCsye41hzFO
	 ShpG84wIcC0Qh2RGqsr8wDO8cxmHzZm3PMEU+HwSFp+soFenqb21EYS86sMvaZP2jm+0j
	 yWuR46LK1Ul1CQhgv7ydqECZkIGhzYT5dpNYKo5Hv/KtIWINqG5pD5OXCcZVCCcOiTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtt8azA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDE8606AB19;
	Wed,  4 Nov 2026 22:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtt8azA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA1F1F00919;
	Wed,  4 Nov 2026 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830978;
	bh=aiYJ6A2IkPYrIeI9lW6woLRxoay2TsOc30lmKhBmCgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtt8azA5rjwHt0EIANWIc3llHGONwgAS62GkrTjMqtimvImJ7zLVWfQzboGN2DSei
	 m1mSDzEPU/w0C9gXyKb+efwm54x4IfS3vUN1wI8wmGDiJIhUE8ZL/DFqrNLhdZXJkW
	 R6/NJKRRm/QZ2XApjazb/gtAcxQ6X3PTu8yNqPDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0438/1005] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 16:02:51 -0500
Message-ID: <20261104211056.349782855@linuxfoundation.org>
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

[ Upstream commit 7490b8356e52e09c196645912f2c054f79aa5f3a ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ab-eoz9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index de002f7a39bf4..8dc656bb78bfb 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -549,6 +549,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9" },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0



