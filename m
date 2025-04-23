Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96272BF3DE;
	Wed, 23 Apr 2025 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421834; cv=none; b=j52hhBZXIPK5KruLX9f8fgSudqTTIGwG5ZJCH3OrTGdKRxglq8iFoldo9/UHT4fU3sArpjDu2VOCuZl8QDkf1Iy9N/aFbabqxTHaFXOdM1DW9jpbpGof+L49zFmdPeN1n1DQK+kgN+Bh0zusjVWhb3/wsLyhc45OQvqxHpKlpWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421834; c=relaxed/simple;
	bh=x6n2ffQczPt1u11OTCbLrxy6wSAFFYN6B0IW7TpYeF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5KHb1Qu5JsOe/3ek8pyXjYD80XfOunpD19f0OlhkrQqlWzZ+XABxiVVoAnCGQnTh2YX94bwi5E5NJfwQCGV0vpRIJRuf92wVjZBjydQTFTB1HVKnPuVEJY3/VMAIADXEg1L0bCXhDLUIB4yGN+Vn4HxLBKqs+eV8TLPSiONFg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCGA3JlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCGA3JlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D89C4CEE2;
	Wed, 23 Apr 2025 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421834;
	bh=x6n2ffQczPt1u11OTCbLrxy6wSAFFYN6B0IW7TpYeF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCGA3JlBpr6iCBDQ/9x/5suiCjnwbOvcj9H8E7KYZ50cKb2zFNalhUqL2zYnqVEBG
	 OYLTlnlPssqYoqAkutmFE1jF0eWkGL6ubQ7TeOGvfEPd8gIZYG6fkVlrCgJ33NOuSg
	 VVIsidLhUQmbQUBTOMpldm26mlCVXp3Mi6vRt/zo=
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
Subject: [PATCH 6.14 223/241] arm64/sysreg: Add register fields for HDFGWTR2_EL2
Date: Wed, 23 Apr 2025 16:44:47 +0200
Message-ID: <20250423142629.664105485@linuxfoundation.org>
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

commit 2f1f62a1257b9d5eb98a8e161ea7d11f1678f7ad upstream.

This adds register fields for HDFGWTR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-4-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2672,6 +2672,34 @@ Field	1	nPMIAR_EL1
 Field	0	nPMECR_EL1
 EndSysreg
 
+Sysreg HDFGWTR2_EL2	3	4	3	1	1
+Res0	63:25
+Field	24	nPMBMAR_EL1
+Field	23	nMDSTEPOP_EL1
+Field	22	nTRBMPAM_EL1
+Field	21	nPMZR_EL0
+Field	20	nTRCITECR_EL1
+Field	19	nPMSDSFR_EL1
+Res0	18:17
+Field	16	nSPMSCR_EL1
+Field	15	nSPMACCESSR_EL1
+Field	14	nSPMCR_EL0
+Field	13	nSPMOVS
+Field	12	nSPMINTEN
+Field	11	nSPMCNTEN
+Field	10	nSPMSELR_EL0
+Field	9	nSPMEVTYPERn_EL0
+Field	8	nSPMEVCNTRn_EL0
+Field	7	nPMSSCR_EL1
+Res0	6
+Field	5	nMDSELR_EL1
+Field	4	nPMUACR_EL1
+Field	3	nPMICFILTR_EL0
+Field	2	nPMICNTR_EL0
+Field	1	nPMIAR_EL1
+Field	0	nPMECR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1


