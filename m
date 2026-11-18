Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016101;
	b=14hoifHOwDOAkqrF0kArKN4zhpwg3ZDZX6+5IByVdYlEvfQfNVngImY8y10QLXV3PPpu
	 oXvcQXKnfASBQL7RcgOE9oBXtx+f5Bg6oN6K/SCY7P9HQskJbcKd5CmgVdAPWtYZ1TtPU
	 ccq/PqwC+RFlNpNVogITuwQC49GOwL/9uNFgWMC/ZEe+zueY30HtDFfZ8FJbfrJ/DjwLS
	 /TXaUgf8lKyyzNuJWJVsxQkb+5qIae0S/TskH79CfkXXjQdfCCWAosJiC/I0sto1UqjM+
	 dNkJE7eE3nBydqN+kF23/0t4RBjWZS+LK+aMePzMGSbh41dZ18UV/FXlCScKskAQEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PfI2YMhGy/VQnlJ8DtqruiZ/jrm3WK8gWXp+TgARKQs=;
	b=Udy/8cwZ73dDSzhUIYEgV92rj/M0y5AzBrg8l9ZOOMs9+4wXEZxrj3s1tFONh3CCKCg4
	 +WJlmO7MgHWmtX8MzmjwShoc2glgVAX1KTdDLDKzJMb8Sv9Vxnvi8XVJDr/liQttNdUQF
	 iMdkq8gY8yMzOfPoEQjt4sRGSg2TgdrVMoB52rlSsOzZcEQEL26nC8x8T1nu0ntYX49Pr
	 Hlp37NWWgs6wLcqF05/DwDPhgLMy8p24JSezPoFH45aw7VNDfhbd0z9RrHnDC5cLjK+IC
	 ztDG6Jaj93Vew0fIAUnPQ58dYwpksjujY5gvmcuu4tUT7VIFhMvYjF8u65aj1LprM0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+Bog6ik;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A75606A31C;
	Wed, 18 Nov 2026 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+Bog6ik
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F501F000C5;
	Wed, 18 Nov 2026 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016100;
	bh=PfI2YMhGy/VQnlJ8DtqruiZ/jrm3WK8gWXp+TgARKQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+Bog6ikLvXrxExg6kpJ3UcWq/cdrSnMueqtYpG2oEloMYlASJLbc1Bah5YmXyzau
	 YzyUm2dYNoXc8ZNoWVmjnrftZj5CwNHF/xi0AxgL6E+pIYAT0nMpb4+lFXbJ9JIe6P
	 yckdMIz+K5WrUWnTqnFySQNmzZLnCTVKINBQbP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0409/2651] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:27:29 +0100
Message-ID: <20261118150302.558629332@linuxfoundation.org>
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
index 544a5d5930077..eb529d73d4b75 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -284,10 +284,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



