Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624669;
	b=zpv/9wvN8gkoUkGzWVTrC5mDHAqZ/DtGHqikt11/Bk8A+uu1DnXsJ9BSfk9YzQRT6ODE
	 /6C4T3+V4qkGD6eMpv+/ehJo9lsrtRLA1a9mK8nL3soFyuLeq/+0ebtvry4e0tLryvOcY
	 bmXycMJ/Q0cu8PAchjTQ+LjA/O4DuXDizA+A5+X/NEpyZXi4wU7mItCbAJnpDFsvDsZ5T
	 DeVni4sxQ11ey87DGqaBDxp/fqnaeJtqCaDjBqpMiXeBadVRGtBJCYZnPFUinILubG6jn
	 4HJrcmT7XH3J0iKBPxQE2IpqejFZDi7LCJ1fo08KzP1V3GVr4PT1Ukgd5lFCe3pMw+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDpgCJ8MTyd//t0qYsO4tai+mmafSwOTkh2wg9oNUd0=;
	b=5Sv5S4hmyGfzhh2YyhPu9FxBvoxw+QTZDvELeb59PasEhh+KpDFMfoN4EEO1BhuL4MY6
	 siU2zpDE6AAPtkrWTrgQyWRguDzZlhu0eX2HHlyYgzB2fQLR1ZzbCrmhASMqtBHemUqgY
	 S2GmEqwPBDxI776jixcZzbd2QoAwLYKG/6uWBT5zuqspeQe6vpyDwNvabCgezt6i6WaSI
	 hRZpW/3UFPcEYHwvdZhNptfZfuHurRCWy2zzkGueqbqjrt/FoDg5ZCIEHzd6Dm08DoNMx
	 tJaT2M5rDkixGB2W1t/2PPPB6b/yYDS+XOkkneS5AvcizmXwT1Z+iQ5C0nPdJscleYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAUOsA7d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967F8606A337;
	Wed, 25 Nov 2026 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAUOsA7d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D2C1F000C0;
	Wed, 25 Nov 2026 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624669;
	bh=FDpgCJ8MTyd//t0qYsO4tai+mmafSwOTkh2wg9oNUd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAUOsA7dpdiJfK6X0IB16+mw5aSkgNOD9uFkhdILKutgFC+kYOkzj1wlnLHAsghOs
	 1UFUwPlpFTT+SSV1xJCYAp6IHU2kc1U/XM4Eb9qpgiPDynKbCaRZJq3zzp0S338Ssi
	 1nOqZuKqJ4Aj9C0Lm+I2+4pfp7nLgd+UWNZK+Aoo=
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
Subject: [PATCH 6.12 266/816] cpufreq: Serialize global boost updates
Date: Wed, 25 Nov 2026 15:30:14 +0100
Message-ID: <20261125143855.367153499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 3d5720dff09f3b90d9ab2a6707e4bb8d69542f4a ]

Concurrent global boost sysfs writes can interleave their global flag
and per-policy updates. An enabling write can set the global flag, then
a disabling write can clear it and finish before the enabling write
updates the policies. Both writes succeed, leaving boost enabled on
the policies while the global flag is disabled.

Serialize the complete global boost update, including rollback on
failure, with a mutex.

Fixes: 6f19efc0a1ca ("cpufreq: Add boost frequency support in core")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c4672b95e32e1..fb04ab5379062 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2819,12 +2819,16 @@ static int cpufreq_boost_set_sw(struct cpufreq_policy *policy, int state)
 	return 0;
 }
 
+static DEFINE_MUTEX(cpufreq_boost_mutex);
+
 static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
 	int ret = 0;
 
+	guard(mutex)(&cpufreq_boost_mutex);
+
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
 	 * make sure all policies are in sync with global boost flag.
-- 
2.53.0



