Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E052584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFC8C433D2;
	Thu, 23 Feb 2023 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157896;
	bh=Xb9zjsWuD2iVWJym7BTZ016iPYFtkt2DOwnW1iLojmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TelKZUsu1qCfrnYO08I97mnklrZlbgq7zA+DmKRwpFyGJPdNr3Kyj7khF1PY81HW
	 WkQB0+hHXy9+jRth//dZpenzAeUv6pljB7yG41bbXz/cuBPu3FHBqq97gnBZ5VEoqW
	 u+an/4b9dgo5NBXgL8hoBWjeDcakXl6FcB+lbpa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Camelia Alexandra Groza <camelia.groza@nxp.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/36] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Date: Thu, 23 Feb 2023 14:06:51 +0100
Message-Id: <20230223130429.781192776@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 8d8bee13ae9e316443c6666286360126a19c8d94 ]

There aren't enough resources to run these ports at 10G speeds. Disable
10G for these ports, reverting to the previous speed.

Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
Link: https://lore.kernel.org/r/20221216172937.2960054-1-sean.anderson@seco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index 74e17e134387d..27714dc2f04a5 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -659,3 +659,19 @@
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
-- 
2.39.0



