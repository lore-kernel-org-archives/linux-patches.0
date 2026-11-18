Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024525;
	b=uCG6bF1irj7NMeuuw8IG5A++TqMrO1RfVlKqcc8lOKU7HzlF6E0t23QvTcibFm4Vx3FN
	 CTEs4J39aH7yS3YrULsqhP0r2joVtW1p8GFQtFCDLpNLaB/NPYbalLKVpru0zdcVWC7Gd
	 t0AIIznLCULv/X10/Y9pQ53cJsTcWYNAdLBA7Z9G7Zo97kKy98CLje4fVtDZEpeBSkpBH
	 TPUMVyOolFabZzvZ6Te2TFBGy7cH2bB4Sa7HUhhJK+qvDEq2yEhNzsOQvWf5CnV6B9Iji
	 orHPeZGd37cZ+rT46F8smQWLXZpx7wnXag8Y9XjZDOb1MaG+P1ND4u7ixhIv1OukgzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RFK+Jd4ShBgPi2hv5cTOIeTzpC1+yPfdsXaMohepMYk=;
	b=UpjlwNl8xVlN1MFaNF0Tj2tD63fpH4hO1HAP+yfBs2rwX7THpT1ie9071fHYQQbj6tpA
	 rTvf3FrNQKmYPtV9EsZXNPGYnw3gEo2PlhJgf5J7ulYE1O/sOFEEXf7wzxTw1gXqlMFEw
	 iQOLMA156D138MvfK4PAVdea3VO8Acirl7Vs1472XcDJO/bt9BPokt5uwyuDXT6fusZuG
	 tb3LTsGfxMebHsCyRKDk0NQSy6lKzZsBw9RfdFMlMhx35Cpa9gYAGyKLMJqlhUdwjZQ/c
	 mYbkaoUdLHFdW7QMUWyWg8qvq9fYioMlEdD7SsTAJXF7WBr7nzTxw5eagt7Aa4RK4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfSzt5WI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EECB606A333;
	Wed, 18 Nov 2026 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfSzt5WI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7021F000C8;
	Wed, 18 Nov 2026 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024525;
	bh=RFK+Jd4ShBgPi2hv5cTOIeTzpC1+yPfdsXaMohepMYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfSzt5WIytt0kJA/iJmLAzhSavqssXzmFTI9zOOo44KKonI6hkUxLiHln1EHYOOAD
	 2tcdhGql0t5TKEG8blR0BJQbUAoDcFvSFu7xQhQmO0cBWHbPxW7LUoyK8XUNmo9pmA
	 TjH8iJFCoIZQIXs5JorcRONhLb184uAbQU3n/+EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0756/2151] arm64: dts: qcom: qcs8300-ride: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150149.595764672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit e55080f068f3f6b733235fd7618c12e61744244b ]

The SerDes PHY node was configured with 'phy-supply = <&vreg_l5a>',
which only covered the 1.2V rail. The 0.9V rail (vreg_l4a) was missing
entirely.

Replace phy-supply with the two named properties vdda-0p9-supply
(vreg_l4a) and vdda-1p2-supply (vreg_l5a).

Fixes: 787cb3b4c434 ("arm64: dts: qcom: qcs8300-ride: enable ethernet0")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-6-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300-ride.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300-ride.dts b/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
index cabb3f508704b..b6d8de57a00e6 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
+++ b/arch/arm64/boot/dts/qcom/qcs8300-ride.dts
@@ -337,7 +337,9 @@ &remoteproc_gpdsp {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l5a>;
+
 	status = "okay";
 };
 
-- 
2.53.0



