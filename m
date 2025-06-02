Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2F1226D14;
	Mon,  2 Jun 2025 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876644; cv=none; b=doQaxxHI+wZALcrKyifdeM44wq3rr7ujLGlqCogSmNTPS5rsdEkRk+4tDjuO4xTxlNu8mB80HHG+Qvpt3ZIX9hodxrtqZHoVzFjR26uoaS8MirYDoNgGAhHQAXHXBDki93jwdBr646T0/yfGqsVT8kMrCMROzAgFKE/n8t6HEvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876644; c=relaxed/simple;
	bh=/mWTHe1nGbgGWoo+30lS2qeRu1poe5N0+GEBTr0YA+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baGVGTjFfGko6TEfpJYZsJwZqvPg2vAPxyDMqgjwG9ylLGwTgnU6xH/sNQXjy3YIlXGK5Kiu2IfdckFI5JlZMBweQJ0+0l4OeoACDMqJJ61AEbUL7fSgs1o6fGW8NjvGE/X+Y9qwpBzim1tza0Wa5t6758xGaTzrqlA2yDPP0sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIj1WeKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIj1WeKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF30C4CEEB;
	Mon,  2 Jun 2025 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876644;
	bh=/mWTHe1nGbgGWoo+30lS2qeRu1poe5N0+GEBTr0YA+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIj1WeKHf2x9tw7zz+Gm1SBOKJ436G5nCvHX1kS5000a/GZDBGPmnoM80zuDOOGY1
	 hY9PmN8c1qoVYQAi+f/VLFZnokd/2YcdKElJMvwilDzp6smYctOpnLQkGgc8Ik+fLB
	 wJIp18Wkx2in9JP0DgelPw9y5kkTSS1jp1PJSsMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/325] arm64: Add support for HIP09 Spectre-BHB mitigation
Date: Mon,  2 Jun 2025 15:45:04 +0200
Message-ID: <20250602134320.887774745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit e18c09b204e81702ea63b9f1a81ab003b72e3174 ]

The HIP09 processor is vulnerable to the Spectre-BHB (Branch History
Buffer) attack, which can be exploited to leak information through
branch prediction side channels. This commit adds the MIDR of HIP09
to the list for software mitigation.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Link: https://lore.kernel.org/r/20250325141900.2057314-1-yangjinqian1@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 arch/arm64/kernel/proton-pack.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index fe022fe2d4f6b..41612b03af638 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -132,6 +132,7 @@
 #define FUJITSU_CPU_PART_A64FX		0x001
 
 #define HISI_CPU_PART_TSV110		0xD01
+#define HISI_CPU_PART_HIP09			0xD02
 
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
@@ -201,6 +202,7 @@
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
+#define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
 #define MIDR_APPLE_M1_ICESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_PRO)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index fcc641f30c93d..4978c466e325d 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -916,6 +916,7 @@ static u8 spectre_bhb_loop_affected(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
+		MIDR_ALL_VERSIONS(MIDR_HISI_HIP09),
 		{},
 	};
 	static const struct midr_range spectre_bhb_k11_list[] = {
-- 
2.39.5



