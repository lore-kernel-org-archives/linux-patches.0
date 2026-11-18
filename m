Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037099;
	b=FR6QVw5CLhTm9dBlfbvZ3hUa4rMLpBmysgg74yuVmLqHgYx4zlvD0h0B0RjBNTVn21fP
	 d/nYVdPI0EfiEpELFyjm8mpdfA4BSMGgAy98dQ5bUMAbN0wbBGdRGvH+ADC7h3B4KA2TP
	 S/P65nYYExJ3GzQiMxCtuIbgNt6wl9U96EDGEAmSGE4YYkdUdM682GSIwxDAc0c3RNWYv
	 ELkm73NPf8rG4llq+xgiBivhZ/JPycRv6x/t10omdL1mIXLxAP+aVR3eMtKoP+jMhM+k1
	 TjV/MNvKQTJEk7boncCt5zbLsHNIzf5uIiugaw58nDdiX9zRtdS3nAJ469mtel6L2Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErxI4sxLGyS3lD0VxpU1Ig8iEJ7YuZNtbfn6e6TguJM=;
	b=MCg1iwDTQ7CwVMZ/qW2xDhCJIFFTAaGtRwoVd/BK+7PYDAEJC+6DX9z58nZFDzjVYzNT
	 bz1P429+BgcrM/9oV5Je1Wt/Pm3ccxIMtNsQF0KgsNiLyawN0ikgCE05mtb7eftw3lUx6
	 2u9jPwvtLBWGnS/F7cq3P79o4I+3MHVp3MF31C/cBKOAxsG/U6ulsO/1YWifpIVnmq33w
	 1p9gWah33YnLd1CDMoE+bw4v6a00dNdzKx69rRFy83qSnDDjnwRvei+4iSiVLUseF7e9o
	 CJDa4uyhe1o7jk3z1Fj4DXOEu1W+5IdtlVDyADPlH3PqAkp2+Hew1gBhPJhIM3p7maw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sm5lRuqf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C5606A33D;
	Wed, 18 Nov 2026 21:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sm5lRuqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE981F000C6;
	Wed, 18 Nov 2026 21:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037099;
	bh=ErxI4sxLGyS3lD0VxpU1Ig8iEJ7YuZNtbfn6e6TguJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sm5lRuqf/6/dZQWVynvu/teil7NXymLoxEf0ecyFEb7+Ly2uH+b3sBl6Nz20YJW/y
	 ZmSaGb52AZV8VD3qb7JsH/I/kCjSeVTng608Vw74JIPp1YBLPl/T5XIpnbSnCAUPQm
	 GWG5Xep07KoZrpdli1qGTPwWKcszDiV82yMU8b60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1251/3318] xsk: restore UMEM flags after failed pool assignment
Date: Wed, 18 Nov 2026 15:31:13 +0100
Message-ID: <20261118150357.730229070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9dc809ed99270..e4261004c2c9d 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -153,6 +153,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 {
 	u32 needed = netdev->mtu + ETH_PAD_LEN;
 	u32 segs = netdev->xdp_zc_max_segs;
+	u8 umem_flags = pool->umem->flags;
 	bool mbuf = flags & XDP_USE_SG;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -241,6 +242,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err) {
+		pool->umem->flags = umem_flags;
 		xsk_clear_pool_at_qid(netdev, queue_id);
 		dev_put(netdev);
 	}
-- 
2.53.0



