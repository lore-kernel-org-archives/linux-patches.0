Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030867;
	b=b+OhT2ITHBq8RkZuwTeX2zeRFVisnnJZUEUaONDxzV/qqzryyAhw85+eo9jR83Z6Ll2G
	 ehJHUk/MwMPnnE3dk7IVKbPgxeQVMza9fpO8C7f0e6DtCW3vG6DjkWxrBl+2f5kfVYSQ7
	 IUNaN/ce43wwMyBVplgJEGA9A6S/BCiie1hjthIl/FpHpnziWWW2juJtSJp8tMAR3DFHt
	 ewAU3DSigxoMXfbOjH+iuq3tvlXZkKlvKU0GK9ptUT5lQ1C36ckeOSoSs0j47Db3Vo5I+
	 pDHZrMHXHK22ApA6sJKNBJU70lf46bdR9vMf20EZ/8BzX/Q/7clURaxS0mu2PoZWTeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NxC+2INXtjICBvG7BYcjQXRzbG5yJE9T5tNyYyUQkAA=;
	b=hhOJJc/04fpPS6UUEcsBZYAyn7v2167t1v0URCM7W33BbqRVPEnfcGzEWzVjwQuMJ+/J
	 OMN7+pW4y0fuhbLZoSmU3Lo+jqw67Eb0Nob24HyesjsR1M6I66SFTFe1Suezclubn0+Mv
	 5ltpAFigAY7nGKQYZdXlFf5IYD6xuNOfH462C3q62zg2uIg/zvW44zR7q/UaZgqrIemAV
	 CNtKA4Jn7rck7+d9X8mFpBzKELqZnKl7Ab427tfZjvUmb8OPHHimtamVPEZJUoYyHffxU
	 XxEOB/DbgB9duw+qIKuW0SfKyzXH7hZOcslqf1SbCmxj/7t53bmQll58vz5X4jJlFNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgDoa1mL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62A606D361;
	Wed, 18 Nov 2026 19:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgDoa1mL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488551F000C4;
	Wed, 18 Nov 2026 19:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030866;
	bh=NxC+2INXtjICBvG7BYcjQXRzbG5yJE9T5tNyYyUQkAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgDoa1mLqn579tQ+QEuZ6j5bxe1Qf75u8h/xK7nO+RY2yjMEr9bgUJ4hw+xyGFQRK
	 caglMzTtoM1BJh00zJSYWnEGZmaWshJivVU5q3zM5ZOw5ewp9vxeWf97C4jKL27IEn
	 kdgXFT+JrQbmZCWP2m+TxNR9lOVgP/zWZe8RawEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0856/1756] cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150043.456215409@linuxfoundation.org>
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
index 07ea7ed61b687..877a3dad06fc6 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -367,7 +367,7 @@ static void tegra194_get_cpu_ndiv_sysreg(void *ndiv)
 
 static int tegra194_get_cpu_ndiv(u32 cpu, u32 cpuid, u32 clusterid, u64 *ndiv)
 {
-	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, &ndiv, true);
+	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, ndiv, true);
 }
 
 static void tegra194_set_cpu_ndiv_sysreg(void *data)
-- 
2.53.0



