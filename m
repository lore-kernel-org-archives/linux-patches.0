Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062996;
	b=cCwNJXf0VttWiQ270VtdXXMS1Kq0Kin8fw6RkZBVNwOVbcxDae9gqmLKegdob0aTpKIr
	 dHVJmyHhG4lrVAw4y+OSk/ge5076Ji7KaApQxgdkjkAL2NaGKTssYzDH7GIbL7oaqiTtW
	 mNgezqWLRxQl10yIe6qvTaQRC7AJi2x/Gare12MTmPznkl3tGE/Q3wFUepu3WxcieFbHJ
	 MgPBVEYu4IK+S6+rPlCKASD8uuTGEzITpg/2XE7/PO6EYxvFgSr36bIX6WCuijtDBcQ9z
	 /DaHX6Av79QIIS4CXXsi39R6tiIHkUUIgBNOSlLozxpDtdOmsHkg0AadzAEG2WVR/Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i5VUmFiQkH5gtFOzAsGsuvQ1+tlsQhdVl6jkwXXxYo4=;
	b=XISaUxPVyFV4xCVbGWatPnQOfYfBm63wqJuRv4OFq7bYXFO/p0CUFGTsLzZIeLhbaWsQ
	 SWjM1ciHM6+gvIqbkqqrA9v/Kvc8BYzO/Re4lSxdHeA3XvJo7oyueXkLgMpSk2dJS2N8A
	 Y40YI7dJ4joTTFFHmmwsrO1laI/zwvw4d4zPjAOQje3Ma7gPFpWBQH4iXoHEZOlz82wKo
	 xq0gd9aelXALwxoDvlVKLYSCQE94/2zupcSBJzH2x7J7ZES2uDEFFCNSPR4A8iAduuj3V
	 k/yY0it2RoKQpOzaq4lQ5Fr+uZghaPOJHLWqYiABTEEqrqzFZsp8AVmqG8ZZ+E/aA1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCucEXe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEF6606A33B;
	Sat,  7 Nov 2026 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCucEXe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B227E1F0089F;
	Sat,  7 Nov 2026 14:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062996;
	bh=i5VUmFiQkH5gtFOzAsGsuvQ1+tlsQhdVl6jkwXXxYo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCucEXe9PoNIsv6qk24bPcbyOQW6Y/CvUZI6OtKtoHj/WhLls1mLp5RO+24i0WBBt
	 ZsiQOEcFAoT8Gz2rtICZzfE1Jr+7uVeuSaIDbAn8C+JD+tuiMHeEA1fgfta5PYwukZ
	 leLS4OUvS+TFy2VhxDunKXY+pygclS+/RCZuKkhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/869] hwmon: (coretemp) Refresh the temperature on the first read
Date: Sat,  7 Nov 2026 08:48:54 -0500
Message-ID: <20261107134900.342814414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit e463cd582ca125e359ad1a66cb076434c14638b2 ]

show_temp() reads the status MSR only when the cached temperature is
older than one second. Commit 5c0e64dde80f ("hwmon: (coretemp) Remove
obsolete temp_data->valid") dropped the tdata->valid check that used to
force the very first read, leaving that comparison as the only trigger.

A never-updated temp_data carries a zero timestamp, which does not look
stale on 32-bit kernels: jiffies starts 300 seconds short of wrapping,
so the comparison stays false until jiffies wraps and passes HZ. For the
first 301 seconds of uptime temp%d_input reports the zero left by the
allocator rather than the CPU temperature. 64-bit kernels are
unaffected: jiffies starts at a positive value there and does not wrap.

Backdate the timestamp when the temperature data is allocated. One jiffy
older than the caching interval is stale under either word size, and the
first refresh overwrites it.

Fixes: 5c0e64dde80f ("hwmon: (coretemp) Remove obsolete temp_data->valid")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260924-coretemp-temp-fault-v1-1-1884f0ff97d5@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index a84a32ada8bd5..e8697d6b9998a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -511,6 +511,11 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
 	tdata->cpu = cpu;
 	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
+	/*
+	 * A zero timestamp does not look stale on 32-bit, where jiffies
+	 * starts just short of wrapping. Backdate it instead.
+	 */
+	tdata->last_updated = jiffies - HZ - 1;
 	mutex_init(&tdata->update_lock);
 	return tdata;
 }
-- 
2.53.0



