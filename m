Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063956;
	b=3eIzlcoel8NvgBoB6Vxdsn3XV6fxPAUohsAcFqihOkNFLgGu4V5TmGo60obmHaBYjyFA
	 AG9rC7Wun3hyGMe3/5GG9FCCtzc4zPL1kRNJZL0uRSxK8fIS0oSEjWS7FylY5jUAuIZe5
	 wf2wvYi1sDk9HAGe2aAcevU1+VgpEndUrJq8xISO6OjVA4+LWYpsv1aW9wdljnGIFtmYw
	 2E6NVvtCuzVpPgq8v5jbv/kVok6WHcFdtipbWB0ZuqrgYnL3cHbhEBvHWWJSFZ0nvls3O
	 DcyOBJPGN8F+zaMABJ0gahO7RTbFWHUdpP+A2T7/A7Z95ZQD+Von5UDg5jikKvXxojQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4up1Lwv2yuBL6aszzUL/P7krhsObhItFNWGxao9KgQ=;
	b=AerfiKVyLA8I9AX1/VREgvxI0n533ndHmKgkwqNkhdgRPnq9jrdri/mofpdmKAgv0Q1c
	 mmrc3im2rF6T2HCg1tR9pvjkacZXbVaxSr9J4frMUPQmxgP8IiLDc3WykNM6QEz1yFtMP
	 ogKWNsOgb4Cb9WMNrSPrNYRwtEoqcsrIIEydnxQmnHDVxrUVLuD6FA6rlwxkgIDL4wv7X
	 AtQ/CUE0VloRreDxmNt1VvEe5FAD67824RKooS6/nvst993NUhaBUqx5kTkY4lCq20Hr7
	 AHJ7QoLH/fsP8OIb0bvQjMZPoW1PB9GspRtuhdc0DGpuLmDITi+a7+q+T5peFSNrxHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBE2d2lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487B9608360F;
	Sat,  7 Nov 2026 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBE2d2lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABBB1F0089F;
	Sat,  7 Nov 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063956;
	bh=G4up1Lwv2yuBL6aszzUL/P7krhsObhItFNWGxao9KgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBE2d2ltfmQNWNRmDN41EIixOGKWzwuy8x/FQegVDld2rYp+Ef01tQuuHN1eHC7gd
	 kHdve21aERqH4SAksBto0B82U2nv2lP+mEXGePYuXPeiOLpGtEBXmv7sjtaMwWJDbO
	 ee5YKINVYCeQC+hKSK7Cnn2UNSA9RGdyWu5iGZ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0145/1257] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Sat,  7 Nov 2026 08:40:41 -0500
Message-ID: <20261107134943.316581924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 27953c044974baf7e24dee3e9342fe0103dea80c ]

The stateful decoder leaks uninitialized kernel heap memory to userspace.
A process that can open the decoder video node gets it back in the CAPTURE
buffers it dequeues.

The reference frame and the compressed frame buffer are allocated with
kvmalloc() in vicodec_start_streaming(), and the decoder can read them
before they have been written. The first frame is allowed to be a P-frame,
in which case it is decoded against a reference frame that was never
produced, and the padding rows below the visible area are never written
for any frame.

Use kvzalloc() for both allocations.

Fixes: 256bf813ba39 ("media: vicodec: add the virtual codec driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 25ec3a43fc712..7ea024b14f0e9 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1605,9 +1605,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	}
 	state->ref_stride = q_data->coded_width * info->luma_alpha_step;
 
-	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvzalloc(total_planes_size, GFP_KERNEL);
 	state->ref_frame.luma = state->ref_frame.buf;
-	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
+	new_comp_frame = kvzalloc(ctx->comp_max_size, GFP_KERNEL);
 
 	if (!state->ref_frame.luma || !new_comp_frame) {
 		kvfree(state->ref_frame.luma);
-- 
2.53.0



