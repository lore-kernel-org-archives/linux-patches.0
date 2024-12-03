Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767801EF0BC;
	Tue,  3 Dec 2024 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238088; cv=none; b=Nt5Tn92q9RIbcdQrAOgqJ8sZ/Gu+QA/Xcvm5VEWgmVn9DQ4U97+18ih21A8UgFjkSF95pdym1A5PtQuReTi/YW0P0F2F1MEtJ8/fsvIUjBN2htg/Sg5E+a+j+WaAOL9hj6B3a1+BjGkkUPBHGacd0fgQdwa+9aUMNcq7uHpBYCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238088; c=relaxed/simple;
	bh=1w9BD9vOCRA2IFHuc4rVrBfJdjZTuXhU0dr1F4W9/GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udP7ED0zo2iybE7TtjSwNGMRYCt/n1abeoVUU/Wqmkd6uqPbcT/mn3U4znY2MG2+7oXUXsOUgxOmp2qrFwdeb9f43v31z51XMuxDcipACbqDhlewJyeb2BJM9lSjqUTqxo2JTuO2UPvJR7liOElbEt6iy1ZdKgRVJus1I4i+wII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es6QCXxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es6QCXxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A77C4CECF;
	Tue,  3 Dec 2024 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238088;
	bh=1w9BD9vOCRA2IFHuc4rVrBfJdjZTuXhU0dr1F4W9/GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es6QCXxQqq8jLsXo+6nqlOMxbmy3g3Jh/NXPkCQQT6TP8PM/XX7LQe8ZFiAb8I0Lb
	 ShItcNydqaIIIRk/H7VAMYKE9ZWvEZRDALK0Pa+EqZ7s4buqahQPqyi6KbJltw0BC+
	 zGsd3uiquiQMFKCPKr1wN/q2XBfAl1VON0cCia20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 157/817] arm64: dts: qcom: x1e80100-slim7x: Drop orientation-switch from USB SS[0-1] QMP PHYs
Date: Tue,  3 Dec 2024 15:35:29 +0100
Message-ID: <20241203144001.854929924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit eb2dd93d03b16ed0e8b09311f8d35cc5a691a9b7 ]

The orientation-switch is already set in the x1e80100 SoC dtsi,
so drop from Slim 7X dts.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241014-x1e80100-dts-drop-orientation-switch-v1-1-26afa6d4afd9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index 884595d98e641..769040b50b04d 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -881,8 +881,6 @@ &usb_1_ss0_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
@@ -915,8 +913,6 @@ &usb_1_ss1_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
-- 
2.43.0



