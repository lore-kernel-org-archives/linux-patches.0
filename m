Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625392;
	b=kYvkXEaz7pN3nQFLODQOHaLhRaim9VUzS9V0qXQK8TqARndTp2xrdUWoiPqbCVBFMd96
	 IbV26pbLANPXq7gLsAA8VEVCyF/dR9rQNJf4K2dyeUGl3zl6dFdQ9o/GrJMVUfitFkVtm
	 ArKIKo3KeWUGx9xixcXRJKVqbDx6KsOuLfKQV3v/fIUESqfQ9C4l91J9JrLPaCK6ecAqz
	 +oE9HIJV0Rc81cq/SUY6WLDP38WKK8Ds9DUzy98scU2fQq/fobMaTTUViqaM2/Swi7JVv
	 dMCHIXOzplzzdDzDL/VNfiig5zquT/lx99CF1ue808dd1GUDzgQVgkMdlulnt3+Kjig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9cdYEvyurSm0FvDz1wls0ydwj2cUMbjc9R1DCWOWPdE=;
	b=S1p+Rrzqb50mhgwXWYV6VkPpr4f9hMpXcIUbqCzGVpCmbgHrjl8Dg9d0DEGiMLPrxGwS
	 ggPM3lkTSGYNwGUhGybNKHnN210X7PNxFR7bpV2/SJ1Y0CSfNbGtIJR2AHo+Oht7fvmqv
	 6ou7rqXOF3oyy62RUjArJEfK/rxa4UKZpLd816sOoSN6Y6qKLBwWNpN4NEwWnfJwUp35+
	 b3J8A1BMFD2SiuULn/N5sZ5PZSjOvWnAOJyXAG8tSjBTDlWqnAVuwbkc46d3VxW3a9Gqz
	 S6HC8yFrpF/L9GYJK1VutvDYrjUlazJK0OzNhgmJmBMUTwtxAAExJe1FK+rQXCzD0Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWVvHX3T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB562606A321;
	Wed, 25 Nov 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWVvHX3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CEA1F000C6;
	Wed, 25 Nov 2026 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625392;
	bh=9cdYEvyurSm0FvDz1wls0ydwj2cUMbjc9R1DCWOWPdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWVvHX3TulGqIcNumbYstxdzWE6cAnSAk8wygk7rdr0FJ5Dc5luhyWUVjus/YONbB
	 dI9qXq1jgxZC8yEZATsPBuHc75lkxyxKyjpQh+vNKsLslAqfq3Bkk4Qq8OE4zK0mDr
	 uQI2nXj8Aya08Yz10xy5OQFNamHE1Vbo2TFIofQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 500/816] ASoC: rt5645: Shut down the button timer on removal
Date: Wed, 25 Nov 2026 15:34:08 +0100
Message-ID: <20261125143900.763584818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced del_timer_sync() with the older name in context, since the timer_delete_sync rename isn't present, while using timer_shutdown_sync() as upstream does. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index a7ac9971ae244..c963262056a71 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/regulator/consumer.h>
+#include <linux/timer.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -4287,10 +4288,10 @@ static void rt5645_i2c_remove(struct i2c_client *i2c)
 		free_irq(i2c->irq, rt5645);
 
 	/*
-	 * Since the rt5645_btn_check_callback() can queue jack_detect_work,
-	 * the timer need to be delted first
+	 * The timer and jack_detect_work can rearm each other. Shut down the
+	 * timer before cancelling the work.
 	 */
-	del_timer_sync(&rt5645->btn_check_timer);
+	timer_shutdown_sync(&rt5645->btn_check_timer);
 
 	cancel_delayed_work_sync(&rt5645->jack_detect_work);
 	cancel_delayed_work_sync(&rt5645->rcclock_work);
-- 
2.53.0



