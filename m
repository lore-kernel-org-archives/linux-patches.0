Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ADD21018A;
	Tue, 17 Jun 2025 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176505; cv=none; b=WnPYWWtOCRbbYZGfCF7+HVlJIZnNegjTt3raJ3lHRBFdD8Hgtc1NldF1laezUhQO8Ga/gieIIbiviP4QVvyjovkZ2So+xtlM5EdLHWm5RgEpREjirA7zfG9rOC4sOrlAeRmIHNuVPUxb6t4Law+uyyPdQAYPBpZd5AbMR3rHSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176505; c=relaxed/simple;
	bh=aHBy57Jgh9uSdzE161VgKUj4y6MSdOuHmt9A8TgFZV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JydG7xsYPX2iK1juzcR83LdzxjVzixPgSVGDEZqGrryeZUlRGbibKXz3Hdy/c2VeL+1dgBSDzeVzsfanyfz9Wdkpa780jMQU6dpEH9KwBa48LGkJ0xF5siMqfyi2jk2wat+jRAsWV9I1OXPjPqWfH3unPViFDtfYWpM2JsQV/qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxofhALQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxofhALQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D3DC4CEE3;
	Tue, 17 Jun 2025 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176505;
	bh=aHBy57Jgh9uSdzE161VgKUj4y6MSdOuHmt9A8TgFZV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxofhALQtmTl3M3Ds7JPgGRu6sbwSCpCOFF/Po3yp8LCndCR5F0IN/xUCjd8lpBP4
	 DfjDGphjYBd93mjA3DSTnfZ4i9NkiWNt3QdRndjBj+fsn7ThwPlmWKG1+ePAdetVJt
	 2wB51AQ/zCRMG0p3FflgctUnsGNkoBo8G4SMaZwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/512] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:23:22 +0200
Message-ID: <20250617152429.186082435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2e98d456666d63f897ba153210bcef9d78ba0f3a ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 62ed64663f495..9ba0cb89fa24e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -233,6 +233,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



