Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060301;
	b=gy8wNSwVIRjyxjknLzor85OfxNLSqqrnIrywjIyKWwBQMKOQDud4vLfmcNmLc378Nv7M
	 nt6A/eigdnSXlPV22URdaz84l0YVSmn1hFhVOxCla5KZstFhO6IucJ+MaOEZmbnxQAjma
	 DsnbBKRK66nvjCk7Sm4j5SAFIcwm1O3H3Rrdfjr6HVuFsNlosOVJO13O8cbGpHgrxLDHa
	 hQ2YO5q+wdDOzfr7Q4Q+jBiRE2nxppHpQib74+LPMs95ymXJb7FVMMFWjkksszNNwjKvQ
	 nnWtmuDFBHSz746yhVZsNcmVsqj7Lb+6qxOvJqDLzJeIvfcfkr96Q7LVroTBI9HY6Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rbf2vD35AoWiUa2QIgrxyB4vfLkN1g/KHoOzXUblWP8=;
	b=htbkqCP4B6Ixo6+XZIJ8f0BNnef3WLMa4LM9QZBLG9C3qO6StgrZfNyJhkNw2ojN41Kg
	 5rKi0NjLjcKaPbJzC2b5nI7MclI5gK8qCRLmjC7X6ajla8AP/TEsB1ay+O5UlZayj+Igw
	 BZQNOaM94BrasHjYAvyYbidU0drlgx67uH+V3rWGCBVAp/Ziru8IIJJ0/5C4h+9MYGark
	 smdustb4mN3yRDNm6BUCpHNSdgRzT8Kuyc2E3oiH0d7gSnPqb/LlBvRE+LVXlAFZ6EkEW
	 RAmn7XliozR2yvPpWJIiqXgPxg6qmf2PXVbPEw1jdh7TIl1EkF81Fpnb/n68bMsQVJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKffxBK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAD5606A325;
	Thu, 19 Nov 2026 03:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aKffxBK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3C51F000C4;
	Thu, 19 Nov 2026 03:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060301;
	bh=rbf2vD35AoWiUa2QIgrxyB4vfLkN1g/KHoOzXUblWP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKffxBK8zy/kumuRwstH6vQW92xPAvSL/5o+IShjaJWcik3nCR3jPyKcBOZ+ZV2As
	 +058FmKs5zVqSNpCeV8dFpofWSeqrNl+/c+we77eeeqZUoZXvPobizp3U8f4/+T3R3
	 tiPZd/X8Tp775B8siLW7zCA5rnKLL8WlGU62LZO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1148/1848] pwm: renesas-tpu: Implement .apply() callback
Date: Wed, 18 Nov 2026 15:53:06 +0100
Message-ID: <20261118150007.805101225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ec00cd5e63f05461ab48128775c73c851c3c2b18 ]

To eventually get rid of all legacy drivers convert this driver to the
modern world implementing .apply().

As pwm->state might not be updated in tpu_pwm_apply() before calling
tpu_pwm_config(), an additional parameter is needed for tpu_pwm_config()
to not change the implemented logic.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 62cff15fbf2b ("pwm: renesas-tpu: Fix runtime PM reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 44 ++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 81ad5a551455e..7f5d2bc3d5dda 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -242,7 +242,7 @@ static void tpu_pwm_free(struct pwm_chip *chip, struct pwm_device *_pwm)
 }
 
 static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
-			  int duty_ns, int period_ns)
+			  int duty_ns, int period_ns, bool enabled)
 {
 	static const unsigned int prescalers[] = { 1, 4, 16, 64 };
 	struct tpu_pwm_device *pwm = pwm_get_chip_data(_pwm);
@@ -293,7 +293,7 @@ static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
 	pwm->duty = duty;
 
 	/* If the channel is disabled we're done. */
-	if (!pwm_is_enabled(_pwm))
+	if (!enabled)
 		return 0;
 
 	if (duty_only && pwm->timer_on) {
@@ -366,13 +366,45 @@ static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *_pwm)
 	tpu_pwm_timer_stop(pwm);
 }
 
+static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
+			 const struct pwm_state *state)
+{
+	int err;
+	bool enabled = pwm->state.enabled;
+
+	if (state->polarity != pwm->state.polarity) {
+		if (enabled) {
+			tpu_pwm_disable(chip, pwm);
+			enabled = false;
+		}
+
+		err = tpu_pwm_set_polarity(chip, pwm, state->polarity);
+		if (err)
+			return err;
+	}
+
+	if (!state->enabled) {
+		if (enabled)
+			tpu_pwm_disable(chip, pwm);
+
+		return 0;
+	}
+
+	err = tpu_pwm_config(pwm->chip, pwm,
+			     state->duty_cycle, state->period, enabled);
+	if (err)
+		return err;
+
+	if (!enabled)
+		err = tpu_pwm_enable(chip, pwm);
+
+	return err;
+}
+
 static const struct pwm_ops tpu_pwm_ops = {
 	.request = tpu_pwm_request,
 	.free = tpu_pwm_free,
-	.config = tpu_pwm_config,
-	.set_polarity = tpu_pwm_set_polarity,
-	.enable = tpu_pwm_enable,
-	.disable = tpu_pwm_disable,
+	.apply = tpu_pwm_apply,
 	.owner = THIS_MODULE,
 };
 
-- 
2.53.0



