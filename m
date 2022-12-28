Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A131863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1F6C433D2;
	Wed, 28 Dec 2022 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238882;
	bh=/LwiEVsMHxiCwIBQRqfirym4OWaQMf+8G/ygFjOrNOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEkQIAhSn2m2Nzl1zs3mINKYcjA18VHx2HRpKs/cLJhrJJWd0Px/RLTWdblv5qMbT
	 WXWCDa8pATWi+OLjvInqKXOqsFUjftbAa29dRuLqlg3tug1WRZEkNlj+O220gBSwDc
	 DSREQwfKvCt3sKMYe2Oesc8clO15SFh5tOuufX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/731] arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name
Date: Wed, 28 Dec 2022 15:32:32 +0100
Message-Id: <20221228144257.860874504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 5f535cc583759c9c60d4cc9b8d221762e2d75387 ]

Update its unit name to oscillator-26m and remove the unneeded unit
address to fix a unit_address_vs_reg warning.

Fixes: 464c510f60c6 ("arm64: dts: mediatek: add mt6797 support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-9-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6797.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6797.dtsi b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
index 15616231022a..c3677d77e0a4 100644
--- a/arch/arm64/boot/dts/mediatek/mt6797.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
@@ -95,7 +95,7 @@ cpu9: cpu@201 {
 		};
 	};
 
-	clk26m: oscillator@0 {
+	clk26m: oscillator-26m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
-- 
2.35.1



