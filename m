Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053523;
	b=TCkpETHZG5ofeJ1Tq2c15rGMy3gof2WuvrIiNcJ54xIxZT6Y02IJoml35JqifX2CV7kC
	 1UJGBShSFsMOyEAj7P85/meyH2dRB610/iubNEJy0C3Xx99OXDlqqgrNmNqjNU1j/jP9r
	 GLE97TIHckWulotcTIcRDNfbc/Cvq8DCkbdWcNjIo8YRwaE2Ym7U4qtzNd//sQTjUee+a
	 KMJOWZ+XHI4pWmGb83DEjLHBXsHdN9luzLkbltXhFbExTNgK5aDdUvdjHf8PF+ov3nvIx
	 IKflPMuUbNGHKBAKkVUAkQXBJntOTZbcdmKBFPliEGkcQIm+N2BkVlvxklMePHTZUEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YNsasyejOq4UOVjkinvWekaPJ1E4XZEBGDR0gyxgkMU=;
	b=vTi91c+0b8PFhRbHSeivmmMeTT/aPdOzznIZYZQOUzqeracJ6p5XaWcGocMWVI4/0gTz
	 8r6KYVCiWbO20IkU5RXSeNl3+WVxiRHfmgxp33720H/ITlCjfFF1UZXEYy15Brj/7Hu1C
	 SC0u99dO3MCMpZt6Igl2um0gL1PtvEACgRUq1/U16OUB+knPWlyCm7EBtX9kqxLkNFOAH
	 qpC80es6lzqGKq741H4nQdzS6OXomtpSF5xbt2ENGLgG7n1mcHJg6gIG81jqprzAkOFnT
	 auPlyOSaOZi4qtcb0nhH0WrBB6vsvdzYqtPBOhme8lp/ph6Vmh8svXY3uhFa+mJYqUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpid4Mrg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB067606A320;
	Thu, 19 Nov 2026 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpid4Mrg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E1F1F000C5;
	Thu, 19 Nov 2026 01:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053523;
	bh=YNsasyejOq4UOVjkinvWekaPJ1E4XZEBGDR0gyxgkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpid4MrgipY4CZrrZ6f6K9fMkiem/GufqfL/6L25y/k9tPSWBNRI9wfCJICXLkmNI
	 9Zd+u1sLbd72Nu1hfmRZ27zGrjh9us9hI2Zo2J4EUNBOzaBpee3xEGdM6/mf/qZyHT
	 Nr9yzMv6a9OAe9xo4R1rZ7k/F0O8ku5bWxRii+ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0951/2214] efi/libstub: arm64: Dont use the platform register x18
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118150050.377798873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1195c9fb84de5..6ea5a6651dd7a 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,7 +19,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu89 \
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



