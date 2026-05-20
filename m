Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C53F359A6F;
	Wed, 20 May 2026 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298516; cv=none; b=LxNm2yFcIrGomyvAXzUtahQDEcVH4Wwu6ujvWgTE1UDLO5jmb8s0PaNxYyg2Z4TK0zeoAQVEtJVZm+gdWgGhLi2Ek1JO10eDUNecL91mtoIarJxzcjEiDH+pOJZPxL/ETpWx43XdIbC7NgFhv6SGjI6uwMRaOc6SOtxW7Z0vszY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298516; c=relaxed/simple;
	bh=dhfpZGjIsEmFveJB6Rv9nXGdJVs00bc9YuFinf5n5lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msnwpAeaKxmDnngUrmPFmyJNunfs0gspeaScJ4IwK51SHYqIlUkn7B//D4RcRw85Xk9+igWSEMlqVKeEc5Ln2xmO6RwW/DtwBGMFt9ST9KXSYJWLy4ryml8nXAZFtyTqebkbLazlHgmFFJEiOk3fcJk/fDGoqVifMJjYcbVNy/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgBsnBYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgBsnBYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10411F000E9;
	Wed, 20 May 2026 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298515;
	bh=56WPud3q8PmJ+g3jnyxAx4uzmUXQ+oBUAzp22jPo4TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgBsnBYHoNpf3cvqDzeG5wRh4GbEKllQPPZdtzsroZAJOaTUmdgZpt/j9RJT4II1x
	 IXx5G+nHB7WoIGr/HH88xFTcuzJdwIBkcRjmhEMNAzg6Q1Xm4nzSxlm6RZKIO8xxlL
	 xob14+s2cQhtQUcYBEDOxEYcS+p+CQ8VCraDK92Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/957] arm64: dts: qcom: sm8650: correct Iris corners for the MXC rail
Date: Wed, 20 May 2026 18:14:42 +0200
Message-ID: <20260520162143.178411919@linuxfoundation.org>
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
index d22a26a416ccc..4e34c686265d6 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5201,13 +5201,13 @@ opp-196000000 {
 
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
 
@@ -5219,13 +5219,13 @@ opp-435000000 {
 
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



