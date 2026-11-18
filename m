Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059277;
	b=nt9/0gIwIV83Q+QqsBWKoy46eoO3P6Pg/mZ7GiSgnqbdhJgfFxrTlm/EoS2FJD7bCZ6Q
	 2TOutT16sdVWblGbBaDVenL+JyeJWGwhbNTBh3aZuRz4O1Uqv3WaNLSfvknBVPeuoLDUA
	 +r3+4zKkAHx/FjqXM3pOieqhsgTvCdznzTqApanu1XN79HVhOwXdcHRo/Vg9fvMh3Qm8V
	 tdfpkCtKzvVJCl0fokTk4kMn4ATgSB/nJcxXma6G7+gwaIiqMIoM/ooJq9Jh1IyfvD38R
	 iZuQtOjNwv6VLlV0Zm8lcXioEz+kmOwWzdLR3alYDytg/bqsA+8i9Kznsqzx6bBaY7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=apfrn3SGv3+QIwvvoWp6jj61xp3V6P3gYeaaOjQN0K4=;
	b=Jt0kcaYS9FBHlvP3m6rTXOTgtkEKoo9VUeFu0EEJ+tS2kQN5w3JoCmHsbjVDXh0Ard+T
	 v+Ok8NQhVdbRjna2IdHiOZAErAFAGi/K5nioztb5L9O08rURLVbsiucZDj40aUIAsLFZi
	 H+W+qZk5b/Ue4Z2HaP6jDYmwvNfHOgzxeoiu2zq2JNU01xqvuWd+9QzcZARO2d9FgRjMh
	 RBMDth7iuVz+NHMQLwtf3vZfyqut3FaAe9UviSAAen3dpc6nwPI2/W4WzCDzneYjVsr8Y
	 i6TtM1aWvdOIvBWVx3IQHIai8YqWjHcTrp1WZ+l1Wl25/wmDso+BEI85YECGXXt14Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHW6u2fU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54EB606A320;
	Thu, 19 Nov 2026 03:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DHW6u2fU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B0A1F000C4;
	Thu, 19 Nov 2026 03:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059277;
	bh=apfrn3SGv3+QIwvvoWp6jj61xp3V6P3gYeaaOjQN0K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHW6u2fUuXmxpYSvrXWumaTjoA+tdhIbc+79+Ct+2i/8ry9T2XPdGXMY0Kqo7CwTR
	 rzlUXnJUfOHSyI0JVgCflh3bTqDGCJ7U0jigOWN5F2Ny4nZQCKO17In42v2YwaRI6A
	 e+kd0dHb1449VlsYt39lYUD5dLCMODfg74n3JRiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0783/1848] efi/libstub: arm64: Dont use the platform register x18
Date: Wed, 18 Nov 2026 15:47:01 +0100
Message-ID: <20261118145949.241728576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d719134e2d3aa..b17a082675430 100644
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



