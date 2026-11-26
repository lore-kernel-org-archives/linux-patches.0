Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704264;
	b=xE7l9EkIXPAuFae280MUzvinMLGls6d1JqvNkVZzHrr5w0nEwwNnv+0RWLfM7LL5EF0Y
	 8YD0D2FxSmCjejsUTSaZxE5OGo2XXwuSLlUTnhOPqG89joL4G3wT7eTFqo7tIhVNpmvY9
	 KYf3ov+Yr7vhKy6x78gzS8sEPZfnLGsf1cavzg7uhMRY0Chzant1JDRPy8/Rmw/eMrkrm
	 fGcUUcD269qwSrKBUe7IbjMoYtnQqDj0kvZyJelbZ6W00XNALExr2qBwMAufhySvi5xu/
	 oqrtcJ1MVs+bCiOL8IDJ3ySiYmNXQFRts5JJozh0i13q3qD4YzAtVzGOJeNmoxp9gSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uwltSV97ySIRWhrVXfyPYE1AsaCtKWtmuREdDMWwLQc=;
	b=zxkBq5ijv2q8h9tFl3pAl8eHr3YkLA4RU6o1NbWYWFD65Gw7qtnDuxEMQRaCwPu3UMwH
	 WhjvgB2DA2+muBIrCH9nhr16hnyhnQWAgDyROgg6CINVGOXolw4sETiZuqy3Cgtb8FB3b
	 1CPyO46vBClXyPH8n53N5UnSnJdBi33YA8m6G2nqNmRCNlv+HYzalGfq5qawKj2SJ3T6/
	 DeG2VAycdXpDaQdX6Iz2fuD6+fyAY8eGxuRdSzvIoa5AXQtfAxuUYa4SPCn0Rtvi9K0xu
	 3uJ86BCexJl6pn3K7TNTJ+K9ZrKRI46xvV70MqECwuJY1yU7q48BQeTm4HzfB9KvZoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npSA0MIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401DE606A31C;
	Thu, 26 Nov 2026 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npSA0MIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B1D1F000C4;
	Thu, 26 Nov 2026 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704263;
	bh=uwltSV97ySIRWhrVXfyPYE1AsaCtKWtmuREdDMWwLQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npSA0MIeAsenkCNZDqYk80/sCHlr8U9y6+fA/U3TnaciDWWKN64GAe5CU9x5SmOcv
	 eNPBiAn26sjFyuIywJN44N2WlwA+hTu4TXGiOozRoA9V2XM4/KfVMryFU0gBpBQrHB
	 zH+oKD0FWkHVSzWrPTGcK4XufNOGEacN1mGsmd4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/265] vhost-iotlb: Add an opaque pointer for vhost IOTLB
Date: Thu, 26 Nov 2026 15:36:16 +0100
Message-ID: <20261126143608.303440734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 59dfe4f1e810b5820443c84f9863b04b033143e8 ]

Add an opaque pointer for vhost IOTLB. And introduce
vhost_iotlb_add_range_ctx() to accept it.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210831103634.33-8-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: b179f21d2d8a ("vhost: reject invalid IOTLB update permissions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/iotlb.c       | 20 ++++++++++++++++----
 include/linux/vhost_iotlb.h |  3 +++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0fd3f87e913c7..5c99e1112cbb7 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -36,19 +36,21 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
 
 /**
- * vhost_iotlb_add_range - add a new range to vhost IOTLB
+ * vhost_iotlb_add_range_ctx - add a new range to vhost IOTLB
  * @iotlb: the IOTLB
  * @start: start of the IOVA range
  * @last: last of IOVA range
  * @addr: the address that is mapped to @start
  * @perm: access permission of this range
+ * @opaque: the opaque pointer for the new mapping
  *
  * Returns an error last is smaller than start or memory allocation
  * fails
  */
-int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
-			  u64 start, u64 last,
-			  u64 addr, unsigned int perm)
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
+			      u64 start, u64 last,
+			      u64 addr, unsigned int perm,
+			      void *opaque)
 {
 	struct vhost_iotlb_map *map;
 
@@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 	map->last = last;
 	map->addr = addr;
 	map->perm = perm;
+	map->opaque = opaque;
 
 	iotlb->nmaps++;
 	vhost_iotlb_itree_insert(map, &iotlb->root);
@@ -80,6 +83,15 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vhost_iotlb_add_range_ctx);
+
+int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
+			  u64 start, u64 last,
+			  u64 addr, unsigned int perm)
+{
+	return vhost_iotlb_add_range_ctx(iotlb, start, last,
+					 addr, perm, NULL);
+}
 EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
 
 /**
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 6b09b786a7623..2d0e2f52f9388 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -17,6 +17,7 @@ struct vhost_iotlb_map {
 	u32 perm;
 	u32 flags_padding;
 	u64 __subtree_last;
+	void *opaque;
 };
 
 #define VHOST_IOTLB_FLAG_RETIRE 0x1
@@ -29,6 +30,8 @@ struct vhost_iotlb {
 	unsigned int flags;
 };
 
+int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb, u64 start, u64 last,
+			      u64 addr, unsigned int perm, void *opaque);
 int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
-- 
2.53.0



