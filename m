Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023498;
	b=kNDRxKbuQq3wD9C4N2KnrJdLER/TBa2KFjBNDB0QlvAmsVA/SXgAs5AveUS899MinCyL
	 N84RjRjrmRL0HfT7IEsWAM+7eZ3QHFWc8o0DSKiTdQ9ng7avTuBzNs8zm4ESmzJvLW/yN
	 X0Ae4MmhjBImuDBMtM0j0xdFMWlEJI0OtgdDvstyVIRzjGyFrwjrl1SWLGKSaRl0+3ZwK
	 P6owWfUNXMUyhmCSBtH8uFTyNZtdib+qoEljWTnAa2RrWInNZFtxBpSwoS5rYDyBk+KO5
	 IwI4/Kc++IbAHEEdEBqyEt6E543lpolNf1ad4IqK5fJ+HoHg5LA4yiWOy9E6KhOwNOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OqI2lCktrEoAQCCzdbYFoTWQirdBHx6Vlkck4639758=;
	b=D0oyRvZl8KHL5NmlR45bqODGEiALHaTsflJh6Y4IkDZEYChnXS0KOWJtUYXIGUvDeYcj
	 9+v5FbBjwjwqvWBaVBHXRBVbsHxgQ++q0qU/g813DDAONCGAUtrnD8SMVrNXFfWNb3irG
	 R6/tQLQHSLt1m6ZNgNLFP7y2+zgVv/PjuK+LwZ261rpUvqmKTxg065m45MbuFNcab1C7c
	 GQg/dvloImx5e4dMLtMf6nEoHpRRep6ACalxomPLxsRgI2S5nkI2Uo+GO+474/q9IOO0P
	 f9/ldRMX61z1ecLTBLuFXUuaLUKzuycRI7zU8HjLS6bLP+3/C2met2zmiUrehi+wwPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CtmJmfKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FEF606A333;
	Wed, 18 Nov 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CtmJmfKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D301F000C4;
	Wed, 18 Nov 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023498;
	bh=OqI2lCktrEoAQCCzdbYFoTWQirdBHx6Vlkck4639758=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtmJmfKDB8856ouluvsRqk3au3PzZ3uJEWshff1dziaXtWlhZ8w5cjK/mGlWRsvQ1
	 u+5LgrlZs0EMu9Nng5309+wHcaXiNJLLj7liKvchX10rFewvgE7i9l38Tpd9mE8zw9
	 QXeOxC88+1Aw286Ifz2sBmRp2m7hzV7nK0cnQr7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0392/2151] thermal: gov_power_allocator: Fix NULL pointer dereference in update_tz()
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118150136.347809847@linuxfoundation.org>
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
index 0d9f636c80f4d..215c0cbd011b5 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -661,10 +661,15 @@ static void power_allocator_update_tz(struct thermal_zone_device *tz,
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



