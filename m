Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063452;
	b=HfGjIKsKT+Zp1oz/illRBTbU1z2cGEsNOLYVNryQD5YOaK+FNlZOVxrzwtjgtModxZQy
	 hijPIsWECrCKLLn9q/29z66PMShU4rHVK/g8IAh+kmlvUCuihzodWCNN5K8LQlkvRF41x
	 +u9rpEV0jEhR2bdtPNpnyOTPwdoqqsOsMAjywleDbV22viAq5jDzSSHoVmNp7rBS7S2hb
	 OpUVOGK5izJ7sJlNLImD54fdQeJORhgPFeb16Hj/fkQlOVXB0wnGbSy6WZGHyMvBuMLA8
	 X5w6bbD9PrQbqA9YmbijltNOhr6ri44DyD0hLfB3zI69lzTkVSF4jIttCQOzIEIkKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lce1OrWrrGiMDGspFCHYwSISALXKeV8Rxmf8BTo5cBI=;
	b=kByC+01EB7eBjyuSXQkJ2pe35IRUEXmdxjlDViF0MnQ3pBbO84SNLnv/kGQpDTonHIYa
	 qDEOW9qWrnSwtDTsWPYCdu9kCmnXRcLNqdG92DVYFa9XJqCiOTSMxdXcJ2OqfEn/n/QL6
	 w/4ZWhYa1wuB/rkdotlprU9c8pwjRuzF5bpmNoO2jZ6PqqFyylgNzos0mO9eDq8j4oZ5j
	 TXywBEN6ZUEm4ztfMa3WY14obbPnotQp6GZOPcRqlw+ULZ7EIoNTnORG6t/8R9IhMKGHI
	 4bIQF7V3HZnOUs306g9TYAMjttlGx4cOZHz4gpZSxZLyeiJzPrwpcuRxPihqZxBIuGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIatNLqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5998606D804;
	Sat,  7 Nov 2026 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIatNLqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393D41F008A6;
	Sat,  7 Nov 2026 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063451;
	bh=Lce1OrWrrGiMDGspFCHYwSISALXKeV8Rxmf8BTo5cBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIatNLqyLvkm9L1tfEizlXSglryPRLSq7J1sWK6ojkXn/oF14HXE0yYnecj5u9G0A
	 S1sROupsIFpUOqEh0IhiGyTbi86stNomcV5+ZFZ2IPxOZ5Cj5hpMn3CkShiFa/SQhN
	 if7UHl0YxR39kTKz+Acwljc8uVYwKBH5sVYQpbrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 609/869] cpufreq: loongson3: Use global physical CPU ID in get/target callbacks
Date: Sat,  7 Nov 2026 08:54:51 -0500
Message-ID: <20261107134913.734419830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit e38360d7c62c8fa530b58905f99a4557d4d6b352 ]

Our server productions (e.g. Loongson-3D6000/3E6000) can have discrete
global physical CPU IDs while the core ID inside the packages are always
continuous. In these cases we should use global physical CPU IDs to get
and set frequencies.

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index e3cd78a5ab187..1ae821e265fbf 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -16,6 +16,7 @@
 #include <asm/idle.h>
 #include <asm/loongarch.h>
 #include <asm/loongson.h>
+#include <asm/smp.h>
 
 /* Message */
 union smc_message {
@@ -219,38 +220,40 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
 
 static unsigned int loongson3_cpufreq_get(unsigned int cpu)
 {
-	int ret;
+	int ret, core = cpu_logical_map(cpu);
 
-	ret = do_service_request(cpu, FREQ_INFO_TYPE_FREQ, CMD_GET_FREQ_INFO, 0, 0);
+	ret = do_service_request(core, FREQ_INFO_TYPE_FREQ, CMD_GET_FREQ_INFO, 0, 0);
 
-	return ret * KILO;
+	return (ret < 0) ? 0 : ret * KILO;
 }
 
 static int loongson3_cpufreq_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	int ret;
+	int ret, core = cpu_logical_map(policy->cpu);
 
-	ret = do_service_request(cpu_data[policy->cpu].core,
-				 FREQ_INFO_TYPE_LEVEL, CMD_SET_FREQ_INFO, index, 0);
+	ret = do_service_request(core, FREQ_INFO_TYPE_LEVEL, CMD_SET_FREQ_INFO,
+				 index, 0);
 
 	return (ret >= 0) ? 0 : ret;
 }
 
 static int configure_freq_table(int cpu)
 {
-	int i, ret, boost_level, max_level, freq_level;
+	int i, ret, core, boost_level, max_level, freq_level;
 	struct platform_device *pdev = cpufreq_get_driver_data();
 	struct loongson3_freq_data *data;
 
 	if (per_cpu(freq_data, cpu))
 		return 0;
 
-	ret = do_service_request(cpu, 0, CMD_GET_FREQ_LEVEL_NUM, 0, 0);
+	core = cpu_logical_map(cpu);
+
+	ret = do_service_request(core, 0, CMD_GET_FREQ_LEVEL_NUM, 0, 0);
 	if (ret < 0)
 		return ret;
 	max_level = ret;
 
-	ret = do_service_request(cpu, 0, CMD_GET_FREQ_BOOST_LEVEL, 0, 0);
+	ret = do_service_request(core, 0, CMD_GET_FREQ_BOOST_LEVEL, 0, 0);
 	if (ret < 0)
 		return ret;
 	boost_level = ret;
@@ -263,7 +266,7 @@ static int configure_freq_table(int cpu)
 	data->def_freq_level = boost_level - 1;
 
 	for (i = 0; i < freq_level; i++) {
-		ret = do_service_request(cpu, FREQ_INFO_TYPE_FREQ, CMD_GET_FREQ_LEVEL_INFO, i, 0);
+		ret = do_service_request(core, FREQ_INFO_TYPE_FREQ, CMD_GET_FREQ_LEVEL_INFO, i, 0);
 		if (ret < 0) {
 			devm_kfree(&pdev->dev, data);
 			return ret;
-- 
2.53.0



