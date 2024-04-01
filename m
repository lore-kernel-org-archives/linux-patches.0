Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A831C0DE7;
	Mon,  1 Apr 2024 16:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989455; cv=none; b=INGU8G7a/qA0asduc1EziRYX5cUqoxA+qzqNVio7xNvEqhXfiMHx6nr3gt1SPRVVEw68xh+6BW3FdPfQ6SFhFlUXG45a8k32kG8Zi6jSayGYCUIyERc/3ucKzUIwmX//l4QmrDT1FXguEo+RZpa985tzDJCTbki+tPZg7f4gDm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989455; c=relaxed/simple;
	bh=OSD1KCno8QX8jlCQeiFUozF9NUuaWpO3KuMgkxHyXNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ6SqIFVByNdfyj9Vnl5XSVLC+3daqWoXpy6KrvKW2pCv4FHG7YilbWDKS9hye3XxX/UbcEDNmM+bwXvyU3XSqjOz6aVoP++b4LecL/hsIjUHrO9mj/zEcK+Rt0D8DLO/jivYwKwxXJWPY4syi2V0bjK8VCWbqDEqq5zZbnzpCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blU5UQQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blU5UQQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFD1C433C7;
	Mon,  1 Apr 2024 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989455;
	bh=OSD1KCno8QX8jlCQeiFUozF9NUuaWpO3KuMgkxHyXNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blU5UQQdRDNea+DussrCBBViCu9xZhpCs91+joUitHUh6A8xDkB1I30wZJ5v0aKzQ
	 e65VgT31Yo81ekrCDO7F7LLyVssDCkRHLWeWelMpGq8bv1AO5OLerWx1t3pIVR5JEQ
	 MbUN5tYZpYYmeBVEQMOaE68zLKWzzg10bQPKivA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/396] arm64: dts: qcom: sm8550-qrd: correct WCD9385 TX port mapping
Date: Mon,  1 Apr 2024 17:41:15 +0200
Message-ID: <20240401152548.683646313@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8ca7fbd92c1b28edb5d5df7aeb8bb4886ddb9829 ]

WCD9385 audio codec TX port mapping was copied form HDK8450, but in fact
it is offset by one.  Correct it to fix recording via analogue
microphones.

Cc: stable@vger.kernel.org
Fixes: 83fae950c992 ("arm64: dts: qcom: sm8550-qrd: add WCD9385 audio-codec")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240124164505.293202-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550-qrd.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
index 2c09ce8aeafd9..7a70cc5942797 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-qrd.dts
@@ -835,7 +835,7 @@ &swr2 {
 	wcd_tx: codec@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
-		qcom,tx-port-mapping = <1 1 2 3>;
+		qcom,tx-port-mapping = <2 2 3 4>;
 	};
 };
 
-- 
2.43.0



