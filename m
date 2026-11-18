Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037846;
	b=e9GmRQT7LCkqnboK2OrtvB1bOyfwlgRT+Ldkb+FQcFmOb1L1dgFhJJjGrQ968GOsG4B3
	 TsuSMjfLQ6ZNrTx/mjou9lqdWMhvNMG8ECNNGCslBTJm036EnoXSOHK6ke5Fi7GR85O63
	 251XTGD/pTL+cO/VU/2KYmJq19ewXuuPfoLqgiVUosV8cgGy+/kUtHem7QGod2PFtxi1n
	 nXvJX7f2zVS1zpMUs7IQhSE0O1wa41PK79Z6qBd6iKluu1akW11T6P/VqbDZRnL9XbhtL
	 vlXCuZJSjI9qvuQOV11wjk3sfGg/tDMMJj992Nbq9UDp455cu1R3cRftIc1pU9oa34Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFs7ZLAwbpW/bLLmiOMoDKQDgTzl5Gw3tfZedv20EtY=;
	b=TWOlcvqfprDXFui+7SijSQkqWDPFW6pFn7CQrpJwBODo3noECrmTRx7z7NLEpm9utUIR
	 cBBPkP9eUyMiFlP/Tdks0Tr6YkdtSo5FONatODLlxl/m7nUpwJm5aQ6TR9Wh1I5Dy/sde
	 ZsTh17nWQZ3CoG75FjPdpfSlZwsS1UdfAgKxIUl0+3Z0VgMOMbtoK/k6tiD/rocynxwnj
	 3hNwQFgJJR/8khMpyIL0uwl9Rqbb9rV+uInLW143+e34a685h8LcCFcIeAY3Da2fRIoDH
	 n633JHak5sZEo1gNYNVHIm50TQVi7yxakO944Gm2Gu5nNKUg4anMTA4TDviWtHYTCRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOqoNt2s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED70B606A32C;
	Wed, 18 Nov 2026 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOqoNt2s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE661F000C4;
	Wed, 18 Nov 2026 21:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037845;
	bh=DFs7ZLAwbpW/bLLmiOMoDKQDgTzl5Gw3tfZedv20EtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOqoNt2szVWHGXMOLONeDpP/JXBVQytRRKZ+VSZrojBPZJ/bEMwGbUmdscSmBfkA6
	 WxIg5/C0QrWQ5oHpjOPESTckW1Ap7oWKeCSpzubhqRjS/D662v5JkaLUkvI8L9ULAO
	 bTvsvsPoQzsq0VKbCrH6gO3CPaEVnH3Ijt+RfPaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1538/3318] drm/nouveau/nvkm: clear use.enabled when subdev init fails
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150407.114975593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c20e827a069a..3ceca50fd8d43 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/subdev.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/subdev.c
@@ -145,6 +145,7 @@ nvkm_subdev_init_(struct nvkm_subdev *subdev)
 		ret = subdev->func->init(subdev);
 		if (ret) {
 			nvkm_error(subdev, "init failed, %d\n", ret);
+			subdev->use.enabled = false;
 			return ret;
 		}
 	}
-- 
2.53.0



