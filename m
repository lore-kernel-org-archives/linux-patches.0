Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D108265630;
	Tue,  8 Apr 2025 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111081; cv=none; b=GXvmXVk/8R9cZE+0sQpo2EzhKtdYv+tjslEuCipTpdS/fPfiExlA0Hk4fx9ycHBE4WLFAuZu7GSqfIQO2Krn+7lSGWskMqC2HjBgwz5px6fiXizpvzjF5MldFLQBUQcNCmxoqo9izr6RnOhYEDYXEXUh+Vwa+BNGOYi//tNlq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111081; c=relaxed/simple;
	bh=HSRC68Wx0QPvZ9W8f4bbWSeitd2KB2sxVGNr7T1BmiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUdX2ynmd4J0MoifJTbrgcNXvplSBLoM5dz9IArN2x4ydJvAEDyNakxY3+j1T0iLGEJBwiNrkmuOcFmF5g+HuN+dco0XuIRoi17DYus9wX6ghhqaslO2AW/K20pJrMwco/FVYppsqO/oUHG/dbyicZNde89tRReCofGp06l+hxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsWC2a3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsWC2a3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7019C4CEE5;
	Tue,  8 Apr 2025 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111081;
	bh=HSRC68Wx0QPvZ9W8f4bbWSeitd2KB2sxVGNr7T1BmiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsWC2a3LPyHTbCdV2SBkFw+uxJSYmPHaVAn551KFbxmVKZuIi2BIMjrAne1fWXZhF
	 /s7sayLYySI2M8BhKrh/cM/w+XwWbXbXFx5HgYGoTNY8lM2FuMwZM5B3wU1o9Tbu4i
	 Ci51EsmXf9bGgVWJhXBmd/36TvEKeOMQOLoGc3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 252/731] virtio_net: Fix endian with virtio_net_ctrl_rss
Date: Tue,  8 Apr 2025 12:42:29 +0200
Message-ID: <20250408104920.146675567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit 97841341e302eac13d54eb5e968570b5626196a7 ]

Mark the fields of struct virtio_net_ctrl_rss as little endian as
they are in struct virtio_net_rss_config, which it follows.

Fixes: c7114b1249fa ("drivers/net/virtio_net: Added basic RSS support.")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Link: https://patch.msgid.link/20250321-virtio-v2-2-33afb8f4640b@daynix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7646ddd9bef70..d1ed544ba03ac 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -368,15 +368,15 @@ struct receive_queue {
  */
 #define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
 struct virtio_net_ctrl_rss {
-	u32 hash_types;
-	u16 indirection_table_mask;
-	u16 unclassified_queue;
-	u16 hash_cfg_reserved; /* for HASH_CONFIG (see virtio_net_hash_config for details) */
-	u16 max_tx_vq;
+	__le32 hash_types;
+	__le16 indirection_table_mask;
+	__le16 unclassified_queue;
+	__le16 hash_cfg_reserved; /* for HASH_CONFIG (see virtio_net_hash_config for details) */
+	__le16 max_tx_vq;
 	u8 hash_key_length;
 	u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
 
-	u16 *indirection_table;
+	__le16 *indirection_table;
 };
 
 /* Control VQ buffers: protected by the rtnl lock */
@@ -3576,9 +3576,9 @@ static void virtnet_rss_update_by_qpairs(struct virtnet_info *vi, u16 queue_pair
 
 	for (; i < vi->rss_indir_table_size; ++i) {
 		indir_val = ethtool_rxfh_indir_default(i, queue_pairs);
-		vi->rss.indirection_table[i] = indir_val;
+		vi->rss.indirection_table[i] = cpu_to_le16(indir_val);
 	}
-	vi->rss.max_tx_vq = queue_pairs;
+	vi->rss.max_tx_vq = cpu_to_le16(queue_pairs);
 }
 
 static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
@@ -4097,10 +4097,10 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 
 static void virtnet_init_default_rss(struct virtnet_info *vi)
 {
-	vi->rss.hash_types = vi->rss_hash_types_supported;
+	vi->rss.hash_types = cpu_to_le32(vi->rss_hash_types_supported);
 	vi->rss_hash_types_saved = vi->rss_hash_types_supported;
 	vi->rss.indirection_table_mask = vi->rss_indir_table_size
-						? vi->rss_indir_table_size - 1 : 0;
+						? cpu_to_le16(vi->rss_indir_table_size - 1) : 0;
 	vi->rss.unclassified_queue = 0;
 
 	virtnet_rss_update_by_qpairs(vi, vi->curr_queue_pairs);
@@ -4218,7 +4218,7 @@ static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *
 
 	if (new_hashtypes != vi->rss_hash_types_saved) {
 		vi->rss_hash_types_saved = new_hashtypes;
-		vi->rss.hash_types = vi->rss_hash_types_saved;
+		vi->rss.hash_types = cpu_to_le32(vi->rss_hash_types_saved);
 		if (vi->dev->features & NETIF_F_RXHASH)
 			return virtnet_commit_rss_command(vi);
 	}
@@ -5398,7 +5398,7 @@ static int virtnet_get_rxfh(struct net_device *dev,
 
 	if (rxfh->indir) {
 		for (i = 0; i < vi->rss_indir_table_size; ++i)
-			rxfh->indir[i] = vi->rss.indirection_table[i];
+			rxfh->indir[i] = le16_to_cpu(vi->rss.indirection_table[i]);
 	}
 
 	if (rxfh->key)
@@ -5426,7 +5426,7 @@ static int virtnet_set_rxfh(struct net_device *dev,
 			return -EOPNOTSUPP;
 
 		for (i = 0; i < vi->rss_indir_table_size; ++i)
-			vi->rss.indirection_table[i] = rxfh->indir[i];
+			vi->rss.indirection_table[i] = cpu_to_le16(rxfh->indir[i]);
 		update = true;
 	}
 
@@ -6044,9 +6044,9 @@ static int virtnet_set_features(struct net_device *dev,
 
 	if ((dev->features ^ features) & NETIF_F_RXHASH) {
 		if (features & NETIF_F_RXHASH)
-			vi->rss.hash_types = vi->rss_hash_types_saved;
+			vi->rss.hash_types = cpu_to_le32(vi->rss_hash_types_saved);
 		else
-			vi->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
+			vi->rss.hash_types = cpu_to_le32(VIRTIO_NET_HASH_REPORT_NONE);
 
 		if (!virtnet_commit_rss_command(vi))
 			return -EINVAL;
-- 
2.39.5



