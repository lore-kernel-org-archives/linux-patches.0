Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E716369D6E;
	Wed, 20 May 2026 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295825; cv=none; b=k4VA2FnsAvM23Z66HfEDBp3QbWSrbpK2XB4+xARUy5kBbNdG9IBRpy3jIf3uET/uJNRyUuYntxj1yQKzPNDYZ3zdGjT9ZDUH6q81fHzdPRv9IAIcEhNu37r2TBMzTKxPZW8NBLi7L7XYVnIHrPa2p4PY4TetW7JBwGC1c+xhpS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295825; c=relaxed/simple;
	bh=++0JQTJdeo7EczZagT3/53HtCb/84JWOF43eEnrH8hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ7yMK3wMmgVwCttN+ZuWiP93IDw2MCgz5VYbnSnSWUwj1CnZZQTD57qV7skZ6YsCuU4M9xyoJ54KOBV2kUv6H1HKoCAO53foB+Y3L4PDcG+bxBm/N+KH2yMAsH+CMfm3duhVqS/RPDIdvwA7KuXmxVj5YsQgDp6ahJRYtAeb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG/uhSZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG/uhSZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A611F000E9;
	Wed, 20 May 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295824;
	bh=Y1rKVhzpnV8kl2eKbtwRpj9WoNRIOlWP2GYxRC+5BnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QG/uhSZVuJka38V+eFJcZhDLckdAgRg+CjKdHxM0lympyXeMDXOXP4kI8EJM+EP4P
	 +wSRzw0nQCgPz2w+OsbRSxJwRO+y3Tf+n0VYUob2GxA99ucrzhhH4JU/UQ7zTbVMt/
	 VU3782k1JEPgQsHHquL0W+IhmAUkgf++RcZb4r1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0515/1146] arm64: dts: qcom: sm8650: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:12:45 +0200
Message-ID: <20260520162159.839956353@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7c302a2a6c1a4644e798ecfc4e72ddc4acec653f ]

The corners of the MVS0 / MVS0C clocks on the MMCX rail don't always
match the PLL corners on the MXC rail. Correct the performance corners
for the MXC rail following the PLL documentation.

Fixes: 56cf5ad39a55 ("arm64: dts: qcom: sm8650: add iris DT node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260313-iris-fix-corners-v1-5-32a393c25dda@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 357e43b907405..9437360ea2153 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5236,13 +5236,13 @@ opp-196000000 {
 
 				opp-300000000 {
 					opp-hz = /bits/ 64 <300000000>;
-					required-opps = <&rpmhpd_opp_low_svs>,
+					required-opps = <&rpmhpd_opp_svs>,
 							<&rpmhpd_opp_low_svs>;
 				};
 
 				opp-380000000 {
 					opp-hz = /bits/ 64 <380000000>;
-					required-opps = <&rpmhpd_opp_svs>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_svs>;
 				};
 
@@ -5254,13 +5254,13 @@ opp-435000000 {
 
 				opp-480000000 {
 					opp-hz = /bits/ 64 <480000000>;
-					required-opps = <&rpmhpd_opp_nom>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_nom>;
 				};
 
 				opp-533333334 {
 					opp-hz = /bits/ 64 <533333334>;
-					required-opps = <&rpmhpd_opp_turbo>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_turbo>;
 				};
 			};
-- 
2.53.0



