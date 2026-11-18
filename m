Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061322;
	b=FsywEq7d3dSSC/ZVTPNPPBY0mCtYMFTvhpOmbHC3P1rSG3gUCR4QgMnSpu1qmoq/u7Yk
	 Bp18dA1Ie+hAS53wZFyNm5RLz3OY5QyK1TvdUmpZXC/Etp6gBsP4kzM9sXr2Pos/RSAiM
	 bdcee52smOVhZwxNc3ZOwV0wCOtsWV7N44BGHs2LBFmthFD02yti/T8bDDKG63+6FbKPY
	 al9HevgYf9LQtbcBnBiWL9krhE3gIQ0pgLusLoPv29xwbXaTwwleKEnQkILs57qJvhpw/
	 S1OVwPuKga6Ys70gyJ0VSnP2x6aenVT9Vsq3aXBBgnzx3sYFcKpZsivISZWhdIB39sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqMwV2U9SzyAIWejmXJNwybkkAX7nbW3DrKSOSwjxD4=;
	b=Jyyzm7NSKKTJJOtNna0r1e0gxV8T2ySRb+qztz43nUY0HPpMiMISpsqsUi7ZIpIB33Ij
	 NMGRpNjyb0S0GnH7dhtU3xQQrmXj8Ovc7sZzWkMRXR7PCBmtueWtrWJNxPWCZFsbRC4Pb
	 NHL9l6h+Ge3G9MygDdcK8ySY+8PS+Cd8aHDcQ7Bip4cd8jPRkB5mbVON25X0omxhbd5PR
	 KMWmR4uxUw38otGF7ksPYVap/K2ofqfo8/yne9gGtbRn05KGl7B+0jbyyZTKTnDOLqgr6
	 AmS4Xbgztu4YhLLKuJuzlr6EZytJN2IZBrz0P45GtIKIKtuceolf0wjwo8E+w1xsaNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7KPQlmK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA1606A320;
	Thu, 19 Nov 2026 04:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7KPQlmK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD391F000C4;
	Thu, 19 Nov 2026 04:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061322;
	bh=mqMwV2U9SzyAIWejmXJNwybkkAX7nbW3DrKSOSwjxD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7KPQlmK7f4SUu0esteGzyPqqpjQnKe1+ZOhzLuridfDQabjjUsn69JkHgwTCi5GJ
	 G/6jkqXWZKxbVXBey+u6hPVICG4w2e7rrNvWR9TjfLzhXeyplfKp7mhicpJnl3GmeR
	 LoaVSdWsxr2eUnrnzC86R+Es+mYN1vLrGpEtKx0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1469/1848] cpufreq: sparc-us2e: fix frequency table index copy-paste error
Date: Wed, 18 Nov 2026 15:58:27 +0100
Message-ID: <20261118150020.814101814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 92acbb25abb3a..bbf5b3522fa67 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -284,12 +284,11 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
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



