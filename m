Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618748;
	b=12kuBoZlgw/EczMDxsoiAFsNDrLbjXysB+1IcmWfvpOZ/wpDGGMcVQB31C863uDXfYOL
	 0XHTHSaGaeG0EDba9jQ+XVg/ySdkGlJipUzBLYQvfmTOL0szRhmMBwe8d6R5K1XoKoQd8
	 jUVOZBtFRSfjyRWo3UOG76r7FNa7MHhvz56NuNAl/GK7MRU8DNueNai6zS50J37naElnh
	 sT6M3idV2J7lm4aYWzICNm7MT02lu6sVAbB14eDEG+d/0pzc09C471+fvaX8+uNNpkAcx
	 6YAvfAxJ8dMofrOUjUuPvcGrYprZGR1e5TC9ahKqkOp1cPrgca8CbM+rZwMLMh80V+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KcTwL1jtlxXxOriVfO7ydr7SGdlqmyQTjuc6EcBw+FU=;
	b=Jvadgc+6fPF6+ZoAqHVcrxvlIbwy5ULIn2Air/JujWvBsMjAf1xYhKJNCQFS6j22oD57
	 U3LIrcJ47+0ru9G4wB8NsUJWMNXwQ8Ppm7NJ6/FG7H7ZiCSyAwyogyQbStPvRmfcOfLF/
	 QeQgPnESqIvp71ZicWYozMftUk5KmEuCmwcmZriVIutWLVDbP1vdcv/yJD3UCS/BZUn2T
	 T2bjULAUBo9kS2PfinpUwx/SnGB43ZDZT0u3YyQ8//8MfFCBoSAGudjRAByoOrDMHGHWM
	 b7OMsc4nZinrKl65qPK0upct9B277cTSLq/0zJ6tcyzrw2vJ/lmX+xK9Q6jgrRhGyjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T0oF4/ty";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964FD606A31E;
	Wed, 25 Nov 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0oF4/ty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8282D1F000CF;
	Wed, 25 Nov 2026 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618748;
	bh=KcTwL1jtlxXxOriVfO7ydr7SGdlqmyQTjuc6EcBw+FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0oF4/tyC4ps+15Z3qtrVqiPJxQp0Q0cTHbGpSSs5YvFuKr6fn14jdS96DDHT2iw1
	 HcjKP80NsZ2/RjP2RKiJ1GuCCmjiKsmKTzs1+G6HetFgxBXbA/2iWm0KXipYLQ0hVW
	 pDP9NpUV8ScnYtfkkyHDsTJz6oubdg02KE8lER7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0377/1005] kho: check fdt_phys in is_kho_boot()
Date: Wed, 25 Nov 2026 15:28:35 +0100
Message-ID: <20261125143830.569051429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 58c5852ca96c58cdfdb9646870b217fc54d06a97 ]

is_kho_boot() is called early in boot before the linear memory map is
initialized, so calling phys_to_virt() via kho_get_fdt() there is
invalid.

On arm64 (and similarly in upcoming riscv64 support), this triggers
BUG_ONs in debug builds, such as:

  kernel BUG at ./arch/arm64/include/asm/memory.h:377!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  Call trace:
   is_kho_boot+0x2c/0x38 (P)
   efi_init+0x94/0xf8
   setup_arch+0xf0/0x240
   start_kernel+0x84/0x490
   __primary_switched+0x88/0x98

Use kho_in.fdt_phys in is_kho_boot() directly instead of translating it
to a virtual address.

Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20261023054518.3258350-1-gthelen@google.com
[Pasha: massaged the changelog]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3c87c2a3d6f09..ab55b77119d64 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1631,7 +1631,7 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
  */
 bool is_kho_boot(void)
 {
-	return !!kho_get_fdt();
+	return !!kho_in.fdt_phys;
 }
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
-- 
2.53.0



