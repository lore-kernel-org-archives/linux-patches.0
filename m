Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064947;
	b=3ASHqEGH3qHdRNsSLHbVCsNxR6DbqVUAbMNPASQUt5EsbEcSS3wZk8qTxugaCV6vsYVt
	 UhMDMqwQjx7BYuqzTR3Jm6NR/dGvh1v0wcOgOE+c1sEZZoRQ9aGHSusse/pZigLnelUku
	 zX/aZDfxt7LETvQ4EofjaYUxfa3Wpt/qQNPXNFmKNE065cHtSPV2KLXC6GR1PRRghtHPa
	 O/7bE/eQp/hhoTgD52x8nIf+BybYXXcif8XTYLh7uB2BjmQzrKx2O4sACL+5yo+es4LU8
	 YaItQOGmxVI8vChZKKl5M1c8gCh/DRAvLmj6rYQwO0fAKM0PCWMXmaa1hHA2WpVtuaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LipX2abKVEEVvHb3V9Xqh9wq3qCvVoBd+ud06XVJjP0=;
	b=rQCh4cgkFDUX/BaHlaYJv5rU1EwPXMseJjkwLO8yYrE55Envvf1iP+q3auw3/4T2pj/z
	 MQIx7GkG95CJvoHb7hyz29xMZdja7s/6jluJqb9w1D9GPq69m487+DyiI5xcM7J2cdyRC
	 5ha3wgs1r9rEkuEp5OwQWIpUXtXqD+J8BWXTEL/ggoJebNS/I6KuW5DkNEmXXa+bIuqRu
	 kdo19dlkLccGQGHmS7nEhHNtFF5V/1WvU6BvLIE8FPdK579QvkT2EkWAbKheENJbk3UXe
	 OADtKwLNcQ6Q1u7KHVdLoV1+WVXt4YO1kUByfsOPcj7y4Gv6NTjbOkLUoXdIIcb1+wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9e6GZhS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9973F606A331;
	Sat,  7 Nov 2026 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9e6GZhS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4755B1F0089F;
	Sat,  7 Nov 2026 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064947;
	bh=LipX2abKVEEVvHb3V9Xqh9wq3qCvVoBd+ud06XVJjP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9e6GZhSOkzeTZ0Bs4Pn4lHv1rMDSw0LxMiu2lRuAavYlmd1d4b8mrcooxCL3Nmd+
	 vJ6PPzASzd1EjIO1vRjGcxzhNuzxC7xZc3YnuFRqemKo93XcGY5gVHTr2uogPRVMSf
	 b2Q9fYvbPpWu7AfPW6pxt/xGkOwcE39s/WbhbxYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0796/1257] efi/libstub: arm64: Dont use the platform register x18
Date: Sat,  7 Nov 2026 08:51:32 -0500
Message-ID: <20261107135001.314888024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 4c86b5f3fa78347fa9cbc9e8ec06615b2f80e397 ]

The UEFI specification designates x18, the platform register, as "do not
use" on AArch64, so that UEFI code is compatible both with an OS that
assigns a fixed role to x18, and with one that uses it as a temporary
register.

The arm64 EFI stub and the EFI zboot decompressor only avoid x18 if the
kernel is built with shadow call stacks, as that is the only case where
-ffixed-x18 is added to KBUILD_CFLAGS, which the stub inherits.
Otherwise, the compiler is free to use x18 as a temporary register, and
it does so.

So pass -ffixed-x18 unconditionally when building the stub for arm64,
so that the image can be run by loaders that rely on x18 being left
alone, such as a kernel that uses it for its shadow call stack.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f6..48982d05c441e 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -21,7 +21,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(CC_FLAGS_DIALECT) \
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) \
+cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) -ffixed-x18 \
 				   -fno-unwind-tables -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
-- 
2.53.0



