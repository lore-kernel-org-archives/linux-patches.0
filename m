Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622530;
	b=mrIrIcuF7IrTx0z57ZfK4i4c1gO8WjG9d+ChckJTVXnkZjIsTFbeTs0oMikkEv/ZnD4A
	 FjxcmBDF8rBwENN+1MzDeT+kijtB/UpmfKmlc5BRfy7WdRLaT9rE9ccaczFp5fyTZCQiW
	 rhFysqLWdMPOSW5lk4B+MN4JokIBF/7GgTedBeLIiyNThJ6RjP8QFL0VDLZxuYVxZeiYh
	 wbMXhFsLPllTuq222jic73zuYQlFP2suYfsXeSRftBUVF3k9LhMOkZkfp7qLfUQc0gOXN
	 MWjOv8ex+rJAX9Ckk8F57UqtDSzmj/oRLgjs6+TPvD7jvDHYwd2sD04Ndv3GUg0yStA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CUSiCO0XHUlNSgm8EzcvU5hoNhu5F+juh0Z+CEFzsFY=;
	b=VVQYxy5ARU+04AFafK2SlMF1NssSxrs9lGbi6/O3mNnid6eu1TS2Is2l9S9Guy3Mbf0U
	 SFDxZgJYSAhmck9BxaDyfEH3axi817+JvOGFuHw7eSLUTfthFw7Tx7IIvU66tc76ToUE9
	 Sc5GHGqa36A8GaqW32D1ovr9R3pX5ucSHCQG32cvhlaO2w7ZyEr85W9PezEOsXNMU19Q/
	 xa8+M1s2mTxlDiP+hdN052WrjIQbgfvcHBM/LXtSRLEK71KEsBm0ClfZZJ5QXo2/lNecI
	 NVUcpfBa0Ja6IYhsjyf91rrvfAj/YetUud2/ljdsOY9UJJioLcwCRwja/WKj/V679dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQIPv4AD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817FE606A31E;
	Wed, 25 Nov 2026 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQIPv4AD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1AE1F000C4;
	Wed, 25 Nov 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622530;
	bh=CUSiCO0XHUlNSgm8EzcvU5hoNhu5F+juh0Z+CEFzsFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQIPv4ADcBwWd8ffl1/SniPMpxbLW/yqTVOZSK8tWNaqQKqhz8ZAs9ZzwrZUjY1bc
	 m5yjj/Gt4OVTibCVKispm315oQjol+pgXsh5Dm/AJhcssu0A3wl1qF+fyCI+0pmCKu
	 wZsTYZQCsVm3d1BRNPi9K/dRq2aOeusn0V8nZ/M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 567/990] drm/msm/a5xx: dont read the GPMU registers on GPUs without a GPMU
Date: Wed, 25 Nov 2026 15:32:14 +0100
Message-ID: <20261125143835.378981511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 77e3ffcf69065c4ce92c725540e0b4db14f43ad7 ]

Only a530/a540 have a GPMU.  On the other a5xx parts, reading the
0xa800-0xac60 GPMU aperture during a crashdump resets the board -- on
sda660 (a512) a GPU hang thus reboots the SoC instead of recovering.

Split the GPMU block into its own array and collect it only when a GPMU
is present.

