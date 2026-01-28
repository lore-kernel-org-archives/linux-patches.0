Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FEA13B7A3;
	Wed, 28 Jan 2026 15:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614317; cv=none; b=DYXRnG7X+yJHMXfgRILEpLS8oZJ8SCQblBF/YSkNz8K0yMyH32K9OMxo466SNEi6rhSoLUeibZur4hQ2A1shLsft//x0zocZFI0TQsSWAK0+M+w6LC3LNUIiQRLiFiQxWbyV/IigOaTUklKocZ7Z3lzYboXvsESRUdwpTw3QhTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614317; c=relaxed/simple;
	bh=1LOBiWFDwRwo9LJSbc2sqQNKgeRe6i9QPbonu9uat2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUttate7Bfd0W16smglCcFdnc/RAK3Xb+s6wZ1qHGyv1Cgz/l8eJHcbHnEkch/xyobANQSD7Fm4hJBiV3cXs5QGwMGCWC/6BrimHsdKhK9S8UHxdSS/+6z7ejnJ0i6pMHykl9agV/5V8MNrpm1KWcAleUI9th09bWHzWOPz6sqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTSo64Zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTSo64Zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A804C4CEF1;
	Wed, 28 Jan 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614316;
	bh=1LOBiWFDwRwo9LJSbc2sqQNKgeRe6i9QPbonu9uat2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTSo64ZlhP+19cEsMzs3qumzhxBwFa2TJ01kQVD2zcDyeOmyuyDMxDxnFf9mfBK6U
	 d4Bbi16j1t77Z2nm8ofkEt2jlGUe/UF3+aWhMmua5COq6omLs2yZALXbpU0clB6V7Q
	 A3G9nFqStnumAzi5KjuVaP+Mjfgg9EotAJKwzcQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/254] arm64: dts: qcom: sc8280xp: Add missing VDD_MXC links
Date: Wed, 28 Jan 2026 16:21:14 +0100
Message-ID: <20260128145348.353230160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3e70e79ce24b0..8472e00bde5ab 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -4412,8 +4412,12 @@ remoteproc_nsp0: remoteproc@1b300000 {
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
 
@@ -4543,8 +4547,12 @@ remoteproc_nsp1: remoteproc@21300000 {
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



