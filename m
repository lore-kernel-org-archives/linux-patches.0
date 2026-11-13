Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590469;
	b=IyJnpgv8uQTcstL3h7sDKJYQxSNJYd8LZk2WEqU/WSYmXPq5ZY6heWhTdx/RxDFSYut9
	 /owVtdu1MkefsKdYQipo5nbs7zqF1alxnN3XwFv4wCPXZp0ZXleMlHPGgW05cJKlV068w
	 2xNyK+2mOkDggduHrnmzIXCq+CD0Au3Vbwvf015ddJ7uzk3wIO2tY57YSXILpmLIvORU4
	 PBtIj5vO9MH9KAFzPz1RlN2OcBBRLzS50COi+NarqyIMenpd/9KhmVLgHJAL64yvvO0pB
	 AhpHkZ83OVYopqkRvkewmz/V1LrduA50cVuwZ7H8vtyfu0RRl0yoU/0AECIbkuR4Xkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDad8mGBRHxMXd3K2Vbse7O5MzHTZiYqsEYY8Uo4fjs=;
	b=0yAMb6Vv74TPw2lsdh5wlDgocJNQjFliWRYAVMSL+fZyRlbQ8bW4HLVL5KnYbl4ciZbj
	 3W33q9Xz4fkZduXRxcgBRjdRKoFKdQgWWH1rQxQaQ6Qwj88glBy7tOvVhOcfu9tl3FdbG
	 WeLvk4gQ0ekhPBE80nANuFzFBYhYQNnyur+eLOpFS9RBmJzHAKnZelctGdipoOyUgIYs1
	 qWH89Y/+mqKhjB92TCG0JIZUsE9gFsc7eVYsf9b32KykD5VvA+d5fvfaACfYNeFrCwUJi
	 pgywmsNJ03RHuvNbjLAjLXmgE1ji9yBTXgD9U9Fgm1mj8YOn+fiR2No+0O5+0BSq6tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALnpZawb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583F606A89E;
	Fri, 13 Nov 2026 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALnpZawb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A931F000C6;
	Fri, 13 Nov 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590469;
	bh=zDad8mGBRHxMXd3K2Vbse7O5MzHTZiYqsEYY8Uo4fjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALnpZawbGRTQY+IATNpoGtuUHbkHxKD0AYkoy3tkbNSZ/l1CeUwmV7wr5ennlmVrE
	 NdxSDaJtGX2J3AgkD95EGh+xaCYwUk2scb617pER1d/O4UkUco7G7HuuFG7e2DGYFg
	 khjbmBvfBJLt2GcuBqv7XjMgl39QQCfugWreczGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 424/686] drm/nouveau/nvkm: clear use.enabled when subdev init fails
Date: Fri, 13 Nov 2026 10:49:17 -0500
Message-ID: <20261113153835.309023606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index b7045d1c84158..8c9e3427bfc06 100644
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



