Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055018;
	b=GoS8DhjklbFuGpD+h+dQpnwlDuTTvrpAmlRDnsoUD6Pb3E4oBakEz0pUh/sKKQkqo6Gc
	 KWZRfUrbmaW15WRO4c2hFNV9faz7OcFeOOeMbJZD0R8KEzSYNfVy0hwkkjNaYhousVlkG
	 +dwW+u8RYkKdo3/3sfcLhE+sQ/kjU+POb1i3F+GOnoGcKo85w7QBt7kJANyoYIX6LNRYf
	 nQUkaYRv1nhj7e3tNrevp04IlaEJOqm+oqdx9l2Or3lTtFE1pnp2AL4kvVyHq4VRJavVa
	 fESB8FjqIfOELoznLd8ieRZadylIYOTd72hO/gWifH9eniJSQdamxJTpLTHuY5Ha//g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGG4uuio27U8gjuAVkeeS0jnCL8Y+xN8U3F3QC6x1Ls=;
	b=dTT9975i63Krm5BXYpAgDkQLMwcGz1uTp18Hb6IrdpbzGHQnsFKO27TZnUYyjTEA5gPi
	 B/FlbiZG8uH4qzjc3a25LGsHANzaAQAuN38HcI2+czVXnN0jVcn49OCf25IkzEDDLN4A/
	 vivMIVSsOZwXvHseVYpfWFvbSAIXX0J62CVNXtbH65UDdV/V+9EVeSzoI/9XvY7NKaX1I
	 Mh6OU1v7vWcBRa4ydzNDjKfzD7KWh2fA7UvYID2BfwwOeJYEEHpuNGC0RBiiQ/pnzb9n7
	 LbkRLc2IYnPgo87dYlrcBZk0hdCrSEAY/fJ1bUZs1Zglpuo12oGPE1c1nBHAuAbaV9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isdPdZn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C27606A320;
	Thu, 19 Nov 2026 02:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isdPdZn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBF41F000C5;
	Thu, 19 Nov 2026 02:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055017;
	bh=rGG4uuio27U8gjuAVkeeS0jnCL8Y+xN8U3F3QC6x1Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isdPdZn82BHoaLPZyDOF1Tf5VVHEWIIhLo05zXI9uTHZ0Ag4bySdwDzqhcUrU/dZB
	 +UyWDzyHpCqRR/8RNzEe4TL+hLigb/QLjb2mdnZk25ucQ/HIhHknwAQH+rqCJaecmH
	 B0sRypQMD2U4HBGyQmkXd0Ttz+i+uNLN26kPeHbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1481/2214] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:52:37 +0100
Message-ID: <20261118150110.398199236@linuxfoundation.org>
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
index 956b42729c376..3188c55612ce7 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,7 +314,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



