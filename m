Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A4611705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B37C433C7;
	Mon, 11 Sep 2023 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443020;
	bh=tM/VbfWaSJjGqJVAE2a9DhmSMTw089Dje6K0HT+g01s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+WX+DdSr88UN1ams4d1Xc9/Sd+N1z35LdFifmpUsJd22yx5nkWBHHG5ecpVQkS3r
	 X42GxT66LY8P5DiRpE29l2dotR+CsuqMbcuqhQISCg4Rq5RiBpZu+psuBa2s+sQFVR
	 UJLZ4nWdhORDiayYYGmK1Bpi8n7R4tDCqB6YAG0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 229/737] ARM: dts: Add .dts files missing from the build
Date: Mon, 11 Sep 2023 15:41:28 +0200
Message-ID: <20230911134656.974169448@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 86684c2481b6e6a46c2282acee13554e34e66071 ]

Comparing .dts files to built .dtb files yielded a few .dts files which
are never built. Add them to the build.

Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 92632115fb57 ("samples/bpf: fix bio latency check with tracepoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 59829fc903152..3cf1bf724e8ed 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -335,6 +335,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += \
 	kirkwood-iconnect.dtb \
 	kirkwood-iomega_ix2_200.dtb \
 	kirkwood-is2.dtb \
+	kirkwood-km_fixedeth.dtb \
 	kirkwood-km_kirkwood.dtb \
 	kirkwood-l-50.dtb \
 	kirkwood-laplug.dtb \
@@ -880,7 +881,10 @@ dtb-$(CONFIG_ARCH_OMAP3) += \
 	am3517-craneboard.dtb \
 	am3517-evm.dtb \
 	am3517_mt_ventoux.dtb \
+	logicpd-torpedo-35xx-devkit.dtb \
 	logicpd-torpedo-37xx-devkit.dtb \
+	logicpd-torpedo-37xx-devkit-28.dtb \
+	logicpd-som-lv-35xx-devkit.dtb \
 	logicpd-som-lv-37xx-devkit.dtb \
 	omap3430-sdp.dtb \
 	omap3-beagle.dtb \
@@ -1561,6 +1565,8 @@ dtb-$(CONFIG_MACH_ARMADA_38X) += \
 	armada-388-helios4.dtb \
 	armada-388-rd.dtb
 dtb-$(CONFIG_MACH_ARMADA_39X) += \
+	armada-390-db.dtb \
+	armada-395-gp.dtb \
 	armada-398-db.dtb
 dtb-$(CONFIG_MACH_ARMADA_XP) += \
 	armada-xp-axpwifiap.dtb \
@@ -1590,6 +1596,7 @@ dtb-$(CONFIG_MACH_DOVE) += \
 dtb-$(CONFIG_ARCH_MEDIATEK) += \
 	mt2701-evb.dtb \
 	mt6580-evbp1.dtb \
+	mt6582-prestigio-pmt5008-3g.dtb \
 	mt6589-aquaris5.dtb \
 	mt6589-fairphone-fp1.dtb \
 	mt6592-evb.dtb \
@@ -1645,6 +1652,7 @@ dtb-$(CONFIG_ARCH_ASPEED) += \
 	aspeed-bmc-intel-s2600wf.dtb \
 	aspeed-bmc-inspur-fp5280g2.dtb \
 	aspeed-bmc-inspur-nf5280m6.dtb \
+	aspeed-bmc-inspur-on5263m5.dtb \
 	aspeed-bmc-lenovo-hr630.dtb \
 	aspeed-bmc-lenovo-hr855xg2.dtb \
 	aspeed-bmc-microsoft-olympus.dtb \
-- 
2.40.1



