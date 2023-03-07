Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BD4BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE3C4339E;
	Tue,  7 Mar 2023 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212160;
	bh=4GUtBWMX+AypxFqzqyVpo2AMVvZ0Vbp10oWwUTeCDfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdoatmVygvPPfUUocmlkjAWlD+EWaiIbNu6CVAp2sPEwaiaJMEjDBOLwKDKzFUdFw
	 J9YoUKtN1k1gLee47+p3bQyq09on6a2cssyppI6tErRdGk8S8eWYtUyAVehIwzQOdE
	 0c+umMxRP0CXd1vvg/pj1R/M55+MPBoBu80zB2nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/885] arm64: dts: mt8186: Fix CPU map for single-cluster SoC
Date: Tue,  7 Mar 2023 17:50:13 +0100
Message-Id: <20230307170005.237676537@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 1c473804b0c8a68c6ef2cf519b38ec6725ca4aa5 ]

MT8186 features the ARM DynamIQ technology and combines both two
Cortex-A76 (big) and six Cortex-A55 (LITTLE) CPUs in one cluster:
fix the CPU map to reflect that.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 2e78620b1350 ("arm64: dts: Add MediaTek MT8186 dts and evaluation board and Makefile")
Link: https://lore.kernel.org/r/20230126103526.417039-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index fb32e3efcdb12..48e15c8ad3b95 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -47,14 +47,12 @@ core4 {
 				core5 {
 					cpu = <&cpu5>;
 				};
-			};
 
-			cluster1 {
-				core0 {
+				core6 {
 					cpu = <&cpu6>;
 				};
 
-				core1 {
+				core7 {
 					cpu = <&cpu7>;
 				};
 			};
-- 
2.39.2



