Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2681B222590;
	Mon, 22 Sep 2025 19:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569723; cv=none; b=kQQhsNQwibbjyxwbm6Y42vOrnXF4rang9aHnDlMTkWkuT70JiYXta2KcavFTyEgZeQbEPbI2bU4mfFt5d7JLYsXL+VE2HhYglcDA12Lecna2x79/zvE36dCA1KtNFJg8pD0orDvVmtslmZCKYkdM6CV2AJMSs4NSVbofogBWLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569723; c=relaxed/simple;
	bh=rqq6Tl8FnsK3L2aMQi9ZHL6+fpg8SmlkAJ2giQpXGXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oatsw79ecmc/2qs3NG2ns/rzxMZo2bYbeJbOY4fUrdcPTItqjFo5wgxqOBdlRYJTSmmqwOLzGPWDuZo5lULPrYkNrS/c4CRQ/1gWM4siGw2ftMsj7U6MyIU0w3eWZEgJGPmDV4UI7Dxa4npgnyaKMMUuN7bM7NF6jItFc6aBqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTAri95u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTAri95u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E02C4CEF0;
	Mon, 22 Sep 2025 19:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569722;
	bh=rqq6Tl8FnsK3L2aMQi9ZHL6+fpg8SmlkAJ2giQpXGXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTAri95uNjIo2hzurjaIUIGfiLqqkoYmCcEM9t6jKUc+ddJYytU66+E8lSCTvUZou
	 MN/kfERzSFE2GcZuMtn3tT65DtXRIAOmb5X7Blx2BySaSH8ndm55ITDmYGjAtQ/cjT
	 FuoXaZgYOOjTyAqIn0DYn1Jze1emxfVQRhOPzcUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 32/70] LoongArch: Update help info of ARCH_STRICT_ALIGN
Date: Mon, 22 Sep 2025 21:29:32 +0200
Message-ID: <20250922192405.460517213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,10 +503,14 @@ config ARCH_STRICT_ALIGN
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


