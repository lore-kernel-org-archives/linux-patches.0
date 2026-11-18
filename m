Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060551;
	b=ASB20LIqvCrMQ6q5i1j68T6J334gR/Fvu2ZukakWJXOoKtWgi8ESY9MX7J8CyCFkZGIo
	 RrzuD0gGRvnoxlDE6shcfY0J6GxQnqilSNi8FoDxkVA4xcOCDi+qBD9csTnbc62ySoC0X
	 FnDZo7sigHYRZouiLQEXHdcLOVrXEEIP9eTQRORs2gCfzFyN9yWI/tzDq5vM7oqPYcd2K
	 yQWPwnw+9ihefbpmkvhNT/TTiw8qEDsysPNjPgvELLbgdynMVSAgYuZ/d3k2nWLe54D8O
	 HrqsUTb1BjiD4jRRMTTaqnZy888qY8rAtPETJxW/Zx+VkHxkvJv6axFHpAT2dHtCEKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=egHAbLIR12GAKiI33Ww/XfBDi/EoAHpZ6L+yiYS1MHk=;
	b=oPxYneVUooqqkuhJ1uS3Z6Ds8jnrN3r9mvN3JoVC1VGXmhxIj6Jq0g/SYGrEut+4S9RC
	 eaYp32JEWQif0TRedoUf9cqQ3RVRIcRMQ1jGlTWiv1mbnZpsVeemwoBDEfXkTzAihWpvr
	 M5tCBSHtPtyQNZCBZO1ZeClvsiTCOMJJkI9jL43LNO1SzpqPUP/yv6waQlshmfcsdXG35
	 hpJQ70kutnp4fevwNae+iUT5uY57ff0ezKSZhudpEw8xffl1K2PxNyJ1PwfbcscrIm0PP
	 gHIvzlFTYbP+15EHGCJCYjB0AiMghcAlY4cLArM5i627lCrmArsm+48RhsKZvcFX6cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMhV3GCP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF1606A325;
	Thu, 19 Nov 2026 03:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMhV3GCP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE61F000C4;
	Thu, 19 Nov 2026 03:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060550;
	bh=egHAbLIR12GAKiI33Ww/XfBDi/EoAHpZ6L+yiYS1MHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMhV3GCPE1Iz8d6sfGZJNV3QVToCaJ2LYs99+411C2lTPHT4TivBBZyZ17U8xVyeV
	 V1kavq/YmY3Sb172xV0jyviqlU0LJ7zeKdD/XzNncbVx+I++CZXvNvNGvXUmhlNX8m
	 P26DIC2RFjJoNhLJM+V3MDzo/9QPaKf0lWb54zEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1237/1848] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150011.643677812@linuxfoundation.org>
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
index f9b201f3cc3e2..08052c75a7dfa 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -309,7 +309,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



