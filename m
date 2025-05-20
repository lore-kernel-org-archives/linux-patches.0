Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BB24E4B3;
	Tue, 20 May 2025 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750460; cv=none; b=djRWNuakh3e2I2mumtKdhQ40QhCCVdfgdDth7Hxr3QQpteLZFcuZ8uNkNv37ILEYtjkrjA+ZfmCfqHwDSi7zp7l/T1f4COMTy/ZsFm9QbSsWa/3durO8bH4vl+9uhvyeWT7P+tfyjh3kUB/Hi6V68RtEc/Z/6M2IfXp5dWBsSN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750460; c=relaxed/simple;
	bh=OHQ9RrvZ75jgM+2EFgfehcFATHSUaj6pI2tUXeccpg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8HCBLt+D4Xyvov1zUwMDh0oCqkr3/YlD0VX41GU99F/qOEq7GTHUM1zMWFU2BHY6sRjE0sDeS4SISWxbubFS+vgsprC8+0l+w/TcVdUu4tWj1bk/20VRPlA67svkNgvwnwf5dIX9/qARniFffl2BUjV7x40IonbzHI5NhSQFDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVgM6fxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVgM6fxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A00C4CEEB;
	Tue, 20 May 2025 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750460;
	bh=OHQ9RrvZ75jgM+2EFgfehcFATHSUaj6pI2tUXeccpg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVgM6fxWK1J9zeNy1k6OVijcH90W0bUeEZKTbd0IBTisZNELpdY1Nc61vFoQpNhEo
	 3XSw8VJ95IEj3Fkbq2cfcQqGqI2lltjWODcF40aCySl7as4Tc80iblMVfogDGUn/Km
	 wMXXt2Wbd8jtq450K0UQxBNYfGpf0qLm7d3zoDW8=
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
Subject: [PATCH 6.14 008/145] riscv: dts: sophgo: fix DMA data-width configuration for CV18xx
Date: Tue, 20 May 2025 15:49:38 +0200
Message-ID: <20250520125810.873449932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index c18822ec849f3..58cd546392e05 100644
--- a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
+++ b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
@@ -341,7 +341,7 @@
 					   1024 1024 1024 1024>;
 			snps,priority = <0 1 2 3 4 5 6 7>;
 			snps,dma-masters = <2>;
-			snps,data-width = <4>;
+			snps,data-width = <2>;
 			status = "disabled";
 		};
 
-- 
2.39.5



