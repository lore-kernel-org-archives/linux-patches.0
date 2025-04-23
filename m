Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2FC2F2E;
	Wed, 23 Apr 2025 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421698; cv=none; b=b99CmNsf9GEaBjzR/+WaR0qezURbOheZCbW4UKZIuoKSRcpdUxRUtKU5Bncl1K8K/4v+XkryGpOV7qQ84tvP+F07Bxk9wDVR2HomAHiIWTL5SXeBZ0pkEUyr7qmODj/EsD27uTEuVnzBxkiA6qT/y+GBBp1KFsCX4GkHgWuKtGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421698; c=relaxed/simple;
	bh=NkZRqXQRTNgj9/u3XXnJVb4GYvU54IhrT3eUzBk3RiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/BgDYu6Aico1eehqE6SqFWck09+qrzC/UypnET3xBBwX4lZQOJ5b+181zGf4MhQfuOi0vVFxVp7Ta3Vd+78VaO1BNmYsCrMmH2OII8je04At0zi6+xYNLJHFYudQt1WgTGki3y1e79Mo4ZrfTA6xnN+BeykBDbgy0+TftvLVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbZqPiwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbZqPiwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55682C4AF0C;
	Wed, 23 Apr 2025 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421697;
	bh=NkZRqXQRTNgj9/u3XXnJVb4GYvU54IhrT3eUzBk3RiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbZqPiwjAJiOP7/WJ8xwzFyqQjmYliIOkn+vRpGtui8xQ5yYXLbOHNcB23Fh/naCH
	 IJ02w8qcA11i2CTsKbxL1wSGC+nZ99ucKeo2kruSRj1txmSxRKhHcsY00LkO5u8gnD
	 amavq0AtAA2I16g2CHDsvTBAWFK3RI2JGsO6lZ8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.14 221/241] arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
Date: Wed, 23 Apr 2025 16:44:45 +0200
Message-ID: <20250423142629.585270529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit cc15f548cc77574bcd68425ae01a796659bd3705 upstream.

This updates ID_AA64MMFR0_EL1 register fields as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-2-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1664,6 +1664,7 @@ EndEnum
 UnsignedEnum	59:56	FGT
 	0b0000	NI
 	0b0001	IMP
+	0b0010	FGT2
 EndEnum
 Res0	55:48
 UnsignedEnum	47:44	EXS
@@ -1725,6 +1726,7 @@ Enum	3:0	PARANGE
 	0b0100	44
 	0b0101	48
 	0b0110	52
+	0b0111	56
 EndEnum
 EndSysreg
 


