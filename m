Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5157C8F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF844C433C7;
	Sun, 16 Jul 2023 20:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539984;
	bh=ZeDljBdDc0QoLZkbRj9/vd/LKtwCLqaIdlAM1oGstK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN2Y6pXPJoogFdtLaT5zYjDC3ZJwyrzmeiqwgl9oC4kFTKSow8aW0Vt1VI5WfKIvR
	 GygWGMly3gzPzWP9+EpBIj5IeG14gXHykjp6fiIjN1KiiIy9tinW8PCfliSVf0B6l3
	 BPokxwQsdjYSvKOIu7FNB2VRftK51as5ISCjJl4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Molly Sophia <mollysophia379@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/591] arm64: dts: qcom: sdm845-polaris: add missing touchscreen child node reg
Date: Sun, 16 Jul 2023 21:45:41 +0200
Message-ID: <20230716194929.095479804@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 4a0156b8862665a3e31c8280607388e3001ace3d ]

Add missing reg property to touchscreen child node to fix dtbs W=1 warnings:

  Warning (unit_address_vs_reg): /soc@0/geniqup@ac0000/i2c@a98000/touchscreen@20/rmi4-f12@12: node has a unit name, but no reg or ranges property

Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Molly Sophia <mollysophia379@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-18-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 74c6832e05985..093b04359ec39 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -484,6 +484,7 @@ rmi4-f01@1 {
 		};
 
 		rmi4-f12@12 {
+			reg = <0x12>;
 			syna,rezero-wait-ms = <0xc8>;
 			syna,clip-x-high = <0x438>;
 			syna,clip-y-high = <0x870>;
-- 
2.39.2



