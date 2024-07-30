Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BA1A6177;
	Tue, 30 Jul 2024 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355917; cv=none; b=a5NU55LPKYwuGG3dCHF9ll74ZMcLOEQBYCtQ74qWKTnkMoEr4YMWiuDgU8YKeSlS6ebq9JGsXL0lhmotm0cC3eLgEOtN3X0oi+koTXgW48jNEzgiWytBOuF2w0zHeN8Zt5gL2uQHlIxxaJXX8hzNPTL0O6nDu67w5gBXx2fhicE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355917; c=relaxed/simple;
	bh=jB6GSrEy34frvArCruNSODg0w4Tq/Ik8Kc8cuEnKyO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1/XPxsd87QIpJNcAKlRJz9oWAm/Mtm4mvKp0tt/CE3XhbvWKCVX4zyHOeJ8ZRCT56uuADl6Xu/EKRYkfPIfNIY6Q6+FKxMNBwOtIX1JW3hN36FMWY+lKthCYAUlBd6Ms62Uwcj3ermAjqAUuOaSRuwfZ0tc6UibkkDeMubfiDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEGadbWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEGadbWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628EEC4AF0C;
	Tue, 30 Jul 2024 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355916;
	bh=jB6GSrEy34frvArCruNSODg0w4Tq/Ik8Kc8cuEnKyO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEGadbWgYC0JaWqxkKjMiLRaVoh4M5ee10KUNly3lSAU+9BkZJPd1C9DV4iOSIUJf
	 zjhVI7r3OzYi3pspiIw0uZrVjMMCnxSqut1pH5Qi6aWXz92itYELsRpW3afoQeTES5
	 zQH/publJkMk1qifcy5v6MSSQLzePxPeeh0fThLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/568] arm64: dts: qcom: sm6350: Add missing qcom,non-secure-domain property
Date: Tue, 30 Jul 2024 17:43:29 +0200
Message-ID: <20240730151643.861246408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 81008068ee4f2c4c26e97a0404405bb4b450241b ]

By default the DSP domains are secure, add the missing
qcom,non-secure-domain property to mark them as non-secure.

Fixes: efc33c969f23 ("arm64: dts: qcom: sm6350: Add ADSP nodes")
Fixes: 8eb5287e8a42 ("arm64: dts: qcom: sm6350: Add CDSP nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20240705-sm6350-fastrpc-fix-v2-1-89a43166c9bb@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 7477bfbd20796..2efceb49a3218 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1299,6 +1299,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -1559,6 +1560,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "cdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-- 
2.43.0



