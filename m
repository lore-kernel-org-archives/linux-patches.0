Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDCC7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2D0C433EF;
	Mon, 24 Apr 2023 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342980;
	bh=eGv4a4FzWkg5bY8vQUaTgYzHjCdabyFPX1mabeIPR2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxMHmTD8wuKqS7n0p7xxILbgA2Kaiof1L8LVPhWeA8fuutODdNWXRw+yxCm4p0nMU
	 I7x+sAl6PWXwQ9rVIArnWgS1RwangyO9WcWqLxM1ao2MM/aP1VwUpGNfZbHFx7DC6x
	 6iNe2/ovL0vbwo8QO/W3Reloz/vXPA2otzq3luH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 004/110] arm64: dts: qcom: ipq8074-hk10: enable QMP device, not the PHY node
Date: Mon, 24 Apr 2023 15:16:26 +0200
Message-Id: <20230424131136.296045403@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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

[ Upstream commit 1dc40551f206d20b7e46ea7dd538dcdd928451c6 ]

Correct PCIe PHY enablement to refer the QMP device nodes rather than
PHY device nodes. QMP nodes have 'status = "disabled"' property in the
ipq8074.dtsi, while PHY nodes do not correspond to the actual device and
do not have the status property.

Fixes: 1ed34da63a37 ("arm64: dts: qcom: Add board support for HK10")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230324021651.1799969-2-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
index 651a231554e0b..1b8379ba87f9c 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk10.dtsi
@@ -48,11 +48,11 @@
 	perst-gpios = <&tlmm 61 GPIO_ACTIVE_LOW>;
 };
 
-&pcie_phy0 {
+&pcie_qmp0 {
 	status = "okay";
 };
 
-&pcie_phy1 {
+&pcie_qmp1 {
 	status = "okay";
 };
 
-- 
2.39.2



