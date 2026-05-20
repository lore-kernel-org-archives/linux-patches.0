Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C5C29D26E;
	Wed, 20 May 2026 17:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298474; cv=none; b=BZc0xUTIQiJ1yBTjYy2fyINvXmgQEws2wilijX9qe0B90SKHXnW1z+Hq0HBGKyRONCDDGHL+E8s77EOLn3PVOePQGbr4SKYk/7YWBneCZlFNUR+zmzHGkDeM2U20DeZT8gPl0qdfgA5pL0DjcE8udbPlkybILpCPcwFpeMQMUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298474; c=relaxed/simple;
	bh=X4x3skrMcaKXkXriZvATjQHIuAuYb1pcQwXEEMz6Yv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrQNawSq5w4wzfTbDkzsvUNuhxYwwRQZqVEwrDHUNR8fpLEGVp5fPolNPhheNAsgcyvVAePeYn6TLf7zxjvWg5XYY6eVKA888kI9UMntUyPY33Jvj1hmdnIZcQyma/cYFA1i471WwadBYhlyjwBVHkEVfFC1GabQd8lf0asF/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKWLHaGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKWLHaGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E4A1F000E9;
	Wed, 20 May 2026 17:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298473;
	bh=Pn4sNs4sgSQmastDVc3tTPiXkL5G+MFR8+LabGxtNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKWLHaGsN2RWOrDk0NEQGiIYmE1BS3pb5JQQkB14sfqmpzdWKcpcohQ1hriFQO1Oi
	 cHGHbY0Xv07UWFxcyuMYxQtzOsUANZ78Ryqe7S2KLrER2VIXFZRapyuMz37Xf2tNvo
	 n/PxgETBFbNLpLZMg1rSQ981TUuihptfK28VhOGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/957] arm64: dts: qcom: monaco: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:14:40 +0200
Message-ID: <20260520162143.136420643@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit bba8d9ba7df8f6592552377049fc84958fd0575a ]

The corners of the MVS0 / MVS0C clocks on the MMCX rail don't always
match the PLL corners on the MXC rail. Correct the performance corners
for the MXC rail following the PLL documentation.

Fixes: bf6ec39c3f36 ("arm64: dts: qcom: qcs8300: add video node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260313-iris-fix-corners-v1-3-32a393c25dda@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
index 7a4c3e872d8ee..8580884a16e98 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
@@ -4743,19 +4743,19 @@ opp-366000000 {
 
 				opp-444000000 {
 					opp-hz = /bits/ 64 <444000000>;
-					required-opps = <&rpmhpd_opp_nom>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_nom>;
 				};
 
 				opp-533000000 {
 					opp-hz = /bits/ 64 <533000000>;
-					required-opps = <&rpmhpd_opp_turbo>,
+					required-opps = <&rpmhpd_opp_nom>,
 							<&rpmhpd_opp_turbo>;
 				};
 
 				opp-560000000 {
 					opp-hz = /bits/ 64 <560000000>;
-					required-opps = <&rpmhpd_opp_turbo_l1>,
+					required-opps = <&rpmhpd_opp_nom>,
 							<&rpmhpd_opp_turbo_l1>;
 				};
 			};
-- 
2.53.0



