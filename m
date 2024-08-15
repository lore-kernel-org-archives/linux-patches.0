Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6E1DA4E;
	Thu, 15 Aug 2024 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728934; cv=none; b=GfCpX2OY+ANSJMi778Q/JvVB1NvyGcFON2oLVDiaIERSCh6ActXIgWPVnpqZ+WsLlqVVPC2suOOp13y947TowX/QdqPKKbSYyTxedIzmIzAn4z8FKM/oZpJGqc+O2ZZEaaGnx8Q3D//CqAL0JP74uUz52Y8MP2aaFgEiSqSCLZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728934; c=relaxed/simple;
	bh=00FmnMQ3+wBcUIZZ78+S/Dti1+Jwqo0okl1pDJvmB2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJtXk1xtO1ma0j/uhGlGhQU/SZljwPxHdTy4jr380fyaUW5kaIuE5jfdWgTwuvcFGKTjmtQ86Oa+CDCqB5ahW3gYGIhgsH5FaORn0SRGSgTpoy7DdvCAE6CqchtrItnF0pGh77R/un9pCWGyId4l5MNomqeAzTbXcLjmv6PKOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV12Gp2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV12Gp2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58476C4AF0A;
	Thu, 15 Aug 2024 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728934;
	bh=00FmnMQ3+wBcUIZZ78+S/Dti1+Jwqo0okl1pDJvmB2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV12Gp2moFJ8+6w5iMfPfAyh2RwTrTbYD+D1Hb11KxGO4OEwtuAK+xdZu+MKndt+1
	 CutdTVIoJigELwWC1SzECXMGuJY2EbvaUPrBcaiCmPtx6CQiQ4aMJNdgo3H5yHvKwy
	 JaSCnllSgnKTyAyo2jXKpSbwN1la3jIqcdP1z9AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/196] arm64: cputype: Add Cortex-X1C definitions
Date: Thu, 15 Aug 2024 15:24:35 +0200
Message-ID: <20240815131858.120615908@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 58d245e03c324d083a0ec3b9ab8ebd46ec9848d7 ]

Add cputype definitions for Cortex-X1C. These will be used for errata
detection in subsequent patches.

These values can be found in the Cortex-X1C TRM:

  https://developer.arm.com/documentation/101968/0002/

... in section B2.107 ("MIDR_EL1, Main ID Register, EL1").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20240801101803.1982459-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 304e634c64a05..ad054869acf6b 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -89,6 +89,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_CORTEX_X1C		0xD4C
 #define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_A720	0xD81
@@ -131,6 +132,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_CORTEX_X1C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1C)
 #define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
-- 
2.43.0



