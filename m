Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FD66FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEB8C433EF;
	Mon, 16 Jan 2023 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888496;
	bh=blyfxqLSv5GZeaCEmRMoaZLV2VTBXrIYjdiSqc+hSis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ+VOBzejAI5AgG4XTzScT9fu10PgwRVp+2kqz/u3yxjKcnHnVI5D3EscdKPfwdFy
	 Y0D6g0i8B0neRC3r3vDzeGOarIbTCzE34bxkmZ6YqgaDNXpr6TYqBRNVFdP8qnowrR
	 SKy7JQNfSoN7OPpgcLyZ/NVDIXWZnlKZskLsKMl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/338] arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name
Date: Mon, 16 Jan 2023 16:48:21 +0100
Message-Id: <20230116154821.986637559@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 4beaa71107d7..ebe1b5343966 100644
--- a/arch/arm64/boot/dts/mediatek/mt6797.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
@@ -101,7 +101,7 @@ cpu9: cpu@201 {
 		};
 	};
 
-	clk26m: oscillator@0 {
+	clk26m: oscillator-26m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
-- 
2.35.1



