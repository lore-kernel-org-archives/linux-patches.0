Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065031;
	b=K2Xtq5OOtYXKdq1PZaQppuAf8NiLKXDfsEL7KkSac7Ebz7pT+zFg2Cv3YRMRK6jMWHzp
	 OZ5F6w1hWQv6pUVNUZFBdaMMVqwlpJLc+QZNpuwwPeJa4r8l5hzSDg/ar7A3S813I+Lnj
	 ZQDSDzc11FiNDaujh9AhIG7wJ24r+5VAtWwtM2Rxpu/rFPkODIcTgCAp0EPSyZFOZ4rjd
	 szH+me8ZbXPO6gtc6ADXm7+h2ikGcOFRxK16QfqIpulFLebYWoJq/tKVMmj9Lu4BxkH8t
	 voTnoWTUYek1oh8vuN5ta8LJePU7njnmvOiZqQSwM2wKORj4T5cot1A+Vmj5qxqdcjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/3/QaaQhTIOcg3kHwcwDVDG+y4J+YYWLWrfDFA9QMY=;
	b=H4L+j3xZpPhjeb5gR0Wo7HnYYHfllozKTllvxKzz7hl/USUldr/8d6ERFpMHD350noDB
	 9oPh/ASacDforgpu7Jt+20WlLRJG6fmasK8RmW0BzMbckwuEXO4eUSodD2h6cUAylXjq5
	 jHjHDtdvn/BA0ihTmOjSAnne+F6a8vTaY1RLuhUY40jLLjZDIJB6vEX8QURKUswuLMW3u
	 Vfq4cpy0cFzffBiUvH2UTYPLmpavRWmruqG6k/eRNHnwTqHoytNEPe1ba5OwhlFrA7M/V
	 5eOrKRCZNCnoAswUtMw6+QhsLAIylzi8x1zZbIiIe0gKnpwUVFR/rRfRvLbvgdjQp8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAgJovFq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28986606A339;
	Sat,  7 Nov 2026 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAgJovFq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52061F008A2;
	Sat,  7 Nov 2026 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065031;
	bh=M/3/QaaQhTIOcg3kHwcwDVDG+y4J+YYWLWrfDFA9QMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAgJovFqin12hZqtcipRjhtwFTcnoyzbQAQSg9Yt/JcpP2sfViyL8QQllAOh0eLp6
	 HIGHm1Up3YVZUfMRz6exktb+RKlv5P4t+0mkNkdlGUVYSDr39XtSZoOVMtC3u5HnIT
	 D38net+8zKXCnZCByXepv3DcTIMzTtnFoXSiBr4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Nobuhiro Iwamtasu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0889/1257] rtc: pcf8563: pass the driver data to the alarm interrupt handler
Date: Sat,  7 Nov 2026 08:53:05 -0500
Message-ID: <20261107135003.875610623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Igor Velkov <iav@iav.lv>

[ Upstream commit 5831f5fef10030c175e585d51b0e793dc6fef6ab ]

pcf8563_irq() takes its dev_id as struct pcf8563, but probe still
registers the interrupt with the i2c client. The handler then takes the
regmap pointer from the wrong structure: the first alarm oopses, the
level-low INT is never acknowledged, and the interrupt gets disabled as
spurious.

Only an RTC that has an interrupt (client->irq > 0) reaches this path.

Fixes: 00f1bb9b8486 ("rtc: pcf8563: Switch to regmap")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Nobuhiro Iwamtasu <iwamatsu@nigauri.org>
Link: https://patch.msgid.link/20261004-pcf8563-irq-data-v1-1-f176763ddf2f@iav.lv
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 7eebdb0580674..0767331a2cc7a 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -531,7 +531,7 @@ static int pcf8563_probe(struct i2c_client *client)
 		err = devm_request_threaded_irq(&client->dev, client->irq,
 				NULL, pcf8563_irq,
 				IRQF_SHARED | IRQF_ONESHOT | irqflags,
-				pcf8563_driver.driver.name, client);
+				pcf8563_driver.driver.name, pcf8563);
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ %d\n",
 								client->irq);
-- 
2.53.0



