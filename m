Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029475;
	b=0DUkYBlkQ9WNbhVJAyOMpyO/eOBBvg0FU4F7Vw7O2CIxUxVpblYVTC/sLnhx7fvFs/oV
	 hWx3YDJjlFgluqaR/GdROboIkmK6iv1afrHCxRAIxJO6O95XfBnKKKVlMU2F7OqvFrMA4
	 1F9AFnUIXoWywb4EAPYwtNxI2t2pBnw062r0Zq2FZNnvLo9YwAGt+emWtMfxTQizSjfum
	 KiMFE12nya3d6Qc7KSgXBT0MgPl+mFCIFiS0oG2Lii4mX+0AKRxiwYXJMNvFlamHT/2cm
	 z18nMeo5aBMH2wUcdI7CkfCfJjZsUOWrcdTRiLnLWr2fK3OEQKvbFGGjTo4Rpp2xfNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yd52TzCjZzUf4yA6HTw+6LIjLXj7x0ISvUlDi+/c10E=;
	b=t+JcWCRWlsVNAILq7HX3riUdZfFdBFTe3wsnpUI3Yf8hdX4lcPgpcu2NSJA/opZ2XfxY
	 zMzc7SI2kTYhOoX75obPI5kreGPPR24suO/m8F75mN8Ye0PY0aayuh8WGFTek1TCs63Px
	 xrFt+k3vgGnKEvLamo44jkHe826xEoKW54tn+q5LPmDSbIwRUKs5XefpriZ/g8D+O09an
	 wwJcg/y7ya1gpUPBzj9JnxsgfpKv3d6mkYztH74K7TM1xdOhHnMuARTqbEyecMOjvFLOg
	 3/zeyxrpxUkwhjlSuNEuz21VQ8uIrfENo1C+aWEdVJqqSW5zmqlxGhxInX2m8yvAc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbGRyphU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73760606A332;
	Wed, 18 Nov 2026 19:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbGRyphU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8043D1F000C4;
	Wed, 18 Nov 2026 19:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029475;
	bh=Yd52TzCjZzUf4yA6HTw+6LIjLXj7x0ISvUlDi+/c10E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbGRyphUyWqAWld47Ao4Qf2kPt1Ua6Bxc5RD/DivfC6iS9Z0HdHRfx2DNCPgc7aGI
	 dMX2RnFgz5WUOhD6whd0stEQPGPbroOUSW4u72QajFR+VCG/HB4SwoYy07Mzr+zWcm
	 VJxsvSjGoVvBH/7ImCk9pQyON6+2W28Dj8WPIMK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0361/1756] thermal: gov_power_allocator: Fix NULL pointer dereference in update_tz()
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118150022.694953327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit d3515092f1bff9cfb4d99ea82dcd4ac66f32f50d ]

power_allocator_update_tz() unconditionally derives the trip descriptor of
params->trip_max as below,
  const struct thermal_trip_desc *td = trip_to_trip_desc(params->trip_max);
and then walks td->thermal_instances. However, params->trip_max is allowed
to be NULL and in that case the list walk dereferences a bogus pointer
derived from NULL which oops the kernel.

get_governor_trips() picks trip_switch_on and trip_max out of the trip
table of the zone. When the zone has neither a passive nor an active trip
point, last_active is NULL and params->trip_max is left NULL. This is an
explicitly supported configuration, as documented in the function
get_governor_trips() as below,
  If there are no passive or active trip points, then the governor won't
  do anything. In fact, its throttle function won't be called at all.

Return early from power_allocator_update_tz() when params->trip_max is NULL
and only compute the trip descriptor after that check. There is nothing to
update in that case anyway, with no trip_max and there are no thermal
instances for the governor to account for, num_actors stays zero and
total_weight is irrelevant.

Fixes: 912e97c67cc3 ("thermal: gov_power_allocator: Move memory allocation out of throttle()")
Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260822114236.15998-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 90b4bfd9237bc..da7da3ab07558 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -655,10 +655,15 @@ static void power_allocator_update_tz(struct thermal_zone_device *tz,
 				      enum thermal_notify_event reason)
 {
 	struct power_allocator_params *params = tz->governor_data;
-	const struct thermal_trip_desc *td = trip_to_trip_desc(params->trip_max);
+	const struct thermal_trip_desc *td;
 	struct thermal_instance *instance;
 	int num_actors = 0;
 
+	if (!params->trip_max)
+		return;
+
+	td = trip_to_trip_desc(params->trip_max);
+
 	switch (reason) {
 	case THERMAL_TZ_BIND_CDEV:
 	case THERMAL_TZ_UNBIND_CDEV:
-- 
2.53.0



