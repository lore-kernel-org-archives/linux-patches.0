Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEE81419B1;
	Tue, 27 Feb 2024 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041890; cv=none; b=pj4WIKPqDam8kfOtth9LDDwBYdDa/70es8O0t6zqrxsJICmbmWIg5flFioU0L8Y9hL3ncm1l/Sqb7wO29sX9dM90hDuu6LKyVXvFZcVk9VF6g9mht6kRPvgnlA+O9ftq/9FwJu0qVdfDfqHslX8cbeKP2PpuyxDESKt/+pwNT/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041890; c=relaxed/simple;
	bh=whtIR4Ui0sW7an6vdql5d0SUkYIZojnIZ1HdNxRvrVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvmuwY2iRlXWHxuzxf3bQ1bjT+4UnmeY1Aor/9ePJlLXjTsZGRyWAg0XDY4p3lg8imjnkXMP+M17UIwQZ9+ygjO/8FfKPIOnSEcgRWNNtVOGWBZ70H5zMx1KlKOog9aeuVgyJRKNtZn14oT+F95xkUUjUxRdj2F15ia1OTMfPgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNJpqmlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNJpqmlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335EBC433C7;
	Tue, 27 Feb 2024 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041889;
	bh=whtIR4Ui0sW7an6vdql5d0SUkYIZojnIZ1HdNxRvrVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNJpqmlR6M4Z6z4UO1mE8AuESPu2tPfWZWHUPY6Csb5Iu/9hhJA6ZC6O3Q7+YnwCc
	 K4m5h77wHxEn3UN/fXStKHG5aBOOWxY3vW2GawX0+T+Qffjc0lFvNZRtChiVB2Hn/i
	 yd/HaXaWMKTPxGHrF31GGRuJgY1VFL19uYCbDopM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Fangrui Song <maskray@google.com>,
	loongarch@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/299] LoongArch: vDSO: Disable UBSAN instrumentation
Date: Tue, 27 Feb 2024 14:23:36 +0100
Message-ID: <20240227131629.263693450@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit cca5efe77a6a2d02b3da4960f799fa233e460ab1 ]

The vDSO executes in userspace, so the kernel's UBSAN should not
instrument it. Solves these kind of build errors:

  loongarch64-linux-ld: arch/loongarch/vdso/vgettimeofday.o: in function `vdso_shift_ns':
  lib/vdso/gettimeofday.c:23:(.text+0x3f8): undefined reference to `__ubsan_handle_shift_out_of_bounds'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401310530.lZHCj1Zl-lkp@intel.com/
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Fangrui Song <maskray@google.com>
Cc: loongarch@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index 5c97d14633282..4305d99b33130 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -2,6 +2,7 @@
 # Objects to go into the VDSO.
 
 KASAN_SANITIZE := n
+UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
 # Include the generic Makefile to check the built vdso.
-- 
2.43.0



