Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062610;
	b=cxToshr1rsb9CLIGWp1EEr0Itbd8VQ43Y068V8xJ5A1hPZSUuPSVAVtK480KFEqi5OuK
	 BD6Aaiv8lu9UisHLsDr138jqVC5zlCiDdCY5khyEMOiKIUBGqWY1ghvx3iWYdD+GkAVlp
	 wAzx4ikLnq+02Y6r2EEsZ7KJp/em8iC6V4cNYsYoKm2K2CYWTuAV8WFz59FDTKdaAlWLy
	 Ic1IDV5KYoH/RhF1/DDTi8l7kxDVTH/vpPfXXxD/beOyOULDsDOrlvf8XH7N/L7uCaN+7
	 tQQ9rykUEljj5m2givDpAxecWwY0c+DPGD91qs1LpQyOHTdET8CzEGzYA7vVHA2C3vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S6u+hqcADgnOPYx6ExaIxbLrWSUsFfDeWCS5QZTTFWg=;
	b=WyfrNBaqqWHbmoWuMMx9fyMhSnS5vRIEgwD8F5Gk18pxrr9uUlrzolHaXMPej3KEjGjd
	 fX5SQV/+RkRXe/8gdOfxRcSwJTPbc7zk2ytd5lxOOUCPlErJSzapC8Bp+V6qGgF1/kipe
	 p0WpR8qszPMK4uHGHzq+KizbydNR7c/EwOscKpQxejN5g5tLJHp3btEFhY+zazMXFrwhm
	 PtZ5Hga+IvKMA8olMa0I/NvyN0nheQ3K+mE13m32f8C9Hp+Q4hRRxEmliGb9zOxplFnQn
	 zDiEJcpADLWuS7JnmFlUrPrTHbCrfv6K0f/z9/O/tbUuHRZILV/dkTIxymm31QNLXDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8ALEgYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B62F606A335;
	Sat,  7 Nov 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8ALEgYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAABC1F0089F;
	Sat,  7 Nov 2026 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062610;
	bh=S6u+hqcADgnOPYx6ExaIxbLrWSUsFfDeWCS5QZTTFWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8ALEgYs6Xdz2QpnGmGq6MHP3WW4Zho86nZqhF8fcTc7LHg8lhoCO6qTuaMew1A9R
	 JK3TmC8gNnDjFnGmaRGAy5DhxWRz82R0NXVlOq8yWh7vFfbbDnquMCmsJCZWdrDZL6
	 os5Uifa/2uaNeUFvmRTnnfiY4/rVyKK324EMq+FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1481/1536] xsk: restore UMEM flags after failed pool assignment
Date: Sat,  7 Nov 2026 08:58:17 -0500
Message-ID: <20261107135039.446979938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 925e0e62491d9..13fc16e361e04 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -171,6 +171,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
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



