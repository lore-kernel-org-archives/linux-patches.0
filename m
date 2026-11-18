Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055073;
	b=1dlIBRP37Ct3s3UIlnIwRSA+Nnr+BpQ0XUptvLrY3vOBXjTn3RNtrcF2Y1R/4HfS8hZj
	 kYT20tzTKPiloBYV3U4Qb4c3qUperMQV00p5ELbNmrHTlUCJKpIe6/stuJRe/SI4aYE7t
	 R+VK5F+PvH/ukBt/zhi2YHezNYkMEd199EkKOFFQi1icVT8greL+uuvJAcjFQxu4f22fK
	 aGbRgrkfLs3BWJCgSBQBOb/NrsgrjdwDpKGHLkZj6+Q19Y45iyIZWt3wKtlKU0uBHA2nH
	 o4v6+5uE1lWcbKUtKA00d0A+usscqtEOjfE72aN7DH0EwAX6oisn1+eTXXDmxDKYM2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=STJF/+w0JnSKbgb/Rgtcif0kYkxtsYPuoEu94DZ72y0=;
	b=PlJ4aEI/svBDxjbOVG0gfSLXIOOOKLGzXyp4vg8d/LQh+uPvDyIhpvdOT8+1bK5QrjJQ
	 MOFTkP1FoGChUDeLlKNoDAAjrJOIU/6cZRP3kMd8pND21yHnkodm3Obm43lchpupCRXfT
	 mZVHKhpecRquaXc5lHHUIqVVXEZ4RX1GnolUt1FqHXVde5WzaSAAC2zz9j86Ub0TgDI9l
	 HB2OQp9IaXZnMkHzNlzYZIKmp+RiEgPm4yAosSwDxMZ7P4MScHn89nQrOCMvBt0plmaSr
	 eNIE6YWTjb+tbRzsBzsCMcEEILowkuKRjYqAEqvUVWWTJekWOg6MdhJomquzellCBxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvGYgc7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F67606A320;
	Thu, 19 Nov 2026 02:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvGYgc7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E071F000C4;
	Thu, 19 Nov 2026 02:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055073;
	bh=STJF/+w0JnSKbgb/Rgtcif0kYkxtsYPuoEu94DZ72y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvGYgc7DB+suaWqx6GYnexH/PAV1n3HQe0ylBzTRVT5IUGxnjK9x9Xqpm9h5GzFR8
	 pRqvQsF1KErvq0DQQ+x4anrjUhq6/YEWSethUoY7LXLFuJXp834YgT6t+Joxha4Gjd
	 5HchLjzs33poqQq6h+FmIXYILF6jOk/B1hmDbehw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1500/2214] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150111.725357344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9adc6b6434dfe..a46e259611b71 100644
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



