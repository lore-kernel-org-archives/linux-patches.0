Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052255;
	b=5tWvbHJ1OcVKXIV2uG0xuhS42AVTnZAZDs/wx30P7HNRjpY+zUCab8CUeIFX6HZp7JHB
	 0UcIiY0Y9rVz3mlMhb91DRXEFQtvv1pX0E8jwgBtkwgEfl6zlIP4ud2iB7OZfoK9rB2ij
	 w8nuIQJKF396pfsyGdkefu+sw50OwsCtaqQkPb+hbBQX/Mj2BSUJn1ANsCqv29k3Cfw8o
	 l9I0rcHp8dlZUg4SkqkZKftKvHEUggp1CJpAxlfIkdqLQvVq8lHi5bSHjBKtgPEH/V/1B
	 eKPx4Lzsa8GMYOcpSZ91VM42HnxJ0r2AeaAciBtyhGZLj79xHgm8XhA6cQV1h60ThuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJjBsXF6G30zmkuimG5nvdENxZeNN5Dm7+2CTzezwYw=;
	b=gAM7XoCQcjnsRpu595QkMZXvionOwIJ8cvNaPn7L8vaDm21RZaKa6K7mykYRqoYh9gIC
	 7LhLflqinNVtqdfIIszNXUCspHHGnpM3s3PjTkJyoMDE7h7a5k5dZZESIVAs02CnIacZj
	 qYGvGTDU3EiJe2m737rYDd+zxI8CEyWUCS8a9zeRTIwhmukH9q1A9Q92qHOKvBc5lgVaq
	 MCZkyHbtTxs4sTv2Me0k9EemcMLhKO1p5FIiCLp7KUp0DwBms+icip/noc8HKbDPX7tKo
	 AAUhGPt4bWNtTfwDiw42qcq49DXL53cGFFt+dtpzrnffT2+4QfD6OxRprh3Sip/JKUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eBJhEx+q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A263606A31C;
	Thu, 19 Nov 2026 01:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eBJhEx+q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A03C1F000C4;
	Thu, 19 Nov 2026 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052255;
	bh=KJjBsXF6G30zmkuimG5nvdENxZeNN5Dm7+2CTzezwYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBJhEx+q9epiScbEmAwR4hRCqpYL8MlGxbAV196MtS1T4iKDW/ir5tLNhZAqIPtdk
	 3tMEiUW3YLjGSIjlxNg8QGm6cIC3KsyNTb17KgoJIlrTrA7bwIh/roJc14zIOn4CaM
	 7sYUCZ5f3KMWMlnjHcbB3B8Tdoz5kjbHTre5A1No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0471/2214] media: m2m-deinterlace: fix default capture field
Date: Wed, 18 Nov 2026 15:35:47 +0100
Message-ID: <20261118150030.032449513@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 4ee3ebede5d01efdcdd88c94f9df271d2eb237de ]

queue_init() initializes default formats for both the source and capture
queues.  It first sets the source field to V4L2_FIELD_SEQ_TB, but then
stores the capture default, V4L2_FIELD_INTERLACED_TB, in the source queue
again while initializing the capture queue.

This overwrites the valid source default and leaves the capture field at
its zero-initialized value, V4L2_FIELD_ANY.  vidioc_streamon() accepts
only V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT on the source queue, and
requires the capture queue to use a compatible interlaced or NONE field.
Userspace that relies on the default formats can therefore get -EINVAL
when starting streaming.

Initialize the capture field instead.  The bug is usually hidden because
mem2mem applications commonly call S_FMT on both queues before streaming;
the TRY_FMT paths normalize the fields and S_FMT overwrites q_data[].field.

Fixes: 8f0755c06b90 ("[media] media: Add mem2mem deinterlacing driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1f89e71cdccfc..5c05eb2d31045 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -830,7 +830,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



