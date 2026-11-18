Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027039;
	b=sjk47ABHM4klEZgfRgK8MfKn1GMTvlgEErWKliC047g6O7I01MFejwCl27pniQ7wGoFE
	 p2ghMN1Gs7umJobxYe4eY85Boc5QjajIv41bTQScpLC4plxKRYUzw+6/xvHJ9Ho2P+Daj
	 OYGNRTGhWyEHmxBJE1xO4h6SwfDp1eBI1Z+a9NCRlQwkREouv+Fqfhw9BSG9uExCgWRZF
	 2Py+pah9oV/FAjAqaVNV8emcCv/a9HikzLQiqAMgHs2d2XPcRGaC7QshCHiMh8TuOhhz4
	 brOXzEzCwFYQ4gvqkNKodzwLjyK4gpq4RZmR1eS0J/fwhjOCkFWOwQvhamfJ9DeedxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qxq137NyXUboZutKJianB+iHw0aDEtXK08dHcPgqUls=;
	b=ayvOX1tNFnBqEXGTY23UU8u/YC1n6hSpo4S0rtIyX70I66FqgiYfFKvlR5kijiDWYyGA
	 y2lM8Kz8ERMBwjoCHL3Mx7p51MDA8zKdimR2OlsX3+LmM4c4KaePGwo6mTkuZ3r2a0U2e
	 lQui/mbe9jjZ4jJck5zSraMzMpThVnpneAKMYXBy7//BESMW0tQYk3QuY29fsJSnAnp2l
	 uciX9Xi2u+nEP1idT6G4NjlLMrheNdb1DDm2CbSpBgL51FLtuRbKpw68j7p3cmVUl/xiR
	 61z3ziV/ZHteavuRhUVSrdGV9eMr0JR73NZiAG438hTCEJcAv/BTDLY54ugd6LjPogg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7CrqnUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E20606A320;
	Wed, 18 Nov 2026 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7CrqnUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F281F000C4;
	Wed, 18 Nov 2026 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027038;
	bh=Qxq137NyXUboZutKJianB+iHw0aDEtXK08dHcPgqUls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7CrqnUVNqkrS2W8zdQFoOC3T8z3eLkSmjvY5T5eoIX6XNbRmigimjBPWY6aoPAbG
	 rxVIqgoZFMnsVDOmwN7yAXYCyQvKl4XvwYNIB9MLzHs/JzlkU7ijo8V5wYjZkbnoaN
	 UuRLEJixWhpRMuhDSBX48fwhzCTrZvSQlYHzWv4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1606/2151] ASoC: rt5645: Shut down the button timer on removal
Date: Wed, 18 Nov 2026 15:55:41 +0100
Message-ID: <20261118150220.369673080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 428cc6850dc5e..086db420762d8 100644
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
@@ -4289,10 +4290,10 @@ static void rt5645_i2c_remove(struct i2c_client *i2c)
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



