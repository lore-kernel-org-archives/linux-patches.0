Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062420;
	b=CzUJpVBcy1cYkUHoexg1FMA3qe2rBqaJG40Q4m1oJF42zURNZbfrBLMQR3TRgTpBE1r4
	 CY66kpxah6s6iNbqO6RPptG0WWBMCVrBJ9knXbBRNKoOjBXehzqg0JODb/tg/a+RgjL3Z
	 YEAHUekHJbWtZ5je0tjvs9sIEMlbzT7+8eFTFZVRyzvRC4aOuMDHGGa7jpSaqCXeoOeRd
	 TQufBiqIygYY405HSEiRdx/s02pDA/b2g1rqC/FM+0jvDfAVWMT0X4wumDGT70h+/LaGY
	 GSfUtvAWYBcB7Jaa0iUPRTfv6Th7CIBDPmFTKDavNGTz20zScJtATE6GZDRDYkVDwCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hM96TgYJx01oOlDyr0cU2Vs20n4bppy0EKKfMCDzlRk=;
	b=oa/d2891kaz//QUMdCzxvFNT5c29x6k8E0/FyioeWQzTun9tHz6+5hUe3t9IolPRrTMV
	 a7jnq/X6RuWHBmVvobyv7lHGwobTbUlBVdeWzq03Qtp1dwTOOpCqff7mrMHra7QXIXfIa
	 HV0k8I//VZ3FmDRjariEHkn82OyWBky5eRmvGReoNm9j3coXun2AcyzHfnKw0aA1Yf/Wh
	 M42680EF9H0XGVVZ5wmsTBi9JI66noReRgdEmLbO60Pnny8U9yBSGmn1hCu1g/wWJZJn5
	 H39qDukvScdDYfrgAvtSbidePOX6HsLK34P728iOiEbElAXpKPP+8f6l71ungaMSk+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJkIjRVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7793360A261B;
	Sat,  7 Nov 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJkIjRVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0311E1F0089F;
	Sat,  7 Nov 2026 14:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062420;
	bh=hM96TgYJx01oOlDyr0cU2Vs20n4bppy0EKKfMCDzlRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJkIjRVZMem2DznnG+3PIj/EC2rqTLghndKHvU3YqW0v3NMA+UyWNbHu7gTGcpxLJ
	 Mkq0A9xVbLVBWNT8hAvJktqTp+bCPU//ShAT9UJIhbLOu19uFIQgIjEa3u2EdPPZLR
	 hsV8bw/7FHklUynSglOFYUEQluErKDKecn/p3qrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1335/1536] cpufreq: loongson3: Replace IOCSR read/write with MMIO ones
Date: Sat,  7 Nov 2026 08:55:51 -0500
Message-ID: <20261107135035.312772595@linuxfoundation.org>
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

[ Upstream commit 81792daacfb41ca07b04bd3956ea9e672080cc98 ]

Our server productions (e.g. Loongson-3D6000/3E6000) can have multiple
nodes in one package and SMC mailboxes are also per-node. However, IOCSR
read/write can only perform on the current node, while sometimes we want
to perform on other nodes (e.g. when switch governor, the get and target
callbacks are not run on target core). So replace IOCSR read/write with
MMIO ones.

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 34 +++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index ef93d02f65804..85da1bf915e15 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -17,6 +17,7 @@
 #include <asm/loongarch.h>
 #include <asm/loongson.h>
 #include <asm/smp.h>
+#include <asm/numa.h>
 
 /* Message */
 union smc_message {
@@ -165,6 +166,12 @@ union smc_message {
 
 #define FREQ_MAX_LEVEL			16
 
+#define MMIO_SMCMBX(node) \
+	((void __iomem *)(nid_to_addrbase(node) | IO_BASE | LOONGSON_REG_BASE | LOONGARCH_IOCSR_SMCMBX))
+
+#define MMIO_MISC_FUNC(node) \
+	((void __iomem *)(nid_to_addrbase(node) | IO_BASE | LOONGSON_REG_BASE | LOONGARCH_IOCSR_MISC_FUNC))
+
 struct loongson3_freq_data {
 	unsigned int def_freq_level;
 	struct cpufreq_frequency_table table[];
@@ -177,13 +184,27 @@ static DEFINE_PER_CPU(struct loongson3_freq_data *, freq_data);
 static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 extra)
 {
 	int retries;
-	unsigned int cpu = raw_smp_processor_id();
-	unsigned int nid = cpu_to_node(cpu);
+	unsigned int cpu = 0, nid;
 	union smc_message msg, last;
 
+#ifdef CONFIG_SMP
+	switch (cmd) {
+	case CMD_GET_FREQ_INFO:
+	case CMD_SET_FREQ_INFO:
+	case CMD_GET_FREQ_LEVEL_NUM:
+	case CMD_GET_FREQ_LEVEL_INFO:
+	case CMD_GET_FREQ_BOOST_LEVEL:
+		cpu = cpu_number_map(id);
+		break;
+	default:
+		cpu = raw_smp_processor_id();
+	}
+#endif
+	nid = cpu_to_node(cpu);
+
 	mutex_lock(&cpufreq_mutex[nid]);
 
-	last.value = iocsr_read32(LOONGARCH_IOCSR_SMCMBX);
+	last.value = readl(MMIO_SMCMBX(nid));
 	if (!last.complete) {
 		mutex_unlock(&cpufreq_mutex[nid]);
 		return -EPERM;
@@ -196,12 +217,11 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
 	msg.extra	= extra;
 	msg.complete	= 0;
 
-	iocsr_write32(msg.value, LOONGARCH_IOCSR_SMCMBX);
-	iocsr_write32(iocsr_read32(LOONGARCH_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
-		      LOONGARCH_IOCSR_MISC_FUNC);
+	writel(msg.value, MMIO_SMCMBX(nid));
+	writel(readl(MMIO_MISC_FUNC(nid)) | IOCSR_MISC_FUNC_SOFT_INT, MMIO_MISC_FUNC(nid));
 
 	for (retries = 0; retries < 10000; retries++) {
-		msg.value = iocsr_read32(LOONGARCH_IOCSR_SMCMBX);
+		msg.value = readl(MMIO_SMCMBX(nid));
 		if (msg.complete)
 			break;
 
-- 
2.53.0



