Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A42EE271;
	Tue, 17 Jun 2025 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177858; cv=none; b=C3aukuuFrh1a9R7I9jOCCk3hDeOmzaU+04sWfC0kwWpaVqdmED7HoQgSe+3UyYn5lsVbW1NqUr7GSyWYXHU3DO7JN1amp4sU+uyEq/hrIaKC1kAESOza65EZ1OPBMweXIv6C1jRxCM+s3Rbed33Iq/dI7DgUfA+md2WpV3/7Ri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177858; c=relaxed/simple;
	bh=gPHH71KBIWa0hFdd4FLHy3Cth1uR4DmvEFJ8k4ww2Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFQaeZr00/j7LCQGjb4pOLNkm3JMqBqmJFc5K/Od+QAFUiFQ339KFfirp0JPOtx18Q32ZpjW+KHtoKfblQZp4tZ9NA86u8xZFcFC5pTHNMNn7EMOvXIaJhe5nu6VjSza5s3SdTOPh36zqSfSuPCUJUq8lCX2aPMkobhK5XoMWZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxIAeBMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxIAeBMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE44C4CEE3;
	Tue, 17 Jun 2025 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177858;
	bh=gPHH71KBIWa0hFdd4FLHy3Cth1uR4DmvEFJ8k4ww2Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxIAeBMC29iIA5hcszPvk61sxyKB38fO26ZTK+NudCClW4v0fPOx56Hx+PO73sjzp
	 Pd21lNc1oUMwKX6P+V3IjWKFLz8PBRBP+RyJ9ELfxdLM8hlN9T71TeJHTJJw+XjQhc
	 pwOSdaFyB8ByXkyS5YWJKDTxfdINtRpkk2V0WHDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 373/780] arm64: dts: imx8mn-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:21:21 +0200
Message-ID: <20250617152506.647414896@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit c3f03bec30efd5082b55876846d57b5d17dae7b9 ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 36ca3c8ccb53 ("arm64: dts: imx: Add Beacon i.MX8M Nano development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index 2a64115eebf1c..bb11590473a4c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -242,6 +242,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



