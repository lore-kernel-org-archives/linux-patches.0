Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8703A30F80C;
	Tue, 21 Jul 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655791; cv=none; b=AxGqjvIoWFOHHElQLPzGeWxQY5sN2Kxa8f0OkvSeQpP0os66oyXfQiYxO1eS9jtBfuvCCVKXfkcLXhYdUIhsW8fyWFn7vnhwR2KMBPA5qu7Ui5k1wuDe0DcoWknnV/rEMalx0q8pYJNyZXtOrnqVaiAErHOrVrxXY4xzoPtrG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655791; c=relaxed/simple;
	bh=qEFUKO/jMBGLdu9cHrNsvIHPDUYuoo5m+9LqXTPjuts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEFzFDl2hDAK3J2XdI+DKuvGwx9PQ3Z+yA4bfFXdJew4VKgm/Hg001LKKVn06IdMR+aAhcjUBNsXFPRb4PAMyRv54FhPC0iQBJ657fFfcYxXA/KIjBiIlgFirV6h4lhhMGLnbLtl6wCP7lIXrf55VzxJj9EXypHOGJW0lqXIUBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyrSDsgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyrSDsgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5641F000E9;
	Tue, 21 Jul 2026 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655786;
	bh=z3uiRMfk0ZnLXSfpY/0IUD7tn0fElkValfymrwgAOKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyrSDsgXX432LSwo2mAeWXw9Rzi/WkB19o+iQCpTWaFJka2kVKVvnyfNThIKnCASY
	 4Cft3Isp/KRb/ASC4Axs4DdTspc9AMOOUPogNHRof0TWyPR+7mu/65RwzaP7HR4RXW
	 4cSu22+7T44wsYnD0AlH1rmddGZPAYJNkn6v2884=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0139/1611] arm64: dts: qcom: sm8450: Fix ICE reg size
Date: Tue, 21 Jul 2026 17:04:15 +0200
Message-ID: <20260721152518.000449795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit 7fb3d0512dacc0d09217eb45057357f00298203d ]

The ICE register region size was originally described incorrectly when
the ICE hardware was first introduced. The same value was later carried
over unchanged when the ICE node was split out from the UFS node into
its own DT entry.

Correct the register size to match the hardware specification.

Fixes: 276ee34a40c1 ("arm64: dts: qcom: sm8450: add Inline Crypto Engine registers and clock")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260402-ice_dt_reg_fix-v1-2-74e4c2129238@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 6c00390010f1f7..3a352e5f3f191b 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5348,7 +5348,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



