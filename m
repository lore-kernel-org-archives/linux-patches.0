Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545BE1CDFCA;
	Wed, 20 May 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295688; cv=none; b=J0B8RCKpl9fgdErEBBwYNVZcAA+XAHYJj6c/M7xoPsLP+jEt6uQBHtYCRPmWddTuQQEgegyRPItLElKPzkiX4xGDIYN5ZhB6dLCXRxxI7wc77FiYsL8mgWdglGuMXTuE85abOqjqvxwEt+6jup06+nhhltA7Xy0W4yYJbecDORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295688; c=relaxed/simple;
	bh=bujbUkm7JCZ0LxrAktY29CPuNRV2uwHIiZ82zDRNzMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIP6/QAjJiJQoMyjHrImRJxK/5brucURYLHcssvG/ys1DlrnSwwjOOIKjU7CUXqnspK6+waIxfYnLpEU0Sa8orwiK/9iV2zP5wOnU6dZgi6ifNkcsZna0TVGnLwQAzwfGuB7wlVPFX/u7bR04Suf12iB+ETOUMUECzjfVO9i0Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jw+6KZnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jw+6KZnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6D81F000E9;
	Wed, 20 May 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295687;
	bh=FAd6SItDbcsfGiVVYStdGwX1P7Ghv3sHGrXJ/hDfGGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jw+6KZncECFUY2tfwr37kaamg0ro/YbILDspYsnWYFMQpnSLh0eKkpfqhNNrywoVQ
	 adLHHMV8RDgAmNpOeI24J4IKKZabnzTUCuNo1p98tb2uekPDoVIxRQTkAfWnaWTwKm
	 1VOgh9vXBvTtZtimN5WUWyoK1fkWdTTCTQVUcMZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0512/1146] arm64: dts: qcom: lemans: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:12:42 +0200
Message-ID: <20260520162159.774107246@linuxfoundation.org>
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

[ Upstream commit 85a6cf5ef8cf6e6de948fbba56101fa05049417f ]

The corners of the MVS0 / MVS0C clocks on the MMCX rail don't always
match the PLL corners on the MXC rail. Correct the performance corners
for the MXC rail following the PLL documentation.

Fixes: 7bc95052c64f ("arm64: dts: qcom: sa8775p: add support for video node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260313-iris-fix-corners-v1-2-32a393c25dda@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 2db2ab9cb2e06..be8c8c59ef5ab 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -4625,19 +4625,19 @@ opp-366000000 {
 
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



