Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024581;
	b=xr2O25f7sUQ3d/I1Y5dxVGrJzVWKyjlHTZ+zAN731JKdGhzX4WreFgtKrLt1LUO1rA8Y
	 eOFa0Bdovf1lQhLwHcVw90JQ5HI5HqHhhg/vguXoY/5DYIZd2otuucMyh0foc4vHu1zO5
	 Xx1qs406fHIwhpo/qkXiPFJzUUuw2r4JA1MnxhwCJIHC5xaKxw+KTkFw6SFo2L0sc2RHj
	 iHqcRiqJehbnRHM8EcLoUzuRaOZT2j+HTF17sbeHj5P6tdrJnuLdkCqudFY0h36u7SoGD
	 K4EYEH0QVufGgPcTiY4zQSIdWSpXSRbk49q9QrmoGj8GMfkg7vy28OqSMb91YDWSnRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TL8sJPMCAPCHbAQpUVgtiwHt3bL7/VWagDVocDNX4Zg=;
	b=P5CWPPPALEVuy79hKSdE3i3MsIgOJRJFA67CZkyWz22kTaDl3fgDI8G7Q1T8ExC44kPH
	 tzDIqDF11/JxfFzD0D+OwxRnVMUUl98unyeAOYhSoetsFsjMy0tgt59dHMEmvhXS+f8Ii
	 mnbST3l9LD15nv+pBHCQqeaejdQGz8zXSx9d5BJzfDnvRMU0TLtQX825xyIfn0dDPv1od
	 oGsn9jdtgr8CmwJCGMenhWbtyTDsar0zZ3o2pP9NC6fhP0joLCSntjj4Mk1NSOG5VoFiD
	 FMOOQaBVYgx+vVWtn9TLMZ3AY+SIOcxgo4+x/s4a3zJzxxN5XgLmQyiTmTLwqdDKAiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yR/9m1nv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BE606A325;
	Wed, 18 Nov 2026 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yR/9m1nv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845401F000C5;
	Wed, 18 Nov 2026 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024581;
	bh=TL8sJPMCAPCHbAQpUVgtiwHt3bL7/VWagDVocDNX4Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yR/9m1nvtsUYAb8f/0UQtv6oz0R813m+QBkmfiV3lO+w5agMMZs5zHxtm6pnPV4kf
	 dxuWsGHtuL/IeRbqqqeUonbEPrsP+970KnD8U4R67LGjYT1N74Hyu9O1mf7paCpBFi
	 MOmamIlM0GaF1ZvDEziuMQ/oZF5+MfAM9U+Lptg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.18 0774/2151] kbuild: keep .modinfo when vmlinux is linked with --gc-sections
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150150.329277894@linuxfoundation.org>
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

[ Upstream commit a98db7418797bc27bef53c861b97ac748f598414 ]

Builds with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y, such as arm
allmodconfig, now fail while extracting modules.builtin.modinfo:

  arm-linux-gnueabihf-objcopy: vmlinux.unstripped: can't dump section
  '.modinfo' - it does not exist: file format not recognized
  /bin/sh: 1: cannot open modules.builtin.modinfo: No such file

or, with LLVM:

  llvm-objcopy: error: 'vmlinux.unstripped': section '.modinfo' not
  found

Nothing references the MODULE_INFO() strings, so --gc-sections
discards every .modinfo input section and vmlinux.unstripped ends up
with no .modinfo data. This is not new: ever since
modules.builtin.modinfo started being extracted from
vmlinux.unstripped, these builds have silently produced an empty
file, losing the modinfo of every built-in module. An arm
multi_v7_defconfig build with LD_DEAD_CODE_DATA_ELIMINATION on current
mainline yields a 0 byte modules.builtin.modinfo. The switch to
--dump-section only turned that into a build error.

Wrap the input section in KEEP() so that the linker retains it. The
output section is still (INFO), so nothing is allocated for it. With
the same arm config, modules.builtin.modinfo now has 14119 entries,
and on x86_64 defconfig, where nothing is garbage collected, it is
byte-identical before and after this change.

Found by KernelCI builds of the linus-next tree.

Fixes: 39cfd5b12160 ("kbuild: extract modules.builtin.modinfo from vmlinux.unstripped")
Fixes: 5fe4dd596641 ("kbuild: do not allocate .modinfo in vmlinux")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20260927161227.1179863-1-sashal@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3c62b1ef31800..52b57b7e133e3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -838,7 +838,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		.shstrtab 0 : { *(.shstrtab) }
 
 #define MODINFO								\
-		.modinfo (INFO) : { *(.modinfo) }
+		.modinfo (INFO) : { KEEP(*(.modinfo)) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
-- 
2.53.0



