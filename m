Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A42D3F9F1;
	Mon, 29 Jan 2024 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548446; cv=none; b=QB5qEMhR1riEY3cZoLtpQldgn/7cYOh6wkLXefsW5mQk9/3gp1jyMzddizJzK6uQkj4xFLjkK6PjLP/msbJtmghBovXhwrY/n0CpFmzerNwq80HQOIeKQ+OKrSyqoIvPDEHwvNk5PvPAc2XEETahbjuilDGHjJ5MxDqku2RAa24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548446; c=relaxed/simple;
	bh=BoGXNR5V2tEfg1HUeUSIxe+aivcNRsNL7r7feYTrCRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjeEhf3RVN3Nj8TUz0ChZHtQp15i+SsWJKIoaRW2FuqVmw85D36jTpwUiBMY3kVvxjyuLjKAdW0F2Vmh9/K4PAi7NbWQ2ueMlMhVGukb91U8EjMRt90LMhwJ5bBcILFgfEnzYutW4hQtJn+hNu6jbeZxP75quvn1O6/bFELPGU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjzADctt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjzADctt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D751C433F1;
	Mon, 29 Jan 2024 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548446;
	bh=BoGXNR5V2tEfg1HUeUSIxe+aivcNRsNL7r7feYTrCRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjzADctt1jB7PVXF/XuwfYz4VZID6Xmj/S94Xo7bHoIjGc4EWPuucr1SZIFHB+XC3
	 stWOSAkN84RHEE2IUwxAQKX3LZBHiXPE3CbHMAA7NNm+o6jzGfvw1jYv+LMzBA989j
	 OSsaagI5JdVY69j98SsfiCMx0nylyVBBwN1v3lao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoff Levand <geoff@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 029/331] powerpc/ps3_defconfig: Disable PPC64_BIG_ENDIAN_ELF_ABI_V2
Date: Mon, 29 Jan 2024 09:01:33 -0800
Message-ID: <20240129170015.805236027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoff Levand <geoff@infradead.org>

commit 482b718a84f08b6fc84879c3e90cc57dba11c115 upstream.

Commit 8c5fa3b5c4df ("powerpc/64: Make ELFv2 the default for big-endian
builds"), merged in Linux-6.5-rc1 changes the calling ABI in a way
that is incompatible with the current code for the PS3's LV1 hypervisor
calls.

This change just adds the line '# CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 is not set'
to the ps3_defconfig file so that the PPC64_ELF_ABI_V1 is used.

Fixes run time errors like these:

  BUG: Kernel NULL pointer dereference at 0x00000000
  Faulting instruction address: 0xc000000000047cf0
  Oops: Kernel access of bad area, sig: 11 [#1]
  Call Trace:
  [c0000000023039e0] [c00000000100ebfc] ps3_create_spu+0xc4/0x2b0 (unreliable)
  [c000000002303ab0] [c00000000100d4c4] create_spu+0xcc/0x3c4
  [c000000002303b40] [c00000000100eae4] ps3_enumerate_spus+0xa4/0xf8

Fixes: 8c5fa3b5c4df ("powerpc/64: Make ELFv2 the default for big-endian builds")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/df906ac1-5f17-44b9-b0bb-7cd292a0df65@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/configs/ps3_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 2b175ddf82f0..aa8bb0208bcc 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -24,6 +24,7 @@ CONFIG_PS3_VRAM=m
 CONFIG_PS3_LPM=m
 # CONFIG_PPC_OF_BOOT_TRAMPOLINE is not set
 CONFIG_KEXEC=y
+# CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 is not set
 CONFIG_PPC_4K_PAGES=y
 CONFIG_SCHED_SMT=y
 CONFIG_PM=y
-- 
2.43.0



