Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020530;
	b=RPoxeVQOyCZiPZJG46KuvW25A4IN4TemYwVi92UOa0uV/2rbb7NYDasg/Bo0PkqAybTU
	 lyTzQQXh8FCp8lUGc4S087NV+EJhRew+32FAykktvcfTKaLV/XgQjS94xkn84B95YieWU
	 GHLiKCe1XFcA8kPgOEsAQh8R23CxoLq+2aBJ43MKAHT/8XjoGK9Vzi4sVwxXWyK5FHGc0
	 Pt3BI0311Et5Twp+e5vBM/UOnNoGxmHAH4+9+1g7NZGfnjCHUclLnc9kMVpdKtwd1GDqF
	 vRirP7ZvnCQicqPn/xZVrtc3aecBaUtQUSxsqENkJi843N8RajamiImPFMns9r3pQhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oENP859kIKxvLWDBmwrMnFha/bQ9K6y4dZX+tEmiW7o=;
	b=ef7XioHyk0X5Fg/ZiuxHYt6gPU7OlJzu67WO6B/Ck4FX2EbQqb0EtWJ6eRZZrGRf1T2g
	 +G6+Kp7BOuiLArdX2JKIyspal11XW8BfIrlSennlbE4CPzPqADCA8yyNKlvJoTYIp5eba
	 3acTNhzTFggZQ8TrDt9ldh0IIwxwtSQ1hZpZbNKoyPf9LvrCxSCS5noUpTD7LO0CBunaZ
	 +XDU2SsJ0je5cIbO0s+YBWTOyYUCduoYxjxl8G4XpWl6wHW2wYLutohn5lBYe3TzerYyC
	 rlGfWQO8mBVi7h10M8RqP5sxchpIUih0TSokghhcqxVBVvCZe3RwgPDtBC22oIQGgDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fgmg+R7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A4606A338;
	Wed, 18 Nov 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fgmg+R7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2D31F000C7;
	Wed, 18 Nov 2026 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020530;
	bh=oENP859kIKxvLWDBmwrMnFha/bQ9K6y4dZX+tEmiW7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fgmg+R7fSlbiMVkrSaCKMqywxdmQZnZxFNmz5xpDvefIQX0l0Dy4bbS8SbKpjVbhJ
	 409bFuGTACCXpYYcKH+tWCfxbkDSfKjMSZb1/kmBiR8fJ2AOqhIRGSZqElOiQ97V/+
	 63nAGKbnnkw8qR2joqPelYg+s2xZZS5rqZuGi7Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1967/2651] ASoC: rt5645: Shut down the button timer on removal
Date: Wed, 18 Nov 2026 15:53:27 +0100
Message-ID: <20261118150357.302431403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit f0ecc305442f20a6df2575943e9897825d80cc5d ]

jack_detect_work can rearm btn_check_timer, and the timer callback can
queue jack_detect_work. Deleting the timer before cancelling the work
does not break this cycle: an already running worker can rearm the timer
after timer_delete_sync() returns. The timer can then outlive removal.

Use timer_shutdown_sync() before cancelling the delayed work so that
subsequent attempts to rearm the timer are ignored. The IRQ producer has
already been removed at this point. Keep the restartable timer deletion
in the suspend path.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: 7ff6319e7da5 ("ASoC: rt5645: use polling to support HS button")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/179203261324.2681924.5002100194676410503.rt5645-button-timer@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 7313ea71c9580..3c4354d885093 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -19,6 +19,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/regulator/consumer.h>
+#include <linux/timer.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -4292,10 +4293,10 @@ static void rt5645_i2c_remove(struct i2c_client *i2c)
 		free_irq(i2c->irq, rt5645);
 
 	/*
-	 * Since the rt5645_btn_check_callback() can queue jack_detect_work,
-	 * the timer need to be delted first
+	 * The timer and jack_detect_work can rearm each other. Shut down the
+	 * timer before cancelling the work.
 	 */
-	timer_delete_sync(&rt5645->btn_check_timer);
+	timer_shutdown_sync(&rt5645->btn_check_timer);
 
 	cancel_delayed_work_sync(&rt5645->jack_detect_work);
 	cancel_delayed_work_sync(&rt5645->rcclock_work);
-- 
2.53.0



