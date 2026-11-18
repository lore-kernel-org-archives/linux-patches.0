Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024572;
	b=KhnmaMDpKu7lIUoV18g0TlNHqt6QOZWaWZCM+mt1wPnXNmsZJE2ONuRZOsBq3dOWEJ54
	 HS1kRLSgKBcY806lrIJDeWCktnezaEdq6oL9murUF7gROeje/Q+y6LWDofGWr9g5Jqb01
	 9U0HMTn00AOWXPKwxE5nUUsQi2CUXJSyKMUjHy5FOiJAieSptu1X4FIdnkDk8uKabVPt4
	 Psh363G7Dkbo+0P2HF7kaR9uvuXFkGFbY7wkW+Xt5gi1f9j+HUFpK+vsXq5BRpDOp5u+v
	 TAhfqp96J8HWrSaap7RHsXvRMYlihFQ7tCjXet9LuOiK+0mxOuzWPEVSW2s/i3SOCWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXTDyp7XL8kh7bNMQthPqDnq+qZM0jE2vB8NiC6zSMo=;
	b=tpKEfOkW5BSgPhHs3EfG7PnInkqAJFUzGm2CanDEeahJrKeQSpdiyqhK11sW8vFd5i01
	 WOnGkEesCln6lyT/TcauKEqsS5V0LbPMxD5QIDDL2EhXoewwupxXNBVRWiRyILQeg2KCZ
	 Kt96GvBuqoVjea8HBn0CGDkb5tkKZflFN/0FhIFjHjduN6bfWiha4symUpeMV0AT/QBW7
	 xy86bi8qwDerNniZhMWVXD9eLyMyNJpOLNeC2FS9K++t2yhVs7q99ZOWLlFarxtq6sj50
	 DQc8OgUWSQ51M5Pg7XDEfPg3WbacqhHEtUp1FANXBvUSHytHnTuGUZoYIt999+ZWQTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rB5k5iG1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8096606A320;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rB5k5iG1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5BA1F000C5;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024572;
	bh=iXTDyp7XL8kh7bNMQthPqDnq+qZM0jE2vB8NiC6zSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rB5k5iG1dsEVmFbjcY7Ct147xYmAwTIAlUd3z7vV9FMyh00dfx81A3lx2vqAvpalJ
	 lsFVFOdQypPDbyAogzOamplFB5E5EBpQBPdapwIZQNhgunCGNhKzKrvTJJcR1CumPI
	 mleo4D5vVi0vmGlPch4gYQBF5ZHBM+4LFKnbQvtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0772/2151] kbuild: Remove alignment on .modinfo section
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118150150.263707460@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 36d4a11b56aa98da4b4652a2e34d229ffcf36070 ]

Commit d50f21091358 ("kbuild: align modinfo section for Secureboot
Authenticode EDK2 compat") aligned .modinfo because it appeared in the
x86_64 compressed kernel image after commit 3e86e4d74c04 ("kbuild: keep
.modinfo section in vmlinux.unstripped"), breaking boot.

Commit 8678591b4746 ("kbuild: Split .modinfo out from ELF_DETAILS")
properly addresses .modinfo appearing in unexpected contexts like
compressed images by moving it out of ELF_DETAILS and explicitly
specifying its location in every architecture's vmlinux linker script or
discarding it where it may appear elsewhere.

Effectively revert commit d50f21091358 ("kbuild: align modinfo section
for Secureboot Authenticode EDK2 compat") and its follow up fix,
commit a26a6c93edfe ("kbuild: Strip trailing padding bytes from
modules.builtin.modinfo"), as they are no longer necessary in the
current tree. This simplifies future cleanups.

Reviewed-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260918005142.GA1585590@ax162/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: a98db7418797 ("kbuild: keep .modinfo when vmlinux is linked with --gc-sections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |  2 +-
 scripts/Makefile.vmlinux          | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6640e06ef2f13..f60238b0b8918 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -838,7 +838,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		.shstrtab 0 : { *(.shstrtab) }
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) . = ALIGN(8); }
+		.modinfo : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 276c3134a563a..77b9969842e00 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -102,18 +102,8 @@ vmlinux: vmlinux.unstripped FORCE
 # modules.builtin.modinfo
 # ---------------------------------------------------------------------------
 
-# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
-# tools that expect vmlinux to have sufficiently aligned sections but the
-# additional bytes used for padding .modinfo to satisfy this requirement break
-# certain versions of kmod with
-#
-#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
-#
-# Strip the trailing padding bytes after extracting .modinfo to comply with
-# what kmod expects to parse.
 quiet_cmd_modules_builtin_modinfo = GEN     $@
       cmd_modules_builtin_modinfo = $(cmd_objcopy); \
-                                    sed -i 's/\x00\+$$/\x00/g' $@; \
                                     chmod -x $@
 
 OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
-- 
2.53.0



