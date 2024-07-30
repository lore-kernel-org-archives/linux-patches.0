Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DBA187FF2;
	Tue, 30 Jul 2024 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355397; cv=none; b=agRm0YMMENaFLF/MMAJsU9Hmbb3MIX/JrE5Syflxi8pasm6QJ639kVuitHnddDpy8lLDNYFxnnSQs0EJNbF0pl65234XXBBY4RY8QXaMPSkngRE63oOunvv/nEhpYHAknoJHK6e7GEyMaumkiNEawAtgBpGtCpbNizqAyyGoidI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355397; c=relaxed/simple;
	bh=j3r9W+GJQT3i6p1SFSO8BXvj4iGJhEECjMlaVf6T7dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDL7KUA/ptDnxBPPigQa8ECfr4U1p32quH9xW0Z8v2l7wYnxHANn5+OapST/PyVJ7+jQcKiqlpPB0sqrhxNVNb0kzCnbOUqIt6h87CAJ3sDo3WeM6OaH3lpebOusL9xfYMqikIqs8cR46Q/fE/V7UOKosMelB6C1d8bGYzB5D/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvhL2mCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvhL2mCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04572C32782;
	Tue, 30 Jul 2024 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355397;
	bh=j3r9W+GJQT3i6p1SFSO8BXvj4iGJhEECjMlaVf6T7dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvhL2mCid4xEkFmecFD1H1rGedwBoYEChEX3gi/+KB0WzJVpTsWg4EDujGvxQRoYP
	 bkjnADmfpaKakLTEcsJAjysXnfkg0G/Yw6Xu9zD7qbc2wL+oq8dhBVFFaltv8fCm1E
	 sU9C9DI4jhfb5QHQwVMmKeVfH0aaIMbhsdsJlaYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/809] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:43 +0200
Message-ID: <20240730151726.510080268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit fd39ae8b9bc10419b1e4b849cdbc6755a967ade1 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: cc16687fbd74 ("arm64: dts: qcom: sdm845: add UFS controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-6-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index d817a7751086e..4ad82b0eb1139 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2666,6 +2666,8 @@ ufs_mem_phy: phy@1d87000 {
 				      "ref_aux",
 				      "qref";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



