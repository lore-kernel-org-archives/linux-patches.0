Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E020C188012;
	Tue, 30 Jul 2024 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355419; cv=none; b=HB304wFsN2yh+ZA0oGjcxGyQZkHeWS8KG33vV42DzZLyxcsCkriNbRTUxyH1mfQdFrkq3t1LnhfW3HLPIivpWv2PBBpAJ60NMO9W0DxaFGS4Ra3YFUMmWxGi5WWS6wKYgZtVnmkKz5hIA57c9ubXn3M4KdhN2se+Db21UsxiiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355419; c=relaxed/simple;
	bh=ylx6X/pmRENpfhsqOnRKD2JUbLCJMpBkFv33Vuznl44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ur+E5a2VDpNSLbAhB+2CAyCeMAwo8B2tr5tabQh5/cPnSMkxEI7lxJdDfN/o1HkieDKbbfwze2PZLJW3iI6LJ02tHOMW2vQlacROJoRqXJVkFKG7opFYPEcnYwnnjUKDeJt7I3vRepa0+cXoOxjR7R5BNbJGK9PZK1FXWSzcClc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj0bC0Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj0bC0Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F28C4AF0F;
	Tue, 30 Jul 2024 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355418;
	bh=ylx6X/pmRENpfhsqOnRKD2JUbLCJMpBkFv33Vuznl44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj0bC0Q9gie8ayGNIWIXXdc8qQiTmzFnJ0CjQqKwnEzG4vKB1s7/ZQB3/5D0Lr6ey
	 YBa2ZQFyW69fVHu9Lc7Vp2faFr+PRI5x+mRH/F8kjnzNYhg7UPA6yger8TlELa66oB
	 fQJy398mcqiVP0Nft4U96zjtPNZdDHS7HBXBazu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 049/809] arm64: dts: qcom: sm6350: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:38:45 +0200
Message-ID: <20240730151726.586938571@linuxfoundation.org>
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

[ Upstream commit 18c2727282c5264ff5502daac26c43000e8eb202 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 5a814af5fc22 ("arm64: dts: qcom: sm6350: Add UFS nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-8-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 6c7eac0110ba1..5f862cf8858a7 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1197,6 +1197,8 @@ ufs_mem_phy: phy@1d87000 {
 				      "ref_aux",
 				      "qref";
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



