Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20657293C45;
	Wed, 30 Jul 2025 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868798; cv=none; b=exrWseSEcm2vcNIIWqASaJ9Y9atznBsrX0SrKG07pUmoEk4ZLD6qm8nUkb3g9mUlygxA36YnrruYWEkranAP8ZHDAx8VeAEhWaEV6CgxDgomLArf/DWHE1tfJiRH/9L8F3UU0lyYIvwppcHMeDMXU0NbhRVsJKpkuORmnSIXjbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868798; c=relaxed/simple;
	bh=vEoBZEbv8MdjuZhNl2aMk9WjLo38I6BSKhDHIbMAq74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJDgDsBn0NFhCDl/erOeI4+ODM0YxNiWom5JCBsYw+XHB2Hi+ugF54eqO47S9sOgmsQ0Xm76bZ8zGKV9urunvfTDgqMxHfWrKRsrN9+DejLoEtgpESlrQ11V/daYEzDMQExytOTaONaOk//fU4hIcITSLlCnsdXdQcB8FFVWmHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSDihTLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSDihTLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC7EC4CEF5;
	Wed, 30 Jul 2025 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868796;
	bh=vEoBZEbv8MdjuZhNl2aMk9WjLo38I6BSKhDHIbMAq74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSDihTLiO6y1CaBTHwrHK+prPRjSSz8RH3Xp55bn0ZFFCndouSbcv2UZWMYVITx/2
	 A7/3GQ6u7cV7r0A2cfDLeKsTwEzt1S9O/bPzWXGy9W3V9HmIvaDwls1jFSAGoRG8M9
	 nKSllyCJyMOrAjYJGjyQTy2x2v/ggsIu2Ew3xCFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/117] arm64: dts: qcom: x1e78100-t14s: mark l12b and l15b always-on
Date: Wed, 30 Jul 2025 11:35:47 +0200
Message-ID: <20250730093236.576217007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 673fa129e558c5f1196adb27d97ac90ddfe4f19c ]

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Cc: stable@vger.kernel.org	# 6.12
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ applied changes to .dts file instead of .dtsi ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dts
@@ -232,6 +232,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -253,6 +254,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l17b_2p5: ldo17 {


