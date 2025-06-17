Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837CD2EA16C;
	Tue, 17 Jun 2025 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177906; cv=none; b=b2JwpAwyJpn1heZPRoOcO4c2GGLs4zKgp8kJN2AhTYrJCikIrsjqmCRhRi3wRMWBTeYpSMj9CeRhUYOpv9y0QzqPLcCyHkMbYmOajqEM3c8xuzbHYzNdbBmog60F+poK4haT7JmuAJOUZKYGz3N1hi969bqduNuayk1E4piHsSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177906; c=relaxed/simple;
	bh=00xV8eZVWlqtYP2yj1RCjP+xRj5Wbg1rWAyy/6XeS1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLpu2yymcUlhFDt91Df43jVvOqr/TPsYkQpEmx8NlhR9IzcZtwnnGGuavbC8p01zd0pFC2CcUkOpPKl/Y8o34GO4WIsmRYzPUnS7+YtrkO1QOQiKu+3dnIwfLyFHxhIJcCXFiKJUwQwSiLtuni4P/DTB0ZbsrUJZ/hQmV9AUGic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdJuA2Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdJuA2Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF23C4CEE3;
	Tue, 17 Jun 2025 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177906;
	bh=00xV8eZVWlqtYP2yj1RCjP+xRj5Wbg1rWAyy/6XeS1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdJuA2QeM0og69EXCMhPQt7Ehw1WOEPlCWEGUhUJd0kcx6L8izGj7El02Iaox9vgZ
	 oBcWTiDH+MjmYHVsYfFw8mQKUseUxXDDz8ei1tEisKX1XnVY9s/1lA9+ViUW5z2QZJ
	 NoAPwckCXb3J+3qn3RO30vqaxWQClIcfP7lrYIYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 358/780] arm64: dts: qcom: sc8280xp-x13s: Drop duplicate DMIC supplies
Date: Tue, 17 Jun 2025 17:21:06 +0200
Message-ID: <20250617152506.037579218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit a2e617f4e6981aa514a569e927f90b0d39bb31b2 ]

The WCD938x codec provides two controls for each of the MIC_BIASn outputs:

 - "MIC BIASn" enables an internal regulator to generate the output
   with a configurable voltage (qcom,micbiasN-microvolt).

 - "VA MIC BIASn" enables "pull-up mode" that bypasses the internal
   regulator and directly outputs fixed 1.8V from the VDD_PX pin.
   This is intended for low-power VA (voice activation) use cases.

The audio-routing setup for the ThinkPad X13s currently specifies both
as power supplies for the DMICs, but only one of them can be active
at the same time. In practice, only the internal regulator is used
with the current setup because the driver prefers it over pull-up mode.

Make this more clear by dropping the redundant routes to the pull-up
"VA MIC BIASn" supply. There is no functional difference except that we
skip briefly switching to pull-up mode when shutting down the microphone.

Fixes: 2e498f35c385 ("arm64: dts: qcom: sc8280xp-x13s: fix va dmic dai links and routing")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20241203-x1e80100-va-mic-bias-v1-1-0dfd4d9b492c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index f3190f408f4b2..0f1ebd869ce31 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1202,9 +1202,6 @@
 		"VA DMIC0", "MIC BIAS1",
 		"VA DMIC1", "MIC BIAS1",
 		"VA DMIC2", "MIC BIAS3",
-		"VA DMIC0", "VA MIC BIAS1",
-		"VA DMIC1", "VA MIC BIAS1",
-		"VA DMIC2", "VA MIC BIAS3",
 		"TX SWR_ADC1", "ADC2_OUTPUT";
 
 	wcd-playback-dai-link {
-- 
2.39.5



