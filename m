Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B197AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28F3C433EF;
	Wed,  4 Jan 2023 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848563;
	bh=/6YBYL/70aVDQv7rf9A0L4xHzx5cEiN9LmGscUFdsVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN627347k+a5X9CPbUsV5umOx6/CZyQmNcIqqGe+YccVMhmcnZ8X/U7jPFZrVyUqY
	 IhbheNhHex20rV+GsRSTDcEVnkVOTG/t66ql9BoTkbHYajAiU/tp7PuLGA0nT9DNpH
	 KbIIBYjc8QNaGFlP9ioTjmrxm4Pqu+2EQz0vK6u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 008/207] soc: qcom: Select REMAP_MMIO for ICC_BWMON driver
Date: Wed,  4 Jan 2023 17:04:26 +0100
Message-Id: <20230104160512.178259023@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a84160fbf4f2c8c5ffa588e19ea8f92eabd7ad17 upstream.

ICC_BWMON driver uses REGMAP_MMIO for accessing the hardware registers.
So select the dependency in Kconfig. Without this, there will be errors
while building the driver with COMPILE_TEST only:

ERROR: modpost: "__devm_regmap_init_mmio_clk" [drivers/soc/qcom/icc-bwmon.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:126: Module.symvers] Error 1
make: *** [Makefile:1944: modpost] Error 2

Cc: <stable@vger.kernel.org> # 6.0
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: b9c2ae6cac40 ("soc: qcom: icc-bwmon: Add bandwidth monitoring driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221129072022.41962-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -237,6 +237,7 @@ config QCOM_ICC_BWMON
 	tristate "QCOM Interconnect Bandwidth Monitor driver"
 	depends on ARCH_QCOM || COMPILE_TEST
 	select PM_OPP
+	select REGMAP_MMIO
 	help
 	  Sets up driver monitoring bandwidth on various interconnects and
 	  based on that voting for interconnect bandwidth, adjusting their


