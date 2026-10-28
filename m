Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214049;
	b=bIFcrOss6+Jv2tLwKZz5YLoCiKENus2uwLftGQja37SgXv7HllEXbwJ7tFSzcBt8lZVQ
	 UOfexhks83D0zpZfadYm7QjfklxM44h6PaNWPh1CkpakkhJ0rw+nw3R/Yk+cV4dS8MSjI
	 q1lqZQ0d7AHZB9z3IXKJg0B50XqSz/ZYA8z0fInJymZg+MkNlbo+8xWshf/mAZxMJ/x1f
	 QC/fPIeHNrQgv7RzBT3fmkSiH5ZzfdOcfDHnX5uRCw0ZqQ4UiPE1jbdjFCx0g44dYwxoO
	 RV35Am+ptYK+sXCwsD32CxW56ZqbaR5qNqG4LncEc00NRvgYPEdYrhcxwiWeiHkEZ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/MCeCl99YotZkUaZWWuuK7dIuMTuJVMXkqU3GmGlljg=;
	b=G2Gp39kAVVIQn2Bva84Uy46QCD0pnFCjNPP5ITOTI30RY3lTu2giGkKtdaUdj7OdvH64
	 WB9k0IQ59nkrDj4fwqb1AxQs/C01PwWCwa6JhL96sSGVc43B5EOX3odNLjpEwrA1JzHvU
	 K7NrvbelcBfwOMJU6ME++gI3fnvkS9dLNbfDGgFHM9PWuB5BudfbBfrWOs1ADg9LmzhNZ
	 4fgG14zCT2f8EhIiU4UG4O0tqMgKFYb8rqF/NlXW9rNnFX0jmMU3NnKoeg72tgyEBuCDS
	 1wC6WK8rYIVC0Onjzx3an3Wg9dSzlBQDweV8g1yI/u1SZD+b9QGZwD1GHEO5b6gtyyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekuvdXCi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0981606A31D;
	Wed, 28 Oct 2026 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekuvdXCi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48681F01825;
	Wed, 28 Oct 2026 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214048;
	bh=/MCeCl99YotZkUaZWWuuK7dIuMTuJVMXkqU3GmGlljg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekuvdXCiAG2uwnt+hi2cNvcNEeiDb9w1ni2ODsNQMYHiYh1eFF6AfQY8cETPKTvIx
	 M5o9qbAx+nzbIMhwyLjaWKBOWe7nMm9MGOhgkJOBK1XmQ7JYCwxkKDJ/yLJMkd4DdJ
	 5P2FC5bz6VvaqV3mxDZhA+MRE6pQkbcukK1oGu3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Perry Yuan <perry.yuan@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0677/1887] cpufreq: amd-pstate: add check for cpufreq_cpu_gets return value
Date: Wed, 28 Oct 2026 17:46:13 +0100
Message-ID: <20261028170514.817634001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit 5493f9714e4cdaf0ee7cec15899a231400cb1a9f ]

cpufreq_cpu_get may return NULL. To avoid NULL-dereference check it
and return in case of error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Reviewed-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 90dcf26f09731..106aef210003d 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -309,9 +309,14 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 	unsigned long max_perf, min_perf, des_perf,
 		      cap_perf, lowest_nonlinear_perf, max_freq;
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
-	struct amd_cpudata *cpudata = policy->driver_data;
+	struct amd_cpudata *cpudata;
 	unsigned int target_freq;
 
+	if (!policy)
+		return;
+
+	cpudata = policy->driver_data;
+
 	cap_perf = READ_ONCE(cpudata->highest_perf);
 	lowest_nonlinear_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
 	max_freq = READ_ONCE(cpudata->max_freq);
-- 
2.53.0



