Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B5C32FA3D;
	Fri,  9 Jan 2026 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959545; cv=none; b=vA1mt6PMb/vymKRCyIKuY0rctt1kOAwSsGmhrzFgo9Frd0RPf3niWR0dZHbMmDDOnR0Q7p6Cn9+Wm/65WziZVhmGcCIZtyz3X/kDgOnVVuAvwMPvsOr6O4XPnvNH69DiZUE0PDCUqmBrL7IlpTxqSv4WErckOvaW20gj631rqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959545; c=relaxed/simple;
	bh=11bqN8Uhtw3FvQkc7oq9vezfn7nP+O7YVrVvB0vsQ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guwwnZFz6LcIcpKrbao2lj67ETM72g7wtBm30QSgQbmY6o51QLyaVKR1MOwXzjOItMt47T9nhldbUipATBZd8wMncBfWkqbRtnwYkNC69ycWJB22AdPfLWwb/Ay2mIU062DEnIEI8lHDh6DwI1O0+HCZ8Ya1I/CB/KiAyCkn2nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwe5lp+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwe5lp+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8733FC4CEF1;
	Fri,  9 Jan 2026 11:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959544;
	bh=11bqN8Uhtw3FvQkc7oq9vezfn7nP+O7YVrVvB0vsQ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwe5lp+n38L5r+We+59HjrWDCrzvA8GiVXSzIeW7YmjKehuScLg3scA4LqmLNW5KN
	 LO+YRqzfyygbfbcw9v+VJKhROiCSi0vP9UohYm52e/VBa7HlWFYHfQueQ1WPPWDijy
	 yg7Ku/kU3OTYAlFdgeVRtJ8I8jzHws8NHZDnm9dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/737] arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider
Date: Fri,  9 Jan 2026 12:33:48 +0100
Message-ID: <20260109112137.346559368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit d7ec7d34237498fab7a6afed8da4b7139b0e387c ]

The previous GPIO numbers were wrong. Update them to the correct
ones and fix the label.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250927-slider-correct-v1-1-fb8cc7fdcedf@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 9322b92a1e682..bccc52e01da38 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -780,8 +780,8 @@ hall_sensor_default: hall-sensor-default-state {
 		bias-disable;
 	};
 
-	tri_state_key_default: tri-state-key-default-state {
-		pins = "gpio40", "gpio42", "gpio26";
+	alert_slider_default: alert-slider-default-state {
+		pins = "gpio126", "gpio52", "gpio24";
 		function = "gpio";
 		drive-strength = <2>;
 		bias-disable;
-- 
2.51.0



