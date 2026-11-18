Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060575;
	b=A7Zmx8ZFGHIgzk/Nxm9RHHRPrB+EnGJ0CQI5kixKcgjnp7C+J2aNC+pHYxcOQipW5/mK
	 DnV1RmXB8UE/u0Vfh7BgQEN7vUUKE+0esctN7RO5wIG2u0d1VGRJ/ueXsZEEnELDUkEDD
	 OCFkH2rsPXcVwO4Ic7RrTDNr/cTKY1Nn4mkATMCssTHqXVyl1tnPoGiR6t6kog2pzq9/3
	 215bM2Rlwt+BKAsAle/1bkBSyKRlJ59gkUfuSlSv0ZqVN1mGTAeNTiuAFLIXZHOccc/fU
	 YMs5RoxQHwyr8u2bpiS8RH5EdQ1rzExtESxp31Q9ZrT4rfU5kP9QW2suZzcwAeKNzTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6ifCM/EM+Nn5hg/Dl2iOBsh2HQCjan9qUp2Lvma3h+k=;
	b=CldM2dHHaOP5ujA9e4u4taxqX3vQ8WmpobzSstyBOwIN3S5o0sJtLiSi58dvoVT+VQB1
	 mkI5fyRckWks2LNzO6ePhot78puN3sN7tBAAZ9ryZoqLh5xlYGrYC2g5yxjs6ytFrNZMS
	 PncfYwqdnfGJae3U2j5beTZtys2GXMuXWJMjFTGCNwYID9l4sPYiX4bFhM8j1+6wzDgGo
	 A+S4LbeTYSE1kHspqN3RYclR9N/801EqMUlP+S1eITxIG4d32GeM+jxi2M+7q51G/7wul
	 PRp5pFJ4kuJGGhAMy/lW2c13fFK4LuhsHHgKD0Q3S9jBP40ko1mxpACSOHn6I1adniQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBBx1Fbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE93606A326;
	Thu, 19 Nov 2026 03:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBBx1Fbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C391F000CA;
	Thu, 19 Nov 2026 03:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060575;
	bh=6ifCM/EM+Nn5hg/Dl2iOBsh2HQCjan9qUp2Lvma3h+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBBx1FbpUdzJ0CIdS3WrDcxIINdkQlMAOv0tSbF4o5vCtIv9t7g+JmE3ai3BO8q08
	 PCs3+cNRg0PzFzcpkzGym+vdqU4Cwoke8mjhSDeYUkbFz6f2uIFUwSgYYrzkfctka+
	 oykX1CbkFd+ST3BiQGvkg7YSBrpQLZhlqhLkqxHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1249/1848] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:54:47 +0100
Message-ID: <20261118150012.085448728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7b340a35b194b..4022dd9759bbb 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -38,12 +38,10 @@ CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
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



