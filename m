Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3485111C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EE7C433EF;
	Mon, 12 Jun 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567019;
	bh=YMsX/jbft63DgDRxBm9uxcfYUlL7VMyidwIcURGMCDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2J5ddVJ3ufrr7Nt9vcZ7H7vWS7zeZF9lDhO4l+1JNnFpUiCLOwhrxZ4kfa7zS1NuN
	 9213VL8cXFTBQ7XKsvkqRlOj6PbZYRa4285STQaNFiFtYBQ5CV6V1hA1TIh0Q05dFM
	 ozwOu1k+oKBv0lNU6Z8BHi6lcX2vfN8KHCPrOYWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 120/160] arm64: dts: qcom: sm6375-pdx225: Fix remoteproc firmware paths
Date: Mon, 12 Jun 2023 12:27:32 +0200
Message-ID: <20230612101720.547799093@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
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

[ Upstream commit a14da6144d16ef27e3022835fa282a3740b8ad7b ]

They were previously missing the SoC name. Fix it.

Fixes: a2ad207c412b ("arm64: dts: qcom: sm6375-pdx225: Enable ADSP & CDSP")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230517-topic-murray-fwname-v1-1-923e87312249@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375-sony-xperia-murray-pdx225.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6375-sony-xperia-murray-pdx225.dts b/arch/arm64/boot/dts/qcom/sm6375-sony-xperia-murray-pdx225.dts
index b691c3834b6b6..71970dd3fc1ad 100644
--- a/arch/arm64/boot/dts/qcom/sm6375-sony-xperia-murray-pdx225.dts
+++ b/arch/arm64/boot/dts/qcom/sm6375-sony-xperia-murray-pdx225.dts
@@ -151,12 +151,12 @@ &qupv3_id_1 {
 };
 
 &remoteproc_adsp {
-	firmware-name = "qcom/Sony/murray/adsp.mbn";
+	firmware-name = "qcom/sm6375/Sony/murray/adsp.mbn";
 	status = "okay";
 };
 
 &remoteproc_cdsp {
-	firmware-name = "qcom/Sony/murray/cdsp.mbn";
+	firmware-name = "qcom/sm6375/Sony/murray/cdsp.mbn";
 	status = "okay";
 };
 
-- 
2.39.2



