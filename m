Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E609348C55;
	Wed, 20 May 2026 18:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301271; cv=none; b=At0BNwD8grqpKUsHpXoh3+L75ezVqsyyE1SoXKWL68MzJFFaW4DcYW/fbWfQMf3U87V7y9heeJuBOQ1SYehn6bT2J+BG/+U7RZr4Bkz90Vn1nitzcfSiQ+1TkFNhC03puSvtBIg5QErXgloKDhXKD0U/0tesVT7bfO3zSJT5f4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301271; c=relaxed/simple;
	bh=SyWXhLy0TE3UspBn92qQnp4NM9N5wJdOYpV666kc/vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik1oc+wmKzKc25y9vOlBcpnUNdzmPnCLtWcbeW17fJa5I1G3R0VDYZ2pLzEr6Hq/QkT4YczjZtprhSTB7n4Smj7lPOPCN7LZ6L3XwvZzy2eJyU3U99vWbaOcUNT2gcUCG0T8QJyIfCxSaAZRAEP1GZ1iFikct2yFaCsfJ71WdfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG9/3zQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG9/3zQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F81F000E9;
	Wed, 20 May 2026 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301270;
	bh=JWdtBCzCdCk4J6dIQUXRxV3Y1KFq+waCRv5iiEk2qXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qG9/3zQBIrZS1kjOEXyQIzo8OBMUL8CWqcboK1mplmO9n9cErQhBq2TK+CWYUSenR
	 J8xh1/AkhAWFX4Yk/NqgBRKz5PX0ol3LsIHLq5zthXx/ACUeYa0b5D0uOUsXkD0ah2
	 BDmIyk7h9xndVtpcT+CZg0fhpydkqV3jL8HhsJLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/666] virtio_net: Split struct virtio_net_rss_config
Date: Wed, 20 May 2026 18:21:43 +0200
Message-ID: <20260520162121.927113263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit 976c2696b71da376d42e63ca3802eb2aafc164eb ]

struct virtio_net_rss_config was less useful in actual code because of a
flexible array placed in the middle. Add new structures that split it
into two to avoid having a flexible array in the middle.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Link: https://patch.msgid.link/20250321-virtio-v2-1-33afb8f4640b@daynix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3bc06da858ef ("virtio_net: sync rss_trailer.max_tx_vq on queue_pairs change via VQ_PAIRS_SET")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_net.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index ac9174717ef13..963540deae66a 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -327,6 +327,19 @@ struct virtio_net_rss_config {
 	__u8 hash_key_data[/* hash_key_length */];
 };
 
+struct virtio_net_rss_config_hdr {
+	__le32 hash_types;
+	__le16 indirection_table_mask;
+	__le16 unclassified_queue;
+	__le16 indirection_table[/* 1 + indirection_table_mask */];
+};
+
+struct virtio_net_rss_config_trailer {
+	__le16 max_tx_vq;
+	__u8 hash_key_length;
+	__u8 hash_key_data[/* hash_key_length */];
+};
+
  #define VIRTIO_NET_CTRL_MQ_RSS_CONFIG          1
 
 /*
-- 
2.53.0



