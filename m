Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316812C7FA;
	Tue, 30 Apr 2024 10:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473940; cv=none; b=g8n6MwIDhgu4ZWBK1jHO23EXcsCQ638tGVC1zpI5qYVU8tEE66B+1McZvXI0BCi1vGVk3TCwWNt7Zzvv158J3WtNjtDHBmJ4iJBMBJSgIpUgKq1JpdvRDCs+HVx7ecARoDtEi8shkyRUuJK+VzFQnIXYTxrFnolxQk7TcK8ekHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473940; c=relaxed/simple;
	bh=IGsDQeYZEEXxJ9vSDTUGLrRFvMmnpp6sfzQzlnDCDX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhLvJD7ayv+8Bj6W8Y2qjX87bsHzLapeeGiIrDM9xqsuUP6oSnXqhiVQCG5MYBbbaQOhyJAtApR3BfbpExQjFXzDzlwIjW1B4zp4rcJtZe07dl8QrTi62xRq9mVSKHeYNsps9Rb0qsBMZ/wxyEkfKJxAvykSRPNrH40tACboglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzJdegfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzJdegfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C014C2BBFC;
	Tue, 30 Apr 2024 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473939;
	bh=IGsDQeYZEEXxJ9vSDTUGLrRFvMmnpp6sfzQzlnDCDX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzJdegfCBUld+xlWnX76lGbSwTpnj48w3cHFF6yWVyrRyBokhMyRcX5v73j6vptSD
	 e6yx2ZBQyw8+vWimQsyOhg4k1L25oE3mwJJnHRd/1cym6+Qz+3sbdU+hI4Tdeppj8W
	 ZLVkoIrbu6105DGn2gQRS5QwlY/AWoCJ/YpeoCWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiyi Lu <weiyi.lu@mediatek.com>,
	Ikjoon Jang <ikjn@chromium.org>,
	Enric Balletbo i Serra <enric.balletbo@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 012/228] arm64: dts: mediatek: mt8183: Add power-domains properity to mfgcfg
Date: Tue, 30 Apr 2024 12:36:30 +0200
Message-ID: <20240430103104.169336406@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ikjoon Jang <ikjn@chromium.org>

[ Upstream commit 1781f2c461804c0123f59afc7350e520a88edffb ]

mfgcfg clock is under MFG_ASYNC power domain.

Fixes: e526c9bc11f8 ("arm64: dts: Add Mediatek SoC MT8183 and evaluation board dts and Makefile")
Fixes: 37fb78b9aeb7 ("arm64: dts: mediatek: Add mt8183 power domains controller")
Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>
Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240223091122.2430037-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 920ee415ef5fb..e1767a4e38f3a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1628,6 +1628,7 @@
 			compatible = "mediatek,mt8183-mfgcfg", "syscon";
 			reg = <0 0x13000000 0 0x1000>;
 			#clock-cells = <1>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_MFG_ASYNC>;
 		};
 
 		gpu: gpu@13040000 {
-- 
2.43.0



