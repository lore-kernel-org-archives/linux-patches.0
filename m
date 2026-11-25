Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621584;
	b=lCvouWvn7L/+XgIKnZZCVEFcGOK6rCrTn0xOjyd57GLKFPSVYSlPsBNNPiTR8JBZW4LN
	 +WF5xRYa+n0Baw7S0zQ+/PVaCnlw/7ZMvyr6HFUH/5zE7f1TIXLmNQ7fBJbl11kvLPAPW
	 EBjyXcWjsLaRJxk2hpF6+nG+HqY+ukMx3McwkHlt5U6USjJL/LIPscJ1k4dPlQk/XLG3i
	 T2qs5iBpvEtk7fg4FUKxELim/aqSSm960Ok83s8kbVfqUxhXVXNT3w1z7GH6LBndKtc96
	 bmr+586jCE2nhXWAWmfzA5iWaCnNYw9YMYtig+O8Lr/1Ag0lcPZONowZLgji5ICYDoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p72vMn5nwrs4bCq5rknZ4QV2WK1N84csIu1mpDQj5r0=;
	b=LErwVvDDEfaH1HXQzC0nre/imu2fsub+G4HXeYRQhrMPda1O6oaSoqPfpml8Hs0c4g1H
	 p2p0C/p9wgYr+rWqm9OdAJKB2md55O17dfY6r0wkH1N1nSvh+YHiUmm0TBXSkd9a3LHR8
	 LOQ203YBvA1S9gdwC0ThZ1KSzdhOU8r/eutBgy/V/9beLnmFm0PcYAKiSQeEHijGQzB+c
	 ZGM57KnBkzWQrGm+QhTcqb19AUVj0F3Pfw6kbI4+3mo52VWG2z49ldgH+jCJwo3Dqmkxd
	 AMTD78dpUPvlmG8wNl1fMNWZt4P6ojioa0ZfDzYIy1S7JcKaK1EeN8/32AUap0bUF7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5JGrIQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098F606A321;
	Wed, 25 Nov 2026 15:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5JGrIQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894441F00A00;
	Wed, 25 Nov 2026 15:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621584;
	bh=p72vMn5nwrs4bCq5rknZ4QV2WK1N84csIu1mpDQj5r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5JGrIQC5hO/l9Fd2Fejb9xiSt0g8XbkXu+y56j2PUC9FBNhR8B4oK3La5dhEdx4J
	 lNoinbQhHP/kuwhtbCB3qK/ooHe9H/mndIdNdeSswbJavMt5ZwqkT9ey46Oj2wFIf+
	 n28h1Er32opHgm6r/acraS9vL64Q1G3zFzVOd2L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Munique Feitoza <muniquefeitoz4@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/990] drm/nouveau: Fix CE channel creation on pre-Kepler GPUs
Date: Wed, 25 Nov 2026 15:27:20 +0100
Message-ID: <20261125143828.484464321@linuxfoundation.org>
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
index d05da2db94a44..d4fe0e4f07985 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -336,6 +336,7 @@ static void
 nouveau_accel_ce_init(struct nouveau_drm *drm)
 {
 	struct nvif_device *device = &drm->client.device;
+	bool priv;
 	u64 runm;
 	int ret = 0;
 
@@ -348,7 +349,11 @@ nouveau_accel_ce_init(struct nouveau_drm *drm)
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



