Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE460DF0;
	Tue, 23 Jan 2024 00:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970738; cv=none; b=g8N9q/AEwDvz3jMy4egsSyDe9l7dxGIuSkZlugFrmhcyRir34HdxN9fKJ9O7bTqS+4lj2QJnx1meoYwyAeeMqYmKZd+u3pCzFkaaoiZ0PEUFNEkYjBbc0bnHEWT9alYp84zpo8PiiKlAdJGgOKh3LcTdZGaEBI4HJQiyBQqGTgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970738; c=relaxed/simple;
	bh=MhA5E9B1FfaHfmogYH92Jr1xkI/3bSS3bHwKwN1uFlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCfuo4Q4T/fEnTJWaIxr0jzoaFGMi3/RCx2wFhf9tQjvOhihruowSl6wDGxGG50q5Z1RvBsD72N7Pdg592uhZ/w6s8HCiITsI8MOzX908LhcGSAiPi5jZJPTNkkB5ALSbDlPGN9btM+/VzQiRsx0avKvyzc3HBYt7i5eSFEZT8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4e63MpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4e63MpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251DBC433F1;
	Tue, 23 Jan 2024 00:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970737;
	bh=MhA5E9B1FfaHfmogYH92Jr1xkI/3bSS3bHwKwN1uFlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4e63MpGAc1M1hc1hcQHVHoyyxIyAVhIQRHyAzuglZn6vavCS8xICOIBukKZKWZ0T
	 lrbPx7dpUcMvr54YDpz5gQb9KPTqbUUin+dFqst9KCg+ikBrcNC/cxXd/NtnSva0O0
	 BnQxVoN/3Al3jqZ5CayiQItuVeCr2hQD5DG4HCBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/417] arm64: dts: qcom: sdm845-db845c: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:54:29 -0800
Message-ID: <20240122235755.199927099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0c90c75e663246203a2b7f6dd9e08a110f4c3c43 ]

There is no "panic-indicator" default trigger but a property with that
name:

  sdm845-db845c.dtb: leds: led-0: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111095617.16496-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 8c9ccf5b4ea4..135ff4368c4a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -66,8 +66,8 @@ led-0 {
 			function = LED_FUNCTION_INDICATOR;
 			color = <LED_COLOR_ID_GREEN>;
 			gpios = <&pm8998_gpio 13 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		led-1 {
-- 
2.43.0



