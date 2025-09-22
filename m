Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B452F0C52;
	Mon, 22 Sep 2025 19:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570218; cv=none; b=jmjZnmSW18AJ7h3gTU+HRofH0nMdgtTkNwoiZ0YaHrtRidh2EdJr3JA15tywImtCvCVb7dC5FLSCI7o7B1PokXnHD5OtuM101Fndt2LRGXQK4rZkBjgiMZ4+PxMdq4znDhb1fWNvV2EFRWrETGr6jNnMkl/pisLzGJXI/7h+B0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570218; c=relaxed/simple;
	bh=iEH+EyvyfXb4hVldapZka32S4tw7fSTexm/jnSPtH5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAqNzdh5K3giXRw+ryL75MZnkAPRF/aZ1l6IkGDYYlaK6IymkKTtBTZ374+sHz2N33ldD0K1aKncVqdnlM7mLs4nqBzR1kIwKxVkvmCNGt5mZWhW6OVSCTa5ImGMzFWQrKAKzl9pVzPyK4IYZ2AjVgtfgNmFe9HTHNk7Bjy/GtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEFPTGgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEFPTGgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED3EC4CEF0;
	Mon, 22 Sep 2025 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570218;
	bh=iEH+EyvyfXb4hVldapZka32S4tw7fSTexm/jnSPtH5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEFPTGgL8r5oFpw1tdG43rPsHl+5dFixDY6S6qTHzwP51XNqI9Re4iHtP2m8gyC4i
	 3X8nlcMpEOK/aWX+1NN/dycgW+qnRHW8/F87HeZ4chJ4JeVI8+7aMgp1fsb4FG/CiW
	 HhkazlgxGynaoh9BmtulPvg9U0O3CqTLssKZjxLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 064/149] LoongArch: Update help info of ARCH_STRICT_ALIGN
Date: Mon, 22 Sep 2025 21:29:24 +0200
Message-ID: <20250922192414.497370578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit f5003098e2f337d8e8a87dc636250e3fa978d9ad upstream.

Loongson-3A6000 and 3C6000 CPUs also support unaligned memory access, so
the current description is out of date to some extent.

Actually, all of Loongson-3 series processors based on LoongArch support
unaligned memory access, this hardware capability is indicated by the bit
20 (UAL) of CPUCFG1 register, update the help info to reflect the reality.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -566,10 +566,14 @@ config ARCH_STRICT_ALIGN
 	  -mstrict-align build parameter to prevent unaligned accesses.
 
 	  CPUs with h/w unaligned access support:
-	  Loongson-2K2000/2K3000/3A5000/3C5000/3D5000.
+	  Loongson-2K2000/2K3000 and all of Loongson-3 series processors
+	  based on LoongArch.
 
 	  CPUs without h/w unaligned access support:
-	  Loongson-2K500/2K1000.
+	  Loongson-2K0300/2K0500/2K1000.
+
+	  If you want to make sure whether to support unaligned memory access
+	  on your hardware, please read the bit 20 (UAL) of CPUCFG1 register.
 
 	  This option is enabled by default to make the kernel be able to run
 	  on all LoongArch systems. But you can disable it manually if you want


