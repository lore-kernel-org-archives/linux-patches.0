Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE372D7D3A;
	Fri, 17 Oct 2025 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714595; cv=none; b=o+yVSn8LG4z2mm8NL4fwnvqp/sheFf/boiuPh68KNt3DniS79WLreqSYMpZwof4rVqaAoSNFFJrehgtdV6DYpBpJNoeC4uJhvkZ001WgJbIihcI2aH7n7lUxUotVXVn087QzdJZ0bUQ14SQMNe8DEeuBsnmG6otcfzrjqba0BU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714595; c=relaxed/simple;
	bh=MPHDx2iYt5rcyrvssBnqrXz+aofLKbAO49DPJMsTH04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnoyoBtnXV4HCNJnd1WY1mSpCS704z8o6LSZZH2TDeJwVNLrUqp5mE7ITDQQz/cWbsOxzwP6Ml40omqiU9+bTlHiYBdVJCGkJWxB/h/sSUwbgPl44C+FjcF1UwID7pW2jA+y20D8Pdh2AE7Fr4GSmRnbYAXa4zOLuwOp2ZXG1P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHKDg6Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHKDg6Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173FDC4CEE7;
	Fri, 17 Oct 2025 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714594;
	bh=MPHDx2iYt5rcyrvssBnqrXz+aofLKbAO49DPJMsTH04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHKDg6Vl+LPAqOImCb0t9dsxA5utMuPmcWt1oCiW+zntjQ2XI4KxH8+iCVctRXe1C
	 vQFGTi/M4rIs1mAFdIWQavhd99JsUzK3Xdiwt4CySfJ6cSoROQghMJeUiJvLMT1UjN
	 fbTrgqopeTCyEwIQGpHToKs55xR8fhtSo/VZkSCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 199/277] s390: Add -Wno-pointer-sign to KBUILD_CFLAGS_DECOMPRESSOR
Date: Fri, 17 Oct 2025 16:53:26 +0200
Message-ID: <20251017145154.387293260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit fa7a0a53eeb7e16402f82c3d5a9ef4bf5efe9357 upstream.

If the decompressor is compiled with clang this can lead to the following
warning:

In file included from arch/s390/boot/startup.c:4:
...
In file included from ./include/linux/pgtable.h:6:
./arch/s390/include/asm/pgtable.h:2065:48: warning: passing 'unsigned long *' to parameter of type
      'long *' converts between pointers to integer types with different sign [-Wpointer-sign]
 2065 |                 value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);

Add -Wno-pointer-sign to the decompressor compile flags, like it is also
done for the kernel. This is similar to what was done for x86 to address
the same problem [1].

[1] commit dca5203e3fe2 ("x86/boot: Add -Wno-pointer-sign to KBUILD_CFLAGS")

Cc: stable@vger.kernel.org
Reported-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -25,6 +25,7 @@ endif
 KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -mpacked-stack -std=gnu11
 KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -D__DECOMPRESSOR
+KBUILD_CFLAGS_DECOMPRESSOR += -Wno-pointer-sign
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float -mbackchain
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS_DECOMPRESSOR += -ffreestanding


