Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016092;
	b=cjp/fKxvn+07RBqqpNOcM+FOlX4ETvx9ZLZE0iIIA/f7wxk8zPX57JXjLQuCiIEfHAeb
	 m7kPsuvzlvia4DVmN0NQ7Fkx7Px4NGVkalV2u52otk83G/JjInqZm8b9wRPGnecMCWT/P
	 emZgWNNdaLuFjemhML7S7Y7haEzQn4Tuh6LqnDhJzW1WZ84ZIuk0usrFt1a04/ylkSmH9
	 XlYRi2R8qHxsDY+Zwtd6emB5z4FdrzkC/RIQxYPvyheY7bsSHLt/VmmpXXEfPFMeXDqL3
	 4TcVIu0IJtvyowmny2VHDdJbn/eXp2EAwlmZaim+cQXe5VojWZX2eSgOJJcL1yRGQhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBOayPBXNvC7IbyhmEROMCEmxwgieaQY8ypI70DUr0Q=;
	b=Thu8Tu3rwXiLskhE3+z+unhpovUGbd0Qhg938hdwW2zBzMKqML1V5CaoP4OY6GRAbaYw
	 fnPqR6yshuq/0/O/7kEfOlZ2xvSFjJoKUfIYO9fbjbIyh3HtI5fubBj6Vc/rHZN0frVz6
	 iTkH7MrB9GeyDBhTJF1anpe1CmtB81/iqOPrUxNZO7rizuoifsMLFrkZ0xMY0zrIo1Fy+
	 /P0WwS2Ry/IyenBwBxwu3xVEo0W9Sy3VLHKcF7LQPimrbkZn0zIbgoAx/P5pJi4OlcoFP
	 gDa2BuftemPNFaZ4V2mjA7Lp16m4JEdfL1Sty8PzV1By/ubvbZ4UShRc85GwWizui8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnFctEhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5CF606A325;
	Wed, 18 Nov 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnFctEhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1780C1F000C5;
	Wed, 18 Nov 2026 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016092;
	bh=iBOayPBXNvC7IbyhmEROMCEmxwgieaQY8ypI70DUr0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnFctEhWNABG7wElrnNzazDOFjxEnJBnptXe6vr3Pa4KehF1CKcNCOJa32/j5fQ0x
	 1RSVc/oCiRfvL4LB5o8Nq+P85UL9XurQpOqtYfiS3rtK7eGpMJnrzaf2jvdEpW5gnA
	 OJNmbBuK+xzItU4z7CcP8KvP95ZePcdvyNEIxkeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0406/2651] thermal: gov_power_allocator: Fix NULL pointer dereference in update_tz()
Date: Wed, 18 Nov 2026 15:27:26 +0100
Message-ID: <20261118150302.447953002@linuxfoundation.org>
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
index 37f2e22a999e6..b5c254187628b 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -660,10 +660,15 @@ static void power_allocator_update_tz(struct thermal_zone_device *tz,
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



