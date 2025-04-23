Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086628B4FD;
	Wed, 23 Apr 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421726; cv=none; b=R3Y0BcxMk/P4FcfUumAbKQuV0nwHltTez+bRrzjMVkNsBwXq65w3KEpcRZKRNBL5kI0QOPRwJk7/M92cq5Q9iEhrm2RI2UNjWsuJtyh1XF915PT1JAS/oTfgPS7G8AYKg7UpPpx8OnDS8EzJF1SoWwpQmh/A7SuLjQTIjRZw0ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421726; c=relaxed/simple;
	bh=+Vh13KHVnNVKTaZlDjGaJUeg4Q5Pfyjha+jDOrzr7MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmYSZWsn/FGa3u8v7dyhZVbVjkcFPagPJcNqarDa70Z5vN4yZIFgN8iZzDrGNxzIzR1x25Gh0GJh0Xa6AtWvyFvoAIncoYh6j4oj/+G8pO7lXDlVpGDXt5xGknoFdc64MJDdEbGnFUJLX9vKW5QMbSPakDsKKccF8KOCN/5xWOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpD685b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpD685b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22862C4CEE3;
	Wed, 23 Apr 2025 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421726;
	bh=+Vh13KHVnNVKTaZlDjGaJUeg4Q5Pfyjha+jDOrzr7MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpD685b7uXff14y7rea4lGlBqnBStdk1A4b02jAOwdn+arEmEM7CKNkvQ6tYwFaD+
	 j8SRz8N9o22y3Mr6pzVrk3mC/pxqaHtmB1olCeqlw6JAQ6Zm9kQ8qkr2HPdnz5yXfS
	 VamPRlRJQa4a0w/9Ns9CUG9qde6DhJPjoicT2bSY=
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
Subject: [PATCH 6.14 226/241] arm64/sysreg: Add register fields for HFGWTR2_EL2
Date: Wed, 23 Apr 2025 16:44:50 +0200
Message-ID: <20250423142629.798275722@linuxfoundation.org>
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

commit ea37be0773f04420515b8db49e50abedbaa97e23 upstream.

This adds register fields for HFGWTR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-7-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2719,6 +2719,25 @@ Field	1	nERXGSR_EL1
 Field	0	nPFAR_EL1
 EndSysreg
 
+Sysreg	HFGWTR2_EL2	3	4	3	1	3
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
+Res0	1
+Field	0	nPFAR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1


