Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207743AD6;
	Mon,  1 Apr 2024 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987960; cv=none; b=JwJ64xK0XEW4/8Vtp0cqW7weTxd2ukXOozF8rbG8GGTk6WUNXQRezbPeCp72+4HTXByFd7QAXnWrvfiZe19wWv359MmHR4UE94VfuG+7xDEIKKnCDAhbYWrhIZWzwEx/3ZrXCpywpC12NWardfhJiJz0lEXxWxvD52Z4ymGfmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987960; c=relaxed/simple;
	bh=LHjILxWDxLJPwNeW512TGBlANXKwqKPYQD0OfeNfUXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6WHRQ2UTPnBterWa5sHq/+Zplyo6YD869YR4stHUxpJ+KItvLGfhNC/rZ5uNtgR/5kiplnQT5cScGCZry7nsfyEOzRz+5B1ZTd2Ofrq2IomQm1AuIGzb7a6ATwUruM5y+4Fn2b4qiY1CaFbIw81D2+6+FT1mumPTqYgfkFoQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D17XSOBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D17XSOBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D234C433F1;
	Mon,  1 Apr 2024 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987960;
	bh=LHjILxWDxLJPwNeW512TGBlANXKwqKPYQD0OfeNfUXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D17XSOBBwbdKh9DrrLcudXN2XV+a68vYs/lpT7ZD5Uxzh+2ovaCsHtYezhgBk5GCm
	 GFUXiiP27XTvgc0nYgYEWVGQOZrepKQYNXqg8ntsqC94bmcvSaQpB/zXs7aGm9EsYA
	 yYLZKj2qxD17nTu/f11aZwGgBHO7KO7O/G9E8ysA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 014/432] arm64: dts: qcom: sm8450-hdk: correct AMIC4 and AMIC5 microphones
Date: Mon,  1 Apr 2024 17:40:01 +0200
Message-ID: <20240401152553.554081631@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 915253bdd64f2372fa5f6c58d75cb99972c7401d ]

Due to lack of documentation the AMIC4 and AMIC5 analogue microphones
were never actually working, so the audio routing for them was added
hoping it is correct.  It turned out not correct - their routing should
point to SWR_INPUT0 (so audio mixer TX SMIC MUX0 = SWR_MIC0) and
SWR_INPUT1 (so audio mixer TX SMIC MUX0 = SWR_MIC1), respectively.  With
proper mixer settings and fixed LPASS TX macr codec TX SMIC MUXn
widgets, this makes all microphones working on HDK8450.

Cc: stable@vger.kernel.org
Fixes: f20cf2bc3f77 ("arm64: dts: qcom: sm8450-hdk: add other analogue microphones")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240124121855.162730-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450-hdk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
index 20153d08eddec..ff346be5c916b 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
@@ -930,8 +930,8 @@ &sound {
 			"TX DMIC3", "MIC BIAS1",
 			"TX SWR_INPUT0", "ADC1_OUTPUT",
 			"TX SWR_INPUT1", "ADC2_OUTPUT",
-			"TX SWR_INPUT2", "ADC3_OUTPUT",
-			"TX SWR_INPUT3", "ADC4_OUTPUT";
+			"TX SWR_INPUT0", "ADC3_OUTPUT",
+			"TX SWR_INPUT1", "ADC4_OUTPUT";
 
 	wcd-playback-dai-link {
 		link-name = "WCD Playback";
-- 
2.43.0



