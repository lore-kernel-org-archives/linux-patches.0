Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038956;
	b=GWujr/NLGjvJcsBlUU7Rbj5jBpRMRaHBVoCh6P1lcNEA69QcTeA9Li9W0/AdoQfZrgqL
	 XjZWGp6KKFOj0+0HxG+WtSbR1ciL8rm2bCDY7CJ+U470asjnIYJwBY73wdVc9PviALWyf
	 3xGWxS1eIugrVwPaAlExW8ipm/GvNirelseE8SMTqwV0DP2U5cL9M9OyO/RTQHkqEwNyo
	 THW4292MD1Qk8W7BYJyMPNvVFTDw2r/IiUbDQfgcYdh/tZlTxtndjF+AlVpGgsfOTiFkS
	 Ygf6k0aZ57wTYyCVYjZcPfO+4bteiZrSgV91GleBsLaeVPHqzchJt/UtG4Gs40rx2QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m1D/dpNgSFH4NEfgOubNQB7FeFB2SthOOEYlh5RsOIs=;
	b=nHsvP6Kf2i/DIJlicLN1eRhyswRxbuJyuPsfB89BFFagAp2AEhRMr1Z7oae+dAe3R2dQ
	 yPQ6+7HC7mUHXrV8KGp182hQlgheq3kwrATH5Dchrtfk16Mm4cGROwvCPtpZGb4Td24yp
	 d0cblOgNdkvpZE1HT+MIdNx2hykIEW0FUhJ0r8z7B+ItqVnZGIZtpjZTjJlSBvcbSnyeh
	 EZnkYW4av8CYRPLEwYgU7GagHFLOKtpw824UUFMmPqMo6c0sNoyidh6LCUWCUrYaGgMF0
	 hvBcxpcJJmMXWEzUlPOjbqrHbyCBJrHMLUFo7aqyQw+lHGc+mOw6ypzL/UJDZBkKK1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OySPe3a4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E19606A325;
	Wed, 18 Nov 2026 21:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OySPe3a4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B471F000C4;
	Wed, 18 Nov 2026 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038956;
	bh=m1D/dpNgSFH4NEfgOubNQB7FeFB2SthOOEYlh5RsOIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OySPe3a4HXaxbo0DukRVI2axn7AvLItceFaS6BHxQdox7ehiT3dICA8x5Kj914c/6
	 vweD9sWeQWuzbjtleGNQrhbno3Y83+R6Vdr0I5rhVmFPb0gua/RrS4LQwbNHT1WJmN
	 t5r9fXQGzWPyAZTBsozigWtaMCZiofXqli+Un+9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1929/3318] hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118150419.903621349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9a6aa085c94c7f2817c4d50a7264e6fb51286f40 ]

show_temp() rate-limits MSR reads by storing tdata->last_updated as an
unsigned long and comparing it against jiffies using
time_after(jiffies, tdata->last_updated + HZ).

time_after() relies on signed long subtraction, which only produces the
expected result while the two timestamps are within LONG_MAX jiffies of
each other. On 32-bit kernels, if tempX_input is not read for more than
LONG_MAX jiffies (~24.85 days at HZ=1000), the signed difference flips
sign and time_after() evaluates to false. Because tdata->last_updated is
only refreshed when time_after() succeeds, subsequent reads remain
blocked from refreshing for another ~24.85 days until jiffies wraps
past tdata->last_updated + HZ again, returning either a stale cached
temperature or -ENODATA if the sensor had never been read since
initialization.

Store tdata->last_updated as a u64 and use get_jiffies_64() with
time_after64(), which does not wrap in any practical uptime.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: bebe467823c0 ("hwmon: New coretemp driver")
Cc: stable@vger.kernel.org
Tested-by: Asaf Nuri Bertizlioğlu <ycistak@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ sashal: Adjusted surrounding context to match the existing rdmsr_on_cpu()-based temperature handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 6c10349ea68a3..a8b16b6eeca73 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -71,7 +71,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 struct temp_data {
 	int temp;
 	int tjmax;
-	unsigned long last_updated;
+	u64 last_updated;
 	unsigned int cpu;
 	u32 cpu_core_id;
 	u32 status_reg;
@@ -402,7 +402,7 @@ static ssize_t show_temp(struct device *dev,
 
 	tjmax = get_tjmax(tdata, dev);
 	/* Check whether the time interval has elapsed */
-	if (time_after(jiffies, tdata->last_updated + HZ)) {
+	if (time_after64(get_jiffies_64(), tdata->last_updated + HZ)) {
 		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 		/*
 		 * Ignore the valid bit. In all observed cases the register
@@ -411,7 +411,7 @@ static ssize_t show_temp(struct device *dev,
 		 * really help at all.
 		 */
 		tdata->temp = tjmax - ((eax >> 16) & 0x7f) * 1000;
-		tdata->last_updated = jiffies;
+		tdata->last_updated = get_jiffies_64();
 	}
 
 	mutex_unlock(&tdata->update_lock);
@@ -491,11 +491,8 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 	tdata->cpu = cpu;
 	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
-	/*
-	 * A zero timestamp does not look stale on 32-bit, where jiffies
-	 * starts just short of wrapping. Backdate it instead.
-	 */
-	tdata->last_updated = jiffies - HZ - 1;
+	/* Backdate to force a refresh on the first read */
+	tdata->last_updated = get_jiffies_64() - HZ - 1;
 	mutex_init(&tdata->update_lock);
 	return tdata;
 }
-- 
2.53.0



