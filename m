Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065454;
	b=WfGd+hLYi2T63MbPsHysgbPYMmG9PrX04H3A2AmW92DJ3q8I/WjeAomqXTbZ4Oq2NYYv
	 OeSpjy5pMPR6NImOQ7ZS+Yp9wkpGrR2lYEWdhmQqQ0yhX6L8g5ZVuxkpQ1MHmRsvwg48S
	 tSGrt+yda8S4Z5SofNSHxpBMLPJ8EORaEj5KC/VoS+sHvuyPn7YwuwrP6CTw/Stp6Yx8H
	 Bd01jvyp6Jzw7khkTdCDvLvPXlxibVZf4dAyhgPtZD4szPKSy00PLtPcnfksc/+BLnZ1w
	 gFLi+3jgdSQJDL43dqRgKWmgm+sdiwTF/5Ltq7PxjOtPXe5Xf2AjT1bjZFyaMJEaZJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXDK32gcmRX+YsHuKPbX6Y2TJGmcDuDUFDVcS/taoos=;
	b=MBhkAHXKZaHLxhRNFTfngBv8D3tQgl8cL6J21PDtvJ9bTj20dG9ikgSnvpXFTM2hORyO
	 H54/kLE/GhUIqvj+K8/nuGvTyKEzuzRKjKSFWtBXklgLpqTQDOuj51FUrXNrzWbZJzC9Z
	 VBqB1NiFNE58r0LuyLrt+SHqHe/s/ehQh4bg0h4H1HyE5UnRjPOWQhhxFgRgaKUB0zgkm
	 ujJX4V+nHnmU58v/oaslFQMH92iSwWXh+DGyxiUGPkAqkHJxDVX5Uuts5mG+jEzHofj1y
	 hRS9utarmQd+kcVINF+yLhHIgz6nqWUgNxjmSGZ2IpK90jPGt/8P5oj+oyVjSil/cAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eec1UrsF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B925606A335;
	Sat,  7 Nov 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eec1UrsF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3EB1F008A2;
	Sat,  7 Nov 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065454;
	bh=JXDK32gcmRX+YsHuKPbX6Y2TJGmcDuDUFDVcS/taoos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eec1UrsFXGtaVxOz8b5uFQmpnOZvleb8Ff8OqfLXBpYracT3Ma9EsrUvyhNM2f50U
	 cpLLpNkGHSew4ieOmLtQwW1zpkalAhtTNNWcIy0ojJWv2LxhjCWcEchFYymy1bQ3w/
	 gjnle8hgN4ClFL73+NdK8ss6SFfeuOMa8GAT+XtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1154/1257] xsk: restore UMEM flags after failed pool assignment
Date: Sat,  7 Nov 2026 08:57:30 -0500
Message-ID: <20261107135011.078387962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

[ Upstream commit b88b826ec54a06f48a42580c609ba81293ebec8e ]

xp_assign_dev() sets XDP_UMEM_SG_FLAG before checking whether the
device supports multibuffer zero-copy. If assignment fails, xsk_bind()
destroys the pool but retains the registered UMEM. A subsequent bind
without XDP_USE_SG inherits the stale flag.

The flag also changes RX buffer sizing after DMA mapping. On igc, a
failed SG bind followed by a non-SG retry with 4096-byte chunks and
1792 bytes of headroom passes admission with 2048 bytes, but programs
a 1024-byte RX buffer. On I225-V hardware, an ordinary 1514-byte frame
is truncated to 1024 bytes or 1008 with RX timestamps enabled.
Restoring the original flags eliminates the truncation in both cases.

Save the UMEM flags before assignment and restore them on failure.

Discovered during development of AF_XDP changes for igc.

Fixes: d609f3d228a8 ("xsk: add multi-buffer support for sockets sharing umem")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Moses <p@1g4.org>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20261021224705.2078753-1-p@1g4.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 9d2d94f1fb759..e836eca469b0b 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -166,6 +166,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 {
 	u32 needed = netdev->mtu + ETH_PAD_LEN;
 	u32 segs = netdev->xdp_zc_max_segs;
+	u8 umem_flags = pool->umem->flags;
 	bool mbuf = flags & XDP_USE_SG;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -264,6 +265,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err) {
+		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
 		dev_put(netdev);
 	}
-- 
2.53.0



