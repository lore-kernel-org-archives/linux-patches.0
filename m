Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624531;
	b=uda43IFo0cS4mCq69zu3cQ99yGDpZf/qFz1+e+B/yKpAN4HFzBSc5UdBH57l5SztpRLc
	 Cr5GBPH1PJwtKBEsRc5htKPsfwzDbagnbhbOSXsgCg4h3gWWsOR+/kbKcqIcocemGll8L
	 s8hL9poPw2PWIV6OHRPqLw+F8XM0UEpzHjX7rz98b4/E9IcsZvMszmFgc1Rv6tNEeHjPA
	 tBG4NUKsS8lLXE7nwaEiAAT2eMAeimKVXm6gFtpdR+DPd5f+b376GQ8BPiDBpCbPBI4d8
	 L7nyYfylnGBvamXhQTZvfrEiuHcAjuHxqrDe0Ggfxw+ggLizmu6dODbsvGq6j5XbjyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNsft8Ca5cFIMPaEV9NE6ti4ZPxWPFMQ0BvtURPWCrY=;
	b=VGr4syhKt3ebe/JHhjvgXFLisXQBdIvevNPpxrwMhKqUaesrRdaSv+Oi7MUo5U44NtC6
	 25lgEnkYAnJniH7RFtD/Z0e8/KYigor/yDbpQPQ74ux+FyVbmh+/UZ3mWN4DDsw3rkw0D
	 KlG53H/lkEIHgzXEEQ9IybLcGmp3Db9c/6K1Y60c2E+S/Ge0BvxROw0irb4QUrM4Onr9G
	 AUbNRY3CMNBk1btTj41/fY3qJ5y6XQsGXNn/fDL99dA7d/KLyO/8Z/WUZmyE6UHbOy0Ux
	 9hLRXo+aYWkglR32rmbRVLs6PT4MouRHD/VS+u/o655tcS70FaZMM25GIRH+k4UOu2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hikhhcD1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D5606A33D;
	Wed, 25 Nov 2026 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hikhhcD1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A881F000CF;
	Wed, 25 Nov 2026 16:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624531;
	bh=NNsft8Ca5cFIMPaEV9NE6ti4ZPxWPFMQ0BvtURPWCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hikhhcD1BWUKX+wFuaUg0Zhr/dwXo9S9JQiVmCG9qzUM/7eFKsOlf/eSUzSLSVlZo
	 CoKf8kcbtvKEofYbPznVvEs97X9F1VIaP2il8Dm6IUe/F5C/JjacCyf2VIBnvQdYG6
	 2u9NqNRxR3/VkqTSSUJEkBBZKW69ZO4Karssjb/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/816] drm/nouveau/fifo: map Kepler video engine contexts non-privileged
Date: Wed, 25 Nov 2026 15:29:29 +0100
Message-ID: <20261125143854.321230992@linuxfoundation.org>
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
index d8a4d773a58ca..1a5e54f5636ed 100644
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



