Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028680;
	b=WUirmNVRKDS6xt1NP/8XfbWT5R6nTx9vUVpWu5kZgiUzAWV0y6U439BclMHdh4Dxtb8H
	 6ihB+tsELOvkQ7zvqjmyiiXwNkvCFebxv4/uIYwrGKKgnQnMJ4qBduvvIWX/0nEUqpD4D
	 KtJFnoQyKg4ivf+7IXWEoo2YDndBD4tAjYTkJKofn8LZBYkQXXNszUrduse3AyswU09Ok
	 CKrEs7rdh+cyzNvJReMaQt0Up3u7whULr4jPVwHFP7yv6TEf5Ydg/FberV3O0dmUI9lZY
	 i/NP7y7bjRMxrddPnSmtI8eLoWnx/RgKYK/RuMAg+a4/QcKYAexlOJOkDhy8UpC4Wog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N2+rkuDFeQuDKfQJlxjp2yCue1EXLnIp/Mebdj1Ybuo=;
	b=Ad6+pKp0jEvxr5t9TzRmkKt66CHHl5YUH06Df6wcDO84sWdIqSAzv4XVBOPkBIh4Xbok
	 gmDCJtKR3wDuFWgK6cIV1Q64fq3WyCQI0B6ksRf7q+R3b3sPvCgdnslN6HDjGzn0QVY+M
	 u1n+Q9mMz1mf9BF6KZ4U3jaF7bko+eWfHr9SZnKqMzrcf7FO1fcbUQcT1/rSYiWvoHkDo
	 GIV4fPrEwNnq75vbLY7F4jDvv/W9Fp/AH8/gxeXdTqNMhT8qx3A9eoUO4czDB0dMa/d7x
	 2BvXpPUb1ZXErqgBsGW6TNuE4giXgR+IBPfk2/fKDqIpm366QcoVk3+tnkXM5LefQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y/Y9SWsb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CC606A31C;
	Wed, 18 Nov 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y/Y9SWsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122831F000C5;
	Wed, 18 Nov 2026 19:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028679;
	bh=N2+rkuDFeQuDKfQJlxjp2yCue1EXLnIp/Mebdj1Ybuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/Y9SWsb+686SahlWkKyN7TPn3TbdV5eLBhoSI/xfS9hBk5OpkKwb2tJgPBCkI/d6
	 jYGhBzleeGMDsS/F2DY0pibOGQ7tjRpO9pvG9ySVNdOlaPCHo06C+Y+vLe+UWVt+Fx
	 wwk1JJS8JsicJGlHCv5vGlZXMnFs2RSSrlrleh58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0082/1756] hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150011.539559921@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted show_temp() context to retain rdmsr_on_cpu() and the TjMax read before the refresh condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 7f8ff6dd16bfa..13c0b4c47501e 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -77,7 +77,7 @@ struct temp_data {
 	int temp;
 	bool temp_valid;
 	int tjmax;
-	unsigned long last_updated;
+	u64 last_updated;
 	unsigned int cpu;
 	int index;
 	u32 cpu_core_id;
@@ -407,7 +407,7 @@ static ssize_t show_temp(struct device *dev,
 
 	tjmax = get_tjmax(tdata, dev);
 	/* Check whether the time interval has elapsed */
-	if (time_after(jiffies, tdata->last_updated + HZ)) {
+	if (time_after64(get_jiffies_64(), tdata->last_updated + HZ)) {
 		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 		/*
 		 * Bit 31 indicates whether the reading is valid. Some CPUs
@@ -416,7 +416,7 @@ static ssize_t show_temp(struct device *dev,
 		 */
 		tdata->temp_valid = (eax >> 31) & 1;
 		tdata->temp = tjmax - ((eax >> 16) & 0xff) * 1000;
-		tdata->last_updated = jiffies;
+		tdata->last_updated = get_jiffies_64();
 	}
 
 	valid = tdata->temp_valid;
@@ -528,11 +528,8 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
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



