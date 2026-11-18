Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040871;
	b=dWqHIiB9TuNu6/j42ySpAic++Lt/EmBDaUjE2SSrpouAQocLPl3B0Y9wyUqG+HPf2hcJ
	 c8mXEvuePEMJhy8Ehz5U7iYlDIxVWjIR3BeMvfC+KVa5Zid+/lVO2n8SejyXmupQAbD9p
	 7P4FvIzQn2YB8ZPCLOEjYfmhNPgoQ4WdOkj3F5Z/qDUgQj2g8W8sJ6N36/M0yfvJxN45T
	 gyoYAGLNAvrIhKzjGpwhWbbCdnjR3h/v5Dqa7JUmoMT3LbN3nAYJSi+lCgRHMPpjd0Kii
	 FPYwTnkfAmH8Rj3/snCGUwF3984RBDJRvdKNJ0KWKCdrHTBKksPyprcl/+UqvfuvTsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSbjzRlJpYkvrxgKDvenOmeSQauBrVMi1b3lRTJO22g=;
	b=kcc8iIEtOPStmihZXUg+zK/Z5Dhu/O9yxBwFAWcfPiXjwstlsEGrQHO9aVP76GbyuzEk
	 KYiLYMohYifRWyST9strUJOv6KmDlukxRrMrSAniRljaItbAegvQ8eJNGC85b0ZgAbQTM
	 19f/+K3jJfKCniSirEa/TmNKGKpYgbUnCRdqn5oohhAH0FmIRRjyjLFcqLmlDeO4+969r
	 AOVkMh7Zcgkl8OY2Hr/wXreJzzPea9BLWvC/IzRBGeX5DSM+doeYuCITXsHOyuEIea6pC
	 whO/jZJTdDiuBnzfOav7L9Aq2pDYCW2ifQGoGrSU6F0Vv+vwo0migTBwWES39BM2Y6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUpexS3b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B518E606A32C;
	Wed, 18 Nov 2026 22:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUpexS3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E9B1F000C4;
	Wed, 18 Nov 2026 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040871;
	bh=RSbjzRlJpYkvrxgKDvenOmeSQauBrVMi1b3lRTJO22g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUpexS3bDAfVgq0xyc+t53xTEB6eTma6nFnBSzpf2XGDQT2FjLMVOqP624JE0leF4
	 vQrk9kcWnjRAoyQwl5eYfcEGWIUbk1IUstxlrtaNoPFdtRwx5dOf42iYoQ02qWTD+5
	 oSN0BLcrnxP/h2GnJiQFKogIjKkXy5u70QmjV2tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2584/3318] cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150438.709222223@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 454767c2ad6ba..a02480e2660d0 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -339,7 +339,7 @@ static void tegra194_get_cpu_ndiv_sysreg(void *ndiv)
 
 static int tegra194_get_cpu_ndiv(u32 cpu, u32 cpuid, u32 clusterid, u64 *ndiv)
 {
-	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, &ndiv, true);
+	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, ndiv, true);
 }
 
 static void tegra194_set_cpu_ndiv_sysreg(void *data)
-- 
2.53.0



