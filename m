Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485F158D96;
	Wed,  5 Feb 2025 14:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765397; cv=none; b=ZfK1GXsEJbnWkVZ9ulxiE9NxO1doD8MPc2Etk2AGq28Rf7/VpzDsIVq0jZUkryA2ziOdQMfp/obewrZO8pC63axl9rXO8rwWq53KBliQZGIzAwOwOpa0z4HDTBDDpOCnWORGTk+Yyzzaqcogl21ZL0ccjysLEa1Ey0puoTh3cic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765397; c=relaxed/simple;
	bh=efVpWKp6z1OWij3SpbgYl6+qTiJ88f7TVuJIykx7fwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDNq12Nvp4Snh++MNQMr9BBykySR8BkVpaNVbfGiCLaoqmPei9v/DWRmyaOUQTq6WSrcO9+4ABeHyr4zisuc/qeVOvo0wCntob75d8Nxh/rZ84ufaUxN4pZ2001F2eFSrZK9BZjYxGJVn9TTws4pepKscCwabBnsQ9t7Y5u18nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgELc3+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgELc3+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B14C4CED1;
	Wed,  5 Feb 2025 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765397;
	bh=efVpWKp6z1OWij3SpbgYl6+qTiJ88f7TVuJIykx7fwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgELc3+Oz1qVYMNJb0H/NZmcd9JhvXEZU7nseBUVQHILmNuokoe/F9IfQ+NvssmOX
	 gqD0Z+gUM0jzZwrAgHy8dcaorDFqmfnvJl2MkgCCYQU/sxoKPhPd+mG7Af+8osxQPw
	 1KNutmRVWRPvNes953mO0Ep20e+OHMhCRHqjXUUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/393] arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 properties
Date: Wed,  5 Feb 2025 14:43:03 +0100
Message-ID: <20250205134430.412443278@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



