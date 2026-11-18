Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018608;
	b=KJETp7r/Kx7mq+JYoOseooZlZeTVyWlIIoFWqw47T8PMjBBjFvflPwnHa5Q4w1Ri9Fvs
	 W+avIgCEXiIh5KQbh5hcBBaX+ZWOcNtoUPcBADibVX0C4hWjAm31jIwhaqyszaxOfgjxR
	 mLItrTcklwdo4Dsd+BppRXGbwRFWpnz5wGIMgw048FjIB5Xs74wr1BdhBNhBWGX8okp7q
	 vM17j55ZZw2hsqAjkKT5PTEBb9DDAY/x+1Tz6IOsIiIwg6BH9q2FXtNw90Pl8Ahs1aEr6
	 1wqf9Nq68zlKxUvYpSObLe+xEeYxPvx/JtuZ2+epdgxYosbZ9tCe1GEDLZoTnaOuk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBgj66CtkP3QdK2ly3+m+e3FkR2pF6ERfRx+yxbkw4k=;
	b=cxKbcUhT/qwCDElgdXppjnW808jIC91v8LOIwZoXn9NskJMNv2fBSbToE9xk4EkSsfEV
	 +nzNkc5/eHRUy3KpS+zyxWkOI+9x+2p56ajLjOC/1uzCfmpu7nZFHsp2glH3mj3ie3lfJ
	 SyaOldM0sG7HZEFwM4H1tD3SReR6woTYU1q+iIcKrLk1SmAoaGIc8Tw93hmrG8YvmPDRL
	 IimMebUrnQp0AUo1/DMouWkSHl/RUBPiH30oRN5DmtErinsRf1giaOCrOF2QQ40grXZNq
	 4iMQOW4uQvr0utdqMzqEZdZdmHsejVC/w7decg1DKVK+KWbNS5ZDjyuTJCuSr0F1VoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TM+TFkZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99966606A325;
	Wed, 18 Nov 2026 16:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TM+TFkZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FF11F000C8;
	Wed, 18 Nov 2026 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018608;
	bh=fBgj66CtkP3QdK2ly3+m+e3FkR2pF6ERfRx+yxbkw4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TM+TFkZCbC6qJ+njUq/VWHVzOwk6iCVZpp/66h8DgL+2MhZYXks9msh+iLz0VaDyb
	 xXwgzA6Jhy8GcbDwu3CYCSL9aUEu2jss2yQv3Zr3p6BnvvvzhOycSMDZu2YA+nF1i9
	 os8WmqU1+5mWVkiu8lQq80S+Xm7MPhFywJeBVLZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1299/2651] cpufreq: sti: avoid NULL dereference in dev_err()
Date: Wed, 18 Nov 2026 15:42:19 +0100
Message-ID: <20261118150334.731456217@linuxfoundation.org>
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

[ Upstream commit fdbe4cae71c8196cd7681ad47254b5b0560d3c1e ]

ddata.cpu is NULL-checked, then immediately passed to dev_err().
Replace with pr_err() to avoid dereferencing NULL.

Fixes: ab0ea257fc58 ("cpufreq: st: Provide runtime initialised driver for ST's platforms")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index b15b3142b5fec..144ac0f1d85d7 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -263,7 +263,7 @@ static int __init sti_cpufreq_init(void)
 
 	ddata.cpu = get_cpu_device(0);
 	if (!ddata.cpu) {
-		dev_err(ddata.cpu, "Failed to get device for CPU0\n");
+		pr_err("Failed to get device for CPU0\n");
 		goto skip_voltage_scaling;
 	}
 
@@ -281,7 +281,7 @@ static int __init sti_cpufreq_init(void)
 		goto register_cpufreq_dt;
 
 skip_voltage_scaling:
-	dev_err(ddata.cpu, "Not doing voltage scaling\n");
+	pr_err("Not doing voltage scaling\n");
 
 register_cpufreq_dt:
 	platform_device_register_simple("cpufreq-dt", -1, NULL, 0);
-- 
2.53.0



