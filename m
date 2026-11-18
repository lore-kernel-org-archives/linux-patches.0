Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023628;
	b=4XisWji9RhCK05YPWQ4Dxs+bvkNDYhpyZggtanfSm7fTCJm1dQyGjOaFw8tSIZGFnNH7
	 pFff1c32erFWa7wGYU2BuWTGZZ5UTOwPV8AbRb/b00VYFI2aHMDf64DII3A/IQfdgpTAa
	 zinR2nm84QW50niXwlrSzcINzShwq4dFG7P4f58VMEtkMG0WrcGTGlR2l4Yx27rc5TtCv
	 1QDpF2Y8OucScCSmSxvHka8A1S5huwFHCEpcCAVW0VNpJ9ZVyTKrXO1J0Al5htXBQLpGa
	 gZZ62A55JIBBChslf3gbIKEdsf1nTakL9Tc5XsAWa2dehk/9Md3DL5sBKBO7IZybvkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XG6WnCC3KONmD81tMUwaiQgdylNBEzooUko1Kh1wVhg=;
	b=nqFGltlANJQwL1M2n/+SVoVy4xLsjUH6ocVCTYfmEPcBsqIaJKa5b/CnD+zNO/VuRhpq
	 BtPu/5P/GlTVEaxy/pL/1wmLOBHJruxmSF+C+LAZU2tWkKoGX00Dv676c0B3rfeQhe4Dz
	 DrsbctN40OtQg4VbACAS5DhLG0cKZMk1SGS2e6lzGFJ6y80zWyOdjXOMCyfzFvPJd8Wb5
	 KaEg/vFXtf6hTgL3UNxZ2fQ3lDKCOiNeHSCkAh3wqDnMvKN/+XTHNju/4B8g0TNZbiHb3
	 azyrM4Ie+GTKRUO+ELITS8Ml4CLIyayTN4M2WHKR4tEP5KRiZiG6sH9kTlnqPOF4yzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ka6phHDK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9C606A31C;
	Wed, 18 Nov 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ka6phHDK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182CA1F000C4;
	Wed, 18 Nov 2026 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023628;
	bh=XG6WnCC3KONmD81tMUwaiQgdylNBEzooUko1Kh1wVhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ka6phHDKpBMZZc4+SgW921yRPaj1GEVE01XXM7q8OaUoYvNwUjp2DhQOXmFmpxzcv
	 LCSe6Gooboj/t9O/00Ydkk6N/MaIshRdpdzxynrVc/ZAK90yg8zz94Oki0eSHTQ0cU
	 lZJAOLQOBgjwQIev0OvfrB4rNBL/yVPjlSffkwQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0438/2151] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118150137.993123750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit b9eababe8c0b9f71ce7f35f903879a7fcb6daebe ]

These parameters are also necessary for preprocessed files which do not
contain code. One example is arch/microblaze/kernel/vmlinux.lds.S which
inspects __MICROBLAZEEL__ for the definition of 'jiffies_64'.
As currently the endianness is not passed from the build system for this
file, the preprocessor will instead use the default endianness of the
toolchain. When a default big-endian toolchain is used to build a
little-endian kernel, that kernel will hang during delay calibration
as 'jiffies' never changes.

Make sure all preprocessor invocations know about the correct endianness
by passing it through KBUILD_CPPFLAGS. This will also be inherited by
CFLAGS and AFLAGS.

Fixes: 02b08045a030 ("microblaze: Add support for little-endian Microblaze")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20260914-kunit-microblaze-v2-2-7d5756e858f8@weissschuh.net
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 02e6be9c5b0dc..9087a366ce789 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -34,12 +34,10 @@ CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR) += -mxl-pattern-compare
 
 ifdef CONFIG_CPU_BIG_ENDIAN
-KBUILD_CFLAGS += -mbig-endian
-KBUILD_AFLAGS += -mbig-endian
+KBUILD_CPPFLAGS += -mbig-endian
 KBUILD_LDFLAGS += -EB
 else
-KBUILD_CFLAGS += -mlittle-endian
-KBUILD_AFLAGS += -mlittle-endian
+KBUILD_CPPFLAGS += -mlittle-endian
 KBUILD_LDFLAGS += -EL
 endif
 
-- 
2.53.0



