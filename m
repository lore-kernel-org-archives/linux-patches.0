Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F7375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302536; cv=none; b=piVaR88Rr3kZhx7Kc3JVaW6rytgMdYKmySgsS5aJEI/smFpBOihUxG4aVfi6TLdwIXLlwy0I8Q4Rs6ivhIRE/4cc7G1JXqtpOgu1fO91FZK2F/M5YMAGsd82HtVJEP0dwGxFCdWzkhjW4BDFkUZAsYYQSeeQdK0eextYqLj6n5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302536; c=relaxed/simple;
	bh=uYWFugpqvDPzTBH6IbGWpXAbvE1X9sNF1+TAFNzdqXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY+WO1wShNRHbcgNuNA/ENVDh9vfuRbszuu2YgqnnHUGmmzxY2AiKyFdqdQKAtxtni4PkltIhJzS7DFsfGUToTkbQjfFsPl9A/xxWQu6yUBRx5RO0q+hBBJ43c+z/SHGb8iD2VXxC9zbYK+cQtgR0tIVT/aQk2AUo59UuGJOPMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osck7aj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osck7aj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49610C19423;
	Sat, 28 Feb 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302536;
	bh=uYWFugpqvDPzTBH6IbGWpXAbvE1X9sNF1+TAFNzdqXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osck7aj5d/r2wxi0mvsa/4TghURVzkiNupTbrJdsUMjDz/OcXLox2pBYPc4OVt8Uo
	 I1QwkrBMnZ1XMZayEOP9jI5ct+HIfxiP3FatX+aDf/mK70g5Rbg4ajsIinFqM6n9eJ
	 IMI/H3QL5sSUQ6bLtRLusflViuWfhMu4uL+BKB13k5wi6l7cONn7UDMmNnDhWIs3Yz
	 u8mYU2itFoz4XE1a+iRWmUu6AoNooqcOQU/pmjR3AlUBVSbuW1PMg7mypBVLsCwAq3
	 399os28F5XYzfMO4UnqfOws1z68E8PpjyWiX9sjj+DuScxZOAPoGH7//dhpkdlqAog
	 mRLOG+xLbVIKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/164] arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
Date: Sat, 28 Feb 2026 13:12:55 -0500
Message-ID: <20260228181505.1600663-36-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit c9b98b9dad9749bf2eb7336a6fca31a6af1039d7 ]

The touchscreen isn't enabled by bootloader and doesn't need to be
enabled at boot, only when the driver probes, thus remove the
regulator-boot-on property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-1-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index d4355522374a1..66b86dd292c8a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -136,7 +136,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 };
 
-- 
2.51.0

