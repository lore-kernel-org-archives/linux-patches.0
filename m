Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C053E198E78;
	Thu, 15 Aug 2024 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728919; cv=none; b=pv7FE2AU+dAWGYQ9XN3Z7l5Of/TZRNFwV/+EOz1BwPsiWfGAeJAoq3Yf3PHX8uG9i7YEdGUGw1LH/C4PhGA55BkdbN3S6MXpjIpwS+qdwRwtDqP3aUZlE7vW4Y9tKCAAeUFTFneVnNrcf9PSJZYIX6MULKsO/4Ph2rsAYVreZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728919; c=relaxed/simple;
	bh=eP6ISUTX05zja1aX0+2/vYtCb/PaE3klIJ0gKaDIY6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTVhlnzlZtIlvKAbAXSRUyveCNGIVoAHS72nuc6sDajYLzMSOilN0E4aldEilHO5VQf7ZvwpSvQtChDyH/lEn5s10YVuuQHjbmVCGeM1AwQHfo5AqSTh7acJQAgeLYyl7mLetzn8NEuZ0sMDyfaxO2zkmbEjIcXcsfH1utqBzDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plpUKj1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plpUKj1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4554EC32786;
	Thu, 15 Aug 2024 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728919;
	bh=eP6ISUTX05zja1aX0+2/vYtCb/PaE3klIJ0gKaDIY6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plpUKj1smQjZqQfFwphkSaDf6sb3ysCGeMf81CA5kMykTHUVvGHFbXM3Vp1sSUOc3
	 3M4/vcA+8Pd+LYVitXPaMYRsNPBbSQYtcc7vc4WyFOlLi9Z4AHQkFAzcTA/OvumL8t
	 5InW5ZQKtqdlNYCJ5FL6znEy2XvXckUWZM94EmHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/196] arm64: cputype: Add Cortex-X3 definitions
Date: Thu, 15 Aug 2024 15:24:30 +0200
Message-ID: <20240815131857.928601113@linuxfoundation.org>
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

[ Upstream commit be5a6f238700f38b534456608588723fba96c5ab ]

Add cputype definitions for Cortex-X3. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-263 ("MIDR_EL1 bit descriptions")
in issue 07 of the Cortex-X3 TRM, which can be found at:

  https://developer.arm.com/documentation/101593/0102/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 9b44a59195889..a89d6baecbede 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -89,6 +89,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
@@ -128,6 +129,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
-- 
2.43.0



