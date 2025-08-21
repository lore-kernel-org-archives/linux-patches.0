Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D52EA731;
	Thu, 21 Aug 2025 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810983; cv=none; b=ux/zTtl2lK+V6kzql03cDAZwoGzqbyD14tL/Zjlr7Pzpb1VTUHPUgst01man4WmnZMbuK5FtouY2xjLSr3SGBGTod38e4G0WpCUvSw81Ooj9QNsUFGjtcaROVS2HiPFl64Q5ahc4F4BgsdQNoNrV8PQq5MSBWVht8C1XcZPPFXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810983; c=relaxed/simple;
	bh=GuIUENgqio39t477SDk6C7XaAzb2H0I1l0Wr7BFNzzg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s+rBNK5U8xiFxiNMHJu+3zQRob4jox6fP8SRw7uPqoCXkpwwHrSlCPlRWSCh5g06XY/tQXEKxLBHF3vdsPys6+jIBVmEzP4ojWAFs6BOYXthx7es8O/QOf2nfg/Msoz4IA1QEVzAJ9eOyXSvQzeZMaohQ6uNPqbf6oknqaJFn0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4Aaeztu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4Aaeztu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52F5C4CEF4;
	Thu, 21 Aug 2025 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810982;
	bh=GuIUENgqio39t477SDk6C7XaAzb2H0I1l0Wr7BFNzzg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S4Aaeztuk95BY5K32AX3hGLidBlzJ0AAYtGVcqV2k3u7yeoJkI/VjVl+35Z7BDjeS
	 2FiTD9dC5i0NqBluLGUIvTg4hbgsWCfmxO6jo/AFMg9vp+LhOw6nrXtVTRMTx0tFWX
	 4iXScArRQQOsq1tzVTlnA9iXCEdm+5OSerBuTZ91vVTC0D62Oe6ouBgAn16gNlILrn
	 Wz23u7v7NUo4tZs88KxwecJMGiuaQisRE9zowpusfXWaeF7qpG08GOaUl/xEM//Wwc
	 9ZD3FpZNqPH+gs0MFl719C6vNqQL0bqiJdL+y/YByLaKaHwI+RAQOiVW3VnLQARWle
	 2PWbdboTEEeQA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:47 -0700
Subject: [PATCH v2 10/12] lib/Kconfig.debug: Drop CLANG_VERSION check from
 DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-10-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; i=nathan@kernel.org;
 h=from:subject:message-id; bh=GuIUENgqio39t477SDk6C7XaAzb2H0I1l0Wr7BFNzzg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe5qbKjj8E8p+FXEf0rYtsfBiabjJbS6inGxpHRD9b
 vKRRTkdpSwMYlwMsmKKLNWPVY8bGs45y3jj1CSYOaxMIEMYuDgFYCIHnzD803HkWjJp4ybf6TOV
 K5/9Topeb171uKX9d9yvZ8+uBbi2ZjMyPLte3m7y1ej28jUnzTdov32d9M2pr/JjPeMMCxtdkUI
 pRgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, the CLANG_VERSION check for older than 14.0.0
is always false, so remove it.

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed075..6c12852e77c8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -259,7 +259,7 @@ config DEBUG_INFO_NONE
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  The implicit default version of DWARF debug info produced by a
 	  toolchain changes over time.

-- 
2.50.1

