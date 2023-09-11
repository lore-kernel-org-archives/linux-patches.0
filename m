Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A54B11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0898EC433C7;
	Mon, 11 Sep 2023 15:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445114;
	bh=l1kwzk1EbGWURE+1E+5beuO/2IEq8XjnN2i4S1xqz0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBKmvkMBHETmCci7sTdgvEpFJxyPEPzY6KwpdOSGd3QL3i2HkLMFn3LQ3P2FK/Ksg
	 QpBgvMvq6fnoWLSFDioOe3g7IKzBgF/q6HiM/+PsiG0pf6WkRdmKu4mfl6eGIW/Xs7
	 GnKXv22bQmjOwJwPVfG3y2yxQ/ns0kM2YTod2Qes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/600] arm64: dts: qcom: sdm845-tama: Set serial indices and stdout-path
Date: Mon, 11 Sep 2023 15:44:25 +0200
Message-ID: <20230911134640.454226501@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 9acc60c3e2d449243e4c2126e3b56f1c4f7fd3bc ]

UART6 is used for debug (routed via uSD pins) and UART9 is connected
to the bluetooth chip.

Set indexed aliases to make the GENI UART driver happy and route serial
traffic through the debug uart by default.

Fixes: 30a7f99befc6 ("arm64: dts: qcom: Add support for SONY Xperia XZ2 / XZ2C / XZ3 (Tama platform)")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230627-topic-tama_uart-v1-1-0fa790248db8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
index 51ee42e3c995c..d6918e6d19799 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
@@ -14,6 +14,15 @@ / {
 	qcom,msm-id = <321 0x20001>; /* SDM845 v2.1 */
 	qcom,board-id = <8 0>;
 
+	aliases {
+		serial0 = &uart6;
+		serial1 = &uart9;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 
-- 
2.40.1



