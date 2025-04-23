Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B416A28DEEA;
	Wed, 23 Apr 2025 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421086; cv=none; b=pwnXqDzH6KIzGm9cr0zrzlXvqAwWzU7YubPw4yjDYJBw4baZw0tF1iVvWiq180Oi78ggu0uEYW94jjinoaw1nbwWfj/SsINZ4X3FcMSE3BeolYhBSneWKZEvKk9Mubcm6ejyfkXOyyIzQR4K0ERrR9DbPRnw9FJJuu4le0TcF8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421086; c=relaxed/simple;
	bh=XA3avwAMHv6u/gfRCESZLEguhQ26c60iiY1K4fwewxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwYHEB1bJx++dOMid7lIgNTBR2u0CtEk/B9zakMyhoAvqOrJbbhYa+SBBts4U2SGk39ga24UvUis8oNHZxr2KYHTy7aoEgCkOZPaanzAr7G5wnAuI0HqCNaQ5aeLOI1M0XXET9Eq/ZNMelcbG3hJu8hHpzwVuMLuaQJtznjQtx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8otyGNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8otyGNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4758DC4CEE2;
	Wed, 23 Apr 2025 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421086;
	bh=XA3avwAMHv6u/gfRCESZLEguhQ26c60iiY1K4fwewxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8otyGNMyhTT7IHKGRmi9llkXbSkcysdZy+1ggoeK7JeLPDHPKw2gUVerN+6oeSIH
	 HI9MQaY87Y1r6pdSlDJJFJrUzM5lQrKTSFkeoXhHFJ5kha5IwXJznG6bR8C7BJx8EE
	 wx4q+dVlZlQiac4CzKMAs97O38RwUuPKbOssP6bw=
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
Subject: [PATCH 6.12 190/223] arm64/sysreg: Add register fields for HFGRTR2_EL2
Date: Wed, 23 Apr 2025 16:44:22 +0200
Message-ID: <20250423142624.915005587@linuxfoundation.org>
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
@@ -2522,6 +2522,25 @@ Field	1	nPMIAR_EL1
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