Fixes: e20c9284c8f2 ("drm/msm/adreno: Add support for Adreno 510 GPU")
Assisted-by: LLM
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/754867/
Message-ID: <20260920-a5xx-no-gpmu-v1-1-714200254f76@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
[ sashal: Replaced upstream's kzalloc_obj(*a5xx_state) with kzalloc(sizeof(*a5xx_state), GFP_KERNEL) because the helper doesn't exist here, and kept the added adreno_gpu declaration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 49 +++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 4a04dc43a8e67..3d123f6e51ab2 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1338,9 +1338,14 @@ static const u32 a5xx_registers[] = {
 	0xE800, 0xE806, 0xE810, 0xE89A, 0xE8A0, 0xE8A4, 0xE8AA, 0xE8EB,
 	0xE900, 0xE905, 0xEB80, 0xEB8F, 0xEBB0, 0xEBB0, 0xEC00, 0xEC05,
 	0xEC08, 0xECE9, 0xECF0, 0xECF0, 0xEA80, 0xEA80, 0xEA82, 0xEAA3,
-	0xEAA5, 0xEAC2, 0xA800, 0xA800, 0xA820, 0xA828, 0xA840, 0xA87D,
-	0XA880, 0xA88D, 0xA890, 0xA8A3, 0xA8D0, 0xA8D8, 0xA8E0, 0xA8F5,
-	0xAC60, 0xAC60, ~0,
+	0xEAA5, 0xEAC2, ~0,
+};
+
+/* GPMU registers, only valid on parts with a GPMU (a530/a540) */
+static const u32 a5xx_gpmu_registers[] = {
+	0xA800, 0xA800, 0xA820, 0xA828, 0xA840, 0xA87D, 0xA880, 0xA88D,
+	0xA890, 0xA8A3, 0xA8D0, 0xA8D8, 0xA8E0, 0xA8F5, 0xAC60, 0xAC60,
+	~0,
 };
 
 static void a5xx_dump(struct msm_gpu *gpu)
@@ -1451,6 +1456,7 @@ struct a5xx_crashdumper {
 struct a5xx_gpu_state {
 	struct msm_gpu_state base;
 	u32 *hlsqregs;
+	u32 *gpmuregs;
 };
 
 static int a5xx_crashdumper_init(struct msm_gpu *gpu,
@@ -1568,8 +1574,30 @@ static void a5xx_gpu_state_get_hlsq_regs(struct msm_gpu *gpu,
 	msm_gem_kernel_put(dumper.bo, gpu->vm);
 }
 
+static void a5xx_gpu_state_get_gpmu_regs(struct msm_gpu *gpu,
+		struct a5xx_gpu_state *a5xx_state)
+{
+	u32 count = 0, pos = 0;
+	int i;
+
+	for (i = 0; a5xx_gpmu_registers[i] != ~0; i += 2)
+		count += a5xx_gpmu_registers[i + 1] - a5xx_gpmu_registers[i] + 1;
+
+	a5xx_state->gpmuregs = kcalloc(count, sizeof(u32), GFP_KERNEL);
+	if (!a5xx_state->gpmuregs)
+		return;
+
+	for (i = 0; a5xx_gpmu_registers[i] != ~0; i += 2) {
+		u32 addr;
+
+		for (addr = a5xx_gpmu_registers[i]; addr <= a5xx_gpmu_registers[i + 1]; addr++)
+			a5xx_state->gpmuregs[pos++] = gpu_read(gpu, addr);
+	}
+}
+
 static struct msm_gpu_state *a5xx_gpu_state_get(struct msm_gpu *gpu)
 {
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a5xx_gpu_state *a5xx_state = kzalloc(sizeof(*a5xx_state),
 			GFP_KERNEL);
 	bool stalled = !!(gpu_read(gpu, REG_A5XX_RBBM_STATUS3) & BIT(24));
@@ -1585,6 +1613,9 @@ static struct msm_gpu_state *a5xx_gpu_state_get(struct msm_gpu *gpu)
 
 	a5xx_state->base.rbbm_status = gpu_read(gpu, REG_A5XX_RBBM_STATUS);
 
+	if (adreno_is_a530(adreno_gpu) || adreno_is_a540(adreno_gpu))
+		a5xx_gpu_state_get_gpmu_regs(gpu, a5xx_state);
+
 	/*
 	 * Get the HLSQ regs with the help of the crashdumper, but only if
 	 * we are not stalled in an iommu fault (in which case the crashdumper
@@ -1606,6 +1637,7 @@ static void a5xx_gpu_state_destroy(struct kref *kref)
 		struct a5xx_gpu_state, base);
 
 	kfree(a5xx_state->hlsqregs);
+	kfree(a5xx_state->gpmuregs);
 
 	adreno_gpu_state_destroy(state);
 	kfree(a5xx_state);
@@ -1634,6 +1666,17 @@ static void a5xx_show(struct msm_gpu *gpu, struct msm_gpu_state *state,
 
 	adreno_show(gpu, state, p);
 
+	if (a5xx_state->gpmuregs) {
+		u32 o, pos = 0;
+
+		drm_printf(p, "registers-gpmu:\n");
+
+		for (i = 0; a5xx_gpmu_registers[i] != ~0; i += 2)
+			for (o = a5xx_gpmu_registers[i]; o <= a5xx_gpmu_registers[i + 1]; o++)
+				drm_printf(p, "  - { offset: 0x%04x, value: 0x%08x }\n",
+					o << 2, a5xx_state->gpmuregs[pos++]);
+	}
+
 	/* Dump the additional a5xx HLSQ registers */
 	if (!a5xx_state->hlsqregs)
 		return;
-- 
2.53.0



