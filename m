Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023510;
	b=wtDiW8tfS8Y/KjnsG5gPX+112r0cZ1PuQlGVKuKd4sJRue7UMeyqyOruiXUmOANlKj5I
	 AA/692Od8weZHDFslEyoORxsyfUhnwIK5nLyNyZZhTbEcbJ8I33jL0u/vWaOEU5CnOHSh
	 +T/R2ehWkS/0T/xzSEc9wot2C1GFdf5SCi6qRk0gDGy6O7aAap9Ae6f/G2LUrMZeWMg34
	 8znjQzFeFPgvU5rS02SwzVfPjps6qspPcZJVBOjzsUP196OFGfT2t/WAEt5wqImHsWoRv
	 YvHAbGAXpQnQCGITwDbFELU10AIFMyCIqLCy96VAkqQX8KcuwNLErbVfp8B9J1IauvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ezrlotu7AZxr4kv6LDGRDJD6KRXp0G9/tee/eiubiJA=;
	b=qRyvxlRbzK4gQebQQlR9Ib6a7+RH71cshAvPeTpo880n+3dHcwVZyi6smBR/R9xogbCz
	 nlot2zag3P+fra5wMtR/fr2kd113kNPpPHApMKH0YwfdQc4WAk2gNV3z8amC0ig4lS5KZ
	 jxGr7wH6ifCJTRrfNfj4lsZYsh3BOdft7Rp+JLNA3IVY5sr5csGLW5QlnSAlU+e9ijK6a
	 bAR/yY7bVhSEOVQH9G7ktWl6EQAXN/eAmpU1rQBDroMzOq7Vs8tO3+gk6/47ctc3uYTkO
	 XB3YRwo1EBbKDI+eUET3Bfzg9P3N7YB5qZW3ixjrAmFIvsmiI0LTLTJlx+AmptKIvxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4NF4jsr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E4606A330;
	Wed, 18 Nov 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4NF4jsr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3372C1F000C4;
	Wed, 18 Nov 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023509;
	bh=Ezrlotu7AZxr4kv6LDGRDJD6KRXp0G9/tee/eiubiJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4NF4jsr1hee7ESU9dTzj92LvUUZ0GHy2XZujRSeG0a+sKv5BjR2jK/aCslQ/CPwo
	 nfpQhGD9iJHz7l8sTFhpb7IkiBtWwSkdBgo6TSPcF6aj/icEEMg5wlhtp9eFNrICJl
	 dPK0IpGffhJxA0sFB6wvbEJKPZKBxy/+M/3csEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0396/2151] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:35:31 +0100
Message-ID: <20261118150136.490531855@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 93983a9f3beea791c21d77c2425488ad327d4fda ]

cpuidle systems where the governor has no choice because there's only
a single idle state are now handled by cpuidle core and bypass the
governor, so remove the related handling.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
[ rjw: Rebase on top of the cpuidle changes merged recently ]
Link: https://patch.msgid.link/20260216185005.1131593-5-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index c6052055ba0f9..899ff16ff1fe2 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -281,7 +281,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = BUCKETS - 1;
 	}
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



