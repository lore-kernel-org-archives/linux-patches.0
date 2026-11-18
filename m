Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037430;
	b=begPBNvfW6uM/fX7xGHBBsodEUtCpSw0TMoPQ6jUnzCtT4EQQCISnhCoUd4q2KDy69Kv
	 0t8Fg4BSGLYgjUVsjMqxj1Gb7jbjmxuEFB04+Fz04pZNZtpawHqlq9MAxluLVypqqg2kd
	 RlVCrrX/Eww88zEnJrdLzL9gWl7xF/2wboMlxvyyYWbXhw5hAUzYUEFwOJgdo4qbk4FiA
	 kNpAoyvMy3q79Qk/mKYf3rkxJfrrWaWEcyQ306dPz4rKdZA468S0YcgD9EX57ufjpusCN
	 ib0YwmUPdkFtFEKwOA86Ymgdd9vLS8aB8yZ3vyqPLr+7r9Sc6LylAAJVQlXzPjHejKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=semgXvONHxok5vIyp7F0FZhGwLPYtT2u8p1OueGKxfo=;
	b=M80xeV5u6Ua3Rrzl0xFJX+wfHKFH0sh/F2dgLHEqTQbsTxAs74x9yDxhHRbOeYvKYYs4
	 JYqSRhBS289NBRy1XwV5kmUQE5F3U6y1xl8yZLafU7vHfsjfbJX0kk6WNLHlu4fflsGYu
	 x7kOB+R74ogPSAYOwuSs9A0D1Fwyw3bMMlVpSfZq7dRikBnDcXVCt0UFDE+r9ejzDl8CR
	 1pwHUKIS9pQJeFsyIlVtTNPfdtiLuj9U0XiMWvPDBLa3KkZDQJ9MOTmFQis7gESzfr1L/
	 zmr3SrdF5TI9Zjr1mxbLrjf8NBRbNUIn8V9k1Ou+3/eSkjlNBZof3Vm3zuXeJ+E6biA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyzvqAlZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6C606A31C;
	Wed, 18 Nov 2026 21:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyzvqAlZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6116E1F000C4;
	Wed, 18 Nov 2026 21:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037430;
	bh=semgXvONHxok5vIyp7F0FZhGwLPYtT2u8p1OueGKxfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyzvqAlZCJDpgltQUFCCY8CfTpXWMfiKK+D2RaK3uV5Db+cYhKGUY+XRip03a1d8k
	 GNzskPx0AQkELsnCwR/lxFQlxpo7Nzw6Cmgj4w1jAzfiCbGcbFjwMeyXHNA0eSYRtZ
	 vBgum/XbCIcKNt/6OYwjko8QRRQkZ70OwL8pxNzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1380/3318] efi/libstub: arm64: Dont use the platform register x18
Date: Wed, 18 Nov 2026 15:33:22 +0100
Message-ID: <20261118150401.929194470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 29afa73e4b282..d01b2e6210b5d 100644
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



