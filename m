Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048263;
	b=34wD0LZLSrWnVY0vbwjkwKjHUvU7v/AGt48AAndTl3uiugZPlTK3HYS5VqKJg1pR8vfp
	 sS6aR+Hut2a2EyGiD9NY/8Wue5EP7q/abpmGKKz1u6PILDC0NjAqcjfFCcJJGK3zBdKdq
	 pljTkXMqPUVpRsu5xnp7hQNaHscP3ZA5kDhN3yIX+X0IWfyn5PaWIQ4IsNKYPUZa9LBES
	 lA5bPotNaCjeUIAtRkfNhEQRmuZZvF+HWChsXnO0mG21VlT0TwT0ajFLSrqivRdDbTKna
	 hIXfsGRc8FWQiuqFY1oxKBFzqlO9XboAyCNr5RtPRp9EGLfbqCqJt9YxvJU4r6krSkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4rrO8FwizeKNRqLGUhGKtEwaHrTxOb1WlXj30h57Wwg=;
	b=IopZhghFRgwYx1TuVkybDzNFKK1d5naSzM/SxcA7AyTKY83btMfyJr5y3TgDRuOYDm3a
	 XNbsrmFWsaFEe7YmBpJkwoPrMTJOgUtuGEHgLc5Z952w3I3BG1abXHDdoVo5EMakT8xZi
	 zHFkg4M2m1Bk4umr4YL/UVcFJoXkMc9IeGutBPjUXcf0aj2/JrkyubnDXoKo+Upmt2z7W
	 25xvvwR8g2ymi2SoRYqgUrwMj6dMFvjTLcun4XQw9Q5Gxw4y1IJCatOcz+EIMoL5HYn8Y
	 jjM2q/g95h4hIkjyM6SaETYA/KcT+gXrgR9F6jVHbRtxU6/KEvL02RNKWoQ+GUfROEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F/xTKTJ5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602CE606A31C;
	Thu, 19 Nov 2026 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F/xTKTJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ABE1F000C4;
	Thu, 19 Nov 2026 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048263;
	bh=4rrO8FwizeKNRqLGUhGKtEwaHrTxOb1WlXj30h57Wwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/xTKTJ5yeZ26sY1TNOECvaTpy2CyYl5XJXlvEnCdI6w5HJamtYRgd0I6oBBnRrwI
	 1NMxEoD4Vf93WZ165MwhcyuoY1xtE7mp8qYTQBHZFhLqCsa3qnX+pTdpB5naksDDyU
	 XvNT+zolvwSNvSHRuy5E81j+i6tUp0SJhb+68baA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1931/2857] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150310.739918085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



