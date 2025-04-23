Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CFB29346E;
	Wed, 23 Apr 2025 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420827; cv=none; b=exnl+Dtu/bb6VK71ocqphshMFJ+TqqT8qaSFBX0VXls3aXvGqSyj//jmxsM62rSaAIV6rwjUDWyUcbl1TfwzlG/6Vt+TrqZMmNJS0FA+xaDL59XD2bqvyhnmPXUwDw/juiuY1WeKEfqjEqaHovxXqpG8iVmt/L/p5QM8G1tw89Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420827; c=relaxed/simple;
	bh=kL14IbQdX9c/umXa2cO61C2pyPb8wBKHGDabj7ycnLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb8+ly/WigLUdb37VLbqkX14aB8SEPJRfP0HeRNqpL5b9zoomXyN/WsTjrWodtKQhZiRmO194wapBirNXdnXodxYLuVz6VaB751Q7SVEB3GPhHFoz/+iSkjlzqGI52bXbZ023zSh6Av8k1U9C/ohBrNp/c37INd8FYjhx/mBAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gDQ05oQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gDQ05oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2DDC4CEE2;
	Wed, 23 Apr 2025 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420827;
	bh=kL14IbQdX9c/umXa2cO61C2pyPb8wBKHGDabj7ycnLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gDQ05oQjWCg+6kCEJ2uddvOLXubCForf+1oldqTAThPgo8YduFwyjplJvccrZM7P
	 JFCc36xt+EcL0vd4dTM8heBZllcgjwMtT4nbPwiDFE5q+ukeIsdCyWtiiSITtRdz0u
	 BmasXwk/e8NjlTG5hu0TV/uotwBNG8fRaVN3cJZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 084/291] arm64: cputype: Add MIDR_CORTEX_A76AE
Date: Wed, 23 Apr 2025 16:41:13 +0200
Message-ID: <20250423142627.797700835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +153,7 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_CORTEX_A76AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76AE)
 #define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
 #define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
 #define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)


