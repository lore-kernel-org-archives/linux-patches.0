Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984AE244661;
	Mon, 20 Apr 2026 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701240; cv=none; b=YUQCCP07fsN6NyZ37KNnjBAxq9uBItNv08QiUnzKRUDtIlfU1n+u+PqkZfSC2pTq+8uFAp8oy8CRiN6uy+Pi5F0QKO42LgGfkJRQ8QgW6nczi+UR7xkADuSHFk2TFs/2yZzLRA8yFOvIFvwXiAzuFK/QviLHnQziExst2fd5AGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701240; c=relaxed/simple;
	bh=JQyOvcqQGIVrHWBCMT4nFEa4AHsNR1jr6MOaVZeey/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJtg+vm41gACG2kns2FI9VncFoK+2mlpzQ8EeVxkopMka7pzhQc5G5RZxkeIck50Qty+/lWYAvGjiyXR4hhCRZ6RbE/qx40KabfWlANVAhFLJTDaJbrJZjrXy7ibFISxW3cZ0wfiLMJU8tIsD4lSG3x9nK7TaKRY4hO3F0H7ppA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kR/wvGf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR/wvGf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEBBC19425;
	Mon, 20 Apr 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701240;
	bh=JQyOvcqQGIVrHWBCMT4nFEa4AHsNR1jr6MOaVZeey/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR/wvGf1M0jCanJFjtsHJC2uOk5KBtabbL+phl6nBigVqgr75cAYMI998/eg1n9jG
	 wa/I7rU+akl/HC2qbw8aXz57EU5m7FyhajFr7dfCOcUXRix4gZoAE6sDKc8saNv+bh
	 f+bceePFU+kRae8bSBnQkF3wNXfMeg0hf9T39Y4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/162] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Mon, 20 Apr 2026 17:41:08 +0200
Message-ID: <20260420153928.335036387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 1f99b5d93d99ca17d50b386a674d0ce1f20932d8 ]

According to i.MX 8M Quad Reference Manual, GPU_AHB_CLK_ROOT's maximum
frequency is 400MHz.

Fixes: 45d2c84eb3a2 ("arm64: dts: imx8mq: add GPU node")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index e03186bbc4152..c4395de0df762 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1636,7 +1636,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



