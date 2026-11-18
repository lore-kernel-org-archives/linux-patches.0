Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049219;
	b=lEe/rePAwA4mJfgnO0emwKXK5KShmn2LvMoSJJARNHz6wNAlWqVaXA5Oky9Eh11cQIw0
	 kIWQfbPUpQihW2bhBNPna4NogGqQUNIYVXpzHowdKhOH4WfR3Z+or7uLAE5yX8h+z0zUI
	 MsvSzVPCerRKvWP7SNMvDF/zQzVlIAGSlQGaM6zcvnOa0qDAB+VsjB0OZAl2egQad/AD3
	 DRyC5DgBALpUd1nfVogmw5p+ShyTtQ6nwa4gXfOEXwodiugTMjOwZE3ZzzaGpFjHsNGrv
	 N+VHOjlzad3bWCVDNkeyvARQsdt8A2S3bEJlSzrTl7o/cVmPY00tjPw6rEKMHhC56LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMyVy0O2NndPOu9r5yYC00TugUmS15zCjPCLbGj7q3Y=;
	b=lDqB1lV2Y2V2C9c434YPrYAHR5SPRfQX2YQX4lfe684kaYhTUZZzUuLV3p+JKyftQwJv
	 /YxrGGhjSZWFlgCpK2pVEhR6p0ey8jZPwo/b13dmAG21Xq63LB/JQ9LCt1qyXCEfZvnOO
	 B5qIMUMbw2uJULWm/7mTGu5vxJlcPZeHK4Q8wz2LFJLlNGQ+M3UChRwvV++a/FKgHY/e8
	 YI4DSFgDc1xRS8UIPAxpJ93l6FOaFn8ayXmf9RlmfuqaduAmqJ3FeDdBM9xL2C05CR0B/
	 vGrR/rT9sg7GzSY3KoHa/bJeTm3T2/Gl255+PqpflPYlkoQCtyYuxxEAzxZQ+EYPXVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz66cD+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65827606A32A;
	Thu, 19 Nov 2026 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz66cD+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E8D1F000C4;
	Thu, 19 Nov 2026 00:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049219;
	bh=OMyVy0O2NndPOu9r5yYC00TugUmS15zCjPCLbGj7q3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz66cD+a9phqmptWKRURWKDhjPTzFeWCT3a/rajw01btbWHN4ARSerhmGgDzXXBCt
	 0A1XdyrFEghrRaVVPJqwqmtCeskWyHfcX3hToSgkCd0NMQc/TFchraDoLVaF/+2mPg
	 EuH1YPtBmPUd4R/2EmsCL+WsHwkLYkQGsLXKGRjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2233/2857] cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150321.833756273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit f0a750dad7da1c653e85f0698063235453b43831 ]

ndiv is already a u64 pointer, passing &ndiv to smp_call_function_single()
results in a u64** being written to instead of the caller's u64 variable,
so the caller always reads back an uninitialized ndiv.  Drop the spurious
'&'.

Fixes: 0839ed1fd7ac ("cpufreq: tegra194: add soc data to support multiple soc")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra194-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index 4596c3e323aa4..38f749638aec8 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -314,7 +314,7 @@ static void tegra194_get_cpu_ndiv_sysreg(void *ndiv)
 
 static int tegra194_get_cpu_ndiv(u32 cpu, u32 cpuid, u32 clusterid, u64 *ndiv)
 {
-	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, &ndiv, true);
+	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, ndiv, true);
 }
 
 static void tegra194_set_cpu_ndiv_sysreg(void *data)
-- 
2.53.0



