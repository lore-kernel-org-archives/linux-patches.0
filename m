Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618278;
	b=MVTrdpBQ+aIw46Uepv8Xs+7B28A/jsLIBUSi+nPOeA64q797/HLVH5mpEePygZ3YmV+g
	 BkUrpb9fCaN6iRIp1LcMfePjQDFyII8GHdW49UqraiaWrzcBGUTehelS/t6eTFGeHPu2Q
	 5PzewhS2NvAcozN9qA5YNBuSVhr6+gkqNzkQeT5HSHE+RV3dYDdyUnlYZ2rBsPMEGaFtB
	 FatSqsswU7xu02OnIxGAUQCvLNHuEi0abmVNfB8rJH2xIF/A4/LmIi6vIEpegbcyZVElY
	 X4YNf9Js/+IvGTc8kA28mUVt4vlcKiil7NqJxsz6TBmk5+xBY7JZ8I1WfceSUW9RQnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rp4Z+E12zSbPa5exLOXdwsebyCsHX9wRwc9Bkt6AkVs=;
	b=nDCvtL5VI8iJe68iecKvgsFsdnC2CjeVmnTk+D+F2/gvQtsK5mXDUfOl4UwWH389Fov9
	 UZ7ibTluN04In5/JwVqPGAbGPKLqgic2/7KeCCpmbrsOaSFgRaTFjzFEzCmdCVFVGOQHS
	 BTpwNz1e1qJbZ9hXP1WQTm8tBkU/LT+b81rLhmG7HLdYQDyfqkyN566qM3C3E2wqytbl9
	 e8iSR1EyK0PILbNtZWuEJCrlfcE/sim64cEIz+JnJCXVjA8Kkyt2JcNrdN0IXDnmTPefG
	 blqSzBn98B3lzoKvdJKuBQ+6XxF3p6SXFQgX3NOvRXwAgiEzw9Si7IWBUPeJDYjjqVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1cUAqf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5DB606A31E;
	Wed, 25 Nov 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1cUAqf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CC71F000CA;
	Wed, 25 Nov 2026 14:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618278;
	bh=Rp4Z+E12zSbPa5exLOXdwsebyCsHX9wRwc9Bkt6AkVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1cUAqf7g8Se4RuCgI2dEC7+R1+gjw/6k2tpx2fs+ieXSdcAKg6Z+aWVtV7VVBqw2
	 WmNhL5bmiFPH1zMkcfNKkQhodIaDhQXleso2fXVp7HLxd/+PFBD1ctrMk7ummZU+fp
	 fH6fpYwtU4u1Mb4NHneDV/i/7imy7uGE3PcmCExo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	sungbyeongchan <tjdqudcks0424@naver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0230/1005] virtio_ring: use shadow flags when detaching split descriptors
Date: Wed, 25 Nov 2026 15:26:08 +0100
Message-ID: <20261125143827.127485508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: sungbyeongchan <tjdqudcks0424@naver.com>

[ Upstream commit e498eb93f961db1a1dfdabd373500f0d4019c9a4 ]

Split virtqueues save descriptor flags and next indexes in desc_extra
before publishing descriptors to the device. The detach path uses the
shadow next index, but decides whether to continue by rereading the NEXT
flag from the shared descriptor.

Use the shadow flags for the continuation decision as well. This keeps
all detach metadata in the same driver-owned snapshot and avoids an
unnecessary shared-ring read.

Fixes: 72b5e8958738 ("virtio-ring: store DMA metadata in desc_extra for split virtqueue")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261008050423.32221-1-tjdqudcks0424@naver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index d0dc4645b5b37..bec008123ce89 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -910,7 +910,6 @@ static unsigned detach_buf_split_in_order(struct vring_virtqueue *vq,
 {
 	struct vring_desc_extra *extra;
 	unsigned int i;
-	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
 
 	/* Clear data ptr. */
 	vq->split.desc_state[head].data = NULL;
@@ -920,7 +919,7 @@ static unsigned detach_buf_split_in_order(struct vring_virtqueue *vq,
 	/* Put back on free list: unmap first-level descriptors and find end */
 	i = head;
 
-	while (vq->split.vring.desc[i].flags & nextflag) {
+	while (extra[i].flags & VRING_DESC_F_NEXT) {
 		i = vring_unmap_one_split(vq, &extra[i]);
 		vq->vq.num_free++;
 	}
-- 
2.53.0



