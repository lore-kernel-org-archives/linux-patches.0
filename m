Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055023;
	b=Hwpyq3azTdZHonzfa+urw9JFTCfe2Kq7i+rpTR8hJcO9I3/v/VjqBb3RNxGorXqOUZiU
	 SsGyRT7VxJ/CG6Wo64Ee9C7glGT/MrBHkM8f6gKNmgeoNTVj05fF+WYhNLoXbolN2IakF
	 Uw6SbfqV+5bUlJneGQiWlbFVZSF4MW9KxrZ9dJsT6tj5ETIAAPkLIbQXOmfEngaMJd8WF
	 dWEQuXA2FGcigxJQIFMWXaOuiLXaZCOzsIAJG8yCrIYISv7vdXlks8f/62UhHEYHnSTYQ
	 jFo46HsoQ8yuJo30ldTG9nYykv1ypPzLPG42ULIfLYvRBRyfooej4ord3/vXfe4FAoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+nBfcQ9YkZjmilvHdHlZmNuJC9RnnAOY1BSsfMyLQfM=;
	b=CF8cIaDo+HGUsc5moqm7lttN9IkilEI6TNuc+lUMMhs8/QN0J9ljTORR0KhQy4X0Bb5T
	 JHnz7cVvXnCZl4F0ds3Jpu+LT/5qCOD2Yze17lDuxQZyb+jP3wqSQLhFbMHAK/9TVqYUV
	 MrsUMGypjUU+K+iaMHVzuk83cU49aKRWWIycw0OgMVO1vYyIuj/t1J8etdqKE2juUHJaJ
	 fduvwUK0o5/t3HTh+ZbHme3uRgQAyk/hHETooS0ROv9z2T27DJP6sEYfNf/nhMNwM2RoY
	 wKwvLwQyvTChhrpMBTqC63feghJ/uOlBu0d8IdBq1EVsxANc6rx1RnJ0h1PRH1/ckpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmYFQXnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B84C606A320;
	Thu, 19 Nov 2026 02:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XmYFQXnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22DF1F000C4;
	Thu, 19 Nov 2026 02:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055023;
	bh=+nBfcQ9YkZjmilvHdHlZmNuJC9RnnAOY1BSsfMyLQfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmYFQXnNzi8U3yds66I1vDnzJS86JG8bayuzdZzvlNlZ/1sXd3avyFJ0vmkQKGtA/
	 XECxy/BLUbGZTAzF3D2yaxWgFYWvDcdNmeb6FAJOEeyhYXHn7EgHCScxXxFTwuibQO
	 STkx2yQtEAcFUe0ylxs9I5uk1ae5G54DEhARjBsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1483/2214] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150110.473896015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c764e9f8d1bc2..e20b27e4f1398 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,10 +314,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



