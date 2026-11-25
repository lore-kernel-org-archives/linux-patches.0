Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621751;
	b=fQQfWeULE+aQE4og4QP9ruU40WzFzOyymsSFmuMb9OlUSaakgHFpfeEnd6uHcHXUMJf5
	 jXrtm0/CylbcihAWjS5J+i+YqxE3TEq0QtkOECx+OuKNMw1BEQPD3tWKAf9J2m73Uj7XQ
	 tKTAsp8/V1qsRfO624/5WfKduN0mXkkJILJceEHuZG8omZWcdFMC3I/rTZCPS+OKDLwf3
	 tTYA1WqEFBtjG38BYMJ7zHyGDXTx57GD4kd58kp5mIGljovKrSTB62xfnWMlVXsS5MWpd
	 ufxK4jMSKce6gWpRMccNmF0dNZdY9vE5y41+5LZhjA0E4Eiyb9uYEEidOwjWq7+ReUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A931Av7NudmHTt82ux/u89qKW5KEr47XZ8PG6gSOHfw=;
	b=L70yWLJdthf5URyhP9AAzV8lgiDNqEo/k9633Wnvkg4VmZcn2euM9wVRYFgPUt4xPLix
	 z8KeeWLHrWTezsRyI8T1a+LzTfC3fFTH2jb0rz4sxRG6MLdPgeRLr7mqQOsRLwjT/sqtD
	 gZBAlM394P4R0gFvtqtCvlUNwt7GO821LXgp/gHS7393wZuPpnehC36CZdYhpXT0oFd4b
	 Iekr6I253rwfQuJfJ8uucKvOSahKH5M+VCBVt1uNU86GFVPIB4zyTk5Gfopl7YyUTSGiU
	 V6LoZwJ3h5WfHSmZcTp8OPLiN4kg54yUtWexwLofGfDo0JqdwFJgOE3+g6X0RSVpqDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKMArbX+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900F6606A334;
	Wed, 25 Nov 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKMArbX+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F5C1F000D3;
	Wed, 25 Nov 2026 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621750;
	bh=A931Av7NudmHTt82ux/u89qKW5KEr47XZ8PG6gSOHfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKMArbX+m25RqrXI9PFExw17FduGrdxjmSJkqTefypgj80Au98IuQuT0vQxcXrBBu
	 cvvA+qNPUUi3+lMN6qrGnc/GP1jxuXFMEXs55wNcxq+7X0SwpfXYRccLi7gfZbGCJ5
	 Sn4p6dVxD/oJQk+ZLzUUqWI8CW0QXVf1rneTFO0w=
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
Subject: [PATCH 6.18 325/990] cpufreq: Serialize global boost updates
Date: Wed, 25 Nov 2026 15:28:12 +0100
Message-ID: <20261125143829.700069758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index a48dd423b8f98..0df5dbe968ea9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2805,6 +2805,8 @@ int cpufreq_boost_set_sw(struct cpufreq_policy *policy, int state)
 }
 EXPORT_SYMBOL_GPL(cpufreq_boost_set_sw);
 
+static DEFINE_MUTEX(cpufreq_boost_mutex);
+
 static int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
@@ -2812,6 +2814,8 @@ static int cpufreq_boost_trigger_state(int state)
 	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&cpufreq_boost_mutex);
+
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
 	 * make sure all policies are in sync with global boost flag.
-- 
2.53.0



