Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E410C2820DE;
	Wed, 23 Apr 2025 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421171; cv=none; b=ZaUpFLsMCvgpHMc+x+3/aFm4q+jF3kOYGhuar1T6QupNRQZVSr8ucpnmTisNIsA2j+puHa4MfYrVQTDc1GTsDIwFnAplFNhZeBOAAE3XbEDAqfkA4H368Rf/HG4KRolpt7UQvdEWYqV13SFetVfgCrOmJ46ilfjeeY5HfC/hLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421171; c=relaxed/simple;
	bh=s451sJB50M6FmZV61fBL8Whsy95Sc2aDN7sbRGLl1Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkNTBXyl3rnIIDfmp7lbWKTeWcbqRnROpJVlUQap7ALnYFfSmSNm2bM2XiqYn7miO3wvbYpB8Pa47kCR4FvMkmhQwJrk8h+9PVb4ryHk9/YZgV32pnvO4EEmurnoEyjSDtgVMFa5S6iAUEWKO7cywwfJSxdfy0ajlES49Ni5PJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtEoVysY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtEoVysY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC0C4CEE2;
	Wed, 23 Apr 2025 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421170;
	bh=s451sJB50M6FmZV61fBL8Whsy95Sc2aDN7sbRGLl1Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtEoVysYApVdDDek6TRQWW2AURkvsD8jjRQibN6JsOdHD+tEX3tQzES4WgPWuO7Nb
	 A8uIcxnr57g/b7krgsMFywC3cF3lHkAUP1bfVCmEzs/a6bM+DtJhA/6z2y+6T67no7
	 PrrSofS8dvcaJubcH3RrjMR8FidS9y1Hiqd15orc=
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
Subject: [PATCH 6.12 186/223] arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
Date: Wed, 23 Apr 2025 16:44:18 +0200
Message-ID: <20250423142624.750771111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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
@@ -1556,6 +1556,7 @@ EndEnum
 UnsignedEnum	59:56	FGT
 	0b0000	NI
 	0b0001	IMP
+	0b0010	FGT2
 EndEnum
 Res0	55:48
 UnsignedEnum	47:44	EXS
@@ -1617,6 +1618,7 @@ Enum	3:0	PARANGE
 	0b0100	44
 	0b0101	48
 	0b0110	52
+	0b0111	56
 EndEnum
 EndSysreg
 


