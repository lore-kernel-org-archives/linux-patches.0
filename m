Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413CA51038;
	Mon, 11 Dec 2023 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hP+ZqtqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AFFC433C7;
	Mon, 11 Dec 2023 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319415;
	bh=CKzijnam8wNPK1B2bNggF6AbVIfWqDbJxWOlw4RU8i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP+ZqtqFcT7qA2P9ev2P26SdKxOCiDrDa00aoeETe8SntjmArbZKx19wzxxwJpA7Z
	 1Ix5ZxGePGkxkBV/S9TyW6VyAcb8BJueP6TO6Uy9zyB1qixBYv/Brubx7/9WCNSA01
	 lgWQak3ie4P8CEcH6oAv//QtB+vZksctmnBEfgNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/244] ARM: dts: imx6q: skov: fix ethernet clock regression
Date: Mon, 11 Dec 2023 19:19:49 +0100
Message-ID: <20231211182050.083588445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kerkmann <s.kerkmann@pengutronix.de>

[ Upstream commit 6552218f4dc47ba3c6c5b58cc1e9eb208a2b438b ]

A regression was introduced in the Skov specific i.MX6 flavor
reve-mi1010ait-1cp1 device tree causing the external ethernet controller
to not being selected as the clock source for the i.MX6 ethernet MAC,
resulting in a none functional ethernet interface. The root cause is
that the ethernet clock selection is now part of the clocks node, which
is overwritten in the specific device tree and wasn't updated to contain
these ethernet clocks.

Fixes: c89614079e44 ("ARM: dts: imx6qdl-skov-cpu: configure ethernet reference clock parent")
Signed-off-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dts b/arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dts
index a3f247c722b43..0342a79ccd5db 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-skov-reve-mi1010ait-1cp1.dts
@@ -37,9 +37,9 @@
 
 &clks {
 	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
-			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>;
+			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>, <&clks IMX6QDL_CLK_ENET_REF_SEL>;
 	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
-				 <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>;
+				 <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>, <&clk50m_phy>;
 };
 
 &hdmi {
-- 
2.42.0



