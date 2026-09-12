Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433F83DD847;
	Sat, 12 Sep 2026 08:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201947; cv=none; b=tMelcgp72v6nSjVSzpYolG6faUvXF/6SERTirZOYo6uCE5B6OKB32v794DbJtnRo7+OW+OJwvp+jl6Pypn1np1HVFYnQKKCuk4uyJeTqlTGhwGqk+peoy+BN6/L4hpUMYE3cfI4ZTfKZ3FYpKh/WzhPjJFxFDDlILIKMcC0+N1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201947; c=relaxed/simple;
	bh=VVX3Q+NRyGxunRCCZ3g+/KhMG3h0maCN1Q7Nq6P2+zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ezt35yAMinRU7gy0Ceo4DpMklFzVYm4iMOpZsB+/ACoEDU/SrFbjXYawZb4JIzUemN/tRWE/u/vXQAHtX48OoDZBTduwuTpH2i8H3aLJ9QSDMutfGEyOidGJ9rrX4XzQD+GamVvbf4nFZarvKhTVNb2QoQsSqCLvY06zOJf82ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPTClTT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPTClTT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAC01F000FF;
	Sat, 12 Sep 2026 08:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201945;
	bh=/rcQ4upGfBWDhIJ9WeCEpEFyHiPSOJnaTwt1jVW7eew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPTClTT8rWiagQG7axVUXvTSO2dYLATfhIg7o1w8Y2P/nwU3Fwbc71rpZGku8Iybg
	 AdfA3q62ebkS2yHFnCb2jkjR0rGMIjI5bGjxccNWZCvMorCwS1N7ogEkTsiwgjJ1DA
	 ixPRQGIpjPqX0oHv2m/5VWirvDgCiz4XlIdQ27hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Anton D. Stavinskii" <stavinsky@gmail.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <chen.wang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1048/1815] riscv: dts: sophgo: cv180x: Allow the DMA multiplexer to set channel number for DMA controller
Date: Sat, 12 Sep 2026 08:46:38 +0200
Message-ID: <20260912065713.619294319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 06b0ce5a2db7a..ecafdee79ac8e 100644
--- a/arch/riscv/boot/dts/sophgo/cv180x.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv180x.dtsi
@@ -417,7 +417,7 @@ sdhci1: mmc@4320000 {
 		};
 
 		dmac: dma-controller@4330000 {
-			compatible = "snps,axi-dma-1.01a";
+			compatible = "sophgo,cv1800b-axi-dma", "snps,axi-dma-1.01a";
 			reg = <0x04330000 0x1000>;
 			interrupts = <SOC_PERIPHERAL_IRQ(13) IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk CLK_SDMA_AXI>, <&clk CLK_SDMA_AXI>;
-- 
2.53.0



