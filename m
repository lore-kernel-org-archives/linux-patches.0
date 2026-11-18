Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060553;
	b=vTULVacqd/XtOkrokmZtWw8vGE0Kjvnuy1Bj6ZMG/0otxG2+DlA43s0cY8rg5iBYSg3g
	 XqRY2BPNJVueVRUbWxcZakYAsXEqg7i+l/8F7lYNZ4+YRDtwqeZhx2KRksMAG7PVxD3n6
	 B3upIhDD8YnG5GTIb+LdMt/Ho6gXEJw0WP3HUuwnrT3LePv9It49NWI7rawx725+pQQGa
	 ZyUuOnxYMqrSfKlbyRrU7txOMfzG43f3NR36GOsJng1vEzHxUxiC0nfors3+8IcoET29z
	 KzlESBtnKx5RNwyvQ2yCSHy5Q14fOXbMYPAlcnz42M49igMEMlpEBv39tPIPE9UxWfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/MJjXSaXYG0BJtBEEhgdPwLyl3zfIUGNL3WqVKwot3M=;
	b=De2jH7+qU834k6Kgp2vNikPjOZyBTUlj0wNSK0Ha90OasL0iZIDPspsactwaWMFP8mgq
	 HEWFVhkVCYKpxpSLSluplQr9S6x+X/K+X2BnwKxTP97ljGR+FfGbHGQEE+7bRXj8PZYAN
	 qGWJN/15LAvJ9Mu3KGQYwjmMbWE+vJ62iaM7q6vWol+58eZ1O2qKH9gT4Uv+ULON+mO5C
	 uygPVZM/xmTXU3qseI0phQK/Rjs9DbBx++74AvbPQj3nQXfJoFeCpxNaOU1F19g0oCf9q
	 28UN9Dh8J2npWI9RyMjHhvYPvKNknHJutUc95MKMQu/EL0xZypIMvIWwm+PAQsFdiqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C1/Jf5dM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991F4606A320;
	Thu, 19 Nov 2026 03:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1/Jf5dM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BEC1F000C5;
	Thu, 19 Nov 2026 03:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060553;
	bh=/MJjXSaXYG0BJtBEEhgdPwLyl3zfIUGNL3WqVKwot3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1/Jf5dMf6iIgWCJigrYUhKHmtCzrpkhq+7zeGIeoeBKvTRlXwOy8j7tAhxlk8znK
	 xBjLPqzR9Gkp8q8ATTapciKp4TmcbjjmxkM+uh0JYoBVyIkOuj4jMwA0VJq208GUpf
	 lPkZaeHkv35FPv0KTwEC8DBRI10CkKXb2nXEWkhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1238/1848] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150011.678570745@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 08052c75a7dfa..c95c59c52d80c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -309,10 +309,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
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



