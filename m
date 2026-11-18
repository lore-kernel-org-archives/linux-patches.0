Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044940;
	b=RsFdWZAm1PlHpA9vCBEfdITJOgTWlalrMySCXXrub6jQbXdJTiHW5ig+K/A2SYHLx7UJ
	 CbkOjFIDpdkKgGbzRQKWGxvsHbbAfyMP53Id3+pvDv5YQYQR2Evc2awGPprsCH9blUYCT
	 tuIo3Vhphq9SQxRu6t7OmGwCaXCWVPlMx5FFv1V/vnLF5LKPh6eKoGcYKV/66OKLsx+2l
	 b7uK9veYZxjdRfdlqh7a4OAgebqVyf0Rox/m/2w6l2dvsEtmtlVV9py39MDvan+jiO262
	 fyNj+2GBiJxzukEDAAO4GdG9wFnNa+KqlvvQX+UJDeEdB16DsvKjAbQvtPRyqrKNojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vQqcDxiQvid9ET3UZiQ16S62t8ExHU4Md/xqv6PCd+A=;
	b=Y59BGPi99UVPHz2VO2CT1vSLkIRDerwiiPzYkGdsDq/3qAXzipcKbIrCooKUdbbnFS+n
	 bF20vi8wn/y7dbbsfcp+j7nSTviS8dqqZ5DR9xyNk8Iujsova1XNoFKIyZYHklb+4AIrJ
	 TlD8jIPRJuEb79NmL4HA9NtUQ5O7s7eVUD4PwUEYq6MaR/EQB/qBjxQRwMMbnXnY5QnvB
	 2+9TB39QbVur4idN+pXAVXuYIM+z90E7EcJGbPonCMaAf0OKY+nhVtWm/VcVCLxK/BUv0
	 MQuRFunij1JGiEo5nFdPDtIq5/9iwgkD1BTmr5jkVQp63CAUr1Zx+8i/JjoWc25eLTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cRC8/Bio";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E8606A32C;
	Wed, 18 Nov 2026 23:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cRC8/Bio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961A01F000C4;
	Wed, 18 Nov 2026 23:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044940;
	bh=vQqcDxiQvid9ET3UZiQ16S62t8ExHU4Md/xqv6PCd+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRC8/BioqX7Q9D4S+E6i66+dL6ZOh1BH9195dGpYglIm3MYqMoalLTV67JuJoYYq+
	 O4lQ79JjogmOMI2yi8uo/HXoVSCGk7z2AzBQvWIZUdAANUhzQL3xWwVB9mf1nWTyEP
	 6zYDHkgtia+uG6ge6fCphnsIf9vbYKVY+g/AqMJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0747/2857] media: m2m-deinterlace: fix default capture field
Date: Wed, 18 Nov 2026 15:29:41 +0100
Message-ID: <20261118150228.449621233@linuxfoundation.org>
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



