Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625266;
	b=VFDAXsD30/Op6EiLshvJDN26SrQnLqHEwr3gVYtxTktsynThUNCZZJ3fvPwBqiAXod2h
	 nY/Fk/sb55bvu1hTrWayaYGl6qAl612TfDbv7nIFiKh0b9t8fXa4qpOjAg9f9YzDs7dTS
	 JuBbhmL/wtTvseejx5/WtieX9q+PyTUSi58rFNJMZNYo2EzBrEVDBcpxnpeAYiRhDp39V
	 9AFugOpR0sIwE1ZSkEtEImpWWb8gVXzgeQvPs/wgvolmO86od8uZnXaqoFf4SOeZbUO4g
	 /E+pW5k+GgYpgpCUEGWuFpdQS2xaS9V48NIANrQ/3WtWl3gTaLKZxytQm8asKVsPd5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VV+AeFdvZVqyZD6qr/1E2+VmLVtQCxPQbPRGSNACkgI=;
	b=Dyvje1WdDGG6wMgwdx/Qd8ysuZ+ttOTqzvQWMHhiODV1cGeazqLdImYYB8PXdaw0ySt1
	 mSpRYwJS4mSEAoGi9DtI9MVFIh19ksBSG+Qpp9xPUndBrNBx92k7+x8vL3A1GyCh40qYX
	 va66BdqkuvKnlfoqKo5t1np8OV3wMSLm5ufnyEo+WTZ4pQx0BPnO0So3RTkXMSvaRBM23
	 r4/7QFmkzkFUfrax76FLt0infhVigbxF5tXjZJGJ05j6m7zWY7Z0f1qXvg2lCtFXVfS2U
	 mvtdZKOIGXXClm5fn+GQGmC9WDACRiijq8fUb5FK4A+aqXdoozfQlY24wOpUFQzLaXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpL6bVXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38E606A321;
	Wed, 25 Nov 2026 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpL6bVXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BF61F000C4;
	Wed, 25 Nov 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625265;
	bh=VV+AeFdvZVqyZD6qr/1E2+VmLVtQCxPQbPRGSNACkgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpL6bVXfshyhGrtroGlmoPzrzQal9heTP4WblvbQE8B1g38WTKq0F5mmDqw/W84eQ
	 DBn7r3zPRb4aqSePH+efJcB1JC11ppZ+d9608YzsqPlPf9l+Lm40bGuT7f34TrAGMr
	 CxNAVaY+fIL0eVPMwz5aytS5Gua6lDgPPMNnhyxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 458/816] drm/msm/a5xx: dont read the GPMU registers on GPUs without a GPMU
Date: Wed, 25 Nov 2026 15:33:26 +0100
Message-ID: <20261125143859.793111553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Kept the older kzalloc(sizeof(*a5xx_state), GFP_KERNEL) allocation as context and added the new adreno_gpu declaration above it, instead of upstream's kzalloc_obj() form. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 49 +++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index e09044930547f..65c6d14d54248 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1336,9 +1336,14 @@ static const u32 a5xx_registers[] = {
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
@@ -1449,6 +1454,7 @@ struct a5xx_crashdumper {
 struct a5xx_gpu_state {
 	struct msm_gpu_state base;
 	u32 *hlsqregs;
+	u32 *gpmuregs;
 };
 
 static int a5xx_crashdumper_init(struct msm_gpu *gpu,
@@ -1566,8 +1572,30 @@ static void a5xx_gpu_state_get_hlsq_regs(struct msm_gpu *gpu,
 	msm_gem_kernel_put(dumper.bo, gpu->aspace);
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
@@ -1583,6 +1611,9 @@ static struct msm_gpu_state *a5xx_gpu_state_get(struct msm_gpu *gpu)
 
 	a5xx_state->base.rbbm_status = gpu_read(gpu, REG_A5XX_RBBM_STATUS);
 
+	if (adreno_is_a530(adreno_gpu) || adreno_is_a540(adreno_gpu))
+		a5xx_gpu_state_get_gpmu_regs(gpu, a5xx_state);
+
 	/*
 	 * Get the HLSQ regs with the help of the crashdumper, but only if
 	 * we are not stalled in an iommu fault (in which case the crashdumper
@@ -1604,6 +1635,7 @@ static void a5xx_gpu_state_destroy(struct kref *kref)
 		struct a5xx_gpu_state, base);
 
 	kfree(a5xx_state->hlsqregs);
+	kfree(a5xx_state->gpmuregs);
 
 	adreno_gpu_state_destroy(state);
 	kfree(a5xx_state);
@@ -1632,6 +1664,17 @@ static void a5xx_show(struct msm_gpu *gpu, struct msm_gpu_state *state,
 
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



