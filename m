Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016234;
	b=C4FlgP9Z6xlP0Bbl83/Oigt8/iseYr6w5pHyGKijUPshPaLlHXtEh6yny0wLHvpyDnUJ
	 Boevi7355prQQGa+xkM5DbwFkR5WyVYDTgsAPZeeBihdtoS4YUUzRM8nGsNYONukDd/2+
	 LPBgIb1GvK5CE47ptunbxjsOZnQUtNF+4tHPxNMJyrU9NnY8fR0GTzmEfoN2wLRyAW4d0
	 Gyfat0hNRT/AkYxRingIL+ezASGwjHJg2YWLoHb3F61gbHGHeubj503ZGUU7i9B59d2HD
	 XYBBvhAgiNnWDB2XCc6md+Uv9OFj5hQd8hA7MMjrm6ZV20qlFd84LUhB3RvkgNYQgwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oqBYs0LdFhs+IP6I8nG44Wq1lDnXMHYSLwihprS0jio=;
	b=g19nKu5yBfX/Gg0acbmHyM9w6c8Ta2yLTpy8WW1SXxhjZ9KrHJUmAGKTgDeSESdL0ThP
	 6yWiia276dwi0nFf8I5bVylQfVl3IkJwFqA7Bi8bvgXQYFEMxXZ117vmKH2t4ZJuIXQoN
	 BkFuxCjARAJvAkYLmxesUz8LZTDfT6wR8sGKTFdiA7B7UMmMVnIgIvH8cdg5iWbJrVAo4
	 fOLuhkUVOKndDTX4l/dKszZSONifq568yZu8ggKsUI3Q6gicmuJPgRl9v3cB+nfck+TAk
	 qxH56cvh2lNHnZTcJw+Q609woKH2lirNLFlyWsc59IClukgGg8e+nC+NzeBEsos4E1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHVcInRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A67606A320;
	Wed, 18 Nov 2026 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHVcInRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA981F000C5;
	Wed, 18 Nov 2026 15:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016233;
	bh=oqBYs0LdFhs+IP6I8nG44Wq1lDnXMHYSLwihprS0jio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHVcInRm4sL1RhJ2MFDBnbBLVjEwX/OvUUiPaTkASt9QkMthBYZk4C8uWhmKCVmG/
	 bvpjkx96Us5GbDb1C7gu5WPk9RFUD78HMHsdzumBT/4X0l530gzt03VGzBsOgrk6oD
	 QVtUMoVqAaRVGRiJ5CVt1LF5csHWsxgEzC9uONd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0455/2651] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:28:15 +0100
Message-ID: <20261118150304.185516802@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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



