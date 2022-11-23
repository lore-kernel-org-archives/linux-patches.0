Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B01C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F041CC433D6;
	Wed, 23 Nov 2022 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196694;
	bh=/wrEyLTVPqyePPP+3Umh8BzYv8dk/a6tdOLia5W7AWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc5KtkITGXhhT4QhVsJUxOJSfTJjtsWrLsrunOqiTxfa7VEohD6qqz8SM7PsaGslX
	 iUHRtggUrM6w43/oiiGzCyKhClTI1EcB/Clt9QXwWGGvOZm1g03xxlkBduV7Jl500N
	 S7OUbYE6MwLG7vkzTdwSof2K1G/s/u2MB1RKXI/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 071/314] arm64: dts: qcom: ipq8074: correct APCS register space size
Date: Wed, 23 Nov 2022 09:48:36 +0100
Message-Id: <20221123084628.704773615@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 40b21d466a86bd5b10d24f59746ed41283a9b3f6 ]

APCS DTS addition that was merged, was not supposed to get merged as it
was part of patch series that was superseded by 2 more patch series
that resolved issues with this one and greatly simplified things.

Since it already got merged, start by correcting the register space
size as APCS will not be providing regmap for PLL and it will conflict
with the standalone A53 PLL node.

Fixes: 50ed9fffec3a ("arm64: dts: qcom: ipq8074: add APCS node")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220818220628.339366-8-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index b9bf43215ada..79351c6157ea 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -668,7 +668,7 @@ watchdog: watchdog@b017000 {
 
 		apcs_glb: mailbox@b111000 {
 			compatible = "qcom,ipq8074-apcs-apps-global";
-			reg = <0x0b111000 0x6000>;
+			reg = <0x0b111000 0x1000>;
 
 			#clock-cells = <1>;
 			#mbox-cells = <1>;
-- 
2.35.1



