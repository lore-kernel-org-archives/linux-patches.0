Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFE8848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62EC433EF;
	Fri, 10 Mar 2023 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458046;
	bh=GdbKForBwhzdKtaiuUPQIKix80NxJ489Hcmiv1XOYZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKqc2dfUqEmgA5noKR6/OzukpHwSX1JeaVWg16t1qI7ZtLrafgb4CO4S/D38WDd9R
	 /pXxl7U1GGZ+F5L4Nk79Y3/cfXfEuncQIafq2uMGDS+BqxT+7e1n7gnbTBRWJgtUNh
	 6ZbKwym8S7YDCuDlQN4ETXjgxd9QAK5hg9riGLb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 4.19 145/252] ARM: dts: exynos: correct HDMI phy compatible in Exynos4
Date: Fri, 10 Mar 2023 14:38:35 +0100
Message-Id: <20230310133723.184061105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

commit af1c89ddb74f170eccd5a57001d7317560b638ea upstream.

The HDMI phy compatible was missing vendor prefix.

Fixes: ed80d4cab772 ("ARM: dts: add hdmi related nodes for exynos4 SoCs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230125094513.155063-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -611,7 +611,7 @@
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};


