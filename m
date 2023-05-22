Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D0171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B85C4339E;
	Mon, 22 May 2023 19:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784414;
	bh=aOTX9hXS7Cb5RyrIRLOoship6KJNU88lKkUQzE89pgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILLGtN0JC5hKKfkBjK0dTfKGt+4lmWi5ED3kgc9vHe4W4zBTTibA6jUhNVnQdu3JZ
	 isRRQZYM9KVSjzdOgAh7r9UAlTz7hD2XE9gruFAQv7zi2fcx09JqduCPbI0YAWqkYJ
	 /McvnUfKD6+h6Jlrj3xbwOvmeJcSWB8oZixyqMNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 075/364] arm64: dts: qcom: sdm845-polaris: Drop inexistent properties
Date: Mon, 22 May 2023 20:06:20 +0100
Message-Id: <20230522190414.645184647@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit fbc3a1df2866608ca43e7e6d602f66208a5afd88 ]

Drop the qcom,snoc-host-cap-skip-quirk that was never introduced to
solve schema warnings.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230406-topic-ath10k_bindings-v3-2-00895afc7764@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 1b7fdbae6a2b5..56f2d855df78d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -712,7 +712,5 @@
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
 	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
-
-	qcom,snoc-host-cap-skip-quirk;
 	status = "okay";
 };
-- 
2.39.2



