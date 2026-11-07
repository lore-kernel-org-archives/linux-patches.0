Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060800;
	b=MQmDtEjW4LsYX+6jYMXTfEl3eSpei3BGPMbhtvZ4/FXghsBn3U4QnWym2ad3MmXEjgB+
	 AjII1YeajANLvOeMbgnJkBl1G2CEXXmfsXrVE5lrVp/caUJTu06zgnU2k4E1ikdaimD5K
	 ChxfiMfERHPXNYGHVEbffxIzOnwGGS1WS54CBAUqyMd7vBHaMK56yr9SnIPzEWhKG9nh9
	 KUiGPHRJf8O3hy/pBjmTAQ6ErZt1nV2hhf7KocXPLV6F72FCEFD1T2fmEjwPMgODC+tTh
	 NvZRmahgpGylPrbWlw0CGznl9BhDwDC+UYHPyGfqk1YOg4GVLLEDln+DiFlOmvquVeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEa1H7qcjw1OMZsP02a9Hajqe7jbvw55axDdvY7NmoI=;
	b=fhi4XAOnzd9MHnPxsZlSTSVOBwc5ga0jD8d3pqVwPQNnJqROyEdy82PIcEwuIlACIdoi
	 EfYLiB6jgmVKlcq4tl0TMSJ1LQR+2iJlo0BafJSr1K5jXuk5CpsbUvod9S9Z7hJK0qmr/
	 87Fnqn5wiFeC0oDLZXVlOsRqxXSvcO/2HOpsL4/4DeN5n/QsCBXyfWFy9DEvyLn0AV1f9
	 OvM1ehOYTWv7EDxMBHTvCVeCxYzemXPobkhJrWejrJtqS/Jtxdxd2DsZPSeXxZkaP884f
	 4aVlm0EiP1ogTxtD4iBsIaiU1jExfIeEA56fM0czvM2dMI8vJ3cv4odVjg5MGd0jINA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DztaSxlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00B2606A326;
	Sat,  7 Nov 2026 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DztaSxlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0111F0089F;
	Sat,  7 Nov 2026 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060800;
	bh=OEa1H7qcjw1OMZsP02a9Hajqe7jbvw55axDdvY7NmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DztaSxlKiwsjhyq+6BfKqP9hclDEtNvyLmWaemo93fh8T5Tb2XTt4YgX7Gml2PlIq
	 fm+fToC/V4KzTX91pS9O9mNlsvOFQLfvMnk5JWWy3GfZK5ehkLDgBlpHoz2Q5ByMin
	 u6CVFJuXY2cfVag6hE/ud9Xju1XrduppLRRm2QyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0200/1536] drm/etnaviv: force flush on power register ops
Date: Sat,  7 Nov 2026 08:36:56 -0500
Message-ID: <20261107135003.278572661@linuxfoundation.org>
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

From: Randolph Sapp <rs@ti.com>

[ Upstream commit c182a2ae13886463f7ae36e034449477306d182b ]

Add gpu_write_power_sync to verify that power register modifications
have reached the endpoint device in sequence specific sections that do
not validate device state.

These sequence specific areas have been detected experimentally with an
am57xx-evm through numerous boot and module load+unload cycles.

Signed-off-by: Randolph Sapp <rs@ti.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patch.msgid.link/20251013170122.1145387-2-rs@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 10 +++++-----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h |  6 ++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index d2f9ad9d9e89d..919bf6b38e8a7 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -519,13 +519,13 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		u32 pulse_eater = 0x01590880;
 
 		/* disable clock gating */
-		gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, 0x0);
+		gpu_write_power_sync(gpu, VIVS_PM_POWER_CONTROLS, 0x0);
 
 		/* disable pulse eater */
 		pulse_eater |= BIT(17);
 		gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 		pulse_eater |= BIT(0);
-		gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+		gpu_write_power_sync(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 
 		/* enable clock */
 		control = VIVS_HI_CLOCK_CONTROL_FSCALE_VAL(fscale);
@@ -619,7 +619,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	    gpu->identity.revision == 0x4302)
 		ppc |= VIVS_PM_POWER_CONTROLS_DISABLE_STALL_MODULE_CLOCK_GATING;
 
-	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, ppc);
+	gpu_write_power_sync(gpu, VIVS_PM_POWER_CONTROLS, ppc);
 
 	pmc = gpu_read_power(gpu, VIVS_PM_MODULE_CONTROLS);
 
@@ -663,7 +663,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_HZ;
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_EZ;
 
-	gpu_write_power(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
+	gpu_write_power_sync(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
 }
 
 void etnaviv_gpu_start_fe(struct etnaviv_gpu *gpu, u32 address, u16 prefetch)
@@ -729,7 +729,7 @@ static void etnaviv_gpu_setup_pulse_eater(struct etnaviv_gpu *gpu)
 		pulse_eater |= BIT(18);
 	}
 
-	gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+	gpu_write_power_sync(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 }
 
 static void etnaviv_gpu_hw_init(struct etnaviv_gpu *gpu)
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 31322195b9e41..c9f26d86f26af 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -201,6 +201,12 @@ static inline u32 gpu_read_power(struct etnaviv_gpu *gpu, u32 reg)
 	return readl(gpu->mmio + gpu_fix_power_address(gpu, reg));
 }
 
+static inline void gpu_write_power_sync(struct etnaviv_gpu *gpu, u32 reg, u32 data)
+{
+	gpu_write_power(gpu, reg, data);
+	gpu_read_power(gpu, reg);
+}
+
 int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value);
 
 int etnaviv_gpu_init(struct etnaviv_gpu *gpu);
-- 
2.53.0



