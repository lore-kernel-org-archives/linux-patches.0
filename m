Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621580;
	b=OSrm/pACXBdfGRshl2x++RhSr8e8zJI+30kyURYxl8wyrZewDQ81yZToAikQoVP5TXa1
	 Xy7IQqrZJ5wwEdRl4VhHUQsOpj4bBfHSxZ/5H11DA8qRrLboK1oAI5KFIkSHb8GXHGsIy
	 zmB2kT6k74KY/aJd7LjXlTmAbh9aSkMXH7EDushs5V7Bae7JYSwnX+LCG9/VlusMcFcUt
	 g/Xg7z4DwkAjTCAEWamGEANGkVUD1G5VvexJJS5FJ+yA4M1LUTFDUXxKeTdV2xxDMPSYB
	 YqG3i660cGb550aA1mamRurvhXgPcjs2PSHGj9rZpH4NXI+Svjdy6fFfkdZ0+1sTnUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzaeM/lVTg5dcDxrX4AU67Dj9Vo88K8gR/G/nxIaj0M=;
	b=BdBCJq1QqFshsKAHPkHiP1rCnGgzF4YhtHjPT1JGWx/upRk1H8Ezqniv/We5gcAViGYK
	 L7z5vF2cs/aeMO4tWuMndt5QDx4BFkJtkcraE3i9pjMXOzhjz7gPw1hMpDPS+YvxUWFGs
	 Re8dWmZd1aSunjvzTNGpUJaOa/XmXwO/ED7RLrArP7MzebvY12Lic6VDCDH7qmvA3qYRp
	 FbL5T6CZvmYs8qX5nvuXWCccYX4cwUE7OlhulIaB8+bGWz08rrKW2x8aZ073Gs0UkF39y
	 kKXAx0A6Za27+i5bcnmW6T7znkKkF1pv6zp3aBy1VRQil0PrpaxwRU4fo069wuWE3bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4k72OYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08D606A32C;
	Wed, 25 Nov 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4k72OYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C261F000D3;
	Wed, 25 Nov 2026 15:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621580;
	bh=TzaeM/lVTg5dcDxrX4AU67Dj9Vo88K8gR/G/nxIaj0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4k72OYhWpSkA/JquWr2ShkNaaxyXYDV8t8mjqWaObxLN8jQ1oW/ma5P9x+JF/Ak+
	 gRYRgmsH0XyslQAb7hRUvJAjYcH0xu6tNYLcMYJpIHj6twtqv+JZGva6HxUWrDrZrs
	 4+MFh4D95FoGhU3Ja0IwD0CmLFqYhh+hKkjfMm+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/990] drm/nouveau/fifo: map Kepler video engine contexts non-privileged
Date: Wed, 25 Nov 2026 15:27:19 +0100
Message-ID: <20261125143828.462458443@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0820004c342af7ca1b01d0b21e0d5d99ad5c10eb ]

Since the engine context rework, gk104_ectx_ctor() maps every engine
context into the channel's VMM as a privileged page.  The MSVLD,
MSPDEC and MSPPP falcons on Kepler fetch their context with
non-privileged requests, so the first method sent to any of them
faults and the channel is killed:

  fifo: fault 00 [READ] at 0000000001050000 engine 10 [MSVLD] client 0d [HUB/MSVLD] reason 05 [PRIV_VIOLATION] on channel 9
  fifo: fault 00 [READ] at 0000000001051000 engine 14 [MSPDEC] client 0b [HUB/MSPDEC] reason 05 [PRIV_VIOLATION] on channel 10
  fifo: fault 00 [READ] at 0000000001052000 engine 11 [MSPPP] client 0c [HUB/MSPPP] reason 05 [PRIV_VIOLATION] on channel 11

Before the rework, gk104_fifo_gpfifo_engine_ctor() mapped engine
contexts without the privileged bit.  Restore that for the three video
engines, and keep the privileged mapping for everything else.

Fixes: 8ab849d6dd4c ("drm/nouveau/fifo: add new engine context handling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261103221529.585436-1-rosenp@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c
index 5655eda52a7b5..912eb6c3a13d4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/gk104.c
@@ -180,6 +180,19 @@ gk104_ectx_ctor(struct nvkm_engn *engn, struct nvkm_vctx *vctx)
 	struct gf100_vmm_map_v0 args = { .priv = 1 };
 	int ret;
 
+	/* The video falcons access their context with non-privileged
+	 * requests, and fault with PRIV_VIOLATION on a privileged mapping.
+	 */
+	switch (engn->engine->subdev.type) {
+	case NVKM_ENGINE_MSVLD:
+	case NVKM_ENGINE_MSPDEC:
+	case NVKM_ENGINE_MSPPP:
+		args.priv = 0;
+		break;
+	default:
+		break;
+	}
+
 	ret = nvkm_vmm_get(vctx->vmm, 12, vctx->inst->size, &vctx->vma);
 	if (ret)
 		return ret;
-- 
2.53.0



