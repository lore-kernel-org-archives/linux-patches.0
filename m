Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DDB20969B;
	Thu, 12 Dec 2024 16:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020886; cv=none; b=By2AY+eCHbuPPKhLbiBMH3Lpnh5twuYWUs+mnThYeeT/oIxajI+/O0TG1VmsqhIEyOKyljLUonL0uOABiJ+CpkcdCu3JPycoUd7LWv4oKze8d+vjYnUOQWrscJ0ShfzHu0WFLQDN7AOJnAdVHrf2jy7rZD89BfVdY6h5Xzvbu0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020886; c=relaxed/simple;
	bh=QhXZg64Ig6KJmSZGcupjzC7icSlf6aYOcXjcFjf6wug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxnGRG6zhp1lmm23sJW3neUGsFiSbWIYeKP9Bd27RYGU6Jyuc+j0hj9j2p4oFEtyLrQ6T3fazqClbxgLWkj8sGp2D6nGxLmd9blQXN0s0q0SBbqbqb+eeUadZKVhB3VEgUE5NeqjexoHrzK7sdHbvo74C/s7QlaceSMvfLH8ApE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbcKgBUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbcKgBUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A920C4CECE;
	Thu, 12 Dec 2024 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020886;
	bh=QhXZg64Ig6KJmSZGcupjzC7icSlf6aYOcXjcFjf6wug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbcKgBUxSfNWu8du2OJKnLWCoA2ZUdEmyn5C0YJ9B5vNbUJkNYUUHrQbyjkWY6M7a
	 jBMsZN3ImILlydQwfuePz7f5eIdEPzg9fcrMLqrklcPTJT6mRxweHXI5JFrPM4JDw+
	 CFVrfLhXtSOnrT95flS75WcjGQ1mvJaKSMT4PYWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Segher Boessenkool <segher@kernel.crashing.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 557/772] powerpc/vdso: Remove unused -s flag from ASFLAGS
Date: Thu, 12 Dec 2024 15:58:22 +0100
Message-ID: <20241212144412.982712495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 024734d132846dcb27f07deb1ec5be64d4cbfae9 ]

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
warns:

  clang-16: error: argument unused during compilation: '-s' [-Werror,-Wunused-command-line-argument]

The compiler's '-s' flag is a linking option (it is passed along to the
linker directly), which means it does nothing when the linker is not
invoked by the compiler. The kernel builds all .o files with '-c', which
stops the compilation pipeline before linking, so '-s' can be safely
dropped from ASFLAGS.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: d677ce521334 ("powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 6a977b0d8ffc3..45c0cc5d34b64 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -51,10 +51,10 @@ ccflags-y := -shared -fno-common -fno-builtin -nostdlib -Wl,--hash-style=both
 ccflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
 
 CC32FLAGS := -Wl,-soname=linux-vdso32.so.1 -m32
-AS32FLAGS := -D__VDSO32__ -s
+AS32FLAGS := -D__VDSO32__
 
 CC64FLAGS := -Wl,-soname=linux-vdso64.so.1
-AS64FLAGS := -D__VDSO64__ -s
+AS64FLAGS := -D__VDSO64__
 
 targets += vdso32.lds
 CPPFLAGS_vdso32.lds += -P -C -Upowerpc
-- 
2.43.0



