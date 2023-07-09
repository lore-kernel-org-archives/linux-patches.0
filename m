Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CFC522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D812C433C9;
	Sun,  9 Jul 2023 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902091;
	bh=VG9bn1XSTYn5KbuMOla46P1+L12uWP5L90tr1OfucO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wy9iD3XbtiqwJ+y3X2UjBYrLTso3nlH2JfD+d/0zZYmVlI5A8qw9iLEkts+Yu0n1Z
	 pl+FMKEuSBqJGSlE2GbS5wH8n9Jq6LE1hYZM0/0v5HqzOG7S+IEoLubGPbe0wH2Jbl
	 jVsYSxVbIs/SpeHmfIFgO05RAtHuzwYgqsTQc2hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 253/431] ARM: dts: qcom: apq8074-dragonboard: Set DMA as remotely controlled
Date: Sun,  9 Jul 2023 13:13:21 +0200
Message-ID: <20230709111457.086675280@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e60c230588d88036f974cec7e93361e2c4f62226 ]

Add the qcom,controlled-remotely property for the blsp2_bam
controller node. This board requires this, otherwise the board stalls
during the boot for some reason (most probably because TZ mishandles the
protection error and keeps on looping somewhere inside).

Fixes: 62bc81792223 dts: msm8974: Add blsp2_bam dma node
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230507190735.2333145-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index 1345df7cbd002..6b047c6793707 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -23,6 +23,10 @@ &blsp1_uart2 {
 	status = "okay";
 };
 
+&blsp2_dma {
+	qcom,controlled-remotely;
+};
+
 &blsp2_i2c5 {
 	status = "okay";
 	clock-frequency = <200000>;
-- 
2.39.2



