Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018216;
	b=GsiF8i2TrtS92/FbjJQ1OhiP6fmUgHDLN2k9dt1YwpuZ7s/bScT7wl2UDbCB7FcD5oEi
	 jPqBflwM8AwDUKWrwoxLClQFTuznk8+WjKLkh3hew1UovjKhDiQMD2R+Df5rh9HN6+K40
	 dCFn7dtXALWzQXMj3OimvjZPaQPoEfj6K6YV5gg+yN/q5RJ04SHDFnrppuhYH+MvhPk14
	 bV6Obvl3qjXV+rP0dkdXplbEQEWOq2x+4rKyUSv8baIF8ONUlJaTCXeoJpZv6SHVtQ/0/
	 tBo6cIsNXijP6tSVXO3nBUQHHyVJIn+9fqFC0yHxTyfaOQc2cKYzYDcX1lmEqSD6lkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9h2s8VfRZHqdXZeT2esM7cbal3L9PdayvZL12Xc+yqs=;
	b=wWxIUVKQlKqqIaglvqlDXDdtneogdujf0QDzcPLWGc7k2xV45Pb+dHZOz4KhY3ASsngW
	 F+4398F07IuGtpsJ9I7NsXVv9CePFetuB2dshtU3mU0xXjOzImi7j+/TrtEtxqzQb7g9j
	 93SEX6r9Y+UWHZyZYryMd1p1i0LOfNhPO+jSsb9Are48rZyMvvTTsIEiNkHmcad8CY4tQ
	 7E3Cb6tye9WYkcedmYspXIW+/KjJfE/zXIlJgj+uKT2TxxH2LghKl55j75iE0qzz4p5VI
	 JVXbUQ4hXBJz6ZAd/NsBan3O4fL/T80CdEmYvtu+zJxMeD+Rn28lfB0pboN3/Wten0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VglfqyIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D4E606A31C;
	Wed, 18 Nov 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VglfqyIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF1C1F000C4;
	Wed, 18 Nov 2026 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018216;
	bh=9h2s8VfRZHqdXZeT2esM7cbal3L9PdayvZL12Xc+yqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VglfqyICokmsZq8pc+nuyyNqkSEQrPYvI+1RncId1DMX2ZbUdCtr1AH8JS3Yly/n0
	 jRC1s5G8golyludUfWDq+4dfzBc1M9jFLO/gQmhPz4UvY0T7M/f9D9Gr2gOHj0A96C
	 SGRaT4GqhJb/B68wFDBNZH7/FgJWkeQTsgaEnCH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 7.3 1160/2651] clocksource/drivers/timer-ti-dm: Register clocksource/event only for am654
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118150329.775583151@linuxfoundation.org>
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

From: Markus Schneider-Pargmann (TI) <msp@baylibre.com>

[ Upstream commit 0d3a67b1954a3988fef20ba7641d33e6085ad313 ]

Registering clocksource/clockevent for the older platforms breaks
booting them. The older platforms have their own implementation in early
boot that is used to register clocksource/clockevent in
timer-ti-dm-systimer.c.

With am654, the timer is much more complex with more dependencies so
doing this in early boot with the other driver is very difficult and
gets ugly. Instead it is implemented in the platform driver for am654.
However the old platforms may not register clocksource/clockevent in
this driver as that would break the boot.

Add a system_timer_capable flag that is only set for am654-timer that
gates the clocksource/clockevent registration.

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Closes: https://lore.kernel.org/r/2013A99A-0502-4128-ACFA-B04886224393@goldelico.com
Fixes: b8eeeca55456 ("clocksource/drivers/timer-ti-dm: Add clocksource support")
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Tested-by: Andreas Kemnade <andreas@kemnade.info> # OMAP3 GTA04
Tested-by: Kevin Hilman <khilman@baylibre.com> # OMAP3 Beagle XM
Tested-by: H. Nikolaus Schaller <hns@goldelico.com> # OMAP3 OpenPandora
Link: https://patch.msgid.link/20260828-v7-3-next-topic-ti-timer-dm-clocksource-omap-fix-v1-1-85f0e4dc6f9f@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm.c          | 4 +++-
 include/linux/platform_data/dmtimer-omap.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-ti-dm.c b/drivers/clocksource/timer-ti-dm.c
index 6787acac9a438..ae8777d032154 100644
--- a/drivers/clocksource/timer-ti-dm.c
+++ b/drivers/clocksource/timer-ti-dm.c
@@ -1475,7 +1475,8 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 
 	timer->pdev = pdev;
 
-	if (timer->capability & OMAP_TIMER_ALWON && !IS_ERR_OR_NULL(timer->fclk)) {
+	if (pdata->system_timer_capable &&
+	    timer->capability & OMAP_TIMER_ALWON && !IS_ERR_OR_NULL(timer->fclk)) {
 		if (!omap_dm_timer_sched_clock_counter) {
 			ret = omap_dm_timer_setup_clocksource(timer);
 			if (ret)
@@ -1585,6 +1586,7 @@ static const struct dmtimer_platform_data omap3plus_pdata = {
 
 static const struct dmtimer_platform_data am6_pdata = {
 	.timer_ops = &dmtimer_ops,
+	.system_timer_capable = true,
 };
 
 static const struct of_device_id omap_timer_match[] = {
diff --git a/include/linux/platform_data/dmtimer-omap.h b/include/linux/platform_data/dmtimer-omap.h
index 726d891438429..b78ee4676b98a 100644
--- a/include/linux/platform_data/dmtimer-omap.h
+++ b/include/linux/platform_data/dmtimer-omap.h
@@ -57,6 +57,8 @@ struct dmtimer_platform_data {
 	u32 timer_errata;
 	int (*get_context_loss_count)(struct device *);
 	const struct omap_dm_timer_ops *timer_ops;
+	/* always-on timers can be used for clocksource/clockevent */
+	bool system_timer_capable;
 };
 
 #endif /* __PLATFORM_DATA_DMTIMER_OMAP_H__ */
-- 
2.53.0



