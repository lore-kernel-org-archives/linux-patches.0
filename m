Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909B611710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1454EC433C8;
	Mon, 11 Sep 2023 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445266;
	bh=DLac8zRKvget7OzyxUqIsVExlNmQOS18JFZlgucc1rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0TNcCry/QITCa/uJsXfY3HZn9xvfRk6yvjyoemMaIEEfqyCM0vMhkhND+1VDCilw
	 8jHkjDmVCLzMm09rNEsmrEgunLLIJ3MBLYXNgiLxGUfKpyWNyCkEfAecV2+ae1edjq
	 ErNUSorJSTi5p0/shupSi1BMaQATrgJWHy0nrSXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeyan Li <qaz6750@outlook.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/600] arm64: dts: qcom: sm8150: Fix the I2C7 interrupt
Date: Mon, 11 Sep 2023 15:45:18 +0200
Message-ID: <20230911134642.024574063@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Zeyan Li <qaz6750@outlook.com>

[ Upstream commit f9568d22ce06192a7e14bda3a29dc216659554ff ]

I2C6 and I2C7 use the same interrupts, which is incorrect.
In the downstream kernel, I2C7 has interrupts of 608 instead of 607.

Fixes: 81bee6953b58 ("arm64: dts: qcom: sm8150: add i2c nodes")
Signed-off-by: Zeyan Li <qaz6750@outlook.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/SY7P282MB378712225CBCEA95FE71554DB201A@SY7P282MB3787.AUSP282.PROD.OUTLOOK.COM
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 78ae4b9eaa106..f049fb42e3ca8 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1196,7 +1196,7 @@ i2c7: i2c@89c000 {
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&qup_i2c7_default>;
-				interrupts = <GIC_SPI 607 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 608 IRQ_TYPE_LEVEL_HIGH>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
-- 
2.40.1



