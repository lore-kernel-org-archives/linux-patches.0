Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064971;
	b=Wq9HmQFkVA0sSyywT+UIc/NycPsPRYiRohf2vstTuu/Mj9WGMx37Emq5X5eVLvImcei9
	 4goYb+XBqCb5XyJrQ8Dl8eOgdBt94krcnpAbpQR22EvN6G43zkdVs5jn9pTNohKN8+YKb
	 eRkP79N8FDsZ5tkrLSwdl2tOYx1cfeQhBnfLt8eQfZ5zUmFePgD/EUcc/JJubZjnu+IdX
	 NrJXyiiMJeM7YhgVzqZwT1W+mHKJqmRUvOLA8PC/R55tyvDKMUuZqVKVQMkCSoF3ljrhC
	 o+sL4FVNmtgcbWP30zTH1tRoS/LdEz8Lm0WQQx3O5KajX4BYNYO5WQvKOo8du2y+PQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xP6ixjWKK0znxe7EO0vB0CCW3+GGWm+GUdwBICvhzow=;
	b=iN8b9Q/xcUg5zJh9o+TwlxircmIKtB8oHaCPHnWukT3kASX3VcvblYZ5MbAnuE5p9SzD
	 jQuRrNtdZcz8BjA+0QWNUp3gKLt/NvawDd3tvC+/QnQRusJ6CHvSwp0kAMC/tET1/M4Yp
	 +LNq7njzbJC+RqeU+yXpFwKrxtWT9piQO/bsv+9TLBgS4JJJNp98i09PlhdqF8dIwoe4L
	 Tyywo4kUroDaeQsXFPItuRgeJIuZGKR+TbT+uWHVwNuM5wAKw2LDrC1/VnSa+CcLGyPas
	 MJhfScWteuZZwHySYlx5c7O/ZbQ1xW4H80qr4YcKBcvS4FDAQ2tAZHx3P2LWv3r4TJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZkZBEeF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B2606A334;
	Sat,  7 Nov 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkZBEeF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7990D1F0089F;
	Sat,  7 Nov 2026 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064970;
	bh=xP6ixjWKK0znxe7EO0vB0CCW3+GGWm+GUdwBICvhzow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkZBEeF/g7Kj4pRK4bMmZLXxs2hvqbjrjr57UfFUOIJG6HSEcIS18M6nA2C2Lyi+m
	 Tou8hPQg7a0OZkVK5iRqojxzd9Y8oxqxHPMgjcQ6rLSAJbn9Ta/ReN/Fb4sYveSgUZ
	 IDILS9oQNMMvQ2Vpsji1B/MxWhcmGxIgiOEl+apw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0834/1257] cpufreq: loongson3: Replace per-package mutex with per-node
Date: Sat,  7 Nov 2026 08:52:10 -0500
Message-ID: <20261107135002.365796734@linuxfoundation.org>
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

[ Upstream commit 5d7802ada30b3101f408706b7399b0e170d2febd ]

Our server productions (e.g. Loongson-3D6000/3E6000) can have multiple
nodes in one package and SMC mailboxes are also per-node. So replace the
per-package mutex with per-node one.

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index 630f679aa7395..e3cd78a5ab187 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -169,7 +169,7 @@ struct loongson3_freq_data {
 	struct cpufreq_frequency_table table[];
 };
 
-static struct mutex cpufreq_mutex[MAX_PACKAGES];
+static struct mutex cpufreq_mutex[MAX_NUMNODES];
 static struct cpufreq_driver loongson3_cpufreq_driver;
 static DEFINE_PER_CPU(struct loongson3_freq_data *, freq_data);
 
@@ -177,14 +177,14 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
 {
 	int retries;
 	unsigned int cpu = raw_smp_processor_id();
-	unsigned int package = cpu_data[cpu].package;
+	unsigned int nid = cpu_to_node(cpu);
 	union smc_message msg, last;
 
-	mutex_lock(&cpufreq_mutex[package]);
+	mutex_lock(&cpufreq_mutex[nid]);
 
 	last.value = iocsr_read32(LOONGARCH_IOCSR_SMCMBX);
 	if (!last.complete) {
-		mutex_unlock(&cpufreq_mutex[package]);
+		mutex_unlock(&cpufreq_mutex[nid]);
 		return -EPERM;
 	}
 
@@ -208,11 +208,11 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
 	}
 
 	if (!msg.complete || msg.cmd != CMD_OK) {
-		mutex_unlock(&cpufreq_mutex[package]);
+		mutex_unlock(&cpufreq_mutex[nid]);
 		return -EPERM;
 	}
 
-	mutex_unlock(&cpufreq_mutex[package]);
+	mutex_unlock(&cpufreq_mutex[nid]);
 
 	return msg.val;
 }
@@ -337,7 +337,7 @@ static int loongson3_cpufreq_probe(struct platform_device *pdev)
 {
 	int i, ret;
 
-	for (i = 0; i < MAX_PACKAGES; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++) {
 		ret = devm_mutex_init(&pdev->dev, &cpufreq_mutex[i]);
 		if (ret)
 			return ret;
-- 
2.53.0



