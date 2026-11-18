Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017532;
	b=EH0AJVQhxOkUgsJe8Rl7cDE3GGIRAhD9XE9o4fhmpvjst6czx2pQ+/5UlNEMeWZPyTff
	 efMb84ldZ1C40dJ0mhbQDcBipRozR1THitJCtljVULqZ4DfBn3iz92dk0RhoPVd+bkT9g
	 AbvfV71e6s2gTowJHsO3P/z3ssAFU88lVJXmSVexIGExQ37NRof0CLwlQFRqrwTOcYCNJ
	 dRLCSUChwYLGrsB4XCEoTEFG/9w0tdAaVPSewSKRAiJbZRJijQ6i8V0U1HI+S11sucIjI
	 hpnpfNOFTADv3EUr9+UQ15FjtiyF+igm3FPHbinzew7Z8sBvCHFrVyOdIro5b2ZsQcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6r77grM5C0uKWWR0jvn/V04qCOJk4hc9BAsol98PMQ=;
	b=yd4m2datDpNgijRUL/3tIuVGL4bT4NH1SMvQcQiMzkbUrFYtZwQonL/fZZsrqCh2tICT
	 kMNnym3i5uFDz+a8a9ep+98zP8jET8443ZD4E9vC3hDy4nLKm+Wb/dnB96bF2T6jqZL4B
	 EFh00LDgjaq64s0eY5H6PmBksWSqAiAdGJcEA3SEhUqqomzIgH+11Je8xf6u+lFsRmJgW
	 VRy+T1Jbff8mO1EHKI71fnH/mIjZIwAuXb8BgmJ/5n2R4bkTDVQZ9F/zxE4Hx9QhCrwd2
	 DFbdWwiGfyGifUfTuktChK4krEUpy9cP6MBEq+XGmvg8yGLsGXUDbaLP8IvkLcRXiAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYGzllbx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80F0606A31C;
	Wed, 18 Nov 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYGzllbx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CE31F000C7;
	Wed, 18 Nov 2026 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017532;
	bh=q6r77grM5C0uKWWR0jvn/V04qCOJk4hc9BAsol98PMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYGzllbx+5kRfXESZenRsNBa5ZRDSqnJjqugQ+/GO2DTvTNcdAu0IB2f5/Wzn8t9Z
	 OVbHlu+1CzJcc4Hioiq9gZWHHgozopyIbbJzmJ4M+xPkFu5deI/j9wLB0rwJcwjPdt
	 2LI+v5p6YX1hqBfYZaogN+QusJb2Oo2DROq62+Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0911/2651] kbuild: Remove alignment on .modinfo section
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118150320.683770658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index b2988aa12f664..26201821ea7ff 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo : { *(.modinfo) . = ALIGN(8); }
+		.modinfo : { *(.modinfo) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index fcae1e432d9ad..6833b517cacb6 100644
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



