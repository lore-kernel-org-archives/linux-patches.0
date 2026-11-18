Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029579;
	b=UKO+P0F1ipPjaoIYWen1xMNZAzqgfG1sAVbxuoOs9QjljSXvTRNDX3JD/+27oQs2BLUf
	 ys44VtrywsIazD8BpvEhySxj1slsuWY/hrqrP6dhd98fanwIRIE7Vu5de23pWh0FXVxnR
	 wtmB81rB09uYVD3qo4Fn5IMDJs7zED+OjapckPgxPaB73Z2S+MDmd/flugeNT+VyvYAtR
	 cfe+EacSM6sUSwz57dJMsjNMvHC8cWX55RD0nW1NbX/6vTRO6LpvYv02z/SNFUfJucB/n
	 Qlh0o3RAm3BpLOhGTZCqPbUUNWXyFaBKJPZnB5urzKnzK9o9+X5CEekLH2r6jy1E6WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=87HTQHWNAlMihKnx9Bn9HPyU5cOSyYnhe1GZidiiP0Q=;
	b=caTVW35epPLuTQ5GUzC17yTQ3vijAL3wHb9C7uGHfWOAP0xuVN9io/vjaVvfmQHyWbXF
	 udt485834ftM6evirSfd3MWkMHymdd3GZKK1+NtbPmGgDHigjZbvE07qlQg3XK+3Y46Gf
	 ThKPoEQG8ZdhVfpFzvw26w3JE7M4wpNyDbBG7T1dWAAXEpQ01+JsgxxKX2thrdpCt8b9z
	 +uN3b6LcJjaICVeISrzm6fpcPWqfsRwwLsIA7FftmII1/S/P2RAGL1QL1cUt6CVjphvUf
	 sRA13L3Vz4kOPPTbhiBRZ7PL9MTXLmtDUeHiXSejiyC80n2eaRDywrfLPkjjdJg5idw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iq5eiCNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B36606A32C;
	Wed, 18 Nov 2026 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iq5eiCNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AFE1F000C5;
	Wed, 18 Nov 2026 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029579;
	bh=87HTQHWNAlMihKnx9Bn9HPyU5cOSyYnhe1GZidiiP0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iq5eiCNJZbuaKczj0SlRwjMFbkjJOgFWf4FdWeAcdwE2qZ+julIL8sbs6B3HwNwOM
	 yPvK1JmWoRCehUAeUlVS5WwhktxUcLXHSEai+fiS5ZY6hScjuZU/EJSYOHyF9J6v3i
	 Xx/Lm1LA3GrxI2x8w/uNERl6pqRApk3Wp+75p4zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0400/1756] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:42:07 +0100
Message-ID: <20261118150024.686444235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



