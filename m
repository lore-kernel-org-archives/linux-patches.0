Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015935;
	b=jQ0W3jzAtiF6InT93DbuwqEbgbHjBuZ1fOmaGdBtwDP0jeAanxQ1zmZ1elPPlCbc9bbW
	 CJxYQkEMPmnX6GWkayDpxAHaTR4IZl6xJMZjWtFYjABL+Sl8hS+9dNRtegoxDP+Pd5Nky
	 3JXiV2eNo+WiGjcSE2zZdJ5RaSRwjDlzoNghCFljbE6Vqax8ljH/DMI3sqcsSueLJiluP
	 vk/QyNmAJMe8b1V+vmu2wacuaGSLXCYjvxqra/55SNcJ9xbKerA2yDh0czwgjVKhIJFH+
	 PyoUm7/yuLGfaC+fgAoTI/xvn4Uu3hN6Y3GmEZ2+X9h60KJcDBDtX8LAG6CBjGXbeRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a6YfueLONA8XKLcIb+TRQ/FIIZ9fx8yH3NpXL7t1nAI=;
	b=rkspQzz9agY5GcgX1v/RR3XRbqYFmzH9y3rPbskrQ4s2naboHYE+vEdAbLRoGo5WnTSC
	 3dkEMWTmmIWBlH+6/o7nhtfJ7OOlJ5VqKqq+1vNJmQtl1+uZXlU0ypmZb2zYUnoowWClw
	 f2RyvNzCT79/yF7jxFnI841OH3MyuUIhXuKLk/B8cVUtEDUnj1coFVp6d1MX1Nh4uw/Ta
	 BEqDKNAe43cuEvGdunhlgcQGbTrNp94PnG6QExPCN4ABGM7OQkTsRKNBuajLOynKI39Ye
	 ypvO7SaYIyG16chMflWOdtKIvt39TyLmrWVAonOTPfxkHfUmzNp5miVLe99+jN0rxPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFAWUGXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F8606A32C;
	Wed, 18 Nov 2026 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFAWUGXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EA21F000C4;
	Wed, 18 Nov 2026 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015935;
	bh=a6YfueLONA8XKLcIb+TRQ/FIIZ9fx8yH3NpXL7t1nAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFAWUGXOHMdJ/Hr1VYcc1038XGrLob0bdCX2UGlEQfYlLYz2dnXEc+y25ZZlTKSUG
	 g41HueqQr/xMA3FKz5XJEUUedbLSbCsE/5CgoJCowPS47buxFxG1RrIbh6Y3qmdhTw
	 vNhPM/FHRFDAhuJq6EvfFuDnqA7Tf0z5cgpoffmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0351/2651] arm64: dts: mediatek: mt8188-geralt: Enlarge SCP core0 memory region
Date: Wed, 18 Nov 2026 15:26:31 +0100
Message-ID: <20261118150300.473387743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index c65805f2a7e0f..801eee735afe6 100644
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



