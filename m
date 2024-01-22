Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6D12BF1C;
	Tue, 23 Jan 2024 00:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968903; cv=none; b=rNEE+NP9/+tZzQwPTzYPEZ6Cy20/umNRDtk20VfR4itWVYMghDZCCVXatJTGP86eT/isB+lWGbto63pFgYzxNeqjodaL0QAAaEHKFLMlUb6xLY8xU1b8dXpWjrDt7bMCn8u65Abl+A02qe1Zz1vW2/e76acztTX4m0+w+aFJiB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968903; c=relaxed/simple;
	bh=hlxIBXinjbm7KpZnPXegkOadJC4WlyZgpOdDoWNVoeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5g2WZN3U5rnnwDK8Eul1nLLy5LaSteKCvcNVaAgD/NY/nowTidOIhfFtrkXMzo28Ry2U28IHBiFNmKlpPvDF07toAAEKj4SYVnajxy7PvWWiBeh2rK34izA/4GEBDLMJyDOisHiI9OW3V0MIXTtuc+tktybxjAFJXKtBu4xPGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKN46RDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKN46RDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89376C43390;
	Tue, 23 Jan 2024 00:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968902;
	bh=hlxIBXinjbm7KpZnPXegkOadJC4WlyZgpOdDoWNVoeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKN46RDy9CS5ED7qRVj/ysAfESRtVvmRv2BEcTMo9bmTr/wen3D8LEBgbbR2l5v2c
	 h0shz12m9W8UGnEux3BKEse2jTIbVU1HCY68eSQMtUHBR0VZP8genjVz3AfUJqGkuy
	 30t9BBU5hp2RU4AkFoBsoHf7kaMBDk9VtZXkjrxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/194] arm64: dts: qcom: sdm845-db845c: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:57:00 -0800
Message-ID: <20240122235723.108644581@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bf4fde88011c..e99a58b76d86 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -53,8 +53,8 @@ leds {
 		user4 {
 			label = "green:user4";
 			gpios = <&pm8998_gpio 13 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		wlan {
-- 
2.43.0



