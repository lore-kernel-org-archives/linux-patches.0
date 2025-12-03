Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB1632863A;
	Wed,  3 Dec 2025 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776973; cv=none; b=BZxt6SDNEwdzBZuNZV9oYjpcRzdSEpxWC3MGSuJcGzrsZz+ZTciQP5xayu89cYxg69d8HHa8b+vIl4irg6RUcqFy6mqFooUfgBZ2EeOp4Gj+1vSoMVUln/L9jeU7oAHDnHUsN+ZBOv/aFMr5EnwYM2Up6utEpwjUvJfUHbfmP4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776973; c=relaxed/simple;
	bh=IhGNfjYli1iaZRfh2YuuTaBUYMiVAdSYJDgc+1rg5hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqftW84mze33kB9Aqf4anyihFJOuFngxZU3sP9LYJyx73OiBGOFUnW2aqw3lpHbykIuyiNgl6Jj1TUqQ9hAZmJ2XMHNl6x2ohGrQh0PWJLjGcmxZqmpEY+FVfaO6yTeIlPLnOrVtolxE0STdyMdRU+FwUTwNQlVQuwXCfBE0YC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsy5Mqb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsy5Mqb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E78C116C6;
	Wed,  3 Dec 2025 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776973;
	bh=IhGNfjYli1iaZRfh2YuuTaBUYMiVAdSYJDgc+1rg5hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsy5Mqb400+jHrUsl70ZPaOZtdMJXUf5TpkO6KnhX2lx5dp1S6kHmXK14IFY+pDhV
	 YIqAnCRLCnjbpL/uHnjAAi14zF8r2EOqDBx1wSpAGY8/R5xNo0HAry/Om8wkJKS+lS
	 EP5dK29kX8t2tab6eT+PvvoSQAhOV6lW+kmYPOoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/146] riscv: dts: allwinner: d1: fix vlenb property
Date: Wed,  3 Dec 2025 16:27:02 +0100
Message-ID: <20251203152348.087521723@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Matyukevich <geomatsi@gmail.com>

[ Upstream commit 9f393d8e757f79060baf4b2e703bd6b2d0d8d323 ]

According to [1], the C906 vector registers are 128 bits wide.
The 'thead,vlenb' property specifies the vector register length
in bytes, so its value must be set to 16.

[1] https://dl.linux-sunxi.org/D1/Xuantie_C906_R1S0_User_Manual.pdf

Fixes: ce1daeeba600 ("riscv: dts: allwinner: Add xtheadvector to the D1/D1s devicetree")
Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Link: https://patch.msgid.link/20251119203508.1032716-1-geomatsi@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi b/arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi
index 6367112e614a1..a7442a508433d 100644
--- a/arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi
+++ b/arch/riscv/boot/dts/allwinner/sun20i-d1s.dtsi
@@ -28,7 +28,7 @@
 			riscv,isa-base = "rv64i";
 			riscv,isa-extensions = "i", "m", "a", "f", "d", "c", "zicntr", "zicsr",
 					       "zifencei", "zihpm", "xtheadvector";
-			thead,vlenb = <128>;
+			thead,vlenb = <16>;
 			#cooling-cells = <2>;
 
 			cpu0_intc: interrupt-controller {
-- 
2.51.0



