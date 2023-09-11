Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E7311705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00527C433C8;
	Mon, 11 Sep 2023 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443378;
	bh=n+x1/EaGEnhoY3z1i571AVa4MfL8WR3ABuEAMtXJcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbdEvDkRVeKShfnn5nOPqUCx1idG5HqDuLV5mTc9+7JCqNQbAjrfO+4mWDTfK2ocP
	 rySBRwQni+sxnjokJNql1gHQ8+o4dZmQUpWPIHwAirqbr1BXcz2cs35SwqrxDE1J9I
	 dpRymzWFf19mHVK7Nar9yExReMg5131kCEMh5InI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 356/737] arm64: dts: qcom: sm8550-mtp: Add missing supply for L1B regulator
Date: Mon, 11 Sep 2023 15:43:35 +0200
Message-ID: <20230911134700.464801052@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 2c9e45dfeed126488aa73e7b82b3576c4c6f1036 ]

Even though currently there is no consumer for L1B, add the supply
for it anyway.

Fixes: 71342fb91eae ("arm64: dts: qcom: Add base SM8550 MTP dts")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230801095246.2884770-1-abel.vesa@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
index e2b9bb6b1e279..ea304d1e6f8f6 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
@@ -79,6 +79,7 @@ regulators-0 {
 
 		vdd-bob1-supply = <&vph_pwr>;
 		vdd-bob2-supply = <&vph_pwr>;
+		vdd-l1-l4-l10-supply = <&vreg_s6g_1p8>;
 		vdd-l2-l13-l14-supply = <&vreg_bob1>;
 		vdd-l3-supply = <&vreg_s4g_1p3>;
 		vdd-l5-l16-supply = <&vreg_bob1>;
-- 
2.40.1



