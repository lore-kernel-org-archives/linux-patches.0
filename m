Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010418BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C9C4339B;
	Tue, 28 Mar 2023 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015162;
	bh=PRtLUM+zgybqSlW1JB0nIIr0vSASBJDGrzukTx/77Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKFm6qYfTve0hpo7bwEH78EK+giFZi65d3XrT4sOgBjaDHFFeTxxZfHy488gysCN7
	 D8mRfuCJ+v1iwEZNGzy1HrcHMiRwnCA4dngTc0mzbOvuz6XrK0OjJMXE4T3iF9PZEW
	 DDgOX6YeaakYaUUbj3Zj3kHQ5ynES9f4m3s39dIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.2 188/240] arm64: dts: imx8mm-nitrogen-r2: fix WM8960 clock name
Date: Tue, 28 Mar 2023 16:42:31 +0200
Message-Id: <20230328142627.468965699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

commit 32f86da7c86b27ebed31c24453a0713f612e43fb upstream.

The WM8960 Linux driver expects the clock to be named "mclk".  Otherwise
the clock will be ignored and not prepared/enabled by the driver.

Fixes: 40ba2eda0a7b ("arm64: dts: imx8mm-nitrogen-r2: add audio")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -247,7 +247,7 @@
 		compatible = "wlf,wm8960";
 		reg = <0x1a>;
 		clocks = <&clk IMX8MM_CLK_SAI1_ROOT>;
-		clock-names = "mclk1";
+		clock-names = "mclk";
 		wlf,shared-lrclk;
 		#sound-dai-cells = <0>;
 	};


