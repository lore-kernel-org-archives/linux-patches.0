Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB161863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B94C433EF;
	Wed, 28 Dec 2022 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240144;
	bh=LU4Q6uhJSIfxsEceo+8g7BUkflTb0h4W+vhSn01/C0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GY5RSai6J79AgnuNkEWXzRIgLCNjRhmj1/pry54/tgsVDxbLLghjalk1U38w4ns+7
	 KMdyr1MNrcUHQpJjB8dVwdNDqioi5jBgTfLQz4+0c1Egbs/SRyctRbI3pQE7O02WTJ
	 S6KsBOaCawMk+qVj7/6zRU2SRr8k3uFet2vglP20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0065/1146] arm64: dts: ti: k3-j7200-mcu-wakeup: Drop dma-coherent in crypto node
Date: Wed, 28 Dec 2022 15:26:44 +0100
Message-Id: <20221228144331.924945669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit f00f26711d7183f8675c5591ba8daaabe94be452 ]

crypto driver itself is not dma-coherent. So drop it.

Fixes: d683a73980a6 ("arm64: dts: ti: k3-j7200-mcu-wakeup: Add SA2UL node")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Link: https://lore.kernel.org/r/20221031152520.355653-4-j-choudhary@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index e5be78a58682..d3fb86b2ea93 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -386,7 +386,6 @@ mcu_crypto: crypto@40900000 {
 		dmas = <&mcu_udmap 0xf501>, <&mcu_udmap 0x7502>,
 		       <&mcu_udmap 0x7503>;
 		dma-names = "tx", "rx1", "rx2";
-		dma-coherent;
 
 		rng: rng@40910000 {
 			compatible = "inside-secure,safexcel-eip76";
-- 
2.35.1



