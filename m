Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056722;
	b=CKaTyDPF40ZEvHzFGokvmvVhuDMa/Zqam1LcgJpDpI37T3PtJi1MsJArd6k2o6usgsT+
	 c6IQo4S1zxkmmhHd495xhKxS9WroGoXeEIl5h/i86i7KNOGxW/vS4byFJtqJyvxWqeD+F
	 OZFeknIyUIgLn/c47LdfG1acWEIYQTMF1hZ4pewtxmV5x8kfSW7Xx7FbuM9OhhOpAMhjL
	 XhSvJZNiCZcyfXQuHkLt5XG+2KpU7FbJsPNHgDCtcOroTZ13SQrruVbIMsZefIwiayMNC
	 j0HTHD+RlqVhdJh/mjCvzNq2lPUiOj0k1JSHssNty81UR6+hH8tJqc9tTsOx6XM/93Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9TNt7eeIiks04tau9zpWc32pXRk+BdMUGpdIWAICJr4=;
	b=kAJcxR9QEBJA+dlASNWPtAq23InyFYWsaLS4XUNTndPq2aksZPfeQ3rch2/eTZPnfDbb
	 EmaLMaYCDgZARfzkNnQrs0k66tITohpDi/qE3PJgb9YDOerq8o2uYxnLx79ZF3vNU6Wan
	 IJf9s2bQzEPny1ocgATZQbircy+iSOKCsbbcphWPUhY0u1sTkIgE7QBirqWcf3SSHls2R
	 MfiEidm+Q//a/KhBXrMwXP7UXNYay0ZaBr5K417nPCVRpFWhmrBbVPe4guMfPA1gbgj6G
	 YKrbsP+wZSGCUJ+3MVjCWBISKK/PFxJWHTVS9GX8DINoUsJuSNNbvoGEC4zp6wEY5Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IG94dx8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E9960A2604;
	Thu, 19 Nov 2026 02:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IG94dx8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE50F1F000C7;
	Thu, 19 Nov 2026 02:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056722;
	bh=9TNt7eeIiks04tau9zpWc32pXRk+BdMUGpdIWAICJr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IG94dx8bM3OAIaKSuqPln1Tl+3PyxcMtGOA4Qj8ZTPKAVLDRtNM3Bxnm3Jgj6CZxq
	 g7HecaxzvUnjSpTjL8YxscTrO6BlAGgxkmac+sG099Jqz7ibvDeYqnjQRu7cBucgTq
	 szGzvVOYT7OpedsCLiiTCnLJ6rpXpPUAt+7iNhUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waldemar Brodkorb <wbx@openadk.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2090/2214] sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150134.225836276@linuxfoundation.org>
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

From: Waldemar Brodkorb <wbx@openadk.org>

[ Upstream commit f45711b39e03ff5e80b60dcc1fd34b3fc7d3d36c ]

binfmt_flat offsets the in-memory start of the data segment by
MAX_SHARED_LIBS words and then aligns it to FLAT_DATA_ALIGN, so FLAT_FLAG_RAM
binaries end up with a gap between text and data (commit 2217b9826246
("binfmt_flat: revert "binfmt_flat: don't offset the data start"")).

SH position-independent code finds the GOT with a PC-relative mova of
_GLOBAL_OFFSET_TABLE_, which assumes data follows text directly, as elf2flt
lays out the image. With the gap, the GOT register points below the real GOT,
so every GOT load reads the neighbouring slot and gets a wrong pointer. On a
J2 (sh2eb, no MMU) this made userland crash or hang right after start-up.
In my case the data was moved up by 0x20 bytes.

Commit 04d82a6d0881 ("binfmt_flat: allow not offsetting data start") added
CONFIG_BINFMT_FLAT_NO_DATA_START_OFFSET for architectures that cannot
tolerate such a gap; currently only riscv !MMU selects it. Select it on SH
as well when building without an MMU.

Tested on a J2 board (Numato Mimas V2, sh2eb, no MMU) with Linux 7.3 and
FLAT binaries built with elf2flt: with this change the data segment starts
exactly at the end of text and init runs.

Without the patch bootup fails with:
[   12.080472] Fixing up unaligned userspace access in "init" pid=1 pc=0x(ptrval) ins=0x6583
[   12.123609] Fixing up unaligned userspace access in "init" pid=1 pc=0x(ptrval) ins=0x6583
[   12.175153] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00

Fixes: 2217b9826246 ("binfmt_flat: revert "binfmt_flat: don't offset the data start"")
Signed-off-by: Waldemar Brodkorb <wbx@openadk.org>
Assisted-by: LLM
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 04c41890fb79d..fb85365a6eb5c 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_NEED_CMPXCHG_1_EMU
+	select BINFMT_FLAT_NO_DATA_START_OFFSET if !MMU
 	select CPU_NO_EFFICIENT_FFS
 	select DMA_DECLARE_COHERENT
 	select GENERIC_ATOMIC64
-- 
2.53.0



