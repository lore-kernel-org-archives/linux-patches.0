Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6EA50C28B;
	Wed, 30 Sep 2026 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791518; cv=none; b=SaqdDl39CFHhP3VHIwKDvcYcG2+xA+IamW8dfxV5IcPic3I/IbqWo6iwbhEXd3sjmj7mhIJSHScu6e41nDS+Ss+6hUuYXhH2vrgkNPHW5hhsaJmc7lCe/zb59LXbmKexkdDzVjCTWcJoandZPBqk4DoOeyuMtC1cuUm8foOi2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791518; c=relaxed/simple;
	bh=n29qzaFV9lJMmJj72zP7tcbwYfF9yL0dXrOm1eAArKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilebGPGY8072zUubVb0xHIKqe/AGq6GQhuvIEjMStQOgrKqjswQZ5wjgvMyab0SHSU1NL5X5ir7wj/LiLQpkamCBBfWlQnHmEw8JLW9oRfZf5cg4n13VU4P8nMbHGOIz2agoy4e2fywPE3AVfDC0RH3Dyrm9YqzjdFiuKeBGm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orfLhHvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orfLhHvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B21F000FF;
	Wed, 30 Sep 2026 18:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791516;
	bh=MQeY9GaAJsmcgpf7bqxUJx9SqC0N12CsmRHW8ZxAFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orfLhHvokMswR52FqpAW54cZ0lsXSnfixu3ehvpxQiUqN036R1tjpiiR7P0naIvop
	 lZkpeTWMS8YfEEsFK0nlgO/1XY6P1fuz/dky5Uad5GLu1Yefacqp2z5+ffM76rc1J3
	 FVueFrlYsCe68SoKTRvgP/34pmtuMpyFWWLAPCzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/752] vdpa_sim_blk: use dev_dbg() to print errors
Date: Wed, 30 Sep 2026 17:23:21 +0200
Message-ID: <20260930152405.458268006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 42a84c09eff355d895723866b1a5ff48f093112a ]

Use dev_dbg() instead of dev_err()/dev_warn() to avoid flooding the
host with prints, when the guest driver is misbehaving.
In this way, prints can be dynamically enabled when the vDPA block
simulator is used to validate a driver.

Suggested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20220630153221.83371-2-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 0a8693f00c40 ("vdpa_sim_blk: reject out-of-range sector starts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 22b812c32bee8..faaf9cac4aaac 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -76,13 +76,13 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 		return false;
 
 	if (vq->out_iov.used < 1 || vq->in_iov.used < 1) {
-		dev_err(&vdpasim->vdpa.dev, "missing headers - out_iov: %u in_iov %u\n",
+		dev_dbg(&vdpasim->vdpa.dev, "missing headers - out_iov: %u in_iov %u\n",
 			vq->out_iov.used, vq->in_iov.used);
 		return false;
 	}
 
 	if (vq->in_iov.iov[vq->in_iov.used - 1].iov_len < 1) {
-		dev_err(&vdpasim->vdpa.dev, "request in header too short\n");
+		dev_dbg(&vdpasim->vdpa.dev, "request in header too short\n");
 		return false;
 	}
 
@@ -96,7 +96,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 	bytes = vringh_iov_pull_iotlb(&vq->vring, &vq->out_iov, &hdr,
 				      sizeof(hdr));
 	if (bytes != sizeof(hdr)) {
-		dev_err(&vdpasim->vdpa.dev, "request out header too short\n");
+		dev_dbg(&vdpasim->vdpa.dev, "request out header too short\n");
 		return false;
 	}
 
@@ -110,7 +110,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 	switch (type) {
 	case VIRTIO_BLK_T_IN:
 		if (!vdpasim_blk_check_range(sector, to_push)) {
-			dev_err(&vdpasim->vdpa.dev,
+			dev_dbg(&vdpasim->vdpa.dev,
 				"reading over the capacity - offset: 0x%llx len: 0x%zx\n",
 				offset, to_push);
 			status = VIRTIO_BLK_S_IOERR;
@@ -121,7 +121,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 					      vdpasim->buffer + offset,
 					      to_push);
 		if (bytes < 0) {
-			dev_err(&vdpasim->vdpa.dev,
+			dev_dbg(&vdpasim->vdpa.dev,
 				"vringh_iov_push_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
 				bytes, offset, to_push);
 			status = VIRTIO_BLK_S_IOERR;
@@ -133,7 +133,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 
 	case VIRTIO_BLK_T_OUT:
 		if (!vdpasim_blk_check_range(sector, to_pull)) {
-			dev_err(&vdpasim->vdpa.dev,
+			dev_dbg(&vdpasim->vdpa.dev,
 				"writing over the capacity - offset: 0x%llx len: 0x%zx\n",
 				offset, to_pull);
 			status = VIRTIO_BLK_S_IOERR;
@@ -144,7 +144,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 					      vdpasim->buffer + offset,
 					      to_pull);
 		if (bytes < 0) {
-			dev_err(&vdpasim->vdpa.dev,
+			dev_dbg(&vdpasim->vdpa.dev,
 				"vringh_iov_pull_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
 				bytes, offset, to_pull);
 			status = VIRTIO_BLK_S_IOERR;
@@ -157,7 +157,7 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 					      vdpasim_blk_id,
 					      VIRTIO_BLK_ID_BYTES);
 		if (bytes < 0) {
-			dev_err(&vdpasim->vdpa.dev,
+			dev_dbg(&vdpasim->vdpa.dev,
 				"vringh_iov_push_iotlb() error: %zd\n", bytes);
 			status = VIRTIO_BLK_S_IOERR;
 			break;
@@ -167,8 +167,8 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 		break;
 
 	default:
-		dev_warn(&vdpasim->vdpa.dev,
-			 "Unsupported request type %d\n", type);
+		dev_dbg(&vdpasim->vdpa.dev,
+			"Unsupported request type %d\n", type);
 		status = VIRTIO_BLK_S_IOERR;
 		break;
 	}
-- 
2.53.0



