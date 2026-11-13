Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590333;
	b=NJ/E+GAyMIybx//ycWMm8bGG88RUl8FH75peQm19H+nPmvtqnqwOnYHWfdbyDFAWk2IS
	 6GTQHtLbaKfL83RdMwkM4OXk7Mq/wYUYTEMoVNU7CAtS6u/mtfw7a3mAbnegz3wrI2V+W
	 7e+v+Qwx8TS18hyO1Ym9Kl89lIOnWW6cWDGqd95/vbfbnf8Q0/HnsQ22Tr1GtKLU8MI0z
	 4TIazl+FlnpHMR0kUw4LCS035VAsv0Mbtn5Dg3jN9cQyYi1XGmMzq8+cUketWn79Kun3L
	 ICilQn0P4JOvGMD5VNKKtRE/xXks4aBSuEWATSg5tvTGr5jZK22gAJ7GpdyHE9OX/Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZbAYs2xwb8JbpIA0vMJSrvSfeLmDidC6IFSyCA9gBrA=;
	b=ZE88uCXI4LC8luq/mWj8C7mi9I7MhtBZQ9Kjl9VM6tuvYshQM+sQ6wszOvk3kjgDDOTc
	 jJiSTeegLXLCPhMw8MVMW4R+lQbEQgSoAohC3PRcI9iredtGO2IBPgbo/VCZauBF1oSOQ
	 CFvYCE3QoR8iW6/6oMxncsphGfR4wqr8rUKBhZyYHePqdULQZprX6w9cmj8DZvd07aF5k
	 v0qUE2ngkKjlxSy+PkAS6LIfsNqo5IX1cw4rQG9y4pfeaG+3XcQrZJLAVBQlpajG0wTri
	 n4CUELA3CCscojUGoR4l3RQBjvw1CTsSUzV1fy1uCIikUngsVMoskyExL0qpgLoENZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew0f6R8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB6E606D4A2;
	Fri, 13 Nov 2026 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew0f6R8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF2C1F000C6;
	Fri, 13 Nov 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590333;
	bh=ZbAYs2xwb8JbpIA0vMJSrvSfeLmDidC6IFSyCA9gBrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew0f6R8K8eGHmdcJ1qq8gCdSOKxsYqfA0taD83iOW/NIailV20xi344Ks4wBmzQ4G
	 aTLzHZsHMj8YzIgNjS+G6BCZNKXnD5LAJ6fTGqhQpzn8bEx8A1uFWmpsU5r6quUFN5
	 XVzqK78WQ02ieg9KBe12wZfNrFcMvAZCvKhxTf/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/686] hwmon: chipcap2: enable IRQ processing when regulator is already enabled
Date: Fri, 13 Nov 2026 10:46:49 -0500
Message-ID: <20261113153830.353549433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d1ce827a9cc11ffdfec77b7fec9b73a8020a308d ]

cc2_enable() returns early when the regulator is already enabled.
This can happen if a previous regulator_disable() failed or if the
regulator was configured as always-on.

In this case, process_irqs remains false, causing the ready interrupt
to be ignored. Subsequent operations waiting for the ready completion
then time out.

Set process_irqs before returning when the regulator is already
enabled, so that the driver continues to process ready interrupts.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-7-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 34c3e26211458..632efe64f190a 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -118,8 +118,10 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator))
+	if (regulator_is_enabled(data->regulator)) {
+		data->process_irqs = true;
 		return 0;
+	}
 
 	/* clear any pending completion */
 	try_wait_for_completion(&data->complete);
-- 
2.53.0



