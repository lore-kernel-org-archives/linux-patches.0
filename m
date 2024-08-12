Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E531136348;
	Mon, 12 Aug 2024 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479394; cv=none; b=RNlKcFENMOgvL1EWeIerBix3nN3Qw0i7IVqdej611ppgC+/bysSWBByvudqnyoZu5oMxSyLWG76Zlxlf8cIA7VcS030do4QkLI78Vzme+fWHrzY+oOzbz8m/N6eVvr58zvG2xAI59hAb7Rncrwbd69WLpx92asvXYUkvh+kU2O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479394; c=relaxed/simple;
	bh=LKdjHNYV+QGlQfxSZhD+mUFHsWskU5kGgakpPb3bb0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7/EQquPQc4Cm9CbnJQ/FX4touV2xpmAULH+RGoVGAKAJUq+45QvGV23+IBo9kGoWk+NjRvomOBYcAFGHZIdSidjMz1KRIPzslwJ+rAxP6uia6IxgcmLK9QSlnyUBaHfHpTosm0KGBBwhzPxBsanveFk8iJkOoVPsWWpuhNu70c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glm//2LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glm//2LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE2EC4AF0D;
	Mon, 12 Aug 2024 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479394;
	bh=LKdjHNYV+QGlQfxSZhD+mUFHsWskU5kGgakpPb3bb0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glm//2LEfsKp9Ja6rvlEM05aQs2BEbSOKDrZq6mFJ+ns9vYHt1IRrVuowE8yw4ZIt
	 1MkRzJeS4fgE2GFYnINTYuXuPZQeWuI5KgaYxB/VNdpuiodVp1x6xUG4N4OZAOwgBD
	 jlUStHJEDTpFyOcO9xq8RZXY7hSXZZtWrmDb5+5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	James Clark <james.clark@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/189] arm64: Add Neoverse-V2 part
Date: Mon, 12 Aug 2024 18:02:10 +0200
Message-ID: <20240812160134.990593482@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Besar Wicaksono <bwicaksono@nvidia.com>

[ Upstream commit f4d9d9dcc70b96b5e5d7801bd5fbf8491b07b13d ]

Add the part number and MIDR for Neoverse-V2

Signed-off-by: Besar Wicaksono <bwicaksono@nvidia.com>
Reviewed-by: James Clark <james.clark@arm.com>
Link: https://lore.kernel.org/r/20240109192310.16234-2-bwicaksono@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 52f076afeb960..936389e9aecbc 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -159,6 +160,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



