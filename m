Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235EF14F9E7;
	Wed,  5 Feb 2025 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764057; cv=none; b=t3zw0SRvbPkNRCXMJcJ19ITSlZM4kj3/SpHE/QdGkz7+U5y7CZtHrAz+GOrNeFYnUuGM1nlkFZKrdA8sjUq9aC/ljP5G7KR0ZanjuEy5YOYi4Slwn/pI/AZJZ/lSzHxMJzjHNKnXRQDcb0AxzS17X0MAvAIGklmW7QTDwtqBykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764057; c=relaxed/simple;
	bh=dysnE0DOFNi8vv7ls/fRhrGNXxRbvxq9vlRjX4Dzjes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqHoofI6+CKbUI9GIiU2AagadkRsaCxtq+GY222MLXfPTE4roj3pcwD6nKDkbUxj17tXYNznRDosWphZwu/6DS9uVinrAVoXGE7rZeWGrSUe9F9m6JX8R4aBuqjP5eOpwg+YLTV6aCcNnIYIm5/nrAplzxE8N5JS9wXseXo5nFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/DhduJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/DhduJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB47C4CED1;
	Wed,  5 Feb 2025 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764057;
	bh=dysnE0DOFNi8vv7ls/fRhrGNXxRbvxq9vlRjX4Dzjes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/DhduJlF+oqKUpOUuLwg4MOyv0nvTssActKw1L0ZJyMZzlpmdzWOOh6/fTU8Zmy7
	 L0MlJ+3gp/FR0EFDH+51MZHYuGCTzh8rxFCtZh/1UPoWiUHvYBiciuiYBWrT0BYS+M
	 gwtWHkKtCbKtaDkirfU8xwE19JsIQB556lMdEG+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/590] selftests/bpf: Actuate tx_metadata_len in xdp_hw_metadata
Date: Wed,  5 Feb 2025 14:37:20 +0100
Message-ID: <20250205134458.503741812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Yoong Siang <yoong.siang.song@intel.com>

[ Upstream commit 0bee36d1a51366fa57b731f8975f26f92943b43e ]

set XDP_UMEM_TX_METADATA_LEN flag to reserve tx_metadata_len bytes of
per-chunk metadata.

Fixes: d5e726d9143c ("xsk: Require XDP_UMEM_TX_METADATA_LEN to actuate tx_metadata_len")
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20241205044258.3155799-1-yoong.siang.song@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 6f9956eed797f..ad6c08dfd6c8c 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -79,7 +79,7 @@ static int open_xsk(int ifindex, struct xsk *xsk, __u32 queue_id)
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
 		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
-		.flags = XSK_UMEM__DEFAULT_FLAGS,
+		.flags = XDP_UMEM_TX_METADATA_LEN,
 		.tx_metadata_len = sizeof(struct xsk_tx_metadata),
 	};
 	__u32 idx = 0;
-- 
2.39.5



