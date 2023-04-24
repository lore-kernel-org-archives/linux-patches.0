Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB17C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14954C433EF;
	Mon, 24 Apr 2023 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342977;
	bh=/Vv9E/s5GyZt9nBZFKV3OCl+F/T4Q6mhJWQpzX86+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7vsAn8+FZ3J9pF7C8rbeMk3AopCEPu6h07dsXNhRYCN5hlEl0B+VaiV3+r/VCGLx
	 nc8zpqHn75RqVhXjVBlYVW578sje8rt0hXhA66WDLqH6z8xR8kAAI6HJ2iSIQn2x3/
	 PkNm1hvGiavahXpt1OqiFdnKpgTppUWA3Z/veyIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 003/110] arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node
Date: Mon, 24 Apr 2023 15:16:25 +0200
Message-Id: <20230424131136.263130743@linuxfoundation.org>
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

[ Upstream commit 72630ba422b70ea0874fc90d526353cf71c72488 ]

Correct PCIe PHY enablement to refer the QMP device nodes rather than
PHY device nodes. QMP nodes have 'status = "disabled"' property in the
ipq8074.dtsi, while PHY nodes do not correspond to the actual device and
do not have the status property.

Fixes: e8a7fdc505bb ("arm64: dts: ipq8074: qcom: Re-arrange dts nodes based on address")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230324021651.1799969-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index ca3f96646b90d..5cf07caf41033 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -62,11 +62,11 @@
 	perst-gpios = <&tlmm 58 GPIO_ACTIVE_LOW>;
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



