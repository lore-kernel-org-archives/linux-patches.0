Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062418;
	b=pT1i9zyLVWzi+V6Py/MmhU5ziNOh+ggKQDAUHlD1/KMO6eaY9p+cEhGBu2ZZSLGxN0ZI
	 mV8UuwEEGY0q5on2da7tifWGPcanbE5BXpmk6XrlCrn7hQhARDSk2cN1aeTdvfiapcyae
	 Pbwud9bf3vq8W0YAboFbqidiH79xfR89A5amzbxY41BG/skFTqWZJVA597wV1xDrLpCnf
	 Ox39DtlWwiIEjsq5J6FItxP6fr0S88yPi1F7+BT25Ytw5zoUQCOqUL/97ulfU+AEe0vpQ
	 vkGj1oyfN3P/HgpVTXbfnaIFqCHJPOcvMCQGFhJGfNYiBpfwQti1q+CS8CeIBZxnKzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0kr1J0/J1oAkZc3Ij6j95duKDLJPaScwAx/CRu2Koo=;
	b=uEKx4btABNLe7+6ILL8iqYx9jtCpo60Ccqiv59b0FJ9JSS5xlPJdzQQcxxhfiAAZj4g2
	 8lMrA/TG24ChNgKznjQXBvy9tLweZdUrrGuU9uTiOxaf5T2Gs6j37J8kgJQeJGkDY5VWP
	 zwrO30NdVD8pIaawmhii9gmjULWMN9yYa+mHP5WXfa1WnubxIQEd3brNz/CJd2SZ94vtm
	 k620a9mtd3UBF7ntmJpXVpuPhPi42b5n6SY8bsZPnlpxIpFTv/RFTl2ItByPlmhnHuD03
	 jgkR6wlcXdh4VTfHAxuTVR5Q2/P5EA/lryCW9Jvsf5xnPHZSqZtn11pdcft/Gkv349Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sraJaj0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E570C606EE9B;
	Sat,  7 Nov 2026 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sraJaj0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926851F0089F;
	Sat,  7 Nov 2026 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062417;
	bh=i0kr1J0/J1oAkZc3Ij6j95duKDLJPaScwAx/CRu2Koo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sraJaj0qeQgi5JoJEWusaMqao30UcQa20NQX+A3thHI/b41KughlvAUXF9o65vtRi
	 fpXwsMTq5/olzCwaXNFIdU/v8bAuFaiXdV8WQVaqbkEK5x7qrKsgzh8S5szsLi+ZqR
	 QHjvLH81eJfXV1Bs77kCX2pxWB2iZ99fuKt4klxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1333/1536] cpufreq: loongson3: Replace per-package mutex with per-node
Date: Sat,  7 Nov 2026 08:55:49 -0500
Message-ID: <20261107135035.258955175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index ee7c1f2d3e519..a2a798d921cb5 100644
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
@@ -346,7 +346,7 @@ static int loongson3_cpufreq_probe(struct platform_device *pdev)
 {
 	int i, ret;
 
-	for (i = 0; i < MAX_PACKAGES; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++) {
 		ret = devm_mutex_init(&pdev->dev, &cpufreq_mutex[i]);
 		if (ret)
 			return ret;
-- 
2.53.0



