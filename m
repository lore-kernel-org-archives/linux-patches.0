Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063507;
	b=grjNGfsgM2t/Mfx5UxRCJ3IK2oQfjgKx9Fy/rJJ+i4BXy0zHicm2Vf4UquLgATCa8waD
	 8fkh/RfJO1d1ZaGV91fXIOILrFuvDhNXOU0hm2YBl7RCU87MXBIQj/3SfBz3m93CFFbo4
	 dL+8MwYaZXEacoHKFacmEDQkzIdGwOZarHQYcrZDC4xvws6/DZQwjHvPHe2WgkiO47au2
	 VSBbdf7x2NAFsDUGAXRiY5Sw1Ov+qTmAsJdNLQlfIMfK1VDvIi2zvv6ZXlUaM/jReWJBp
	 KLg1X+lgN1EmmvVtOpRa0gN2qVdt3GbAP7c01zSS4Ipx3sbAYD2Vi2yc0TtARARZq0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6gdFeM/UuOv0DglNnY3gNvkd4Z1qq5ezyKuEsczerA=;
	b=vjKMqlAjJ3x7s+QhMhICu3NzfiDDTZ23NSUkdA8p3cW8/5ZKLxQ/hirA4XRObLmCgosm
	 lEnPLy+FtqUF31j0oWt08KJ4M6P9RcADhbMQ5LpJ7WjSoYUbQHgcH3bTA0jE1cVpKJi76
	 LNKhuy+DH+5yDezldvEq9HxYLmD0+VXxhUf6DYFXgBQ2l8we6XQ3XklnwDQRsvwoteO+k
	 xlugy/6gRIaHAMK3VsPfmq4/iweBMInKCJ9HlpHFNQsiSJzA91CJgGczqY6GGpoHtiAgE
	 3YAoP9QqYNnH0Rdnae59LYzZDBXK1OAZSx++40HIR1rHy+XmZ2L2QUb2wy5Az/zrzXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0Reaqs0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13516606B8AF;
	Sat,  7 Nov 2026 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0Reaqs0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683F51F008A7;
	Sat,  7 Nov 2026 14:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063506;
	bh=K6gdFeM/UuOv0DglNnY3gNvkd4Z1qq5ezyKuEsczerA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0Reaqs02gBWCu4NrZ4eQUSERSm7aly8W349qkWi2+n7J/sZU1trLKapLTWnYqAom
	 t0OYaadQy8/uHMeuatsimsVa0qqFCgYhEIBM0mCDWFr57QqittZJ9PntVniVMdsOVn
	 vlP2H/esyMx0XnAAa/7bRl3gZIwbvDEko7JcS0sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Nobuhiro Iwamtasu <iwamatsu@nigauri.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 651/869] rtc: pcf8563: pass the driver data to the alarm interrupt handler
Date: Sat,  7 Nov 2026 08:55:33 -0500
Message-ID: <20261107134915.118692924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 7083d927820f9..c23f04bdd95ff 100644
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



