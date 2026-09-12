Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485B33876C3;
	Sat, 12 Sep 2026 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209781; cv=none; b=kZEagBcEE1upcONmc4cfGXR10wWIjIPLuEFgEBFe/7fbM0JJSkxPVLgpcbtQm+zlnTGVfU/rY7rOmj5UGMP+UY9pCm6Uz79D3ExBmOrjd+8CCclsrpZPv5Vi+qJdUf3WqxK7cLIEcGShlsOLOXfDKVxeyylzCGN/lC6o3/aDEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209781; c=relaxed/simple;
	bh=tlwHso/437YCi4JnQ8WXOGDiIIpKu2Av+R9Ep3oieGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=istu1oWxFXrOEA65QZYu65624Oyrs9Qu8zhNOUMwZc4IHzjYYdNVfx1LU87NalXG1lQRw1GDUX7iduEpqRZ0F8ad4WEZe/KW6uNYyeEtR5pgOZUWyxSaUckGv7WSNo7TVo3P2iPtCvVhxzL08HFTF8l4SCUL3Y0h1xvUEI+26mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSDrMB8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSDrMB8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F9D1F000FF;
	Sat, 12 Sep 2026 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209779;
	bh=9GSbmhoYV0NGMT/2+vznz3LhAHT/T1WF93b5WcrNfzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSDrMB8i83yL09w4GwdQRCejis1V/wWvMWNaJzRL8X4xx73h+Knj7JOBjAqVS2NwD
	 uw0NJKL8kjboh840T13nTMwxzXivEN5UyRdacM9ptiLDob5DpQxGptrdpZsmdoFYif
	 L9DwuHM9L8xmyAcrNx2sHIo3s9lI7FyS2PmBqLV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Anton D. Stavinskii" <stavinsky@gmail.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <chen.wang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0874/1518] riscv: dts: sophgo: cv180x: Allow the DMA multiplexer to set channel number for DMA controller
Date: Sat, 12 Sep 2026 08:50:43 +0200
Message-ID: <20260912065643.220812821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 5011466bade64483bb52bc4a926719d6794e6dab ]

Change the DMA controller compatible to the sophgo,cv1800b-axi-dma,
which supports setting DMA channel number in DMA phandle args.

This dts change does not break backward compatibility as a fallback
compatiable string is added.

Fixes: 514951a81a5e ("riscv: dts: sophgo: cv18xx: add DMA controller")
Reported-by: Anton D. Stavinskii <stavinsky@gmail.com>
Closes: https://github.com/sophgo/linux/issues/9
Tested-by: Anton D. Stavinskii <stavinsky@gmail.com>
Link: https://patch.msgid.link/20260511063818.463877-3-inochiama@gmail.com
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Chen Wang <chen.wang@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sophgo/cv180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sophgo/cv180x.dtsi b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
index ccdb454986535..b2453ae452164 100644
--- a/arch/riscv/boot/dts/sophgo/cv180x.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
@@ -391,7 +391,7 @@ sdhci1: mmc@4320000 {
 		};
 
 		dmac: dma-controller@4330000 {
-			compatible = "snps,axi-dma-1.01a";
+			compatible = "sophgo,cv1800b-axi-dma", "snps,axi-dma-1.01a";
 			reg = <0x04330000 0x1000>;
 			interrupts = <SOC_PERIPHERAL_IRQ(13) IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk CLK_SDMA_AXI>, <&clk CLK_SDMA_AXI>;
-- 
2.53.0



