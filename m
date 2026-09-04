Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5068E41A4F8;
	Fri,  4 Sep 2026 05:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499462; cv=none; b=o/OeKODlQMhYLa/D9P9xxClMRchLsY1+MA2TyR9hB4/y7AjE2ckK2Axohu3Lfkygm14YAbmn9kZsa5n3buOKY9/JZu8X2+BQAFeH6Dhn/LX65vKvbYBoG9ykHitEqrrS5XOlJsW/DhtI0YEwa1smsAQ0346X5xCck2sEZpZAni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499462; c=relaxed/simple;
	bh=SWu2RQnVqtmZGr0WS/4qJoVu8V8PkCUs09N89RHTs6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dscoShSTS+ZJXiR9MODZa5cWhef7j99C4A5SR/vBI7KzGLrxmah5Lvuglav8F+VAmqDX1p3NG+oc1CdBweVGGM+DfJ5tBohiQWiU0e2fixsdwK7XPYOl6gnI/L65v7NNIYvIag9fA9QB+n2e8+U0tz7RE7ZCtPKHOIHp1D5edn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QihwGmWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QihwGmWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F5C1F00A3D;
	Fri,  4 Sep 2026 05:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499459;
	bh=NlOB2mrby1XbgtvhRkstiO396xtvGUttzvxCtwSC6f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QihwGmWc1TIQDOxmj/hpoaMrGMc6j217mLpA0DWN4ryzOjUEc9Vv57q+JoL/Byjpf
	 STXBLih2eR/mPFfwsVSo1uZk6m3Nlq7y+VI71wyKAFcB3zrtPQtr6CfAg43vDEjahY
	 9tyQ0t+0a8Zfu9ybF8+DV/U5UFNrEYLrjxxEtaJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Scott <mike.scott@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 425/713] arm64: dts: qcom: x1-dell-thena: mark l12b and l15b always-on
Date: Fri,  4 Sep 2026 06:56:33 +0200
Message-ID: <20260904045813.354100650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Scott <mike.scott@oss.qualcomm.com>

commit 06c8fc3e132ce8659bc9f0877b5c6daaf41aadbd upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Note that these supplies currently have no consumers described in
mainline for dell-thena beyond the audio codec (vdd-buck/vdd-rxtx/
vdd-io on wcd938x), which can release them when the codec goes idle.
The board-level gpio-fixed regulators that feed the Type-C retimer's
VDDIO and other rails are not described with a vin-supply link, so
the kernel cannot keep their parent LDOs alive on its own.

This mirrors the same change Johan Hovold applied to every other
X1E80100 board in a March 2025 series; commit 63169c07d740
("arm64: dts: qcom: x1e80100-dell-xps13-9345: mark l12b and l15b always-on")
is representative. The dell-thena board file was introduced four months
later and did not inherit that change; this patch closes the gap.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Scott <mike.scott@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Val Packett <val@packett.cool>
Link: https://lore.kernel.org/r/20260521010935.1333494-4-mike.scott@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -589,6 +589,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -610,6 +611,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 	};
 


