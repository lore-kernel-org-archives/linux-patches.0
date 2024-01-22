Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC40713398C;
	Tue, 23 Jan 2024 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969321; cv=none; b=PrwBGZNb8T0qwhIUVibNy8mNUMQE7NU1nyRzG+hcoXkEfOz9mONHGCzo+wbGd3R91gLarm1ZFWjdxX8isnIvu1bbVavWE0Nv4cjFttaYKsakPc7IHNBl5mTcvRjGZ04tmQuN7KZgDuGrr0qbFHF3kbQ+E0j+iT6fFGA4kiUxOzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969321; c=relaxed/simple;
	bh=Jnwe/BeROQA1+fucFLviPhNOBLepMdofW0mnzgnmoNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpH+l8m0pW6pCUbVr0Npofx3YcOJwCdAYu6C53+GjhOLzoD4dkgTMCMF+Gb+RrZLcvTtrReuHiVYJ/yJCq6D+9M4p65yAWeHwfrmU2yxdIVNI6kLC9lhTVXbCl613axllBaerKsqNFoMcXHR1PEgKEHxu0bBtq7iwH4hzJwXHHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kM9LBlEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kM9LBlEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DACC43141;
	Tue, 23 Jan 2024 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969321;
	bh=Jnwe/BeROQA1+fucFLviPhNOBLepMdofW0mnzgnmoNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kM9LBlEoBmDRGoaKh23N1h3tjeHuSLID56x/+dBHQ65dipjC79Wik0+RePYblMtcW
	 EOZggVt1+qHjFLiulOXIeUr615Tq7mRnXhVRUKwzLRHNifBMv8FJFn1tkXmOh3LkqY
	 HYQUl7R/mSD4X0q8859Z+2qpsX6W9bclwhuUAhrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 172/641] arm64: dts: xilinx: Apply overlays to base dtbs
Date: Mon, 22 Jan 2024 15:51:16 -0800
Message-ID: <20240122235823.391659881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 23b697ec85f3e7beed271b9f344c54821de2251e ]

DT overlays in tree need to be applied to a base DTB to validate they
apply, to run schema checks on them, and to catch any errors at compile
time. Defining the "-dtbs" variable is not enough as the combined DT must
be added to dtbs-y.

zynqmp-sck-kr-g-revA.dtso and zynqmp-sck-kr-g-revB.dtso don't exist, so drop
them.

Signed-off-by: Rob Herring <robh@kernel.org>
Fixes: 45fe0dc4ea2e ("arm64: xilinx: Use zynqmp prefix for SOM dt overlays")
Link: https://lore.kernel.org/r/20230911214751.2202913-1-robh@kernel.org
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
index 5e40c0b4fa0a..1068b0fa8e98 100644
--- a/arch/arm64/boot/dts/xilinx/Makefile
+++ b/arch/arm64/boot/dts/xilinx/Makefile
@@ -22,11 +22,10 @@ dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA.dtb
 
 zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA-sck-kv-g-revA.dtb
 zynqmp-sm-k26-revA-sck-kv-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA-sck-kv-g-revB.dtb
 zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revA.dtb
 zynqmp-smk-k26-revA-sck-kv-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
-
-zynqmp-sm-k26-revA-sck-kr-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-revA.dtbo
-zynqmp-sm-k26-revA-sck-kr-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
-zynqmp-smk-k26-revA-sck-kr-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revA.dtbo
-zynqmp-smk-k26-revA-sck-kr-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revB.dtb
-- 
2.43.0



