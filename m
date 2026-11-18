Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044985;
	b=xReC8R9QIpRBGiEzIbtuFW08UkkdrtvX6WAb4eryA8VvLXQJYfawdMKSUIVhzefIfaNg
	 FCun2yYoIsQ/6VNC9ExpUKVBYST5dyLOHFzcuonO+5KeAcckBJpYkSdrOEUKtK3CeNCBq
	 HrWYXfmGpvQQfo9tC9f9YcOG8uIe3Q0pj5ZUTOX0Ir3EvMyWJsQw+kZjx4Kui8fddUqNo
	 nfjG/eTjx6fPuAP468FtQ+FqRcFnfV3gUAZvYujDbjtdpP4T+HlvN1oLDsZNqn3BDQBuL
	 TZ0PW50zgwCGntwsF7cWxD+fLwEmvJvzD0JDIapJ1ZulyfSN73xRMa9DG2FRUQX2p1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HyEUZQdzraFOx9JDlBjh3DdsZ3UNcVD3eH8PUjswbfw=;
	b=elUByfwp3wcNfT2jOh9cZ0RWtdDkvPWp32HOq/JZ+6GfeFsAztQuL4LMzoXsyf+NNZNY
	 Ugb2T+QwCa3AmDo99CVDZRPRTgUiL9hd41Fz6dH1c7GK1SRgFaqlW61IuzrqzUSqko0zY
	 oQZoM+OPxkntEgxifjf3NtIdD2q6DTH0tQLBPvikAlyk7GS4ZEMQMUWx89OFs4z+MPrRI
	 MNljb0s/SEe9/6aWYdtJ1l8jx2VMgFy/PgyYKeKwtc/+VmQxbIpx+DrEO63Rctlw8hlQa
	 bSXBJ56W32QnUHihKTeKOlwTM722JQI0/5y6FFZ2BdzMoiP1E8GNOaownbDTqxPNxrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pen9Acz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE81606A32F;
	Wed, 18 Nov 2026 23:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pen9Acz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F51F000C5;
	Wed, 18 Nov 2026 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044985;
	bh=HyEUZQdzraFOx9JDlBjh3DdsZ3UNcVD3eH8PUjswbfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pen9Acz/ebN4hUdBqm41A/HlURjSdcN0AJxptnPFb9FZt49i55UnHgqixwuKuY+91
	 zTmrpYm7HpsjdckkmikEZRWSS9I0KvAbElnSuQ2CGJsuEigJO3QAs2dGScMY9i0KMg
	 0mOhpF6CBiqlgwUGu/v064EiJqRORJjOJ0O57bzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0761/2857] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Wed, 18 Nov 2026 15:29:55 +0100
Message-ID: <20261118150228.951090850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4a1c57b48e203..fb55908d9ee96 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1599,9 +1599,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
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



