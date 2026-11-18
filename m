Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029483;
	b=cxk+NSAi+4po4fHrdimIRkmh9IqQQJ0wC97HpL8+gGn+pEz0Fg1wo4bGrWolJLbvy65p
	 pUu0KAxPaFw2TSlclT4NB1vNZI5yrIlEUXBmfxNs3ggGEgSCdWjXfUqDw7W/xh+LGPaFL
	 0Y53SnexXwix8WnZDCnBMQugMq96nSj8QD1gC0ygQijtTeJ2m8JlRPHvBlarsmbg8Dv6o
	 Dak5DoxBzdfBa8Rucs7QV4VFg4vOXKg5Z2Y++Vq98E2CMUK8+cjB5bmH8PSg8WnoQiAtQ
	 ll0h5Jdh9jHYxMTzRczFLtn3VI1FpFYfJyeGYZBmx6X1bCDnQJqoH1ZmakYSRcumMHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdPzDLlER8EA5v8eeUEBahP/VWHNBMapo9tUeIY1COc=;
	b=oFRllcb2wbnmhZ9AwQnI6uXcj7TsAuJlFc+W1JzEI7yO7CxlyP4wX/GISwTo0y9nyZ5i
	 y3k1iKIH3GAR98RY/4Ps4MYclv33gmJwBSi5HOxfPLN28n4F9sVUUdzgQ4fhSBnQPrDQq
	 +Q+GpW+/e/a/NIeTd3NLrSqC3iA2hRp1OuDLEmVYJ3e/36sSk758wRKfEE8vCuePQDpto
	 VH7VPuwDDUH+SSz+HdWKw8DgCsr35Z4S0Q4YUUkaUKCP/xK7x3X7WM0DDyRvvLH9GAZUO
	 s5vV4Dlk660VsmriDs+bMNYwodWVHBquKZ6vXVH30HsEEI3t+lR5vtULbg+DTE+Zo3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqqmnNYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ADB606A31C;
	Wed, 18 Nov 2026 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqqmnNYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D74C1F000C4;
	Wed, 18 Nov 2026 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029483;
	bh=bdPzDLlER8EA5v8eeUEBahP/VWHNBMapo9tUeIY1COc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqqmnNYPiqq4uqQ7SderktNOqoDBKV+frVqFc6GEQ3xWRC59arcD58MU4SKxQaHkQ
	 RXrKgZZMtctkKwvIG1m/FRyqDMSfYUZE3MRGUoOhUolHKCveak4Rb/X7F5bUbZgZLB
	 mC611H532Xvd/SewgtYhLobH9jmYZqoVSa9yRoM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0364/1756] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150022.803676709@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit fcbd7897b871e157ee5c595e950c8466d86c0cd5 ]

The unlikely() annotation on the early-return condition in menu_select()
is incorrect on systems with only one idle state (e.g., ARM64 servers
with a single ACPI LPI state). Branch profiling shows 100% misprediction
on such systems since drv->state_count <= 1 is always true.

On platforms where only state0 is available, this path is the common
case, not an unlikely edge case. Remove the misleading annotation to
let the branch predictor learn the actual behavior.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260105-annotated_idle-v1-1-10ddf0771b58@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 0ce7323450011..88b87ad5557a7 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -287,7 +287,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = which_bucket(KTIME_MAX);
 	}
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



