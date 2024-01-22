Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADB712BE87;
	Tue, 23 Jan 2024 00:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968827; cv=none; b=VwKHm59fD2i0M/q5iBB3GtxDko+Z8AtmzpJIYfXOfeLy2ogwlnCTPRv3UxNZk236eQ7vyDkuDsRAAysBWZIQuvIAWC+66+0eBq7jTJk9/n5j+7mH7ChC9X5lnpngj+ypRu/SeKNflvGbh4IlnuZ+NKODCblXDgDLH1RZDNKfthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968827; c=relaxed/simple;
	bh=eTxkAu3JyJfxYCVHC8la8AvNnLwj5bIFuP7pndkD1jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UafUPVlp5TARlxNn0eaiA/40PreQShR3+H5YpTsubaMP7byte/KsBH5LgfKywefY5UQpoybjXHV3mVop44o0OSRtL47nRRBF0Gf4rP/UEMpKSYjdD9meuXi2LgPNmoZsv9M7fo5zt58vhrQwXnK5lk8s6OqoeeP6aJSuLKRV2Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sF/z/TML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sF/z/TML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A07C433F1;
	Tue, 23 Jan 2024 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968827;
	bh=eTxkAu3JyJfxYCVHC8la8AvNnLwj5bIFuP7pndkD1jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sF/z/TMLgux0jCR84vCtCBD7PQM7ziFIJ585QIKoItRp0h54NpfoGHWgw7larEMu3
	 48ZlaUVxWhQ7xdJJB1lZB9DH7rdd6J4ar/6IBy/stykG4mz/c6QlhzJ+Y91AkbLy2y
	 Ij+o2umRJ7Kj/RWpzv3zDKkA5FHrTHEU7bJD/780=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/194] virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
Date: Mon, 22 Jan 2024 15:56:32 -0800
Message-ID: <20240122235721.868276093@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 13d640a3e9a3ac7ec694843d3d3b785e85fb8cb8 ]

Base on the lastest virtio crypto spec, define VIRTIO_CRYPTO_NOSPC.

Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Link: https://lore.kernel.org/r/20220302033917.1295334-2-pizhenwei@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_crypto.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/virtio_crypto.h b/include/uapi/linux/virtio_crypto.h
index 50cdc8aebfcf..05330284eb59 100644
--- a/include/uapi/linux/virtio_crypto.h
+++ b/include/uapi/linux/virtio_crypto.h
@@ -408,6 +408,7 @@ struct virtio_crypto_op_data_req {
 #define VIRTIO_CRYPTO_BADMSG    2
 #define VIRTIO_CRYPTO_NOTSUPP   3
 #define VIRTIO_CRYPTO_INVSESS   4 /* Invalid session id */
+#define VIRTIO_CRYPTO_NOSPC     5 /* no free session ID */
 
 /* The accelerator hardware is ready */
 #define VIRTIO_CRYPTO_S_HW_READY  (1 << 0)
-- 
2.43.0



