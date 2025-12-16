Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9DC3A1CF0;
	Tue, 16 Dec 2025 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888257; cv=none; b=eRtyJFSf9OuVnD3rRTX4WhX13LOmaoLo7Q2/Yzad93ZPR2226L2UZZyf6msKuEhxQs/4feBoYyZuPZ4W8W570YiellOMvLaEzgu3CBYLU8s5g+isZaZht4/yBcXs4dEJh6Eri2b8o4RP/Dp6d0QC+8jDSIuBpWwBTRsoeKe8np8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888257; c=relaxed/simple;
	bh=Ojzb2SkmekN1FNr6xtb/ov/VQ9GaurqMGmFCzOUoxiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psi2ouzrzGSLEVVx3j8Yu/TT5Z6jgJYQ1UNd9kGef4yT7EV2V2bNkD0Bf2yfilmObd7j1NRWLzfkvhZmI23I1flZrTx9exR16ooP/FTxvhNDuxlQGd/C/wkmM7bvDwsCt3g4bfTOqEO2WDqfu6vOHoJ1nN2EDqpi75XwoeJGX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoSFMRSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoSFMRSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60F6C16AAE;
	Tue, 16 Dec 2025 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888257;
	bh=Ojzb2SkmekN1FNr6xtb/ov/VQ9GaurqMGmFCzOUoxiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoSFMRSruYgrmtGkcBcITKQQNtYMx1M5mwvfxKkJJUpEi6dEj2uEFi/zia5jxt9BL
	 tLI4zOdplpEk1PkhOw2X5LXD22GTNrBNBrUSKwSO8jDYdPo1iKeryYTF6cmgp1boH3
	 EOGWTHlHwVrH4v8vIOfzsrWMwxmS0gO5MLhjbSHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/614] arm64: dts: mediatek: mt8195: Fix address range for JPEG decoder core 1
Date: Tue, 16 Dec 2025 12:14:06 +0100
Message-ID: <20251216111418.725375777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit ce48af13e6381772cc27676be63a6d9176c14a49 ]

The base address of JPEG decoder core 1 should start at 0x10000, and
have a size of 0x10000, i.e. it is right after core 0.

Instead the core has  the same base address as core 0, and with a crazy
large size. This looks like a mixup of address and size cells when the
ranges were converted.

This causes the kernel to fail to register the second core due to sysfs
name conflicts:

    sysfs: cannot create duplicate filename '/devices/platform/soc/soc:jpeg-decoder@1a040000/1a040000.jpgdec'

Fix up the address range.

Fixes: a9eac43d039f ("arm64: dts: mediatek: mt8195: Fix ranges for jpeg enc/decoder nodes")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20251127100044.612825-1-wenst@chromium.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index ec452d6570314..c7adafaa83288 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3067,7 +3067,7 @@ jpgdec@0,0 {
 
 			jpgdec@0,10000 {
 				compatible = "mediatek,mt8195-jpgdec-hw";
-				reg = <0 0 0x10000 0x10000>;/* JPGDEC_C1 */
+				reg = <0 0x10000 0 0x10000>;/* JPGDEC_C1 */
 				iommus = <&iommu_vdo M4U_PORT_L19_JPGDEC_WDMA0>,
 					 <&iommu_vdo M4U_PORT_L19_JPGDEC_BSDMA0>,
 					 <&iommu_vdo M4U_PORT_L19_JPGDEC_WDMA1>,
-- 
2.51.0



