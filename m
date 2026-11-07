Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063528;
	b=x3z49Qq4WdWSCL/rl3jJW/YtMVhEomxhRRqd82vsHBpu3oxiyx10n/DIYPX90rHZYFz7
	 MNLuzvjKmtjJYD8VdXpT2nkvEZ7Sl4+WhWDfcqpIYnOUP1lhN7P8HEFZWAqvCQeB3DrRR
	 L7yZU/Ve+mBmbBM+p5Kuiciurr1fkhF13gGbPNtMtV+LVHmWgZz4I37VQQLuYz1/pgXox
	 B+z9qzghAXESJPwNg3WBKH4maUSSZN8kw0Dw0gcenTXGnJH3Y1qpt98W1AeMMShMjcGFr
	 5KyWwGekOWlNN2jE+41HiOnQh6meQXmQ8VHkUQTKEe8MbJaD05oLkdaSPfHdfc5CeoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ifjg57toj2hT0Y0q4cBtvNCMN2lqw+epF3nYGy2odC8=;
	b=hkev9Ig97cTDt4AgRlSmzX9Fxg/IYehCelsDv8HDTNU5wBTJvxbX6pHcqdjFQ8Taumut
	 cRlz8FROvhhWYcz7TJaJ9NSQJ+6mfA0FR8vUi8DVau9s/8e313uCFPmhyVZOjSVY17Iu0
	 9U23N8qo4YOp7Gy2SIei3wpxKEzq7i2alXO8o4X/NEv3F90M16hjLyhUTra4xkKzTTnAX
	 RwK3Wr6dqqd1JmOArC+gf1fowcyych8rwBJ0aTb3OJDKzz+6WJ8KZLGboXkDmGJQX+m3u
	 0v+YaZfNlthzQJ0qXLPsNZoAN9Iha0OtKTXIxBGIQMon++BOz2ZDy8D5ySsWTWBO66Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lnLHt9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161A606B8BD;
	Sat,  7 Nov 2026 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lnLHt9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26911F0089F;
	Sat,  7 Nov 2026 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063528;
	bh=Ifjg57toj2hT0Y0q4cBtvNCMN2lqw+epF3nYGy2odC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lnLHt9fG5RJHs9M55dbN+7Sg8JYwuvuVS59yPEPGy01TQF9dNq0r4RqvC4NXKtQR
	 hIUWUvnfUgHbkWp8DUurh6q2uTr5Riw21sW4JApo7HECjoqCoi343cNHbHkhaCeaLl
	 N2hM3R+PmvmwYQnpU8QqtUatBGEyx50WnDbZcArE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 667/869] gpio: davinci: Clear interrupt status in every bank on suspend
Date: Sat,  7 Nov 2026 08:55:49 -0500
Message-ID: <20261107134915.747699259@linuxfoundation.org>
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

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit 800d7627f552bbf602a1736b638aee0ada3fbf87 ]

davinci_gpio_save_context() saves the registers of each 32-GPIO
register bank, but clears interrupt status only after the loop. At that
point g refers to the last bank, so pending status in all preceding
banks is left uncleared.

Move the interrupt-status write into the per-bank loop so that the
existing suspend-time clearing covers every register bank. Single-bank
controllers retain the same behavior.

Fixes: 0651a730924b ("gpio: davinci: Add support for system suspend/resume PM")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261018170622.3406158-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 5de42f1143dab..80b3b36cf703a 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -593,10 +593,10 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
 		context->set_data = readl_relaxed(&g->set_data);
 		context->set_rising = readl_relaxed(&g->set_rising);
 		context->set_falling = readl_relaxed(&g->set_falling);
-	}
 
-	/* Clear all interrupt status registers */
-	writel_relaxed(GENMASK(31, 0), &g->intstat);
+		/* Clear stale interrupt status for this bank. */
+		writel_relaxed(GENMASK(31, 0), &g->intstat);
+	}
 }
 
 static void davinci_gpio_restore_context(struct davinci_gpio_controller *chips,
-- 
2.53.0



