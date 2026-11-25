Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618745;
	b=IK6sWCwyKO8sAILhBaZOsLXGA4cfHSmBAzWjTbcjc3tgSpBKoUJ/bDE6xOVaGhFoCXJ2
	 3MIIsPG0SEM4wXD8LHgQeMSTPlyZpaldZ6lM11Kbz59lKp8LmSCvt9FN7aJoK0Ojb/72q
	 e60Kmptav25/P7/aCq+4BN8HR+AqGfnAFgxDBk5ixFMabEJ6LZQEAG0FOX+kY8JGMJuox
	 JlIomE0+cLxguJr87+OUmxI9quvn5nZXmU8j8s48SN8mZDCuTbtK9AAET6RyZgkV+XUy1
	 LMkOtc7BUaX5jdOhkAueso36KOyV4p8hX9qFXtYDzI3V/bBU5iAsvvgoZH0umhCMT4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+h3O1Ku2cqEWVwvhA+9gzcy7FHenvu3RIGZBXRfUh8=;
	b=BzsMvqF+jNsp2fVsPvhx8HWGt5etSte4ufWgyfL8niFjD+xIdvxgRMZIjNkHVYqFUlhd
	 lrFWicM5OugE4lcuSY81pPg5tlVeotR8fElCzk2cPLZ0jrJ3DFfeZxdqmNqE1DzsiIIzy
	 peVg7OvchxswSaCuJd/CxU1RWK4i6jS2kG73YE3RLJYjBd+AYya269PERNNJ5zRaLu76o
	 lDATm0QSNlBSjB6t0/8ZJCxyFaErMY6YHWHWG4iGlCSUEHDJKFOfx5QGrbKSZt8s4w74D
	 +wH830RUyUDa07tBTzmObTfGJPVjVorwVLe2y0Yysbsy9LOeiD780i7wh/K4tRxGSAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQaKFlNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDBD606A31E;
	Wed, 25 Nov 2026 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQaKFlNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507201F000C4;
	Wed, 25 Nov 2026 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618744;
	bh=F+h3O1Ku2cqEWVwvhA+9gzcy7FHenvu3RIGZBXRfUh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQaKFlNN+/mWN27+FJ89kACypcg/6TS55tpJ25i54bYqxmReHwfdo19b3yrioYMCx
	 gsi/MAx8OCENJXU72eCiqwcrqmkXDDRJU7zRYyULZlhmYd1pZ0RcN4rg+NNsu3SPy0
	 XTW1O88a2DhUrx71QlZ4ApWh86HGu9tXTqVTnQQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0359/1005] cpufreq: Preserve global boost state on failed updates
Date: Wed, 25 Nov 2026 15:28:17 +0100
Message-ID: <20261125143830.144026732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit a0cde2b601bc32b76d61e50141c619790e5e2e41 ]

cpufreq_boost_trigger_state() restores the opposite of the requested
state when updating policy boost state fails. For example, a failed
write of 0 when global boost is already disabled enables the global
flag without enabling any policies.

Save the original global boost state and restore it on failure.

Fixes: 121baab7b88e ("cpufreq: Force sync policy boost with global boost on sysfs update")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 015962e6c1fe4..4bf7738a81b0f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2818,6 +2818,7 @@ static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
 	/*
@@ -2826,6 +2827,7 @@ static int cpufreq_boost_trigger_state(int state)
 	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	boost_enabled = cpufreq_driver->boost_enabled;
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -2847,7 +2849,7 @@ static int cpufreq_boost_trigger_state(int state)
 		return 0;
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	cpufreq_driver->boost_enabled = !state;
+	cpufreq_driver->boost_enabled = boost_enabled;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	pr_err("%s: Cannot %s BOOST\n",
-- 
2.53.0



