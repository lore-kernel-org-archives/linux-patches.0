Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590965;
	b=aT62MnDcADMQFf4AP9jFbgY6M8SqW+hnk2KNa2R7FnImxZgYQ6aBjVm2fxv6dFJsLcYy
	 G/b2bvsb78QbsmolsMR4ieyVhCWhUo3gjwvi58Iqy7Qs2j9+B4Kw0dNZWpMUb4Drx+EpS
	 QzTRwCuoHfXlubEmKsgeiTrDbn6ZlHJHPKkRcRenwsxxV9LdNxFQ4RiKDrwjF2qlhZdTd
	 RjfrpdWNqyIgg3coEf9L7nR/ldjU9U/nzkf5HpNG157FG/Pkx++IZWl00ryGxTptBDOB5
	 JhbxUCz+cs5CK+90QC3eRQw20UAshykF2eWKWOPnCATTsDko/oRykMWEEX9M1gYpltw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVspNbKtMe6x6WHYdzyndZrxQlOmX7fz7IGu/aJ5ZV0=;
	b=BZtyLjQ+XpY6xJq1vdwH3Smr+opFmQSj6az7vOEIU+i6zJT1LRnWjhA8exCkitkY6/ai
	 U0GGUI/bFR8uB1AAVC46SxI7IG9Or0LjqjHDZQS/vaOK0+Wt6WC7mPS3Rx3YohrpFHLTI
	 TVxp6y92boE9XD+94CRQVMedXYlN1gwUl7uCPGIHCHqe1kbkLLD31ZbjjQQceW3DvP2Z5
	 NPYIKsCBwYt50ihsm/pXAap+p2COYSn1kHe/kvp144PtD76DFKUm2DiqNybvkPgHBXfIa
	 ejRHtHOEAlcYEY1s02yVhQ5vJ122gZPo32e+DX7FlJHawUUKV8ub+yExq7Dz3xh1TyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6lM4MRP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C54D606B45C;
	Fri, 13 Nov 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6lM4MRP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF961F000C4;
	Fri, 13 Nov 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590965;
	bh=gVspNbKtMe6x6WHYdzyndZrxQlOmX7fz7IGu/aJ5ZV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6lM4MRP+ehwGmau6nwpRd78uTxmOHkqPw13AhZEBun0mo1865+rjZrksVf5e5QDi
	 EN+oLoUMDgSPynew0gJKum79AxhzBJPEhh8cIMU3eBbYOs8VwDdAuPtZ37Kem2MqCp
	 laIB8NdIVOLNnW7Mp/ZsJIeg4xUDS/vcBoCEybcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/670] efi/libstub: arm64: Dont use the platform register x18
Date: Fri, 13 Nov 2026 10:45:06 -0500
Message-ID: <20261113153816.650894394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

Cc: <stable@vger.kernel.org> # 6.12.y and older
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 1141cd06011ff..d33c02e587174 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -22,7 +22,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -std=gnu11 \
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_STACKLEAK_PLUGIN) \
+cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_STACKLEAK_PLUGIN) -ffixed-x18 \
 				   -fno-unwind-tables -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
-- 
2.53.0



