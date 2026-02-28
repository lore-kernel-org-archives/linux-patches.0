Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349B036C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302336; cv=none; b=tpA/57nmg9IGI9V9rLw11pJCYeWOrPTjHi6atiBMYwUPhV1FhaTLOwKGUtAkDZ3ZYnaZifjUCjGAAW6FrGPwoO8/La5uIRbvPC2ymamY7tqn8dHW2Lvjxs3NIXMNLYogY7E2gGxCa/wIsogLv/gE6cJ1Zr9NQqQe/249mj9YzwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302336; c=relaxed/simple;
	bh=W7boLV3z3bd61tJ9rRaAD0Uq8lpuBgEKP8AB/jIJ3WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvDiRfzfXIxzfV4snmwo7n0UbRijydSuSyqzo3vSAODrLzpFYBze6UXRZcgTkyvWIAr8dJaPit/9vN4WLBk8dzcFM8nz3jXX54ydbxhFRRnIxWzHXfvcoSFYxJ+iykzdTilrBkdBhO130HgQBYQw/E6K1evzbZaPbGguxmHZIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVILXDnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVILXDnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B86BC116D0;
	Sat, 28 Feb 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302336;
	bh=W7boLV3z3bd61tJ9rRaAD0Uq8lpuBgEKP8AB/jIJ3WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVILXDnIeMhBj2iaWaZDfhqCIeg/o3HehXxCNRZPd9GE3ofJ/EMMOHZ0KRom0Lw6R
	 y1EDU/YohfL/ZC5zHzsfvWrhlHe2JECjYj+N5BVEGwUualV6Bazb1sVenM9NSgTD6Y
	 T92LMQ9WltKfOP4S2d/8iA0Np48HCeoBUv+B3CrFNbo0fbb8Zliue+tRrMvszT25YC
	 SgRbrVaL980EnnoQST9Kypf6ZbhX6/gkSAX9gc6x2N79o98fJkic3dqAfOtT8aczAO
	 pYfevouTVsI1teqVChQHvNtP4Gvu10mg8Ok3C5lNXXXCre+vG3v6NFz/9BSnBIbjcY
	 evKBsVmxWAnmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/232] arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on
Date: Sat, 28 Feb 2026 13:08:30 -0500
Message-ID: <20260228181127.1592657-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

[ Upstream commit 45d1f42d3e84b5880cf9fab1eb24a7818320eeb7 ]

The panel regulator doesn't need to be always on, so remove this
property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-2-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 281e1178a2f46..ac3db3d5d2bad 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -230,7 +230,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

