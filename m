Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E33352016;
	Wed, 20 May 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295686; cv=none; b=ljBsHw9tAgyIaG3ZvBe4wOLnqb3uGf37v75FZys6SH3oErSzT+jakVy4Glzslfbnx4VGplIpuMGQH6/HrI6ocdI41iv0B4gWGT+oJgKwr383Gq3OtJ1uIBGiK5BW/kPeE57O3hshIzGGncVv5QVtmKuCsJZ0Q+SzKTQTIuzJ/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295686; c=relaxed/simple;
	bh=WtWs41/Ap83YnsQoVp3wwS+2Dtr6N7NZzwwmvB8zK5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDHP5KrdzdfaycOLJo1SRnKYEjkESBrcUnjHt6DEQSLkKsteHbMqU/o4sAZM47zxUs+9NZfAS8pJ51dENCc/Q15kAEQN04kCe2qBBzRFs6x80Gw2W9/7Q2gG4wOePT7TBC2bBqvtU/elWopErQZXAUv0YAECyHWWB2iN+DxAkeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kytqfxAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kytqfxAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B4D1F000E9;
	Wed, 20 May 2026 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295684;
	bh=mhBoN47nk1Ylg0SEFEhDPXEzFtRnBy09URNxSowGKA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kytqfxABDkDA5ZmfXaJza5DUOOX3m3ZvWRv60XGfGVYNIMz4NWdXR74xu5Ipbc+6c
	 wV1LpSOOj0l/9LC9Hbgd9S4RX8Etu4X2BGGg+fFVXiLTm0M1JaH2cDfe6LuTsYAPVM
	 7nNnTdA1Gehlk/4HmxbavCERUWynxUjeesWEnv7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0511/1146] arm64: dts: qcom: hamoa: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:12:41 +0200
Message-ID: <20260520162159.751888908@linuxfoundation.org>
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

[ Upstream commit baac8b5e43f42b632b912a6a837d94fd5bca48f2 ]

The corners of the MVS0 / MVS0C clocks on the MMCX rail don't always
match the PLL corners on the MXC rail. Correct the performance corners
for the MXC rail following the PLL documentation.

Fixes: 9065340ac04d ("arm64: dts: qcom: x1e80100: Add IRIS video codec")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260313-iris-fix-corners-v1-1-32a393c25dda@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 4b0784af4bd39..f01b363009826 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -5432,19 +5432,19 @@ opp-338000000 {
 
 				opp-366000000 {
 					opp-hz = /bits/ 64 <366000000>;
-					required-opps = <&rpmhpd_opp_svs_l1>,
+					required-opps = <&rpmhpd_opp_svs>,
 							<&rpmhpd_opp_svs_l1>;
 				};
 
 				opp-444000000 {
 					opp-hz = /bits/ 64 <444000000>;
-					required-opps = <&rpmhpd_opp_nom>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_nom>;
 				};
 
 				opp-481000000 {
 					opp-hz = /bits/ 64 <481000000>;
-					required-opps = <&rpmhpd_opp_turbo>,
+					required-opps = <&rpmhpd_opp_svs_l1>,
 							<&rpmhpd_opp_turbo>;
 				};
 			};
-- 
2.53.0



