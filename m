Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F457323;
	Tue, 23 Jan 2024 01:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974041; cv=none; b=Udp/9vGO925ME9LiVU4SnBx39QgJhXNTnn9hEwYuB3Xm2hS4HnLucziJLXejxrEtzjtsS++pEfPKudeH1x6mFNVlnIjPDnOu9+y50t7D4oAa9N9l7E9G6p4ECAfIgRzuteMNzD/aedicgDn4BkRFtF6EfvlXjyoFs2i4uWb5uhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974041; c=relaxed/simple;
	bh=dmayhOpcW+2iK/8Nci1101tTVku6UsspyIfRPTQPXOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufsIHlTpNtDZYtF0CIPzejm0UixiDTLJc4P0QiDeW91ZJMT/8qZ8JZrY2IpWP4xn3gC6stYY31R8ftAXP5IFYH4OP6ldOahLWlvJBUzJc44cJjeR87s+yWw6I+vK860znMEOIjDCdLlU9BT4u6T3HfjXfBRdvnFtRv0ovwjNQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlqhVKr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlqhVKr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65873C433C7;
	Tue, 23 Jan 2024 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974040;
	bh=dmayhOpcW+2iK/8Nci1101tTVku6UsspyIfRPTQPXOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlqhVKr1ug85SjhJBJK3690A5Iqjr+rXdO38xKJiwthZTjtzNwNgzPXmvjzv8l7kX
	 pdWam2zO2AhfxKRXCxAX9z4/BMpuQu5e9QlaI6WbIQcmzNZJzd4Nryq4f7eOFkR9MY
	 t+Zc0mN24/8kSMlL6ft+jXAqJtf89GlF1THoGdmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/374] arm64: dts: qcom: qrb5165-rb5: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:56:33 -0800
Message-ID: <20240122235749.409248255@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit dc6b5562acbac0285ab3b2dad23930b6434bdfc6 ]

There is no "panic-indicator" default trigger but a property with that
name:

  qrb5165-rb5.dtb: leds: led-user4: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: b5cbd84e499a ("arm64: dts: qcom: qrb5165-rb5: Add onboard LED support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111094623.12476-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index d3449cb52def..9ef0afdae148 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -58,8 +58,8 @@ leds {
 		user4 {
 			label = "green:user4";
 			gpios = <&pm8150_gpios 10 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		wlan {
-- 
2.43.0



