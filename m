Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30C2F6904;
	Wed, 28 Jan 2026 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614891; cv=none; b=cZcYviy6b8/6SCDw1prVuzZO3a67GonviC2lA9PhBMZSrsbbZsujc12cbQj4sW3r7gtarudUC+NLzkTFhvO9THGsAWud2bO5/cRk33IfLQctzAXblk1Vj5Jcca0HN8kn3f535An0QlQUHwU8vy3BsKDGOh5Qtuixuj20JdmvnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614891; c=relaxed/simple;
	bh=1N7XyPJSOBSRGXWolUt7KusafATVjpFqxdlJWycXJvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjMWYO9fXX9IHtplj0pLoTF4swCcgHT2W/4hw3SoIJJpsY9cpbhD3PXPHsmu4v8KE9lXgeg/y22JfwuL9PxDtsUKH0o2zMpVJJUwUJl+fs6I1Np8FyTlzuxXFx5KPsaUX1t+WULCsIq0Yjp03ys3TuRSBp1+3o+MpdlUAjeS5ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5wlX8WL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5wlX8WL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8948C4CEF1;
	Wed, 28 Jan 2026 15:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614891;
	bh=1N7XyPJSOBSRGXWolUt7KusafATVjpFqxdlJWycXJvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5wlX8WL+smTpCyxOnpr61n6soT3hWb9TtPEbvW0Qu+eHYsV/Phslh1DKnQI7gF6Y
	 hU+NGJwSCOINbE65P7Lp8L+ARZUZQv6DTDwjiSzFSgiBg8pSKvO6MY6jg9kMmpkbKS
	 +Pj+S9OufLXC5gMxMeMMk8zwqTttjPtzYdSmELrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/169] arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links
Date: Wed, 28 Jan 2026 16:21:33 +0100
Message-ID: <20260128145334.386238680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 868b979c5328b867c95a6d5a93ba13ad0d3cd2f1 ]

To make sure that power rail is voted for, wire it up to its consumers.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20251202-topic-8280_mxc-v2-3-46cdf47a829e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index b1e0e51a55829..c10ee18cb611a 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -5218,8 +5218,12 @@ remoteproc_nsp0: remoteproc@1b300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&rpmhpd SC8280XP_NSP>;
-			power-domain-names = "nsp";
+			power-domains = <&rpmhpd SC8280XP_NSP>,
+					<&rpmhpd SC8280XP_CX>,
+					<&rpmhpd SC8280XP_MXC>;
+			power-domain-names = "nsp",
+					     "cx",
+					     "mxc";
 
 			memory-region = <&pil_nsp0_mem>;
 
@@ -5349,8 +5353,12 @@ remoteproc_nsp1: remoteproc@21300000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "xo";
 
-			power-domains = <&rpmhpd SC8280XP_NSP>;
-			power-domain-names = "nsp";
+			power-domains = <&rpmhpd SC8280XP_NSP>,
+					<&rpmhpd SC8280XP_CX>,
+					<&rpmhpd SC8280XP_MXC>;
+			power-domain-names = "nsp",
+					     "cx",
+					     "mxc";
 
 			memory-region = <&pil_nsp1_mem>;
 
-- 
2.51.0



