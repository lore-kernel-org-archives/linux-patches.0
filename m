Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829619;
	b=e1QD7NLnw/nfeARHSWOtmFqmfYMlpGMzCjQzPVUuN2znHxR5QIzQJHPcUwfOyiRZ/L2/
	 uWyPMOXeqrofCdB7m5AcKj9P7Jk0yofn0VW09TmUe8JSK/L8ZJJQl64s92XDOp8xzPQ8E
	 38O0QoOzKKCT48sLC2Hezw4CJ7wx6SjEwjqrMvC3C9l7tHIRToL2QcECvHLmww2X3HBnB
	 jRQJUSsOP1VQDJfYYAixaGrftzqMZdavu36vTyiDkJBk6GNV7uYvnTm0ddrQUQS3/VZ8v
	 Fs0kRh5yA30kmrOjNGJcnvLldn4hp17pNvDWfjBOjpBnN1XDQIfQElCXOies5O1z9Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KfdOTwhGY+UHd8Jqu5r1h4LYUGykcSRZALCpXTmsh+A=;
	b=ScFeG91/O4mG60WoTHK3ytbYqVv9qYKoVgFWbIByGjmTSimLP4VRCvEIE++DwISAJgfk
	 AT0hcp46Ls8FZjbf5u7BkJB6lRMheZtGgY2KnVdUYT02400anXT4rDfCAzByJzMKtjDEe
	 PiE9Y7U4gp4SzJhnLZmdtPuFTjYVGbsEh0BcYax561cSXbzfLk6yp0kMjErFPgNLlz1YR
	 XdUxwE/ptZEaczrv5W0H40m5HoUgVQRTqSAlDHNuAWJFfnp19iIffGA0v80f5rLi63oZV
	 NVtm3n3fhhj4vjHm7EEWCnSoNmq8iC3pWXQ5taJIOI9qFMrolLSN4NB+whDKqpjGERw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXOMOAc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963DF608C98B;
	Wed,  4 Nov 2026 22:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXOMOAc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305CD1F000C1;
	Wed,  4 Nov 2026 22:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829619;
	bh=KfdOTwhGY+UHd8Jqu5r1h4LYUGykcSRZALCpXTmsh+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXOMOAc3pPllIuOY2tMnLBI95qIn/Z5uxpjl9vex3KrSjQt4SEvwFh9oEYc6cvbuU
	 wLeXEc3dYanyj1u0mnDhk/zR/EnH5crRfjK75aUT5y2YA97y4h+nLPbOJ9SVFbQ+WE
	 otPYCyjiq9QXObTyGXbZ+HRp3UNMv0tdT7GaiLos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0238/1005] drm/etnaviv: force flush on power register ops
Date: Wed,  4 Nov 2026 15:59:31 -0500
Message-ID: <20261104211050.518208383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index daba33052f524..e81383c5bb1b4 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -543,13 +543,13 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
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
@@ -660,7 +660,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	    gpu->identity.revision == 0x4302)
 		ppc |= VIVS_PM_POWER_CONTROLS_DISABLE_STALL_MODULE_CLOCK_GATING;
 
-	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, ppc);
+	gpu_write_power_sync(gpu, VIVS_PM_POWER_CONTROLS, ppc);
 
 	pmc = gpu_read_power(gpu, VIVS_PM_MODULE_CONTROLS);
 
@@ -704,7 +704,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_HZ;
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_EZ;
 
-	gpu_write_power(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
+	gpu_write_power_sync(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
 }
 
 void etnaviv_gpu_start_fe(struct etnaviv_gpu *gpu, u32 address, u16 prefetch)
@@ -770,7 +770,7 @@ static void etnaviv_gpu_setup_pulse_eater(struct etnaviv_gpu *gpu)
 		pulse_eater |= BIT(18);
 	}
 
-	gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+	gpu_write_power_sync(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 }
 
 static void etnaviv_gpu_hw_init(struct etnaviv_gpu *gpu)
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 5cb46c84e03ac..e89d591d7404c 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -204,6 +204,12 @@ static inline u32 gpu_read_power(struct etnaviv_gpu *gpu, u32 reg)
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



