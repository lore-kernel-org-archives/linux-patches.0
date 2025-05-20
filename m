Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493732459F2;
	Tue, 20 May 2025 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750040; cv=none; b=ktyWdib3Xq5yhxvPYfLVdQt1oylXJsA4UbH0XMBUx8nxlby3rnxh2CIyBKI/RdSRWE5AC3zI4eEn3tx5axW2XI4Aukliv3YcBTsKUj5xq3YlflYssH9e/1MITxOKktFsQQXOhwRwyiFXqov4jX806300kq5+2LLvI8ozM1Ryto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750040; c=relaxed/simple;
	bh=wyRutWzuzGn05KCxp9ZaFRS0hDKe25cusLjX5NPMXKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNIDyGjz/8eTUFvcqpySOhb3jaw2PzdWxl4VxxNgdXDkF9L5HKVo0WpNDIqxQuSS/Ujx+9L9t5BLooOgkxt1vz6kdRx4NNfFL1ElabntXZe/rt9wO0J4AHJ5fBGj+MmdHa6dvum3WfCrOxvnS6YFZGR5QFBICc6f362Nivk5Ndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCYdUqiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCYdUqiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9DDC4CEEA;
	Tue, 20 May 2025 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750040;
	bh=wyRutWzuzGn05KCxp9ZaFRS0hDKe25cusLjX5NPMXKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCYdUqiQruastXrBRQQj8M6YcUR+FyZ7n3MzGwiVFLldxEMiwDBWhKYaUuto5YGMH
	 3Vhyse7o3/b7QWiQtIXWVCUeNLVgsomltLw2jTlrDvHBUPMwKixUMQ+o+WA0MdDy5f
	 jIMPPtdx2sa9+O3tuVUFl9oQsR/TuLcfHY8NV6F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Yuan <yu.yuan@sjtu.edu.cn>,
	Ze Huang <huangze@whut.edu.cn>,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Chen Wang <wangchen20@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/143] riscv: dts: sophgo: fix DMA data-width configuration for CV18xx
Date: Tue, 20 May 2025 15:49:20 +0200
Message-ID: <20250520125810.256887338@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Huang <huangze@whut.edu.cn>

[ Upstream commit 3e6244429ba38f8dee3336b8b805948276b281ab ]

The "snps,data-width" property[1] defines the AXI data width of the DMA
controller as:

    width = 8 × (2^n) bits

(0 = 8 bits, 1 = 16 bits, 2 = 32 bits, ..., 6 = 512 bits)
where "n" is the value of "snps,data-width".

For the CV18xx DMA controller, the correct AXI data width is 32 bits,
corresponding to "snps,data-width = 2".

Test results on Milkv Duo S can be found here [2].

Link: https://github.com/torvalds/linux/blob/master/Documentation/devicetree/bindings/dma/snps%2Cdw-axi-dmac.yaml#L74 [1]
Link: https://gist.github.com/Sutter099/4fa99bb2d89e5af975983124704b3861 [2]

Fixes: 514951a81a5e ("riscv: dts: sophgo: cv18xx: add DMA controller")
Co-developed-by: Yu Yuan <yu.yuan@sjtu.edu.cn>
Signed-off-by: Yu Yuan <yu.yuan@sjtu.edu.cn>
Signed-off-by: Ze Huang <huangze@whut.edu.cn>
Link: https://lore.kernel.org/r/20250428-duo-dma-config-v1-1-eb6ad836ca42@whut.edu.cn
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Chen Wang <wangchen20@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sophgo/cv18xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
index b724fb6d9689e..b8063ba6d6d7f 100644
--- a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
@@ -309,7 +309,7 @@
 					   1024 1024 1024 1024>;
 			snps,priority = <0 1 2 3 4 5 6 7>;
 			snps,dma-masters = <2>;
-			snps,data-width = <4>;
+			snps,data-width = <2>;
 			status = "disabled";
 		};
 
-- 
2.39.5



