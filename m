Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990F114A4FA;
	Tue, 23 Jan 2024 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969244; cv=none; b=Y/4KHv9+SslGQgX5D86WpJ0NPXOlfh7DXrL9lQC2+3V81Ekq875WyALPYTcXMRo80ww8Mr7Hl7K8gqgrXlF2tgvdpH2Hj9vE8tSbMZuoekfY4kHyi++7u7oo10aSxImnptVAnh8OlL+1lbHEskIXZKDRs17kSzbva7l6U4u+UkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969244; c=relaxed/simple;
	bh=NxyscHWB/kk6Q16ncuPJ2rUIfPlm4MffMiffnqYXCiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA8VmzmxHXuR1kx2slaUueODP4lLC5gmmhmdrSu4MLL3kolvhNFQd1XgsURtAFLjjaVgqMOCF2voKVymIlAwf/66FSwkqa7xWj2S0XG11FJFrCxcZjOMzEdS1pgu4A6J1l1yS8dzuJVkx0mPVe+HzjEt/SEBOQ3TLXOE+ZKvkzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm80ykC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm80ykC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEDEC433F1;
	Tue, 23 Jan 2024 00:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969244;
	bh=NxyscHWB/kk6Q16ncuPJ2rUIfPlm4MffMiffnqYXCiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm80ykC+osP5wXHt39WSHpuAQbwaQm5kByYOCtzxy/1mzxZIjNJkV/qR0hGTM4H1K
	 Ktxq90dwHMmex5gZT8M84ZrLHo/mOptmgOo+3Q+C/8N3GC8Hc47JSXiVUXuiL6K2Tg
	 QdmcZ1Z64xEP5gkd8CCxMTUxc5Tbmo6yX/PWTNVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 122/641] arm64: dts: qcom: sm8550: correct TX Soundwire clock
Date: Mon, 22 Jan 2024 15:50:26 -0800
Message-ID: <20240122235821.874805331@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

[ Upstream commit ead0f132fc494b46fcd94788456f9b264fd631bb ]

The TX Soundwire controller should take clock from TX macro codec, not
VA macro codec clock, otherwise the clock stays disabled.  This looks
like a copy-paste issue, because the SC8280xp code uses here correctly
clock from TX macro.  The VA macro clock is already consumed by TX macro
codec, thus it won't be disabled by this change.

Fixes: 61b006389bb7 ("arm64: dts: qcom: sm8550: add Soundwire controllers")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231129140537.161720-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7b9ddde0b2c9..09353b27bcad 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2194,7 +2194,7 @@ swr2: soundwire-controller@6d30000 {
 			interrupts = <GIC_SPI 496 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 520 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "core", "wakeup";
-			clocks = <&lpass_vamacro>;
+			clocks = <&lpass_txmacro>;
 			clock-names = "iface";
 			label = "TX";
 
-- 
2.43.0



