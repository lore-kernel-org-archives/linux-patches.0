Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634BD2F2365;
	Tue, 17 Jun 2025 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176421; cv=none; b=Xga1a009ntbf9eZnI+ZdxOObSP/dywIULrfypnR7MDC4sZjvdIpccjlYTYkSzwyJZQ4Wujtrxq/3QKOgF7xtnezoe5D26hthN+tJrvq/qYLWD8Y7Qe/xIgjw25d9tSaewn/9vCg3S2WL3JaxPtiEO4UUS3a9Ky65xpVI/01EDAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176421; c=relaxed/simple;
	bh=7pLm6KcLNN74UMme9LvnmqkTUbA4CLyv51Jst+d+sNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIr63ZXhejGOFvUUfMruPwg/a4Xe1zLlLasxAlDjRtdkDNfwevSnLwzHH0kbZvVd7YZcyQMMUPlozuZwA3YPxgb3VyXb/RPhn3kZv/5FbMzqjVOPSdxQSRfJ4lHwiF7bN7j4T6s0ll1wSka0kpFS9BpE02auk2uuwxMJwWABbBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrJi+KTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrJi+KTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D6EC4CEE3;
	Tue, 17 Jun 2025 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176421;
	bh=7pLm6KcLNN74UMme9LvnmqkTUbA4CLyv51Jst+d+sNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrJi+KTjFUslNh4OIGRyNQmlbTIt2uoN/JXSER5Kpbs36k/fisxxpp+Ir+q9u1z91
	 +/jZfZOz02GsZkKJY/tT3dWYvRbjmmZHf8WiLVkXnd3ntq3EPwdQtlwp/t4EgleDfq
	 Bp4nKUI1HIjvYkCiOF7yWXxbOi8ekT2iW0jZS134=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/512] arm64: dts: qcom: sc8280xp-x13s: Drop duplicate DMIC supplies
Date: Tue, 17 Jun 2025 17:23:14 +0200
Message-ID: <20250617152428.869863943@linuxfoundation.org>
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
index 6a28cab971891..8e5951da5920d 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1131,9 +1131,6 @@
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



