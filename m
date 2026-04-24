Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F183D47B0;
	Fri, 24 Apr 2026 13:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037678; cv=none; b=mrUjpQrmfuR79whh+9sTrKK+UTwe952ptQTLI5gNviEuqCQjGGJFbTriwukibrPskfkVwwvbYUcN6E2P2X9E2KQVatH7cA6Kt2p657goB3OwzXcizpb5SOlh2yjEBuJrHawvMICQJuwEXmt7xdxYx5mFLdjKqx76HH4/bF0FI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037678; c=relaxed/simple;
	bh=jUYZPyqO5hw7jA5EAv3FVX9Ot8NIKf/T1ngugiv9aMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuNYWkPbIlzf4MR8E6c4qb7osnMv7cqGeBdCEirDgLmylZDBOkJk/F0GMco5xPJixd3PTuFTxRlYLeo19t6WREwFRJ0SQbCspF3WrFoAFqQRfQVb2x28O1HDS00FPttevjZAkcThg02s6Xq8YvxUk3UQbfWHd1iaakBs9JBjb5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9hsMWxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9hsMWxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC22C19425;
	Fri, 24 Apr 2026 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037678;
	bh=jUYZPyqO5hw7jA5EAv3FVX9Ot8NIKf/T1ngugiv9aMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9hsMWxX4l/tDKIt5ax/WcYGbwnxZkxhZtt4VP0ZW74ePJ/SBOrx7DLmokeZXZfQu
	 kyhbhJWF751vQVGa4h4MSPMtN5qNT7NGnZQe8XZjU4E5+s6XJoL7LwV/B0MER7bMQE
	 o02w2AMyMGKnF4yVvvHKbhc3wG8Bv30hQQyCxNZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/166] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Fri, 24 Apr 2026 15:29:02 +0200
Message-ID: <20260424132538.727026842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 052ba9baa400f..6b93fff5e97d0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1629,7 +1629,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



