Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2163630BC;
	Wed, 20 May 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295693; cv=none; b=JO3uKgGeToUAnEC4vQxZDCXoxCHGgo6853GwNdNXvVsiG5Hwc++R1oZ5NXz2aP4RCP6CYNFsRbCyewognVisPVK6s+MXfhcLXt1L5rhQdCuysSq6pnHPur6kTQ5Icfe2JU3nqU3uOt93JvJqg41Zm2FHnnVRdlaqFUTIGH7L6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295693; c=relaxed/simple;
	bh=PnBPYf25ZRpBqhAvXbGmrGIOEYG16x1AYChyMtyuSuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4cnyrTZ6BA0IuUxkck4FuFEzog3g7YmOfZT84npUvC1QD3ZZHQQ3cbbtGMbic8vrFfoj9gBeKvsMuob89afHMQceUQUpfWsfmodpqwPZpEO9WEsNJhx6rCZDzTqfGGhYAU5R8Eh4m2X4nPsbon0KboQU1f9guSkCyU6FYyY7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDMIPO7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDMIPO7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090041F000E9;
	Wed, 20 May 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295692;
	bh=7L0sq/GYbiPs3ET746hU2mhcPbpunxXcQ78oQGkVvvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDMIPO7q/mEOXAGhKCWvDO48lKVhH5wfkhkHDy7O0khjWXUAqsHUmSPOJH3J4V/36
	 eK1I7yjezbliRlwcgwexkDWdDYIRPPYGJoshHFSBQCxYgfpIGlDW6zL+mMviS7V5H6
	 evT++DEzfo1NyogcquA6zAjd4Sou7nAi4gADc454=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0514/1146] arm64: dts: qcom: sm8550: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:12:44 +0200
Message-ID: <20260520162159.817123061@linuxfoundation.org>
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

[ Upstream commit ff8edb5bc8bdf8bdf4573d8dc062b09cc1e6bc76 ]

The corners of the MVS0 / MVS0C clocks on the MMCX rail don't always
match the PLL corners on the MXC rail. Correct the performance corners
for the MXC rail following the PLL documentation.

Fixes: 41661853ae8e ("arm64: dts: qcom: sm8550: add iris DT node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260313-iris-fix-corners-v1-4-32a393c25dda@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index e3f93f4f412de..6a338c522ee92 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3320,19 +3320,19 @@ opp-338000000 {
 
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
 
 				opp-533333334 {
 					opp-hz = /bits/ 64 <533333334>;
-					required-opps = <&rpmhpd_opp_turbo>,
+					required-opps = <&rpmhpd_opp_nom>,
 							<&rpmhpd_opp_turbo>;
 				};
 			};
-- 
2.53.0



