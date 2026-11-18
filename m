Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025460;
	b=c5rObmd+VCdSemhlE1zC6Bw1LzD6p82hQwHclt9lgZkWkVj0hUPptRZqfk6cOGulmT0e
	 wGd4mq58JLAm2yla/b76XyGmtlp5Rrv4p9GRLyakc+ye5qR6Zjz+F5GRuQIOIunpJ3SVn
	 QuxA1FhAbMREVi7QT/y55wbfQ7y2Dh42DKM66FJB2/I/p4InnmUL2xzmJiECSKMA/0cNB
	 R4jlFrXjWuwiVDf5Y6bjAz4CnRT7chLtYMseiCqab9nfT9DJyEWtDipHhH5QsT6u7OAy5
	 YhG7t0Ue92yLlbgvWo1AVPMFlhcYH/CumEsocgCGsQJX2HsnFXqy2OidXeXSieVkncw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ul+3gFRk7Z08RSzDh1CM2KblYxxcu8rWMGdUUSs1HW0=;
	b=Ue9kyq4qXrxzjxjgCSVTVtIafWcYO5mXMZwcvjZlxkax86j9WO+2ufau/d3NJzotxvmg
	 73M485e1W9k9sHaoNRM55kG2vgUAsrOD8ekBGIp+wwbfRfK0aQiplwlCLoKPV/UXGvsCW
	 OVlCaW7D4feEOgnkedn5sxHzB/TEcFLI+RxkEs6Ljth3yqVojCDZD5BTyd6SrqJHUw00h
	 xDRLjGBjAQBRgyfQQxACgwqmXRjwDgaTz1Q6PL6JoA1+VVsGjdwqJvg+JAds5a0cgO8Fs
	 ohYunlHsf3fsiS84DsFwsrB+kX8i2KDPFLCn/eu0iruptH+DPHv7g8Pa7XPm+oiTwkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2j4BqiQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA77606A33A;
	Wed, 18 Nov 2026 18:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2j4BqiQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D9C1F000C4;
	Wed, 18 Nov 2026 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025460;
	bh=ul+3gFRk7Z08RSzDh1CM2KblYxxcu8rWMGdUUSs1HW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2j4BqiQwxVN/C00FEhZdX0g5YZaiXAYx3AASXGxrpcV+mmf97ysguS3gQBe2hUQX
	 9WVCQxHgYYuVtxAWd2nbmE+R8OE9Q2eSsQVEpu6RbzG6QUKadYFh9eJ8l0ItTzxcBa
	 Z/rBsi4yxBTotkcMZqUrUsJQEs4lc944JVmRatDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1087/2151] cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118150201.853382887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 9b4f516f313e0..cdd974b62fcd2 100644
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



