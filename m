Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A91A01C6;
	Mon,  2 Jun 2025 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872594; cv=none; b=VOPKYOl5eH47YeyCwKjYfdopJ/djA645qerDwS2jn7SDlmKUMw3Y7pm8ah6zfDRgdpv4z6DDBv7jwgTwvVzHbBZzZpVsCWQEiv+yidT7MelQz2LFMoYh5hyST74UGS00ogH/wqFBJE9uoovRjZdZET4WCulH7NqBGXTxiXNiOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872594; c=relaxed/simple;
	bh=qKgwV7Lm4VZvSqsz7vPLGz66hifvEbE7o1czTx5sftQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIYe01PpMDSKxv16zbT1oUozka+HrXQ7EkAq7O1zWfHtXaKCB+bX4SbxVhz3+HGSfPifxLYbal8NgP8Zwb3NIvFBnTJSa0KRCC2ULAu3YSkRKaGJJDFu1nw3CvjOxfR2V79I6KyopDKQiLaWz5cujF2op5E2ptIQIUAzZS6v+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/u/BYx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/u/BYx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1870CC4CEEB;
	Mon,  2 Jun 2025 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872594;
	bh=qKgwV7Lm4VZvSqsz7vPLGz66hifvEbE7o1czTx5sftQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/u/BYx5hsze18I4SFP2IhI+gSI25dJKwmqLp8Dg8sAUDHtRiXI4t6nPt965s97Fb
	 HdhnW/jP8bgyDnivegW8X9dt2xC0vvaqyMVbvYGeADa209N2ISsXgRdXseJcRJEJed
	 VzxX45tV94aI/EUYTehY6s+2YSWV61P7PP6eAJzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 13/73] arm64: dts: qcom: x1e001de-devkit: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:46:59 +0200
Message-ID: <20250602134242.217221531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 7d328cc134f7db1e062f616a30cffe96fbc43abb upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 7b8a31e82b87 ("arm64: dts: qcom: Add X1E001DE Snapdragon Devkit for Windows")
Cc: stable@vger.kernel.org	# 6.14
Cc: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
index f87730f4b63f..b133302bf846 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -507,6 +507,7 @@ vreg_l12b_1p2: ldo12 {
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -528,6 +529,7 @@ vreg_l15b_1p8: ldo15 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {
-- 
2.49.0



