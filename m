Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018575;
	b=ijOOKuQyvw3gsxkDMA++EFs9uDKKJeHSDcZC0vq9A1MkXAyLA5UZsBxamytdyF+H3X7J
	 dPs4RkIvhQyYFo1Y0wVCmKrCb8RFWOL6iqRg8nLw8OZP3dY2rt++MUQhTQfwr+RzkXw7f
	 4msyd7XV2EM6Po9Ky0MzIDcMyeRHpbs3bs6Vzz06+GBVo86nw2ByZduMZwNDllz2UaJVd
	 NgF/w46RSPZ2Yy0Ey6A74kkAAxAgVYsRzJOUi3oTAoBnIhHTTRULn0UOC+0k3YywxJI98
	 BiHTgalXluFOpPBVeAFMO+rCCHJYlIkHkPXzS+CVqCEdyhpeIh+MGb9x6iAGjZP1Fbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=auJPGP9R42Th4YJrojow5xGmFNVL43lEBwdLu0ZlbtE=;
	b=n75MqmMjCm7znREXno+isEs5IRE6g8FE08UotZSIMeQW22kfIKmhI5rSeWZ1ODpVch2i
	 UzC9KRkNgntrhh/TvteEWn4mt53ZeE5jECynk6pDTBLuAiA255WsunNJUEQWCVKyDD/Zm
	 WA4RpvhNq2PH76WkyM3sRSeiMUfmzCUiZBiCRIpFAXF1GQp++H2ENsY0pOta8S6f5PQNX
	 pXtHmK9LewM4ZBAj/tUPeZtsq3tMkKsZNNabZ0Jom3+AdgV1naCF0nMFmpikXqUs4ma/q
	 0A/+yB4nFF9vAmHNuvf+ObcCcDnTgO3US3TEGqu+xoVh4MHmNMT+eGrvxWg7lSXkS6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjYuFfMQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0FC606A32A;
	Wed, 18 Nov 2026 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjYuFfMQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC951F000C6;
	Wed, 18 Nov 2026 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018574;
	bh=auJPGP9R42Th4YJrojow5xGmFNVL43lEBwdLu0ZlbtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjYuFfMQHQ2Ie5h4ek1r8SIFQ1CwysxYdctMmsHQQmv0AaQWP73Y4ybfEnGsI8i05
	 wHl7n7xtSnj8ZSPBzh7yticAKKaFb9DeW8nm/PhwXrElJ7IwwoPuuuF2DvdgLqvcLx
	 uYJcbzg5mD1Q6QazaFMG233yddZvLEr+U+lJGqtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1262/2651] perf: marvell: avoid large stack variables
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118150333.406056911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7e17084177aa6c76231c6ee8cdbbcd24f40c86cc ]

The probe function in this driver constructs multiple large structures
on the stack, which ends up causing a size warning:

drivers/perf/marvell_cn10k_ddr_pmu.c:1168:12: error: stack frame size (1296) exceeds limit (1280) in 'cn10k_ddr_perf_probe' [-Werror,-Wframe-larger-than]
 1168 | static int cn10k_ddr_perf_probe(struct platform_device *pdev)
      |            ^

Avoid this warning and simplify the code by turning these into static
const structures and directly assigning them without the extra copy.

