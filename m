Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E08AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD63C433D6;
	Thu, 27 Oct 2022 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890432;
	bh=PzNHI3g0Q55PYBrcSnOd02+jdbk95bvg3BuYXKvgvbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ypm1PTkdcA4rmZi25XfezCkAP0zT6bGPPFbdtuPOs6BXxzDdWZdYJbeE65EFd8QNU
	 RUTek9n0KNjYM3y2w2JE88fNwpHwxa+k100dCQjJt0npqX7+/YbeTLkAIieOZVGT+Z
	 qhBO0sADq18aJ2qQrL/R20p3VfJ3aDLm8BNco3Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Green <evgreen@chromium.org>,
	Sibi Sankar <sibis@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alex Elder <elder@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.10 69/79] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory region
Date: Thu, 27 Oct 2022 18:56:19 +0200
Message-Id: <20221027165056.661492250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sibi Sankar <sibis@codeaurora.org>

commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.

The modem firmware memory requirements vary between 32M/140M on
no-lte/lte skus respectively, so fixup the modem memory region
to reflect the requirements.

Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi |    4 ++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi         |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lte-sku.dtsi
@@ -9,6 +9,10 @@
 	label = "proximity-wifi-lte";
 };
 
+&mpss_mem {
+	reg = <0x0 0x86000000 0x0 0x8c00000>;
+};
+
 &remoteproc_mpss {
 	firmware-name = "qcom/sc7180-trogdor/modem/mba.mbn",
 			"qcom/sc7180-trogdor/modem/qdsp6sw.mbn";
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -39,7 +39,7 @@
 		};
 
 		mpss_mem: memory@86000000 {
-			reg = <0x0 0x86000000 0x0 0x8c00000>;
+			reg = <0x0 0x86000000 0x0 0x2000000>;
 			no-map;
 		};
 


