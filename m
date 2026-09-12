Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543927AC31;
	Sat, 12 Sep 2026 07:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199942; cv=none; b=KwsR9nLyq2s65Ml2/c5U/GJivu7Gb0OZpPY8jSDWvU/V2V0qF1xdtBhfPOQBpuIXqVR1BS1z8dtrojMjGlA/yrve6VEgsKdPdz4iiDJDsq3iM3XYwaDwMBcx9AsnOQatqLTwSa/I0tcuMg1vwDE+hRtM2dS0Wm4P77pSXWCu9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199942; c=relaxed/simple;
	bh=MujMeVXp0Y3zWNlvxblJQtKOLTIh4JPA7fU4vmDYEtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqjo6StxMOBczr5QoClx/5RFlWACHWS6bSR0JqrX9kgj2XbC5wvk2lv5si1c2vSJjEdWFAICbu8528sP49viWmI7LpcfqRVindgKclFwxh1QIcmk56pQvof3xcNn5/mKHb6Fc62Cyzfdcr4M3TbpVGMA5UhzOoGVwkRFB2UOzV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByWBro/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByWBro/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A320E1F000FF;
	Sat, 12 Sep 2026 07:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199940;
	bh=Bd49nqIPLisd4m3hXlRL8uSONXo4ihfaf68LMB48DkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByWBro/ml9TWhremiH1qHIS/GwN9DTKPfUxydTEPdfg+zFgAYIMyWXUKTA0HCCmDs
	 jHpX6yr3UtjHl/IqnHEk+sljNnrVy2LhjZDkibbB3Yhu+SNcwRgz2ViRPTcv52R+7L
	 Cb+34XOz5eugLabyQnu1Vqc7Sy+QCQwbRdWJZPo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0645/1815] arm64: dts: rockchip: Fix rk3566-bigtreetech-cb2 touchscreen property
Date: Sat, 12 Sep 2026 08:39:55 +0200
Message-ID: <20260912065704.024209954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7707e4555cf1d52689621e3206df8ad2debaa0dd ]

The TSC2007 driver uses the ti,max-rt property to specify the maximum
touch resistance, but the rk3566-bigtreetech-cb2 device tree uses the
undocumented ti,rt-thr property instead.

As a result, the configured value is ignored and the driver falls back
to its default maximum resistance value of 4095.

Replace ti,rt-thr with ti,max-rt to preserve the intended resistance
threshold of 3000.

Fixes: bfbc663d2733 ("arm64: dts: rockchip: Add BigTreeTech CB2 and Pi2")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20260721135450.45286-1-festevam@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
index b6cf03a7ba66b..04cf285e6c2af 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-bigtreetech-cb2.dtsi
@@ -569,7 +569,7 @@ tft_tp: touchscreen@48 {
 		reg = <0x48>;
 		status = "okay";
 		ti,x-plate-ohms = <660>;
-		ti,rt-thr = <3000>;
+		ti,max-rt = <3000>;
 		ti,fuzzx = <32>;
 		ti,fuzzy = <16>;
 	};
-- 
2.53.0