Fixes: 9b551a2446b2 ("perf: marvell: Add CN20K DDR PMU support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_ddr_pmu.c | 85 +++++++++++++++-------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
index 0a8cb61664084..9b68d6c1c31cd 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -1165,6 +1165,47 @@ static const struct ddr_pmu_platform_data odyssey_ddr_pmu_pdata = {
 };
 #endif
 
+static const struct pmu cn10k_pmu = {
+	.module	      = THIS_MODULE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
+	.task_ctx_nr = perf_invalid_context,
+	.attr_groups = cn10k_attr_groups,
+	.event_init  = cn10k_ddr_perf_event_init,
+	.add	     = cn10k_ddr_perf_event_add,
+	.del	     = cn10k_ddr_perf_event_del,
+	.start	     = cn10k_ddr_perf_event_start,
+	.stop	     = cn10k_ddr_perf_event_stop,
+	.read	     = cn10k_ddr_perf_event_update,
+	.pmu_enable  = cn10k_ddr_perf_pmu_enable,
+	.pmu_disable = cn10k_ddr_perf_pmu_disable,
+};
+
+static const struct pmu ody_pmu = {
+	.module       = THIS_MODULE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
+	.task_ctx_nr = perf_invalid_context,
+	.attr_groups = odyssey_attr_groups,
+	.event_init  = cn10k_ddr_perf_event_init,
+	.add         = cn10k_ddr_perf_event_add,
+	.del         = cn10k_ddr_perf_event_del,
+	.start       = cn10k_ddr_perf_event_start,
+	.stop        = cn10k_ddr_perf_event_stop,
+	.read        = cn10k_ddr_perf_event_update,
+};
+
+static const struct pmu cn20k_pmu = {
+	.module       = THIS_MODULE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
+	.task_ctx_nr = perf_invalid_context,
+	.attr_groups = cn20k_attr_groups,
+	.event_init  = cn10k_ddr_perf_event_init,
+	.add         = cn10k_ddr_perf_event_add,
+	.del         = cn10k_ddr_perf_event_del,
+	.start       = cn10k_ddr_perf_event_start,
+	.stop        = cn10k_ddr_perf_event_stop,
+	.read        = cn10k_ddr_perf_event_update,
+};
+
 static int cn10k_ddr_perf_probe(struct platform_device *pdev)
 {
 	const struct ddr_pmu_platform_data *dev_data;
@@ -1202,56 +1243,20 @@ static int cn10k_ddr_perf_probe(struct platform_device *pdev)
 		/* Setup the PMU counter to work in manual mode */
 		writeq_relaxed(OP_MODE_CTRL_VAL_MANUAL, ddr_pmu->base +
 			       ddr_pmu->p_data->cnt_op_mode_ctrl);
+		ddr_pmu->pmu = cn10k_pmu;
 
-		ddr_pmu->pmu = (struct pmu) {
-			.module	      = THIS_MODULE,
-			.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
-			.task_ctx_nr = perf_invalid_context,
-			.attr_groups = cn10k_attr_groups,
-			.event_init  = cn10k_ddr_perf_event_init,
-			.add	     = cn10k_ddr_perf_event_add,
-			.del	     = cn10k_ddr_perf_event_del,
-			.start	     = cn10k_ddr_perf_event_start,
-			.stop	     = cn10k_ddr_perf_event_stop,
-			.read	     = cn10k_ddr_perf_event_update,
-			.pmu_enable  = cn10k_ddr_perf_pmu_enable,
-			.pmu_disable = cn10k_ddr_perf_pmu_disable,
-		};
 	}
 
 	if (silicon_flags & IS_ODY) {
 		ddr_pmu->ops = &ddr_pmu_ody_ops;
-
-		ddr_pmu->pmu = (struct pmu) {
-			.module       = THIS_MODULE,
-			.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
-			.task_ctx_nr = perf_invalid_context,
-			.attr_groups = odyssey_attr_groups,
-			.event_init  = cn10k_ddr_perf_event_init,
-			.add         = cn10k_ddr_perf_event_add,
-			.del         = cn10k_ddr_perf_event_del,
-			.start       = cn10k_ddr_perf_event_start,
-			.stop        = cn10k_ddr_perf_event_stop,
-			.read        = cn10k_ddr_perf_event_update,
-		};
+		ddr_pmu->pmu = ody_pmu;
 	}
 
 	if (silicon_flags & IS_CN20K) {
 		ddr_pmu->ops = &ddr_pmu_ody_ops;
-
-		ddr_pmu->pmu = (struct pmu) {
-			.module       = THIS_MODULE,
-			.capabilities = PERF_PMU_CAP_NO_EXCLUDE,
-			.task_ctx_nr = perf_invalid_context,
-			.attr_groups = cn20k_attr_groups,
-			.event_init  = cn10k_ddr_perf_event_init,
-			.add         = cn10k_ddr_perf_event_add,
-			.del         = cn10k_ddr_perf_event_del,
-			.start       = cn10k_ddr_perf_event_start,
-			.stop        = cn10k_ddr_perf_event_stop,
-			.read        = cn10k_ddr_perf_event_update,
-		};
+		ddr_pmu->pmu = cn20k_pmu;
 	}
+
 	/* Choose this cpu to collect perf data */
 	ddr_pmu->cpu = raw_smp_processor_id();
 
-- 
2.53.0



