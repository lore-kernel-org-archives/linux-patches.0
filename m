Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C984657F4;
	Tue, 16 Jun 2026 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624685; cv=none; b=VEfyj/AOUKxe6vyxjS0HDVWNmA7xVlCIaZQC4fcodz0jWLLhpcM2jor8EQJs0lcyMQxN2R7mRQOlUX/Hi4ECLR40rpezDgoxUfaAucOvDWnQEZTt7oweFWTwAIXNE8P6hu0GsG23ww/njV/uVvC/F8EJ+xCx1Nasz6wLUpXGnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624685; c=relaxed/simple;
	bh=k3E3FkkIy60wygn2LzVKgk7E93QcnoLkXrTw36Lo4Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwEt6STxyD5h07C8Aws7SivRnuNqoLifo7FfBfc1VXj1ZnoVQnd761gb08QIx7qJ4jxHkCo7SKR19N8EGbIEjbg4mWCTAttFyK6mGwM4fkJWIKPqd9/3FSfQLtHY4BTG1pmcEqQaBmteZYfNWLW4QuNISFe+o5T6SP0n6xGXews=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrvXMEEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrvXMEEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246A71F00A3A;
	Tue, 16 Jun 2026 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624683;
	bh=8PI/7N2tVbU0q3blmZ6XNIj6qdm/RLfHaEHZCf+LyIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrvXMEEQJLnFmG0eKYg6scS6W1N0XNhemEr8jNom/UPm//qIMNIthQwMlZwauS/hc
	 pjDYRVjQpCbqt4AiU99pjWgWMwFqOMoY9kPgBbT8sp0QJirSCNKQbd5DqGfNaT8qq3
	 cpmC8tVvut/PIr3m5Zw8/PzJo8E3eia+JoDhLpTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.0 374/378] arm64: cputype: Add C1-Ultra definitions
Date: Tue, 16 Jun 2026 20:30:05 +0530
Message-ID: <20260616145129.777387752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 60349e64a6c65f9f0aa118af711b3c7e137f07ff upstream.

Add cputype definitions for C1-Ultra. These will be used for errata
detection in subsequent patches.

These values can be found in the C1-Ultra TRM:

  https://developer.arm.com/documentation/108014/0100/

... in section A.5.1 ("MIDR_EL1, Main ID Register").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v7.0.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -97,6 +97,7 @@
 #define ARM_CPU_PART_CORTEX_X925	0xD85
 #define ARM_CPU_PART_CORTEX_A725	0xD87
 #define ARM_CPU_PART_CORTEX_A720AE	0xD89
+#define ARM_CPU_PART_C1_ULTRA		0xD8C
 #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
 
 #define APM_CPU_PART_XGENE		0x000
@@ -188,6 +189,7 @@
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
+#define MIDR_C1_ULTRA MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_ULTRA)
 #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)


