Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BC718C93C;
	Wed,  5 Feb 2025 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766904; cv=none; b=TO1Y6vjd+YEQ+reI4f354xnaYLclZ6PZGeSxVsCK7jEc8DbFRya3yJ3KVWnZk32XST3m2wS15TYOMHB8pPg3oHjS683TDF5i0SThTIDqpfeTX0Gm+vQCs2r4vMg6Z7W8slrLxSRx0YNvhpV5LGgO41pDnfy+iUbpxd6/pMeninA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766904; c=relaxed/simple;
	bh=cXMC1IJ9POuQh7QFU/Px355ZxqY1WdE0MXA48S17qPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+lz0p1D30ODHUHuk9bwXyL++pMWcyIW29YOohooHwez3/coAGS9oLRKYDcXa7m6WAaz9xkwzIdS4jOxSvNrOdeOkjyVOIAsBj9w4/tF/igCrmkX7CXOMy/9k/e5YMFOPDkNjBfBhmH1/LuW8/veEJuX+PUBqhZPSM96Md0eNyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dd0xxDdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dd0xxDdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58DBC4CED1;
	Wed,  5 Feb 2025 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766904;
	bh=cXMC1IJ9POuQh7QFU/Px355ZxqY1WdE0MXA48S17qPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd0xxDdM9TmPkvIrcOtXu1Br4uTHSx9QiKQoSxAttjexWqqr54aYphi3YhlIaobeG
	 CfgFvXMjBucMPaYuQS6Wh8jM2cWVQhh6Adg/nmPtTd6TlyHldUGPKmnTW3ixqAh8QL
	 HQT4cfI93r9nQL+LDZgFUvBMnR87fs2cu6BS28XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 378/590] arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 properties
Date: Wed,  5 Feb 2025 14:42:13 +0100
Message-ID: <20250205134509.731903516@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 9875adffb87da5c40f4013e55104f5e2fc071c2a ]

The dlg,const-op-mode & dlg,periodic-op-mode were mis-names with twice
the "dlg," prefix, drop one to match the bindings.

This fixes:
sm8150-microsoft-surface-duo.dtb: da7280@4a: 'dlg,const-op-mode' is a required property
	from schema $id: http://devicetree.org/schemas/input/dlg,da7280.yaml#
m8150-microsoft-surface-duo.dtb: da7280@4a: 'dlg,periodic-op-mode' is a required property
	from schema $id: http://devicetree.org/schemas/input/dlg,da7280.yaml#
sm8150-microsoft-surface-duo.dtb: da7280@4a: 'dlg,dlg,const-op-mode', 'dlg,dlg,periodic-op-mode' do not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/input/dlg,da7280.yaml#

With the dlg,da7280.yaml converted from dlg,da7280.txt at [1].

[1] https://lore.kernel.org/all/20241206-topic-misc-da7280-convert-v2-1-1c3539f75604@linaro.org/

Fixes: d1f781db47a8 ("arm64: dts: qcom: add initial device-tree for Microsoft Surface Duo")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-6-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150-microsoft-surface-duo.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150-microsoft-surface-duo.dts b/arch/arm64/boot/dts/qcom/sm8150-microsoft-surface-duo.dts
index b039773c44653..a1323a8b8e6bf 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-microsoft-surface-duo.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-microsoft-surface-duo.dts
@@ -376,8 +376,8 @@
 		pinctrl-0 = <&da7280_intr_default>;
 
 		dlg,actuator-type = "LRA";
-		dlg,dlg,const-op-mode = <1>;
-		dlg,dlg,periodic-op-mode = <1>;
+		dlg,const-op-mode = <1>;
+		dlg,periodic-op-mode = <1>;
 		dlg,nom-microvolt = <2000000>;
 		dlg,abs-max-microvolt = <2000000>;
 		dlg,imax-microamp = <129000>;
-- 
2.39.5



