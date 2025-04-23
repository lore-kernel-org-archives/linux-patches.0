Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58DF264624;
	Wed, 23 Apr 2025 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421718; cv=none; b=ISGC1jPA9R55bpYFxhER+aEZZ+c6uSP0keLIMHeCYuYZeLhgSYiPv9MkAg2ce0xquQGZbP12Sn6GrvNQ5wjaYdSlvslakseu1bB9stcpl+zPJQPADfe1xYytZFGDhNf3eJlzVj3h1ASyeMBqbS+dR550QuzKhfYkn/s8biMYEv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421718; c=relaxed/simple;
	bh=TX4AcErGChHkeZ/T01FPi+Pp2gu0UnZQ/DIbHDDbSrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQsTJCTWpILiHs1ZVxDc+7ZGUTlf6atvDL5jgI6tqjqbuNstoH8lICBTgIHEv1+So0RJZ9FxnGKXQuGCRTt4MgsH8lDY8FpNpk+ER1BPJ7CUnk5b0BdIBn15oA+KGZNizBmkhiZWY1vVAyHA8qBVNP2iUNEeqoZlrbeQUKaa4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWvriS5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWvriS5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F707C4CEE2;
	Wed, 23 Apr 2025 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421718;
	bh=TX4AcErGChHkeZ/T01FPi+Pp2gu0UnZQ/DIbHDDbSrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWvriS5YAQDBP4iIVH7zVBoR8DHOny0enqHxWG34dWlbSrdzAknSG0j0FmMsukLy1
	 MQhQdPmXF9KFEr6QqCjLUvCqtbQzN54uSXKK2LbhIos3lonHtnHkptc1yOdSwbPAq8
	 EQL+vMinBxV5FoeFdpcDxtVNseNrxKMhByyFgyA8=
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
Subject: [PATCH 6.14 225/241] arm64/sysreg: Add register fields for HFGRTR2_EL2
Date: Wed, 23 Apr 2025 16:44:49 +0200
Message-ID: <20250423142629.757952816@linuxfoundation.org>
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

commit 59236089ad5243377b6905d78e39ba4183dc35f5 upstream.

This adds register fields for HFGRTR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-6-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2700,6 +2700,25 @@ Field	1	nPMIAR_EL1
 Field	0	nPMECR_EL1
 EndSysreg
 
+Sysreg	HFGRTR2_EL2	3	4	3	1	2
+Res0	63:15
+Field	14	nACTLRALIAS_EL1
+Field	13	nACTLRMASK_EL1
+Field	12	nTCR2ALIAS_EL1
+Field	11	nTCRALIAS_EL1
+Field	10	nSCTLRALIAS2_EL1
+Field	9	nSCTLRALIAS_EL1
+Field	8	nCPACRALIAS_EL1
+Field	7	nTCR2MASK_EL1
+Field	6	nTCRMASK_EL1
+Field	5	nSCTLR2MASK_EL1
+Field	4	nSCTLRMASK_EL1
+Field	3	nCPACRMASK_EL1
+Field	2	nRCWSMASK_EL1
+Field	1	nERXGSR_EL1
+Field	0	nPFAR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1


