Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB231A6816;
	Sat, 12 Sep 2026 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217391; cv=none; b=JCOY9TqsFCUI0xe5riWEngbSGn6Ol7jskV+kN8sVdt5L6Xb9luJGIMKFlBE6aHR87jt3LWfmAFCh2OYtyHtFruv9CYMR4SER5PQQvzdtu7bXuXzGhq4TWq60c7vznvYJacWcaqKdzbtQnSutamlXPCfPkEGeqoJwIsalavlHHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217391; c=relaxed/simple;
	bh=RBwOYahPYHpCSE82dyZMOsqusvztqUjeJMh8Rsel9ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZdPjl3vmUCr9QhFVzIvC3MWSv9X+QuYkP9+ycz2vJ5VF0soaLU0RzRit3poJEw6iqzJBa8uwevylqB4SiCfIQeKOdTBFDeJ8+DlMEkxGBBQ1zjhKGi47mzoC5gRB2A3t9rCXapRkmBBRbJscPjlrCUhwVz7SAWQ1rjQ7I5Fqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8SW5l8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8SW5l8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0471F000FF;
	Sat, 12 Sep 2026 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217389;
	bh=y7Xpzk9kdrvCmIN8DGydG52dFYKVnZe1S5yEBAG05xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8SW5l8jt13RsWiQa9Tz+5eOUrGE/diqjYayRRVJJYCg/Poj/8Lb/59HglzepUGYD
	 2cIrvW3LzWCLfW7IkE0nQzYMfydZyLn+Occ9txAlM1Hgz1hpMA3VilWXbZ7UBda7mW
	 2h0sYRHml3tqUBoCNl1Dq8TOLh3u9Xarf+9fET0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Anton D. Stavinskii" <stavinsky@gmail.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <chen.wang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0889/1376] riscv: dts: sophgo: cv180x: Allow the DMA multiplexer to set channel number for DMA controller
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065627.376202771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/riscv/boot/dts/sophgo/cv18xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
index b8063ba6d6d7f..e519a72c093d1 100644
--- a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
@@ -298,7 +298,7 @@ sdhci0: mmc@4310000 {
 		};
 
 		dmac: dma-controller@4330000 {
-			compatible = "snps,axi-dma-1.01a";
+			compatible = "sophgo,cv1800b-axi-dma", "snps,axi-dma-1.01a";
 			reg = <0x04330000 0x1000>;
 			interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk CLK_SDMA_AXI>, <&clk CLK_SDMA_AXI>;
-- 
2.53.0



