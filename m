Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059DB5102A;
	Mon, 11 Dec 2023 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoXvqi36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5962EC433C8;
	Mon, 11 Dec 2023 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320506;
	bh=xV/9BUlrV4lJQg6GEyzIxHSHphllx9ySeE88CdhHhSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoXvqi369+spPRKU6URLj0c6OrNXQfsCKwqnfNuauomIhs4zq5zPOIY+DY99mBEts
	 Qy9gvAN0HlGq6YHFtdUWE3lgv0ax8R3Ez1kpSHuvffs4rrtFaq8p2Hm87tnUjiqp8S
	 JLMLZumvI+f6BdoE7esoWUUuLYPuZAWJtKUaeXB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/194] arm64: dts: imx8mq: drop usb3-resume-missing-cas from usb
Date: Mon, 11 Dec 2023 19:21:17 +0100
Message-ID: <20231211182040.349982163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit fcd3f50845be909c9e0f8ac402874a2fb4b09c6c ]

The property is NXP downstream property that there is no user
in upstream, drop it.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230323035531.3808192-2-peng.fan@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 209043cf092d ("arm64: dts: imx8mp: imx8mq: Add parkmode-disable-ss-quirk on DWC3")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index bf8f02c1535c1..d3b6874a75238 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1431,7 +1431,6 @@
 			phys = <&usb3_phy0>, <&usb3_phy0>;
 			phy-names = "usb2-phy", "usb3-phy";
 			power-domains = <&pgc_otg1>;
-			usb3-resume-missing-cas;
 			status = "disabled";
 		};
 
@@ -1463,7 +1462,6 @@
 			phys = <&usb3_phy1>, <&usb3_phy1>;
 			phy-names = "usb2-phy", "usb3-phy";
 			power-domains = <&pgc_otg2>;
-			usb3-resume-missing-cas;
 			status = "disabled";
 		};
 
-- 
2.42.0



