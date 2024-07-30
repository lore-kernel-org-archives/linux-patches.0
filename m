Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01B6187FF2;
	Tue, 30 Jul 2024 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355451; cv=none; b=eC3kdfuGqZBZO8TvsH8+9iqaP7KYfexJYo2oPy8Va9hwveKQKT45MRMPoaDF40u36uY73yhm9vGxrLOjA34UryrnyPqAnGReft3WN0WSU0andsonZP1t5LLnPsdrDsADPOuiZP8ncBbzCho02PpVYbqTqlHMPka8+E4+5xLjTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355451; c=relaxed/simple;
	bh=xquWXPB5ox80mLe6BSR5C6vhbqKzIrw8yuI5shvNOpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khmXZodBQ/en9HicmmeUD37ih4pURAgiLJvY0KzB+JBrJeePj6JMnzBEeV8gfxXdRZBvMWFPfTR6jLxdpdUduraVE/TlVZAnSUcoglA+7e+FfOMfXkpmnbbc7jMeKfKEkUjD1fN+MBXtBg/HNSoMuG7yeMgVLS3/t0G7Hs+VJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vz6JGfqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz6JGfqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D119C32782;
	Tue, 30 Jul 2024 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355451;
	bh=xquWXPB5ox80mLe6BSR5C6vhbqKzIrw8yuI5shvNOpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vz6JGfqy7IUpC82q5rsyYfWdU79khSbpqa4plq97oqSRHc5abxrR2kadKmkMHjg0s
	 464llr8nbYFA9q3gHPH9HdtC4tDD8RUfEp5AhnRskS+jOBD2RE2HcDRNHiE9S4xYWm
	 Flk6zA9vsnkpdXl47UW/bLQVcVWVMcUhyDSYfXYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/568] arm64: dts: qcom: qdu1000-idp: drop unused LLCC multi-ch-bit-off
Date: Tue, 30 Jul 2024 17:42:46 +0200
Message-ID: <20240730151642.164513069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

[ Upstream commit 468cf125e4796e8ef9815e2d8d018f44cf8f1225 ]

There is no "multi-ch-bit-off" property in LLCC, according to bindings
and Linux driver:

  qdu1000-idp.dtb: system-cache-controller@19200000: 'multi-ch-bit-off' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20231107080417.16700-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 367fb3f0aaa6 ("arm64: dts: qcom: qdu1000: Add secure qfprom node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index 1c0e5d271e91b..1ef87604549fa 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -1452,7 +1452,6 @@ system-cache-controller@19200000 {
 				    "llcc_broadcast_base",
 				    "multi_channel_register";
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
-			multi-ch-bit-off = <24 2>;
 		};
 	};
 
-- 
2.43.0



