Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49796216605;
	Tue, 29 Apr 2025 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948730; cv=none; b=H2OqPoWj63qmbKx69FHzkOoU10UoJMjQqTR8uUkHb1zjhhka9ReDz5i2lQa2OpDk7fnCgtMjJrQBE4d0PKMNv20sIRpxeeKi0+In3vEAWqf5YVDcbL9tVtIW3o4bMulj7j93t1AgiCJgAUVvCrvCC5XyOLYbqvnMcZyCKy1K3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948730; c=relaxed/simple;
	bh=Y3p+Bj9OlT3he1/OfOoWacNX73xixMsPA0beIRFCzQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXAb+IAwBngr2VTCjFXtXDvrKJ1vW34UxgM/lkvtOVYcNFgcbAZR8ciWizcAlou8WKTNqFvUP5IjZEk4H0aHXYf9KI/DuoeAYH3UPLAUQQSD1aG7hGAscpyLCf2L4zjpcVH4w1EMtNyXYyqW36UamhqPRiXTrBkzyiCz7IM59D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDFnn/nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDFnn/nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77829C4CEE3;
	Tue, 29 Apr 2025 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948730;
	bh=Y3p+Bj9OlT3he1/OfOoWacNX73xixMsPA0beIRFCzQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDFnn/nR9jEu1Phdmne7PR4m+jIQxCfELHJ3iZDLOcyocuUkUDaOAOMUwhBIeiRAx
	 rM7a+g0c+6LfaCHtXDpYmcB4ooSDm7T+GXlU1n27R/T3KaMYGbmAlqapGBVUHPbd+T
	 bTkiiZuggigTwLmGj6sI5KWy7TxOTYmlhdR2mYr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 064/373] arm64: cputype: Add MIDR_CORTEX_A76AE
Date: Tue, 29 Apr 2025 18:39:01 +0200
Message-ID: <20250429161125.768470281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit a9b5bd81b294d30a747edd125e9f6aef2def7c79 upstream.

>From the TRM, MIDR_CORTEX_A76AE has a partnum of 0xDOE and an
implementor of 0x41 (ARM). Add the values.

Cc: stable@vger.kernel.org # dependency of the next fix in the series
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250107120555.v4.4.I151f3b7ee323bcc3082179b8c60c3cd03308aa94@changeid
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -75,6 +75,7 @@
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_CORTEX_A76AE	0xD0E
 #define ARM_CPU_PART_NEOVERSE_V1	0xD40
 #define ARM_CPU_PART_CORTEX_A78		0xD41
 #define ARM_CPU_PART_CORTEX_A78AE	0xD42
@@ -140,6 +141,7 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_CORTEX_A76AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76AE)
 #define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
 #define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
 #define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)


