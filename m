Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2428462;
	Thu, 17 Apr 2025 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913733; cv=none; b=bkif8Lq0GgaPAT0yhjNEVNym6irWXxF1euQIJJ8QhEsDx4YjpCR99s569tEnnZQTFC11KgAZjc1dEc79Y+YxQACGvwBC5WPwJV2PxapRJ+24e07Sr7iIEtXlxq5zXzIIgX1hfK+cwswZCEU23nIW+KT6jocWJ/iMAH5iWoUxjtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913733; c=relaxed/simple;
	bh=nnPIXHB+2jfAwLfGZRlVEtNN+Rf+BHv64lIZSUgxL3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCYGKWB2/9zzU+BX94SG3AuI8u+ykf8PZVwitiRv3BpnfM0avqFLio2gRxK1xsFaYRy94Wz3IAtjGXdJpUg3qrQWcfjJ7LFJsQxncRi0IzSwcy/smeAFWe6XipekxFDMv0yQUlDXZa1iFvONBa57Uyr8G/vYhU68IMZOOPA2wRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDd+rpUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDd+rpUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113ECC4CEE4;
	Thu, 17 Apr 2025 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913733;
	bh=nnPIXHB+2jfAwLfGZRlVEtNN+Rf+BHv64lIZSUgxL3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDd+rpUUg5MLaoDMyeZ6I/KRxAhTuV5mBlrO60kEk28W9A0+pt9Cst5pkJ7yX4KwC
	 lxWk5v+92NQiMKDztCZWd2e8CvmGbdy06Q5Px5sE2m/+8U0ugug5+oKOnEX8rg5jJQ
	 VUAlTv2nlLTVXhpFIzlVTBN2OqwjwaijVPeBCOFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Remus <jremus@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.14 436/449] s390: Fix linker error when -no-pie option is unavailable
Date: Thu, 17 Apr 2025 19:52:04 +0200
Message-ID: <20250417175135.862214649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 991a20173a1fbafd9fc0df0c7e17bb62d44a4deb upstream.

The kernel build may fail if the linker does not support -no-pie option,
as it always included in LDFLAGS_vmlinux.

Error log:
s390-linux-ld: unable to disambiguate: -no-pie (did you mean --no-pie ?)

Although the GNU linker defaults to -no-pie, the ability to explicitly
specify this option was introduced in binutils 2.36.

Hence, fix it by adding -no-pie to LDFLAGS_vmlinux only when it is
available.

Cc: stable@vger.kernel.org
Fixes: 00cda11d3b2e ("s390: Compile kernel with -fPIC and link with -no-pie")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503220342.T3fElO9L-lkp@intel.com/
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -15,7 +15,7 @@ KBUILD_CFLAGS_MODULE += -fPIC
 KBUILD_AFLAGS	+= -m64
 KBUILD_CFLAGS	+= -m64
 KBUILD_CFLAGS	+= -fPIC
-LDFLAGS_vmlinux	:= -no-pie --emit-relocs --discard-none
+LDFLAGS_vmlinux	:= $(call ld-option,-no-pie) --emit-relocs --discard-none
 extra_tools	:= relocs
 aflags_dwarf	:= -Wa,-gdwarf-2
 KBUILD_AFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -D__ASSEMBLY__


