Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C217DA9E;
	Thu, 15 Aug 2024 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729194; cv=none; b=T+Wh75+9Cpa8vCjaFa/faPSoRQgbWpHSDX/Y6FGSwhx9QjwVVLkQJYmnxG1UrN3B6KCDISu9VI/zKZzBJpwbgFEkk0nQjoYuOIi3MiTO3HAO0bGldUslbVDtjw14VPiAnp1b9rVcrtFuUdZMU7LJRFxr1X3/9LiS3W3LrDT8N0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729194; c=relaxed/simple;
	bh=/dx+Zp0TxFJBDD74jvxpRPAOXs1Eatjm7K+lBp2hcq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENtiCBp2npFUQo2FQjXWTcr947zo07jgkGJV2nGHN0obHaMKTnU6OdPzNknOsxvwOMymWzdBDHXnYz2BvavKzDx9Tfi3NNHwhI4UyQQwHKPJNmqlITQ9sUfcaReC0bz9REJUHFp7REs/WXQaM+q27zoAfVxrcyZM7Ew9qSGJNR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnbN5Rqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnbN5Rqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD63DC32786;
	Thu, 15 Aug 2024 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729194;
	bh=/dx+Zp0TxFJBDD74jvxpRPAOXs1Eatjm7K+lBp2hcq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnbN5RqykJFnb9cI9dDAynFDk7ivZr++/SB/heRkOOLqpECe8qNg5bOPbFfTDOC36
	 VjWP1JXChUAvaZD4uweATdsmq9p5/C3/LEMvpAOAWqDfjOcnd66NGeMUPka86Pbhuw
	 Ii8ZpPJ69lmCUjB334odSBkX3eAk/o0rF2TTxxas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/484] arm64: dts: qcom: sm8250: add power-domain to UFS PHY
Date: Thu, 15 Aug 2024 15:17:58 +0200
Message-ID: <20240815131942.053336768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 154ed5ea328d8a97a4ef5d1447e6f06d11fe2bbe ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: b7e2fba06622 ("arm64: dts: qcom: sm8250: Add UFS controller and PHY")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-9-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 71705b760c8b1..5f504569731a9 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1756,6 +1756,8 @@ ufs_mem_phy: phy@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



