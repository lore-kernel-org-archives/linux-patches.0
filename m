Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7000619AD93;
	Tue, 16 Jul 2024 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145194; cv=none; b=VgaCiI7GsRMly+wJ1h2CNxgTm5TBoJN7dqUvIcdQ/oPp8XkvyTC8/z6zb55+7sOaV0TYjZmUtBMfZTI6GC7wlodYnijYqBnT4ssdskbq38ckrL7PKS6JMLZ1iL+SmoGFZJZOg5JBJuTtFgRsJOw6ku2K08lH+fvZmeCeNJvesFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145194; c=relaxed/simple;
	bh=uEBRN6c6H873oOGN0xArC1JYthuJ+Fx6dWW3xP2BrJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuW+HA6cCLUwR9KD6ZsmvT26R8kGudIf1zrEivsphRs23OA81CdbIacj8kYoBzwtG0hc4h+079hLCBom5ARqDXSJpgiE/PrcADDYCDn92fzh8DxGv+MqT50DUHgZm/GvCGGu3KwBUYFDC9XLNmYm3ZW6PTH0VVx8gWtqRpoDMeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m214Sf9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m214Sf9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB138C116B1;
	Tue, 16 Jul 2024 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145194;
	bh=uEBRN6c6H873oOGN0xArC1JYthuJ+Fx6dWW3xP2BrJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m214Sf9ALGMg4BTA62cSpO6RJGJ0sYYomA6V1FMGF0iSXByh/UqIfa1CwsQTIqC4z
	 Nw9BRpiphT13Pcf6h/CibhY2q9+SzWdSQk3Vv7L8p3IQmYQG9Zf8Baj+w2Gj32EGzn
	 bEvIFEoGZG4mZ3GF15Eap+N+67meWpvTrQcVtwxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 097/143] arm64: dts: qcom: x1e80100-crd: fix WCD audio codec TX port mapping
Date: Tue, 16 Jul 2024 17:31:33 +0200
Message-ID: <20240716152759.709689332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit dfce1771680c70a437556bc81e3e1e22088b67de upstream.

Starting with the LPASS v11 (SM8550 also X1E80100), there is an
additional output port on SWR2 Soundwire instance, thus WCD9385 audio
codec TX port mapping should be shifted by one.  This is a necessary fix
for proper audio recording via analogue microphones connected to WCD9385
codec (e.g. headset AMIC2).

Fixes: 229c9ce0fd11 ("arm64: dts: qcom: x1e80100-crd: add WCD9385 Audio Codec")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240611142555.994675-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -736,7 +736,7 @@
 	wcd_tx: codec@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
-		qcom,tx-port-mapping = <1 1 2 3>;
+		qcom,tx-port-mapping = <2 2 3 4>;
 	};
 };
 


