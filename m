Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7E314A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0154C433C7;
	Wed,  9 Aug 2023 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577844;
	bh=VBuhYHtB02KKxwHx70ljziQTH5+PePzK7p1OymMm1oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvS9JrRDTOgsizjFTPwGQNtAu75NiF0mHzaOsfQIftt5o1mdLdJITmBHZNHDRHOFa
	 Rzy3gPanKTstcgFoOT5YTO3Zu2BpYLRgVm0v7gvi4JMCuKZXMWelmXeT/qqom5yuNd
	 KQBPnMdRZrNjjQacuWikF9eJDGcKxCv/jVGgp1KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 015/165] ARM: dts: nxp/imx: limit sk-imx53 supported frequencies
Date: Wed,  9 Aug 2023 12:39:06 +0200
Message-ID: <20230809103643.276652094@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
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

[ Upstream commit c486762fb17c99fd642beea3e1e4744d093c262a ]

The SK-IMX53 board, bearing i.MX536A CPU, is not stable when running at
1.2 GHz (default iMX53 maximum). The SoC is only rated up to 800 MHz.
Disable 1.2 GHz and 1 GHz frequencies.

Fixes: 0b8576d8440a ("ARM: dts: imx: Add support for SK-iMX53 board")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-sk-imx53.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx53-sk-imx53.dts b/arch/arm/boot/dts/imx53-sk-imx53.dts
index 103e73176e47d..1a00d290092ad 100644
--- a/arch/arm/boot/dts/imx53-sk-imx53.dts
+++ b/arch/arm/boot/dts/imx53-sk-imx53.dts
@@ -60,6 +60,16 @@
 	status = "okay";
 };
 
+&cpu0 {
+	/* CPU rated to 800 MHz, not the default 1.2GHz. */
+	operating-points = <
+		/* kHz   uV */
+		166666  850000
+		400000  900000
+		800000  1050000
+	>;
+};
+
 &ecspi1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_ecspi1>;
-- 
2.40.1



