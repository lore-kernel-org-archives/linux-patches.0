Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023512;
	b=CePJ+7sJ6WdnPJ4kt2O/t/ZBDTd9qCUW3o1coovhrM0xFfRLLF43d6iTxTeMOnYU3gPK
	 f4EVQV3jVNy6j84qH3EogtNshZBayiCo2AbOks1NlKiMIg93g2ZBmT4CCGamhgyu0uAxT
	 jV7xzbyWEm0/HD7XJMSWw/DD0u9JoIhU4D1hq5S1aMj6PPOiN6i1xEVnUeDAnQlF2UPQ8
	 VppjfeJLsCqZ67pIhLn8tN6gWsl2yZVmyUbA/dZRmr2eiXVAa5Je5tfNRYvw71ZvJXbSF
	 kuVdrxoEsI8A0adDXVvMLkNWvpXY8or6TZ/K0dxStayNbn4KtuIDCcWVj5fY13taMZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3mhTAkGOsOhrP0KF0YGrxIfhFOQJ4Obdrra1LqKgffM=;
	b=fkRlBGdJhShqluqgB7dOn1QoVUyuweahB3MVC3AsSxbmcgPaOmbxF6//FhI2JFFAYRla
	 T1lB8z0P5kWk8w9vypBehN1Cvv5czHQ3P7jIzXA6Jcf8riJNi8Q8q40MX3zmnKAm49IeC
	 OE7vdj7Tc48uqgUOMBQy8fp5n3l7aT34vCyQ83CAegTgoiCoPj7qSDFQz8wjvZDzhx+Eh
	 b4JRqP0XUN5yJ6O2D0bx2ufhxUmMx5gG8Gt6ZqQsQcALUIIrfLMue+oJhww/uy/i4gHFz
	 xp9fgO6PnYGzkbAFHk4AtoBbT5huoSqA6od4MtGocb9CW6P0ZQUa+ckGT7VE/QFmqgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrnuESpz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A1606A31C;
	Wed, 18 Nov 2026 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrnuESpz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E71F000C7;
	Wed, 18 Nov 2026 17:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023512;
	bh=3mhTAkGOsOhrP0KF0YGrxIfhFOQJ4Obdrra1LqKgffM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrnuESpzNNmL4acRkwHA+1+zNC/rV+OspJE3Lp9a1OmUSq4bnYjXZK0BtAEh3QxZl
	 twH4CjmFYUCH0fGiRb2Mh3jAGd5P1RJTtoJWWChfyxDyXq91dzaCqNT+HSse7sxZbJ
	 rG2k8HFejjno4/cUzBdthQ8TZOSUq5TE+/0J7b9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0397/2151] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150136.528147527@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit d594187cafd5ad65afc5f00242f8fa20e1d8c0f1 ]

When idle state 0 is disabled and the PM QoS latency constraint is
zero (latency_req == 0), the first branch of the || in the early-return
condition of menu_select() is taken immediately, so state 0 is returned
regardless of its disable flag.

Address this by making the !disable check a prerequisite for the entire
early-return condition, so that when state 0 is disabled the normal
state selection loop is used instead, which already skips disabled
states.

Fixes: 53812cdc9100 ("cpuidle: menu: Move the latency_req == 0 special case check")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20260827094820.3900062-1-luoxueqin@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 899ff16ff1fe2..d50fb883f75ca 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -281,10 +281,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = BUCKETS - 1;
 	}
 
-	if (latency_req == 0 ||
-	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
-	      latency_req < drv->states[1].exit_latency_ns) &&
-	     !dev->states_usage[0].disable)) {
+	if (!dev->states_usage[0].disable &&
+	    (latency_req == 0 ||
+	     data->next_timer_ns < drv->states[1].target_residency_ns ||
+	     latency_req < drv->states[1].exit_latency_ns)) {
 		/*
 		 * In this case state[0] will be used no matter what, so return
 		 * it right away and keep the tick running if state[0] is a
-- 
2.53.0



