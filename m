Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7076F34D3B8;
	Tue, 16 Dec 2025 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885322; cv=none; b=ohMvCQK+4lU5Wd/mlRXy0Rq3dJbRIJbEYFTW5KcBkgsCsOL747v+Fcb0kEwmITsYRpJkD8FNayHs0+XtVToC8MXUEgS2snHC7133Snni+DSeG0tgvNe89K2aeKoHeMpQjSjEJlOpGkrB3YD2B/BUujRAIY0FYTCTkeDCIVdrf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885322; c=relaxed/simple;
	bh=+CkupwcqJjgcSXaltygk7rW/l18lFlSqEZ6EDqdzHNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkJH4wHJ1PP5/az+ybSdZ1O8prnXX+u6IZ1d+91QuQq2zbQCgG7lzn5ewiNwrGUstxCqkQ35oRjFBud+gjDWLeqmwmvgzu8S6W45PBnsG0Yx/6etV1l8smvPB6uyG4NkuOtw1aH3cL5VOTNC+7eP6IX/IJgmdUeB3ZlDdKM62l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHgplpKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHgplpKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB55C4CEF1;
	Tue, 16 Dec 2025 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885322;
	bh=+CkupwcqJjgcSXaltygk7rW/l18lFlSqEZ6EDqdzHNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHgplpKcMVM1rAVLlycgGa/jva3OAdtAu1kxl7gEkcPNJsiBG/vBTZcnaHfjTBB/s
	 S3tMngmbWP9ebM5GrM294Pef8Uk6LeGsvsj2UBBSeYKJ89rjXvyENpNETmIyqa4FhN
	 vaFIW0wD75XYcNxolVm2t5F2oJITRy5CvtOOzeII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 097/507] arm64: dts: qcom: sdm845-oneplus: Correct gpio used for slider
Date: Tue, 16 Dec 2025 12:08:58 +0100
Message-ID: <20251216111349.054220333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b118d666e535a..942e0f0d6d9bc 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -799,8 +799,8 @@ hall_sensor_default: hall-sensor-default-state {
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



