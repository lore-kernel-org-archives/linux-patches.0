Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024119;
	b=vDoEk0S2WVRHbuZCIVhkQEbku8VIMmkjfHuvdOxwPyHQVLfdpUreS0pVxDhptObYu7gS
	 kO8Kv2Uanrien/g42Y74GIwfK5eADu2tsR/luiCXxc07LdTNzabQCKANgeO8Y6T476RjT
	 bZo8E0a7rswjxYjO6M/LjiQKckCuuh+wQgT5eh1Kc+Z2KUCGifCu+NPk6dineZBW+OVD9
	 TqbIhDYV1vS9XXmOG8hkiA4wPX6etb+nWZsQyBiC1suo9ycCSemCIep+iB2GnSUsMZzOi
	 Yli7LEudL5nriXFRpQJ+/trNNEU96QqlHptYtHC1j0oOCjV1OmOiLK+qLv+nDaghk4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EsrpMaZFrK6IAn/JbzD7jw9NtwBIJYX76tfPu5Wv0qQ=;
	b=2+gVJLtR4FM4YtBDkHFI158geT7fFywF30uJa6dKg4lasMBrXCtlcsvNjMrjWN35/upX
	 65343WQwIxBRUc+mFG9dNCXSVaslvydABSP4j8Q3lJR60tZWmsCDnDDENgxMZJpLyDgE9
	 uS5xsmt7hxASc4L682WxJQkdzVRxGB96/3Rn/IEvL5WdfHXpq5ko33XJM9dlcTLjQaPiy
	 89Wz6sQJbbVWUkpxmWNJZ82vP9FkrcetDirJecp9FtPycA/0KETCXSUzJ/ex9vqn8Qfxl
	 RMNqASZYv7Gn7szFZ6uFCD1+Non2zNoUKFHuk86/DCOD+3BBffzUH914MBqXb8SdlBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td22ZgbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759B0606A320;
	Wed, 18 Nov 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td22ZgbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73CC1F000C4;
	Wed, 18 Nov 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024119;
	bh=EsrpMaZFrK6IAn/JbzD7jw9NtwBIJYX76tfPu5Wv0qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td22ZgbQ5e2myO/HSuh/jfb61AzMTGzE3xkDikDbk/qrSjFgTAfzTuITVhbsmjxaC
	 WmWieLbSub+if6HlA8pjwEUI23X4sbjxCkgvdilChPHRmeDOZysrc1nrbgKt8XlnFc
	 YKKqetW3WFyXqlXuw8cVOvDQRVx3azrLpT9L4lHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0613/2151] x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150144.251802306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit b24bc9dec9c89d01ccb675a55cda6831dc048ce9 ]

Even with __builtin the compiler may decide to use the out of line function
instead of the inline implementation.

The existing code is broken with gcc-14/15 but not gcc-12/13 (Ubuntu 25.10)
and vmlinux no longer boots with CONFIG_PVH if CONFIG_KASAN_GENERIC is set.
The instrumented out of line function performs a memory access to a region not
yet initialized by KASAN, as it is still in the PVH kernel entry point.

For testing purposes, if the size argument in cpuid_base_hypervisor() is
reduced from 12 to 8 the compiler decides to use the inline implementation.
In xen_prepare_pvh(), it (still) decides to use the inline implementation
(at least in these compiler versions), but it is not guaranteed to remain.

Switch the builtin to the inline implementation to address this.

  [ bp: Massage commit message. ]

Fixes: 416a33c9afce ("x86/cpu: fix unbootable VMs by inlining memcmp() in hypervisor_cpuid_base()")
Fixes: fbe5a6dfe492 ("xen, pvh: fix unbootable VMs by inlining memset() in xen_prepare_pvh()")
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-4-08da47943d8e@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpuid/api.h  | 2 +-
 arch/x86/platform/pvh/enlighten.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpuid/api.h b/arch/x86/include/asm/cpuid/api.h
index ea1d9fe438a4f..b9a86643cbafa 100644
--- a/arch/x86/include/asm/cpuid/api.h
+++ b/arch/x86/include/asm/cpuid/api.h
@@ -204,7 +204,7 @@ static inline u32 cpuid_base_hypervisor(const char *sig, u32 leaves)
 		 * from PVH early boot code before instrumentation is set up
 		 * and memcmp() itself may be instrumented.
 		 */
-		if (!__builtin_memcmp(sig, signature, 12) &&
+		if (!__inline_memcmp(sig, signature, 12) &&
 		    (leaves == 0 || ((eax - base) >= leaves)))
 			return base;
 	}
diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 2263885d16bad..b7dcc9c992f32 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -8,6 +8,7 @@
 #include <asm/hypervisor.h>
 #include <asm/e820/api.h>
 #include <asm/x86_init.h>
+#include <asm/string.h>
 
 #include <asm/xen/interface.h>
 
@@ -134,7 +135,7 @@ void __init xen_prepare_pvh(void)
 	 * This must not compile to "call memset" because memset() may be
 	 * instrumented.
 	 */
-	__builtin_memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
+	__inline_memset(&pvh_bootparams, 0, sizeof(pvh_bootparams));
 
 	hypervisor_specific_init(xen_guest);
 
-- 
2.53.0



