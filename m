Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585803;
	b=ad8nJb+hmERGbHOtHhh6gClM5a38oEqoi8yQgKl4ttlgSN1uhIcC2wXEkCZe3Fe/Ul8S
	 +iIGYPtPkuyFgsNUGaSXiuv2ACMDmZaopzK6IT3418//0EpktRCXeWuAgIqynhoWZKVCM
	 Pus6Qc3rNmZ/vP7FHF6tz3SRVPasuq/hh6BDBtKI60sPAwHYTeaDuRL0GWt94Vp4yRaEY
	 lKn4UoJT64YzCvfhpCakoaAycHfwF2N1kI9PEMsV/Ss0uSQbJX6qHmdXY/PHVRYhDZlcR
	 SZC4C3qbvbBiSeRvBABR7ReCjDASxAICx3rsrDIiu8NMcwHQ2aafu1rFGj8Z3lAjkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6+yOfVFDVP0qX0dToCBhXvqcP0Z7LRfPZehG54ODak=;
	b=kBQVB7Q/aLHC2FP9e3LC+J81HBJvlzplFkIgde8ovhd07uSz8quAdyCfD6JXy9Fjbhhm
	 lqLJVpXWywuFEkmtH0ghVCNhvE3bKYTDI+QI9AL5uohsfeMQhaBlEYpts8XhkdZd7DwXL
	 dOxBgfyg9JSOllrJ1GCcotQRvvn+E6IZv/G9V7fJ35dYiycpEQV0LPuvS8CVeOijsirsB
	 YCEXmue8oJlFkknC5aQxu23a78FZRyqwXOWL4/lla14S4bTOlAURBGf9gO09T6Q2Z5Ghz
	 XGN26JpR5lQe5DyYKdkV9tLV97XPNVZva28SwkbSO+bnphDpKekvzPgA7MuJNXd5UOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REl3Omur;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD45606BA8A;
	Fri, 13 Nov 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REl3Omur
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962611F000C4;
	Fri, 13 Nov 2026 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585802;
	bh=H6+yOfVFDVP0qX0dToCBhXvqcP0Z7LRfPZehG54ODak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REl3OmurQka1LUcpwQqFDfe7uW8jrFRC/bMLtKL/qFdGfpTS+21bffKw1JgHvMp3v
	 bnr9q5wxtyW35v7/uWbmh8CweAT9pP+NrVjCei9ck9st5L7Q7G56hBtCfQqO7jitWP
	 vWYffirV6ZoRfzKScOi83WOOXTiKmsPaTYjh98WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 388/507] drm/nouveau/nvkm: clear use.enabled when subdev init fails
Date: Fri, 13 Nov 2026 10:51:32 -0500
Message-ID: <20261113153809.736895008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a1f7f37417bacf2eaf80a8ce6b598b1fa56f8906 ]

On Kepler boards without the video decode falcon firmware installed
(msvld/mspdec/msppp), every other VA-API decode attempt binds to an
engine with no ucode loaded. The submitted work never completes, which
leads to a context switch timeout, a channel recovery that cannot reset
the engine, and eviction waits on fences that never signal. The process
ends up stuck in D state, or killed by SIGBUS when it touches a buffer
evicted after the wait times out:

  msvld: unable to load firmware data
  msvld: init failed, -19
  fifo: SCHED_ERROR 0a [CTXSW_TIMEOUT]
  vo[5444]: channel 14 killed!
  WARNING: drivers/gpu/drm/nouveau/nvkm/engine/fifo/runl.c:117 at nvkm_runl_rc+0x2a4/0x3b0 [nouveau]
  [TTM] Buffer eviction failed
  WARNING: drivers/gpu/drm/nouveau/nouveau_bo.c:1092 at nouveau_bo_move_ntfy.part.0+0x9b/0x100 [nouveau]

Tracing nvkm_subdev_ref() and nvkm_subdev_init_() shows the pattern:
a reference taken with enabled=0 runs nvkm_falcon_init(), which
returns -ENODEV; the next reference sees enabled=1 and succeeds
without running it.

Clear use.enabled when init() fails, so that every later reference
retries init and fails cleanly.  The other readers of use.enabled are
fini() handlers that use it to skip teardown, which they now also do
after a failed init().

On a GK107 (Quadro K1100M) without video firmware, playing H.264 with
mpv --hwdec=auto: without this patch the GPU channel is killed within a
minute and mpv hangs; with it, VA-API decoder creation fails, mpv falls
back to software decoding, and no faults are logged.

Fixes: 8478cd5a740a ("drm/nouveau/nvkm: add locking to subdev/engine init paths")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261101200428.16959-1-rosenp@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/subdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/subdev.c b/drivers/gpu/drm/nouveau/nvkm/core/subdev.c
index aab5a73f467a1..ff6858f5e5d32 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/subdev.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/subdev.c
@@ -157,6 +157,7 @@ nvkm_subdev_init_(struct nvkm_subdev *subdev)
 		ret = subdev->func->init(subdev);
 		if (ret) {
 			nvkm_error(subdev, "init failed, %d\n", ret);
+			subdev->use.enabled = false;
 			return ret;
 		}
 	}
-- 
2.53.0



