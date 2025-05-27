Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301EC27BF7C;
	Tue, 27 May 2025 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364441; cv=none; b=svKOv/GUTv7VR3ACyBpYYyQxOCU/cpyE2ZigXuKBByOjJJUMx8I/vxPq5lKPwIALd2nqKJhZ7RyRlGtV2vXsVAaCNBz3Cij1WOqlNs2ipa+K9fWylOTvhANkVha/ceUOILZVNPoaUVLHeQiWOGlAlXtKAHAzsoENum+tQdvFXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364441; c=relaxed/simple;
	bh=vlVRAff+cSED+kRJ8pBPIqD7WENdpEeaqmZOz/4kw/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaLekun8pb1rRBzuWzH+lEklmIQ7ucnm6S8kbnFpiBSOL+h96FhR0fxJyeEsgcsfplR25OwMLzXQEljMmnd9B8zw7KvBpP3nyqkNPxTZA0qLKOMtILDz26kLZ7T4b1ZrsA31pcc9TB1+upxQ+D+dIe8J0dUCZvKCU+D6yJTgPxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbunsV22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbunsV22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBFEC4CEE9;
	Tue, 27 May 2025 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364441;
	bh=vlVRAff+cSED+kRJ8pBPIqD7WENdpEeaqmZOz/4kw/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbunsV22wblU3T4O2/yefOVqtaS7kc3Wz9nDwS3GGvrsF8ZeFO9kStoH8Ae2MlPNX
	 iB8ysKkreI1rMlM8Kg/2nfm05oseg/thW7ROqKk3QjKOMP8TeNnQvgPEwRjYD7PFkJ
	 o15zGqqsdzKCJzn4VYI0wpjjAGHb9Aoi9iW3g+h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/626] arm64: Add support for HIP09 Spectre-BHB mitigation
Date: Tue, 27 May 2025 18:19:10 +0200
Message-ID: <20250527162447.375676539@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 8a6b7feca3e42..d92a0203e5a93 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -132,6 +132,7 @@
 #define FUJITSU_CPU_PART_A64FX		0x001
 
 #define HISI_CPU_PART_TSV110		0xD01
+#define HISI_CPU_PART_HIP09			0xD02
 
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
@@ -208,6 +209,7 @@
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
+#define MIDR_HISI_HIP09 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_HIP09)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
 #define MIDR_APPLE_M1_ICESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_PRO)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 8ef3335ecff72..31eaf15d2079a 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -904,6 +904,7 @@ static u8 spectre_bhb_loop_affected(void)
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_GOLD),
+		MIDR_ALL_VERSIONS(MIDR_HISI_HIP09),
 		{},
 	};
 	static const struct midr_range spectre_bhb_k11_list[] = {
-- 
2.39.5



