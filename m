Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618501;
	b=dKUr3DVmBuUwbGx23lME0EmvhyiyCtjFxTaDLIOLzzCPYA3+zLoUkYJL/5Mw3TKvjHFG
	 0WezPizCmTXLpwLD+nQ4JmIOsl/a0DoOw3Z2yC/eV80bhKzmU9jhUHs9ArMGG0CxEbQ2u
	 eGVyfykMCxh+zU2NDRl80SwZ2EB/e6K/bIoC2gpTN6Tb/7gAS4VDeDsrDJ/qJqDfwedDq
	 ZZ/TfXZAMflNtWmqV4CXT4xHTaak5F8MG8UO8bqaieKnBlavzCcMfug/alUC+WIa1DFxY
	 A96fw+U+GQ/E1F4hwNIgy//uR0OdOORgIvYqFGPWtsZ9IGFUGlJlPEO/YBHGAs9SFmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rq5WYzuQpXn6rHjQO/Vs6iOjUXlK2zQOdchMNwPc8y4=;
	b=yVSP+tmfcuRCJXGg5vuVGvAEMgbm7w56MZFLPFXh6kECo4nHSpTz+T5CiRThUY/Ieoh1
	 eXrc+mmmGdMU6IjTAwfzr9SKo3pdeIvdnsPdkepUBD8fI2NxDkS/RrqohDmRPll0cmBoM
	 SEJwwxG2Q3MDhWbPrkpyCPiob+CPqJMQJCcmKwqO0xi1OQcBh8vwdpHGvvdKBqj14bLmq
	 P7o9s+gsV15yBlWDY15rl4Xjaeg8EmBLDvRy794UnFfQzK2XLufzebEhc1rivWoifI+5t
	 veT5VLTcD6zEhgEp8t22diAMzBtWV9YZwA3wVs1kcW8Zj1JxQ2IgntMQCHLQFfPv8Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThG73VcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A31606A31E;
	Wed, 25 Nov 2026 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThG73VcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08021F000C0;
	Wed, 25 Nov 2026 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618501;
	bh=rq5WYzuQpXn6rHjQO/Vs6iOjUXlK2zQOdchMNwPc8y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThG73VcM7Z1GxrLrBX/TglAHl0KrOQdI+ZgCZ2TPwpRlznho/WE8iUcxo0/7sZuUV
	 5Rpye4U+aSUPi0JaUkttH6hpiI2uP0PKQloR+m4l6Km3Z3CV/O32FREwOUYt9Viq8G
	 mQ8gfZ/yHKIwMQKR0qpoxCZ2QyfupuXFU5aVK57A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Munique Feitoza <muniquefeitoz4@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0299/1005] drm/nouveau: Fix CE channel creation on pre-Kepler GPUs
Date: Wed, 25 Nov 2026 15:27:17 +0100
Message-ID: <20261125143828.740411666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Munique Feitoza <muniquefeitoz4@gmail.com>

[ Upstream commit a2b7b707d75e605d31fb3d85a6b27f8bb2a01413 ]

Commit 04e0481526e3 ("nouveau/dmem: Fix privileged error in copy engine
channel") changed nouveau_accel_ce_init() to unconditionally request a
privileged channel (priv = true) when calling nouveau_channel_new().

However, privileged channels (func->ramfc->priv) are only supported on
Kepler (gk104_chan_ramfc) and newer FIFO implementations. On pre-Kepler
GPUs that expose a Copy Engine runlist, func->ramfc->priv is false,
which causes nvkm_chan_new_() to reject the channel creation with
-EINVAL:

  nouveau 0000:01:00.0: DRM: failed to create ce channel, -22

Only request a privileged CE channel when device->info.family >=
NV_DEVICE_INFO_V0_KEPLER.

Fixes: 04e0481526e3 ("nouveau/dmem: Fix privileged error in copy engine channel")
Signed-off-by: Munique Feitoza <muniquefeitoz4@gmail.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261030202809.28723-1-muniquefeitoz4@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 2c7077a49888d..6424d0fa1f39b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -337,6 +337,7 @@ static void
 nouveau_accel_ce_init(struct nouveau_drm *drm)
 {
 	struct nvif_device *device = &drm->client.device;
+	bool priv;
 	u64 runm;
 	int ret = 0;
 
@@ -349,7 +350,11 @@ nouveau_accel_ce_init(struct nouveau_drm *drm)
 		return;
 	}
 
-	ret = nouveau_channel_new(&drm->client, true, runm, NvDmaFB, NvDmaTT, &drm->cechan);
+	/* priv copy engine only works on kepler and newer. */
+	priv = device->info.family >= NV_DEVICE_INFO_V0_KEPLER;
+
+	ret = nouveau_channel_new(&drm->client, priv, runm, NvDmaFB, NvDmaTT,
+				  &drm->cechan);
 	if (ret)
 		NV_ERROR(drm, "failed to create ce channel, %d\n", ret);
 }
-- 
2.53.0



