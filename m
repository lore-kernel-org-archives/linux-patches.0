Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015066;
	b=RCf44cIy8H0tNif2nuUhy+QtMghEFy8frZbG0tIfVsy5kvvp6hKD3ilfXP7EUn75NWmc
	 gJoNFp2li1zzT4UlPee9Bcfd/HX5HVshQS7hjpLfJzL8v6/P7L/4NrAKXXFZFB6abNckh
	 47qEig4GCTblZJy8AVxp1uOQ0N0//CfdyY67E9hFix6+LfedcHMsPcILY48iLMcr7GeIS
	 Y4g84Uov3YyB3EfyH/GDBzgpnOttKEv0TY4Fsj8SsZMBkP9Pa2iSdGzTSOLFYYOHsLwFr
	 eh8rFAEeXJ+MBoojvIP7aVKDiSBwynHESw8Bz3EkNdnFrU2wiwRZCdUjWhN1aoRsl4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0TBS+uqx01M8XKT47cT4bXfwS/vy+EunYLOmqwbW7v0=;
	b=E2EIMKpG+c4MoeUv8/DmwgA1IDV+HnQPWatpD0ifMOBn+zfse8p4mB1ecR5Xjiv2+U6D
	 wSPCqFJOkDH1a5R5ns51RDaRz4vVLMsVUgkZUPPGsNfwd49XG+jeyzcafjdpoy84ZngBP
	 cHw5qEOb29ON1oiXGpjqgS09QMTOUXW2UGjhLkGkwM3CyA+6HBpnLyQUvLPySgyarqN8K
	 ymhTIFIbnuwtb+SIXSHaUlmwcrqka9vPQ6Cuk/C3DSzDC6YaWRTKDh+EVYOqOaySAG5H+
	 bgtcoErbfEltA1l4JABMLfybyBu66vNmZvFPOOZFyutX+5u98EIw34OgH3rSX0LNbIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4ikjEH0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D7C606A320;
	Wed, 18 Nov 2026 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4ikjEH0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E90B1F000C4;
	Wed, 18 Nov 2026 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015066;
	bh=0TBS+uqx01M8XKT47cT4bXfwS/vy+EunYLOmqwbW7v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4ikjEH0B4Fq8TRROBuZavpIedDZvB1l1s3adm+cd1SVjZugYNSAGttY0DCcpoVTN
	 xNJp5hFhgFMRrcv6KDn++gDlma8XaqgvS0QLFo0FoqbjHQ1HyjVhBTIsdjiJCj9K8c
	 Jr74LIMogggetaoLIaeyVNl8x6XnVgTF19FEOgcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Asaf=20Nuri=20Bertizlio=C4=9Flu?= <ycistak@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0041/2651] hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()
Date: Wed, 18 Nov 2026 15:21:21 +0100
Message-ID: <20261118150249.447025649@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 7fced0e2abeba..96d57fe12de6d 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -76,7 +76,7 @@ struct temp_data {
 	int temp;
 	bool temp_valid;
 	int tjmax;
-	unsigned long last_updated;
+	u64 last_updated;
 	unsigned int cpu;
 	int index;
 	u32 cpu_core_id;
@@ -407,7 +407,7 @@ static ssize_t show_temp(struct device *dev,
 	mutex_lock(&tdata->update_lock);
 
 	/* Check whether the time interval has elapsed */
-	if (time_after(jiffies, tdata->last_updated + HZ)) {
+	if (time_after64(get_jiffies_64(), tdata->last_updated + HZ)) {
 		tjmax = get_tjmax(tdata, dev);
 		rdmsrq_on_cpu(tdata->cpu, tdata->status_reg, &val.q);
 		/*
@@ -417,7 +417,7 @@ static ssize_t show_temp(struct device *dev,
 		 */
 		tdata->temp_valid = (val.l >> 31) & 1;
 		tdata->temp = tjmax - ((val.l >> 16) & 0xff) * 1000;
-		tdata->last_updated = jiffies;
+		tdata->last_updated = get_jiffies_64();
 	}
 
 	valid = tdata->temp_valid;
@@ -521,11 +521,8 @@ init_temp_data(struct platform_data *pdata, unsigned int cpu, int pkg_flag)
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



