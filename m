Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B0229A2;
	Tue, 30 Jul 2024 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354905; cv=none; b=IZT1KSpMhS9kbBUtP+akoIQ8alNtM/aHNyCHeYIjai0ATzun6AUKv15EFiJfvio1l08L8y+dJHmfc5Lp5PtrJVX1Dv1bnIjEP7BZ+HF6V5LmNAS8IZxz5JC65pqUX9g8Gy3V3Bfc3NKQ4J/652U/bQ39Y5Hi/+XCkAbvZEH+aXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354905; c=relaxed/simple;
	bh=BwZvOCMpKa4U6qUsx9TIfdRndcC8NGb6u2oq28LJOtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7MDJW7LOqD5MjdjxenIgugnD4sL57b8S+QQMHJdTDCppnWajI+tUhb/eeww+M9h0MtCON9LbZZdKlE5e1disw78EQEx56vAQwtELmSsq5p10saseX5VjKFjl37JwZxw6KHsq2cnGj5+VkqZv41zLU4n8zOo1Y3W+WCI5hhDqrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiXqp5qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiXqp5qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1D2C32782;
	Tue, 30 Jul 2024 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354905;
	bh=BwZvOCMpKa4U6qUsx9TIfdRndcC8NGb6u2oq28LJOtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiXqp5qIRLHnkm7zxWySz1KoVaNh7y6m/HsxT/jwg+lXcUgwMgfmOTXJzcv6VJPbc
	 9DkTYh3tGxX3ocEalw8DCJ/Peq+Zdfp1/rLKKaf50Tyv8yfztMv0PK3Go8MWxMTCO3
	 qwJ/YeAPnW5kH5w2hNB9vKlPDQ65xYLX25flAZOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/440] arm64: dts: qcom: sm8250: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:44:27 +0200
Message-ID: <20240730151617.096000190@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 194fb00051d66..6a2852584405e 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2179,6 +2179,8 @@ ufs_mem_phy: phy@1d87000 {
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			#phy-cells = <0>;
 
 			status = "disabled";
-- 
2.43.0



