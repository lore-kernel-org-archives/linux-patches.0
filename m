Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE59F24677A;
	Wed, 25 Feb 2026 01:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983903; cv=none; b=MWi0w4zaB5eblltQOrBD+Ugy06+dP7d0u5Wk3ZgPZR+tSb6D3hjur04Q4KYODZkuxVnyGZidoaHHl4lR9lnigCf6O6OAO7O1pHo7FZH2dmU8tMtvdGbA/kfN6GPuho80A8BivKvfmMw3r2Cj5GEp17e2dmllv0Mud5xoSeZCe2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983903; c=relaxed/simple;
	bh=U1TnIQw1Q5dBUS6xD4Bj3dX84dDlSa6ZD7cDvpg+jKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6qC14foqEvpvLetSZt6BYAOZwGIkEw1GF5j38/8jWwuhQ5BzUUkWxG0QxNkk5GXKDDKENRfL7W0Loeulj82ngT3VQqlHKtQLzHh15hjfXrC8AvTbFRsgnrSZo8xZcNYHwwICGlh1kEdWDuGnPuWitKpopyNTnjRNfnzEHQJwKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdvJCjP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdvJCjP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9919EC116D0;
	Wed, 25 Feb 2026 01:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983903;
	bh=U1TnIQw1Q5dBUS6xD4Bj3dX84dDlSa6ZD7cDvpg+jKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdvJCjP+oWZYHwLf/7oYKVvaZrLN3rZG6KC8jzIH/gBhJEUbqQtSXdvOlTqGvm8Ff
	 bWeC9nv4Uzza7qLD2x6w5FV5jKnEZAygTsVXDEMVW02S0ubFTBGi9GVD/hSXfQF3eF
	 9+Mfl/pvubgFt/j0j74gnWf+gVwspwOuusvpcMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/641] arm64: dts: qcom: sdm845-oneplus: Dont keep panel regulator always on
Date: Tue, 24 Feb 2026 17:17:42 -0800
Message-ID: <20260225012352.431532367@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 35d105ff689b9..7169da658dcd0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -256,7 +256,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0



