Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052205;
	b=yCBDipR7KLh26wXHjzJUGIuhHQ3W51NyZ9MJ1uunOtQizqMGtkz7QZPf+lVT9Mn0JoZ+
	 e6oVE9+g5ixXKLWp1fS6apTvUeZTk5HMZx8ERbsyylCHP52E6zgZiEHMap0lq2XAkZoEX
	 pTsVHkCKxvYCKU2vHueVnZPBZlDXzHU6M2BGoUJM/NPwz3Ssd+VV2aY5Bs/BXhhUIm8ek
	 H1oyHj923ol0mkZZe8rIyNxJXDIZyTgN4AvaDFDUh00m9hWJDpmqlgUo0RWWj01m73ECt
	 So+gwAAeAttE+m2KLEXnXZtgUqk9WkKzYb6YslMHuL9N0jypY+mHSVLVG3MrpFXloBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3fYkxaef1jk1nEBWUAeOFDnQfnyhPBa9Sadi5BHdzgs=;
	b=zFGQX6pD76y4HZolGJwZtCbES22aqqO2pTpY8+YjF5P3Lr/wcam32Tb6ICl0qusEM/zy
	 IJQ8ZpV43qZmW2IkpH8hKBd/DqoHUWMpjhBmtA/xAbr6gIS6q4oxhK2zdevz4XT5iXNFD
	 DPrCwRmlc5OEoC3zEzAzwRHuUp5pPkBb4TYkrLXTp6oevPsRvl/7Vg1A4tLiuEs/HeIZk
	 IOCcAsujs038HAKwYnrhAqWurx+rM/2KWSd/xPHrY6feTesRe0zCXwdYah2sTgqO/KHJ0
	 4aAhnT4vjrm2RzZ/ODFv+4R4dlQH+tGP/5kRb1hx/W2dHu4diY08+WZVF1yxxjHUfGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rg7jYcub;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97352606A320;
	Thu, 19 Nov 2026 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rg7jYcub
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D4C1F000C4;
	Thu, 19 Nov 2026 01:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052205;
	bh=3fYkxaef1jk1nEBWUAeOFDnQfnyhPBa9Sadi5BHdzgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rg7jYcubEJu0tAkofdqNIt5ChTg+U1hI5BSdejcsfE4XckGss6szWP8XYXqqye7Z2
	 pmyNxjv3SthvWlc06QesB74OX9KiPDnrS+H3nOuIZw4VvnA1bpgBNx2Gz9VSkPqGI5
	 Mgf8bQ+oYWXoRI7EWWx3goC7mV8aEsexIArBwo24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0482/2214] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150030.475946852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7aef1783c5f07..3ffd57053d110 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1603,9 +1603,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
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



