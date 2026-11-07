Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064988;
	b=haIy2DzTEpRsyAtNx+eUcJyKu2thxTctv6atXi+OmWyN4WAVxo7To8ROtD3VZfVPpzgq
	 MniZmwOk46d4nqTJUn1XLyiMoD8kOx150qYgqBAXY6lQ80b/gM0bI9+MdCMkQI4bjNXJ/
	 pv4xDB0h+lJ0uCjA7fmooRJ2Aj50ifxCtzJoVKiKT0GKTevPK+WUSL54hNUS2Lc4r+oFz
	 xO2s9ejY9JcWfA9gBZDQLv2Ouxv/MB8aTvsfR3bru1ipqD1Db0pf6U+1lIjNwd1vKb02W
	 WoAiVUWYnTjD1NWrCHhpQwncv6B/8hWxr3+Oczep2ZJ2ilrejZx7bMFjtjvR53EDQ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S2fAbd6EZUAD+OaM0FGtx1OQT3YMlDi8UK3lFKcG9ko=;
	b=AK84HKL34BQ89HMBotyVM2YA9rFIKk+R9PwaM9MVIEcmNU/YZSWO3GmccVAb33joWLZH
	 2tBHMugCe2XiD67RytPp7fJHC7KVDmGip1GoDKc3tprq/bj+z43FnwGcTlnHpdbTTCdFs
	 +BGrerUiDAMrhl7BKS5LkFWz7YT2FKz12eb/RZkWQAVBQ0ZC/nXFSC34cje0bvKyoLgd4
	 yLL0hhhfOMeEU7BNBXiRAImLU7LVLXX/92yO4KN6A1R+tCfrAJfxTRhWZ8aoeJv4ESRyf
	 lCWka73Y+OCKREEQ3i9wDRhLsuyNkIzVy//RtWDFR4X8RwaAd0Jm5933ZynyKYceXaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akD3lzJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC0606A33A;
	Sat,  7 Nov 2026 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akD3lzJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D011F0089F;
	Sat,  7 Nov 2026 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064988;
	bh=S2fAbd6EZUAD+OaM0FGtx1OQT3YMlDi8UK3lFKcG9ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akD3lzJCtLkkYoDQOb675IsQEHEqEQoU6Q9UBuAKj+X9Q7f3Dahm9CIWZGRI6YC8K
	 ejR3Kik2RGNfEfspO1i0xgjrmEv7j8FqApJojWZVMFhnWlF1zC6GzuKeM8TQoxw2mK
	 aApfvEFFws/JhE9/RwDkVXDmCe38eEGZf0/fH+ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0835/1257] cpufreq: loongson3: Use global physical CPU ID in get/target callbacks
Date: Sat,  7 Nov 2026 08:52:11 -0500
Message-ID: <20261107135002.394127293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



