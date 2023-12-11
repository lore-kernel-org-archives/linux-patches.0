Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA8FBE1;
	Mon, 11 Dec 2023 18:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFSEpWUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA7EC433C8;
	Mon, 11 Dec 2023 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319649;
	bh=scJfkLbMq7fUnUk7+P/lrKwZf4grn5HnVtWnupbQC9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFSEpWUMipINr7c/3nLcJPZXHbIpuIcK9xDlvdkonWs0W/cfAybtUahCASDfEWf8i
	 /8n0XEL222LubAUtt3VzMhyvXfWP0rKK5fmOcTkRWKNXULblmg1gt5xpmvLsrxKoWk
	 4oLZzZmDY4btbO412xcN0LptmxNlaBpl7CTPjGSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 184/244] arm64: dts: mediatek: mt8183: Fix unit address for scp reserved memory
Date: Mon, 11 Dec 2023 19:21:17 +0100
Message-ID: <20231211182054.190944164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit 19cba9a6c071db57888dc6b2ec1d9bf8996ea681 upstream.

The reserved memory for scp had node name "scp_mem_region" and also
without unit-address: change the name to "memory@(address)".
This fixes a unit_address_vs_reg warning.

Cc: stable@vger.kernel.org
Fixes: 1652dbf7363a ("arm64: dts: mt8183: add scp node")
Link: https://lore.kernel.org/r/20231025093816.44327-6-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-evb.dts    |    2 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-evb.dts
@@ -31,7 +31,7 @@
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges;
-		scp_mem_reserved: scp_mem_region {
+		scp_mem_reserved: memory@50000000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x50000000 0 0x2900000>;
 			no-map;
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -108,7 +108,7 @@
 		#size-cells = <2>;
 		ranges;
 
-		scp_mem_reserved: scp_mem_region {
+		scp_mem_reserved: memory@50000000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0x50000000 0 0x2900000>;
 			no-map;


