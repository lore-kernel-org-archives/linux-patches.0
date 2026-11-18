Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023376;
	b=PxcTS7gs3r5pncKKdDFoETdT1CNo6jTMF+qOqC+dD1CnOzm4EcUc80Vd8Rlhv4lsT89q
	 lFkZmqXJBKqYyapXjT1sGlsaGddD6w6m+WaBdf3A88dR816XozFIeUhOEe9Kj0c4RCbpo
	 yiLh7GXlnRtSQP1QvVLRP7OVdyAt0C3tnLIKg1xSH71kfKthd2y7FwpnHr0LC9U1vvf5M
	 JtkoSY0FARuasbeRRnxIZSwAP4uQZIbihhvYyqhVzTNFSi/hpaLhqrKn9gcI7mzjaAWqp
	 I8ONnsHmC4DTFhvTm+gi4NHo0TWzUplH63/s6plpUIVfwWRlO/EnE8BEIiXhwzkPsKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icY2jLil6SBHbePRdH6Ofbtu1wi1erArrCqweyKTF/c=;
	b=WCdJxE1l1hZdR7GoW9arYtApF6C2G4FzAsbKMgMoWtzpfqC3i9AgthTTzzZdD8BTfoCd
	 ZX9rNm6UELqd44MzxMuqRrOZ4AKWaf7T9fRB3STTtT+OeMxP1DXmu0YdN6yOiirXGzyz1
	 qGG3M9/ipVx0DpAlyH40Nua5PsQVj0Z9Xwh/FZmwv2mknRS6cuSdqGdjDnMgtwrdMs75+
	 Kg0+ybooDeOSXY3/iaEJwArejsjj9aBSBWe74jTx5nNZR61x7SOhs3ToEzjtrXOLwjH/I
	 VPjRZQY7Pfves+RK+2U9+lKEGOdF3psJl0BAXCDA8yZnZr7hRMIH8lTh/ih+8cvdVMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hMO8hAqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7660A262B;
	Wed, 18 Nov 2026 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hMO8hAqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5443B1F000C9;
	Wed, 18 Nov 2026 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023375;
	bh=icY2jLil6SBHbePRdH6Ofbtu1wi1erArrCqweyKTF/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMO8hAqs31Xd56Fxsgv9+Mvd+5dJ4kYWUPqjYPbMur2v5HJF567O2XmSd0Bk0bRcL
	 IkJScJhgq7PJj9YeE6WBzI5+v7zMnQLApwtIQMko6NUCivze9Bp6O8AuDj1fORHYLn
	 8tm7eMqX8fAyy2xvcSy7gscFCHr+WnpXdvP02IAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0348/2151] arm64: dts: mediatek: mt8188-geralt: Enlarge SCP core0 memory region
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118150134.780848084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Yeh <justin.yeh@mediatek.com>

[ Upstream commit 868297e3ebcc5c9b0e7cada19c82b11068faf4bf ]

The SCP firmware in linux-firmware for this platform
(mediatek/mt8188/scp_c0.img) supports MDP, which the mdp3-rdma node
drives through scp_c0. On top of the segments it loads, the firmware
allocates a 1 MiB DMA region at 0x50800000 at run time. That lies
outside the 8 MiB reserved for SCP core0, so Linux is free to allocate
over memory the firmware uses.

Enlarge the region to 9 MiB. apu_mem starts at 0x55000000, so no other
reserved region has to move.

Fixes: e36be19823f0 ("arm64: dts: mediatek: mt8188-geralt: Enable first SCP core")
Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi b/arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi
index 118d6b2ebd2c6..038ade1acdfdc 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi
@@ -171,7 +171,7 @@ reserved_memory: reserved-memory {
 
 		scp_mem_reserved: memory@50000000 {
 			compatible = "shared-dma-pool";
-			reg = <0 0x50000000 0 0x800000>;
+			reg = <0 0x50000000 0 0x900000>;
 			no-map;
 		};
 
-- 
2.53.0



