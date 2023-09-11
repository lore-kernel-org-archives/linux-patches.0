Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E486511705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EF8C433C7;
	Mon, 11 Sep 2023 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443262;
	bh=tY21J9NDDCWjGRnK6vEGmUIdDXd2ULewqYjOugd6Sws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GN332B/+xCSMyc+euCAN/1iiNLdnH7NuXNewb35aDt+IxpHHwp8auUuL0YEf98Xj
	 Mi8993LC/0cXViRssNT0q2euhggL80OodakCvBmsQxDlYA7qceR98PfJolxEN+4ir1
	 RWXX0rXU3HxamQ9+UqSg3Et/7OD25hXiFjr95Dm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 316/737] arm64: dts: qcom: pm660l: Add missing short interrupt
Date: Mon, 11 Sep 2023 15:42:55 +0200
Message-ID: <20230911134659.390141865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 9a4ac09db3c7413e334b4abd6b2f6de8930dd781 ]

Add the missing short interrupt. This fixes the schema warning:

wled@d800: interrupt-names: ['ovp'] is too short

Fixes: 7b56a804e58b ("arm64: dts: qcom: pm660l: Add WLED support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230626-topic-bindingsfixups-v1-4-254ae8642e69@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm660l.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm660l.dtsi b/arch/arm64/boot/dts/qcom/pm660l.dtsi
index 87b71b7205b85..6fdbf507c262a 100644
--- a/arch/arm64/boot/dts/qcom/pm660l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm660l.dtsi
@@ -74,8 +74,9 @@ pm660l_lpg: pwm {
 		pm660l_wled: leds@d800 {
 			compatible = "qcom,pm660l-wled";
 			reg = <0xd800>, <0xd900>;
-			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "ovp";
+			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>,
+				     <0x3 0xd8 0x2 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "ovp", "short";
 			label = "backlight";
 
 			status = "disabled";
-- 
2.40.1



