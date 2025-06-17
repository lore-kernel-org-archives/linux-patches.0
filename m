Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CA92F2355;
	Tue, 17 Jun 2025 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176357; cv=none; b=Z0Dv31wIh5xPr2jEX+nEAhaK08ACmqBmiOPdNfr8Ud/9tE1uVbl74P6tKn/fsWoZd5fi4KQfYEBgTCtj74b05rJokQebOaeoto2FLormWBwU8ihtfIo+wI0N3oqB1gEs1RzI038AXhxctgw8zmb9Yx9lKRRorCtN9mHmxIPl+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176357; c=relaxed/simple;
	bh=J+U2D4ZvnqT50L3EGA7RVIjxUeTTwKBhQ+wooG6gNMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ior6aVHA6U0IGMTs0YBfp8QyP26LjRIkNg3m7N7jwF1E5i5FbNYPFZkmLYRF5VTG+msmTXpMBKAvjb1rA9nnBPxkItbuxVGreQTUPMeiqw/l7/3qQyxeTB5K9ICEjdxfpJ8uGidDybx4Xl+M75u2/dMLkNe1iFHyUS7uyg2duE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIEV0VfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIEV0VfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEBFC4CEF8;
	Tue, 17 Jun 2025 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176357;
	bh=J+U2D4ZvnqT50L3EGA7RVIjxUeTTwKBhQ+wooG6gNMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIEV0VfEnnZJYP5topw8QEnB1uOelXHYulZSij19tlc9KrHIKzA6k+OlFUYsJZNQL
	 wlpcQN+ImW+tZbXGLk9FyTt3mPevyo0iIjk6UsC89/k65wsEb30dlo4DwoGIrOd+rE
	 gR4qMC3K01838Hd+vUrBuFM6UCM2cnU2Kyh2d6qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/512] arm64: dts: qcom: sdm845-starqltechn: remove wifi
Date: Tue, 17 Jun 2025 17:23:08 +0200
Message-ID: <20250617152428.619424936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 2d3dd4b237638853b8a99353401ab8d88a6afb6c ]

Starqltechn has broadcom chip for wifi, so sdm845 wifi part
can be disabled.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device  tree for starqltechn")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-2-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index d37a433130b98..6fc30fd1262b8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -418,14 +418,6 @@
 	status = "okay";
 };
 
-&wifi {
-	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
-	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
-	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
-	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
-	status = "okay";
-};
-
 &tlmm {
 	gpio-reserved-ranges = <0 4>, <27 4>, <81 4>, <85 4>;
 
-- 
2.39.5



