Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050359;
	b=bOlR3abgmyensTeBgA++IRQItBcT3xn3syF1UKuZaee4W/ZzR6rsGemp4fYHiORjBWQp
	 DYRV+YEOnKtRPFcznIWkY5YTLJDpCvzpNG5X0xHl8so4igG0iwFoeEdFxgaK2JSOV8xF3
	 g2Vb/Ws6JiBipLeB0dXWJ8a5risn5PVnhK9rq/IEoa1sUrYyCDF5IpCcDddjLaWtfxSi6
	 M/vGOFCZclLf8HCjXU+9GYR3BbxPkLXK47KAzlPP+o1u+17Kpd1Pb7WL6D5X5SKqPraAv
	 aYCAoMljTCBypGBNtS11BkaRp62uRFzxWUF4kQrGd3TW42eANwenUci3/AGqtEyPwcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1oSEAnl3vp0OvauvvVF1TDQspB/SXcqjugobx8wnv8=;
	b=wuFKCL4GPBVZXOHM+xVRaCvzO5oxLgpwsIwV8Dbha1q1xavPQkN+87OKxmchIN7hU67d
	 tctkFZu8If2azfapS+pjiXSdHhr79y1X/d2titDUiV67nUngpAmd+NrKDe8xMxgmJfITW
	 5sIUF2mPU/oiVWVqNB3rRVCY+CckIUzm4GtLtsViplcF/HWEAN+/hwtEG10uD/bBy3yMU
	 bU8KfXATzTWbXXHk8DTG8Zqfz4huk23cN+plP/+wgJ3H2XJcjecN8HSFzMuXRnsCi3MGa
	 s73oBO2XzFduVZEMhZZgUAomymWf7o3Bzd6ZKXa1WdUZE6zHJuCVbDZVdCwnBVy54sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf7EppYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A4606A33A;
	Thu, 19 Nov 2026 01:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf7EppYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712BC1F000C4;
	Thu, 19 Nov 2026 01:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050359;
	bh=d1oSEAnl3vp0OvauvvVF1TDQspB/SXcqjugobx8wnv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zf7EppYS57frz4xgjyLAOtwrYAnm2zzjR4rTIAG5qvd/C+36gg1fvNE7eyAPQsQjS
	 +ERwPhp4VDI89uCOIrtYgYGdc3WexZIovO4h4+3D5K6QkKY4UcCAVNkjO/wgdpPYhw
	 Hz+K5PvsZGEWBuJeZIp71vL1arH3C13E25eBDBUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waldemar Brodkorb <wbx@openadk.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2681/2857] sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150338.109501212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dbbfc9ffbb955..8cb703cc1e55e 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -17,6 +17,7 @@ config SUPERH
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_NEED_CMPXCHG_1_EMU
+	select BINFMT_FLAT_NO_DATA_START_OFFSET if !MMU
 	select CPU_NO_EFFICIENT_FFS
 	select DMA_DECLARE_COHERENT
 	select GENERIC_ATOMIC64
-- 
2.53.0



