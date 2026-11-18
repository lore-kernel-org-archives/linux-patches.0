Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046583;
	b=Zxc4rCmBZA0za873i9GsOacacKtHQ3VMMWsvv/hg26sNbs9IF3Xc3brd4eUsOomumbci
	 4R4mnH0m1NMIH8ZjvGWj+jX3f7Whx2NM6QS2fEThP9fPBxPxEW/CzqXwp7aLwu+kquEDc
	 WpSEQnEvdpaUMFB4ionODsoe4kONRdB5McTLlNRkCcSdAN7H92LX19WgzTnlz/xP059ed
	 sHf8d5TO+hY2Qx8wkXJjlI8bYImfomE5nBM3pDl5E0nQq/lO1hDLU8zt2OnGP4x8n7M8s
	 eUf944ol1LzPnWMN5dyimANUHq5TJj4YDQh4rUZqoJxK1f+c0ZkvTX9pU9UwBgH481w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WUUF2fMAwKapGF8dR3VrAUd7FZl+KsVqn0bVVxWAIYc=;
	b=oBjTNS+KiPbdrP0VQdy51BiL0LCw8bzzWnvxZ/NLrnXDGs3KWwytz5jkqIvBnkxrEIFj
	 8zCybYpeEi3BIXGkt8JyY+S4jy6cyQKJCvJuZp80WafKMMPJV2UGDoSCl9wFoIeYgRhNW
	 hkO6mpuJG7TlK+6Of0hh5ZXq0gK1yW8ZRXzuNbAKxDDdM2Ola08uOHoTsKif0gaKU6LF+
	 OSbNAswcyl+K584hFc+w/3uS1B0bH8/dJ1Cx4EeDEIrDdiUEddaIuNp9azPucgqehKner
	 TOEyKIIXGm+0qo4k9BElIwabCiJPCqG6UC2QxstccZUTARegE9h+NS4LIuZ4xq/WINw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVDtwO6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3674606A325;
	Thu, 19 Nov 2026 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVDtwO6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D0D1F000C4;
	Thu, 19 Nov 2026 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046583;
	bh=WUUF2fMAwKapGF8dR3VrAUd7FZl+KsVqn0bVVxWAIYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVDtwO6tenpJiuhVSJcFmMgBeP1gQl4Y45R3AQuzhvxz5EzdlSaCvZ18BwCa/a69S
	 T9RpmKtKZeV9XedMg+iHJA6j8xSxW85LBZvq6//wA97CXMnk3I6zPu4CAW1lyWw/iN
	 aGASTCnwOFM8MOwWC/K5oQr641wC+CNo2iEIBokM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1331/2857] efi/libstub: arm64: Dont use the platform register x18
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118150249.361163896@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 4c86b5f3fa78347fa9cbc9e8ec06615b2f80e397 upstream

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

Cc: <stable@vger.kernel.org> # 6.1.y and older
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 0c3893f00d555..ab15bdd248a31 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,7 +19,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu11 \
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
 cflags-$(CONFIG_ARM64)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
-				   -fpie $(DISABLE_STACKLEAK_PLUGIN) \
+				   -fpie $(DISABLE_STACKLEAK_PLUGIN) -ffixed-x18 \
 				   $(call cc-option,-mbranch-protection=none)
 cflags-$(CONFIG_ARM)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic \
-- 
2.53.0



