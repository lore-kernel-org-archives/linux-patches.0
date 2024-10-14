Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D041A76A5;
	Mon, 14 Oct 2024 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918507; cv=none; b=C/XAhapTUA7esnMGDt/ZEYRVYH819OLfCmabH3Ya+a4SaYKLAO1dr5s8nKC9ug7ND1bE/hE4PPY7Y+IgYMibplh0OM/tBEm0bSWMR0eSp/VqLL8WLtn+lYytlBBy3gEgHhulvTGu+q2Msl3myGR2koGb6EkbSmia1ZHrCAAmE44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918507; c=relaxed/simple;
	bh=Y9ZwoewpEg9NAuIu+S1kxNZ6XWRI8KnabkDTlCXulBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDSvYZ6guZn2o63iJtvSUSp1mhEfv53XEKFpNpLTltVRunH1w3BFNuHmLkV214i7Rwo68tBojW9oQAgjR/3O3cZxRTvIfW/SBJb5vNVTAE7tyxzr5WqMgxFDuOEU7JpZTV65IEqdIQFJLEBujk/Ng5iPdP1TyDFzt6vDG0+P84g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6P6mpLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6P6mpLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EFDC4CEC3;
	Mon, 14 Oct 2024 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918507;
	bh=Y9ZwoewpEg9NAuIu+S1kxNZ6XWRI8KnabkDTlCXulBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6P6mpLs0ERXJLHZWjhJ3ucsX8R7WnzXWAGXZIeCGrDbnPZKm2+kGo47AF6x+VzVl
	 Y9upXsRyMQ3gKxA8CRaA6pUXHYNodghbnnnqkkkA47BjJTfHeN0u7c8pPyQC8OFOm0
	 UkwDntng17SsZ2V0NkI2VOgmWT6RMtS2womRzsTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Joel Stanley <joel@jms.id.au>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 343/798] powerpc/64: Option to build big-endian with ELFv2 ABI
Date: Mon, 14 Oct 2024 16:14:57 +0200
Message-ID: <20241014141231.423250827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5017b45946722bdd20ac255c9ae7273b78d1f12e ]

Provide an option to build big-endian kernels using the ELFv2 ABI. This
works on GCC only for now. Clang is rumored to support this, but core
build files need updating first, at least.

This gives big-endian kernels useful advantages of the ELFv2 ABI, e.g.,
less stack usage, -mprofile-kernel support, better compatibility with
eBPF tools.

BE+ELFv2 is not officially supported by the GNU toolchain, but it works
fine in testing and has been used by some userspace for some time (e.g.,
Void Linux).

Tested-by: Michal Suchánek <msuchanek@suse.de>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221128041539.1742489-5-npiggin@gmail.com
Stable-dep-of: 39190ac7cff1 ("powerpc/atomic: Use YZ constraints for DS-form instructions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig                   | 21 +++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype |  4 ++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6050e6e10d321..345b8b4c60e1e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 source "arch/powerpc/platforms/Kconfig.cputype"
 
+config CC_HAS_ELFV2
+	def_bool PPC64 && $(cc-option, -mabi=elfv2)
+
 config 32BIT
 	bool
 	default y if PPC32
@@ -583,6 +586,24 @@ config KEXEC_FILE
 config ARCH_HAS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
+config PPC64_BIG_ENDIAN_ELF_ABI_V2
+	bool "Build big-endian kernel using ELF ABI V2 (EXPERIMENTAL)"
+	depends on PPC64 && CPU_BIG_ENDIAN
+	depends on CC_HAS_ELFV2
+	depends on LD_IS_BFD && LD_VERSION >= 22400
+	default n
+	help
+	  This builds the kernel image using the "Power Architecture 64-Bit ELF
+	  V2 ABI Specification", which has a reduced stack overhead and faster
+	  function calls. This internal kernel ABI option does not affect
+          userspace compatibility.
+
+	  The V2 ABI is standard for 64-bit little-endian, but for big-endian
+	  it is less well tested by kernel and toolchain. However some distros
+	  build userspace this way, and it can produce a functioning kernel.
+
+	  This requires GCC and binutils 2.24 or newer.
+
 config RELOCATABLE
 	bool "Build a relocatable kernel"
 	depends on PPC64 || (FLATMEM && (44x || PPC_85xx))
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 54d655a647cec..ce88910d54cf0 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -585,10 +585,10 @@ config CPU_LITTLE_ENDIAN
 endchoice
 
 config PPC64_ELF_ABI_V1
-	def_bool PPC64 && CPU_BIG_ENDIAN
+	def_bool PPC64 && (CPU_BIG_ENDIAN && !PPC64_BIG_ENDIAN_ELF_ABI_V2)
 
 config PPC64_ELF_ABI_V2
-	def_bool PPC64 && CPU_LITTLE_ENDIAN
+	def_bool PPC64 && !PPC64_ELF_ABI_V1
 
 config PPC64_BOOT_WRAPPER
 	def_bool n
-- 
2.43.0



