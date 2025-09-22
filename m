Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001DF27B320;
	Mon, 22 Sep 2025 19:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569902; cv=none; b=I6O4iIBiWhB2iurfoHqhRQ8lw4P4OM/o6ThgtlLA86siHSzc4ubI7PMfkFzeEUJg3eHj/+BnbZ41kcsa+uHcVLn4Tp3YjoNgohL/UfxlBXIXSZcbqptH1O5vS4XVEMnCpL5QU22u2saCSb5FSphFLlzu78qTeazuXHMpFa6dQtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569902; c=relaxed/simple;
	bh=20bxNPjk271TquIjBDfCHU9gCabreZQlCEateRXdacg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoYQAKJGmlbjvOVL/PPcAGPiCo6FRIl8CsNLgdZZjGHyhcrxuE8zxiiVGgCZTJiwCRsgrPpDSP4YNyuamniOoESZ9qWB5560Z13Txvhi/Ooy7CQRokylOl9Gair2BM99KIdIeCr4ewYXFhrr8mLnLWu8BMamTOWitNqhdwku3tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvl1r5Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvl1r5Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82697C4CEF0;
	Mon, 22 Sep 2025 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569901;
	bh=20bxNPjk271TquIjBDfCHU9gCabreZQlCEateRXdacg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvl1r5Rs8KDc8uiWfnFWTgJM8VTgbBEcYyum4ynYlKovnO7Fv8S/3mdtPY7ixbgHj
	 wweNWYS6O/Uk4FPZYY5L1oZ1Le/5iEbtlxj04a4NDSXmB7uz1dd8CQvmpIKb3a+qMQ
	 6UGbY+W9ChURxGpQ73bCHKDuqf3YEO+gjmDDsGgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 044/105] LoongArch: Update help info of ARCH_STRICT_ALIGN
Date: Mon, 22 Sep 2025 21:29:27 +0200
Message-ID: <20250922192410.072127888@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -540,10 +540,14 @@ config ARCH_STRICT_ALIGN
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


