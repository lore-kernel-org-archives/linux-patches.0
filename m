Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015778;
	b=5fHtrkddkitHls3F4NkEZXm9yV3L+N1wkdx2LkdDDvdxeVeWKhFeGymS/bVHAbH+ndW8
	 uYC4Nt5esqKZhfMm1b0Acgcp07Q9T4Wr2EcP7DnfnBqh11pwopkdUs0aQokrD4CD4+CL4
	 PNnCpxU4uYSdLwOMZeHNhJBLmKUJ52J7XoRq79lizbhAr1/qqG/ollWhOlA4i95/tHFLx
	 upXPYv1d7yfd31pPFMevuWPUJEWOxes6bGDe5jVu2W7C4LwgLd16tVhZg7iIl3POMv/EO
	 +K2CNvWqW+LptqEiPwDMa2+47Avqu7rtGD7OhGlBoEaRpwETQ+Z80IiCU10DKjfRxQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qsN2POL9JlywxyCZZCZGlmRQ8Icev+AeyFHgOZrLnpo=;
	b=j/mIbfs8ywZztu8lUP6UgBInJIGHbCLD3n4W+qa5WAQFcWuuzg7ko07sAeD6rNuSFXeV
	 PyUqMbNIfZkylzFw/0h2Xf0wzURaVOV67TRBoRwRKJZocEJIBtuf/p0SGl4Z7BuzibCiJ
	 EApdUlZecdfKrObcunQ2Ed7sjYFt+qh+QY6IhRl0BxmF8d8DmXujzVymYnuLkZyIi/vu2
	 CDotioXDjUwSnB4/5KhGYJGKGvVPH718Lz+IzxU6y/yWrcj5g/dGqG1KbSW2SyOm0FdiJ
	 BNWBIXhTNdvNI4/Rkora3aADT+Cve2dS8YgcHdESjSVP7zSYhoZoPFADExJye0SWHYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXpfSICR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A231606A320;
	Wed, 18 Nov 2026 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXpfSICR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A9A1F000C4;
	Wed, 18 Nov 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015777;
	bh=qsN2POL9JlywxyCZZCZGlmRQ8Icev+AeyFHgOZrLnpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXpfSICRve49lMoKa1DKGXEIyWrkz0flJVFpPno9/f+eqwIr2k5qMTVfBRn6jQURi
	 6uqB2b10l6YT/WXX4/QGSOMZsqqtLNhjfwYOaJO+o8/iA8mLVrVQLfa+EuopE4H0Hu
	 ybX1XrN7XRI3l0yIEa/E11w3bKpLcMErQIjuNOd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0252/2651] riscv: dts: spacemit: k3: Drop guest properties from M-level IMSIC
Date: Wed, 18 Nov 2026 15:24:52 +0100
Message-ID: <20261118150256.930952360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 01e2f07c44fc46180bdb10e70506f8acf44a53dd ]

The mimsic node describes the machine-level IMSIC, whose MMIO region is
0x10000 (64 KiB) for all 8 harts. However, the node also specifies
riscv,guest-index-bits = <6>, and per the AIA specification the
per-hart stride is 2^(guest-index-bits + 12) bytes when guest interrupt
files exist, i.e. 2^(6 + 12) = 256 KiB per hart and 2 MiB for all 8
harts. The described region cannot hold even a single hart's files, so
the node contradicts itself. OpenSBI enforces exactly this constraint in
imsic_data_check() and rejects the node with -EINVAL, preventing the
M-level IMSIC from initializing:

  fdt_driver_init_by_offset: interrupt-controller@f1000000 (riscv,imsics) init failed: -3
  init_coldboot: irqchip init failed (error -3)

Moreover, guest interrupt files exist to act as the supervisor-level
interrupt files of virtual harts; there is no machine-level counterpart.
riscv,num-guest-ids is equally meaningless for the machine-level IMSIC.

Drop both "riscv,guest-index-bits" and "riscv,num-guest-ids" properties
from the mimsic node so the node matches the actual hardware layout.

Fixes: 56f37e391a62 ("riscv: dts: spacemit: add initial support for K3 SoC")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729-k3-mimsic-fix-v1-1-368c0aec04b9@pigmoral.tech
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index f9c2ffedeae80..86ccfb82e295c 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -1287,9 +1287,7 @@ mimsic: interrupt-controller@f1000000 {
 					      <&cpu4_intc 11>, <&cpu5_intc 11>,
 					      <&cpu6_intc 11>, <&cpu7_intc 11>;
 			msi-controller;
-			riscv,guest-index-bits = <6>;
 			riscv,hart-index-bits = <4>;
-			riscv,num-guest-ids = <511>;
 			riscv,num-ids = <511>;
 			status = "reserved";
 		};
-- 
2.53.0



