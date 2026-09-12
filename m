Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423A2F7F17;
	Sat, 12 Sep 2026 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229351; cv=none; b=BY0ZniZ5p5O+vMq8TBt1q1QXJsJoM7l1DF1vnvT8p1UrpClzZ+dAbvI1eD2oaIHIxjrHOxDHJgqAfQyC4Chs0Txh9KPcWUSKI1ADbreVdEmxbDghQNUareBw8l1l5i3StV3ABhr4MtjcL/qZ8lJc+CIDyKIelBMfWw5IBOG2H+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229351; c=relaxed/simple;
	bh=JT+UtGIu/t4t6TkvkqjKIJDjiI9/Mru02THVRvk82qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvhlEoOLmcPxKAY6TiH+vNLoP+HXq0bBBhFgjS5xIbWfKKQmfcc7xCFHNDbaUcCYM+EIaLnqrM+5BN9TPrISmDtUYCxCyyRZFQKDhh9ozHEtWp9SIUEqB7KvEseVJtDHXWKwgAWOTpqr1p5IXz4+x1OCbos/cDiBi4T9upXf3mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNfPwNP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNfPwNP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD33C1F000FF;
	Sat, 12 Sep 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229349;
	bh=yXnDF7mGlkL4ElDpruQ6NW8kzk44p8ogJADzDSBDTrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNfPwNP8dnoAeJFQYMHut/vyUT/BvwCYaFmCLLij0By8JP7+yLIgdQpmggRAUJC//
	 +Uqv+lerSrs6DNmj4D8xmm3Pi9HTVYpkLsDYTvYJofuFCvXe3JvmskLXfemAdFgQul
	 matQxvlS0vpDOoKDs6tHea8mW9L4RYAImV1n7wpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0555/1191] thermal/drivers/rcar_gen3_thermal: Do not call set_trips() when resuming
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065600.709597090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 1c63f8cd018db726e6cddcbb5abd069fab0e9cea ]

There is no need to explicitly call set_trips() when resuming from
suspend. The thermal framework calls thermal_zone_device_update() that
restores the trip points.

Suggested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20230208190333.3159879-2-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: dd04ad1cdabc ("thermal/drivers/rcar: Fix error checking in probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_gen3_thermal.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/thermal/rcar_gen3_thermal.c b/drivers/thermal/rcar_gen3_thermal.c
index 4c1c6f89aa2fb..5a715a58f18b2 100644
--- a/drivers/thermal/rcar_gen3_thermal.c
+++ b/drivers/thermal/rcar_gen3_thermal.c
@@ -556,12 +556,8 @@ static int __maybe_unused rcar_gen3_thermal_resume(struct device *dev)
 
 	for (i = 0; i < priv->num_tscs; i++) {
 		struct rcar_gen3_thermal_tsc *tsc = priv->tscs[i];
-		struct thermal_zone_device *zone = tsc->zone;
 
 		priv->thermal_init(tsc);
-		if (zone->ops->set_trips)
-			rcar_gen3_thermal_set_trips(zone, zone->prev_low_trip,
-						    zone->prev_high_trip);
 	}
 
 	return 0;
-- 
2.53.0



