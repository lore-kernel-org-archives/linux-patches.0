Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9901266B7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsM17lmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218BC433C9;
	Mon, 16 Oct 2023 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467946;
	bh=ORuumQl1TpS8ypfMcDVU+P0ZtLmzHiNhxlrWHnZGJtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsM17lmQsONNk4NtoC+udFNkVjl1e1LlII+TeegDD8KygmFLdaef7wID9UIos8bnx
	 Yly3mxM19F2Y5sLMgWbkScEFVxV2MRjxVCVAsvn3lrY33ovuNLaa3i6lW1777w/oaX
	 DATjBeH5NtHocnEi9qZjcfclSYMa0ZrnndiqpPXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.5 121/191] arm64: dts: mediatek: mt8195-demo: update and reorder reserved memory regions
Date: Mon, 16 Oct 2023 10:41:46 +0200
Message-ID: <20231016084018.203747323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 6cd2a30b96a4b2d270bc1ef1611429dc3fa63327 upstream.

The dts file of the MediaTek MT8195 demo board has been updated to include
new reserved memory regions.
These reserved memory regions are:
 - SCP
 - VPU,
 - Sound DMA
 - APU.

These regions are defined with the "shared-dma-pool" compatible property.
In addition, the existing reserved memory regions have been reordered by
their addresses to improve readability and maintainability of the DTS
file.

Cc: stable@vger.kernel.org      # 6.1, 6.4, 6.5
Fixes: e4a417520101 ("arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230905034511.11232-2-macpaul.lin@mediatek.com
Link: https://lore.kernel.org/r/20231003-mediatek-fixes-v6-7-v1-3-dad7cd62a8ff@collabora.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts |   37 +++++++++++++++++++++------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
@@ -56,13 +56,8 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
-		bl31_secmon_reserved: secmon@54600000 {
-			no-map;
-			reg = <0 0x54600000 0x0 0x200000>;
-		};
-
-		/* 12 MiB reserved for OP-TEE (BL32)
+		/*
+		 * 12 MiB reserved for OP-TEE (BL32)
 		 * +-----------------------+ 0x43e0_0000
 		 * |      SHMEM 2MiB       |
 		 * +-----------------------+ 0x43c0_0000
@@ -75,6 +70,34 @@
 			no-map;
 			reg = <0 0x43200000 0 0x00c00000>;
 		};
+
+		scp_mem: memory@50000000 {
+			compatible = "shared-dma-pool";
+			reg = <0 0x50000000 0 0x2900000>;
+			no-map;
+		};
+
+		vpu_mem: memory@53000000 {
+			compatible = "shared-dma-pool";
+			reg = <0 0x53000000 0 0x1400000>; /* 20 MB */
+		};
+
+		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
+		bl31_secmon_mem: memory@54600000 {
+			no-map;
+			reg = <0 0x54600000 0x0 0x200000>;
+		};
+
+		snd_dma_mem: memory@60000000 {
+			compatible = "shared-dma-pool";
+			reg = <0 0x60000000 0 0x1100000>;
+			no-map;
+		};
+
+		apu_mem: memory@62000000 {
+			compatible = "shared-dma-pool";
+			reg = <0 0x62000000 0 0x1400000>; /* 20 MB */
+		};
 	};
 };
 


