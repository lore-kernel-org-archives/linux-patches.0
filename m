Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030864;
	b=18PioWBClgRAtyXXfGwSZ7caVqsNn+jMLzmmUw3hI7Qw5QFGgBKw4ABZl62qNJlN7wRW
	 XF24rL9Xyl3cxMMXGFqVDQNG75xy1VO7rgrJ5VdiXA8J6nWzWFqgw9wq2CtSeSBcOmG74
	 NqEub7OgTMKNij+3M0AaQ2Bdf+aUVhZy9tPiBtOOqb22f6t4RivW4ZiLEH6Ud6ghSKbmE
	 KQBZNDWhWVxKdrCbZyprnKbreM3rqaMnJMOSu2lCbHrWfVjjaakQQPWLy8RE0G6YC/Hgj
	 4iHANz+78rVAAVFP1eyA5UVybd6dTQTwQzZWPriNWuFkZHvwkqHWz79bmd0Dp7oZVig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/lix8jkDHtuCWDGCo6CmdciCiKfUls2hmW9M27/JLYA=;
	b=me2U70KsD9tdBznmhjn5XAz3q+DTLrG23EScKYHeRmGYQVNVSjopf1OzvjmVvcBiHIa7
	 8Crq+E892gm7SElQ+V6Oh4uDsQHQh9yM5wT6gWjcOJAUlgUMDooLpnsBadCZb5LwyYwHj
	 214ycN8CO7pVOKj73TfrxjJdbmqNv68dIUwnbcj2jZhtckkAMJgcqwcseMPzXIdVzyWeG
	 evKfgMRs+TWS2snFsQeyZ9czOQkWdAQuj8BgFbdxqpfZwrN9BBNhrxod6c2xl9tDivDhv
	 CLtMhO+ghHLmNotTdksbRwZjEGTrT5sJFGt773y6czgUQTyksXN0rctFyjL8Zv1ADJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYGAOyZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F451606D356;
	Wed, 18 Nov 2026 19:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYGAOyZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DA21F000C4;
	Wed, 18 Nov 2026 19:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030863;
	bh=/lix8jkDHtuCWDGCo6CmdciCiKfUls2hmW9M27/JLYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYGAOyZzyuSAU4UXg9X5jXZ2JDDLmhNAGSPrpWZDTzl6NTqXfsOvAYmi2k48HkxEG
	 arftStAraqC9x8rKZHf1KUUV93ECbLxGi3ZveuqyL4P+oIYydGBfXRCfvDlVmJ7FT4
	 q1mKwwDGr5BVUZcVFukkzfnYJFRRvUo0L0bQmaj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0855/1756] cpufreq: sparc-us2e: fix frequency table index copy-paste error
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118150043.420267483@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit e5b33fa47792375ca7fc49ccadee87d8e4b72929 ]

In us2e_freq_cpu_init(), the last two frequency writes both use
index [2] instead of [3] and [4] respectively, and the terminator
uses [3] instead of [5].  This is a copy-paste error where the index
was not incremented, causing the divider-6 and divider-8 entries to
overwrite the already-written divider-4 entry.

As a result, only three frequency steps (div 1, 2, and 4) are actually
available to the cpufreq core, while the intended dividers 6 and 8 are
silently lost.  The struct us2e_freq_percpu_info::table[6] has room for
5 entries plus a terminator, matching the 5 hardware dividers.

Fix the indices so all five frequency steps are correctly populated:
table[0]=div1, table[1]=div2, table[2]=div4, table[3]=div6,
table[4]=div8, table[5]=TABLE_END.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 8a0cd5312a593..6d9a7d788550a 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -282,12 +282,11 @@ static int us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	table[1].frequency = clock_tick / 2;
 	table[2].driver_data = 2;
 	table[2].frequency = clock_tick / 4;
-	table[2].driver_data = 3;
-	table[2].frequency = clock_tick / 6;
-	table[2].driver_data = 4;
-	table[2].frequency = clock_tick / 8;
-	table[2].driver_data = 5;
-	table[3].frequency = CPUFREQ_TABLE_END;
+	table[3].driver_data = 3;
+	table[3].frequency = clock_tick / 6;
+	table[4].driver_data = 4;
+	table[4].frequency = clock_tick / 8;
+	table[5].frequency = CPUFREQ_TABLE_END;
 
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
-- 
2.53.0



