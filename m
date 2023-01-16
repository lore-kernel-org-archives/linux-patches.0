Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCFB6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83681C433EF;
	Mon, 16 Jan 2023 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887124;
	bh=rFYQliizlLXtqt3cIQPTJO+HoY1bHgfJWRUU5MHFMl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Csmd/LIq5oMQnhDng1ZK5INsomd2EN1lb6cYRdK5KE9AZCClYFnUchVBd5RiVitxe
	 X1kiWGpW3QwW6NMAolilqepwb4i+P94wtW2pCZGdg0zp3r7R5nxiqXTu5SZf5qrZWl
	 dLSaMrF3p4pO1XdkfYFYIMDSM0fbeMmFQ+U7Zz9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/521] arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names
Date: Mon, 16 Jan 2023 16:44:52 +0100
Message-Id: <20230116154848.660287655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 377063156893bf6c088309ac799fe5c6dce2822d ]

Update the names to regulator-vproc-buck{0,1} to fix unit_addres_vs_reg
warnings for those.

Fixes: f75dd8bdd344 ("arm64: dts: mediatek: add mt2712 cpufreq related device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-6-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index 4ce9d6ca0bf7..424c22a266c4 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -25,14 +25,14 @@ chosen {
 		stdout-path = "serial0:921600n8";
 	};
 
-	cpus_fixed_vproc0: fixedregulator@0 {
+	cpus_fixed_vproc0: regulator-vproc-buck0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vproc_buck0";
 		regulator-min-microvolt = <1000000>;
 		regulator-max-microvolt = <1000000>;
 	};
 
-	cpus_fixed_vproc1: fixedregulator@1 {
+	cpus_fixed_vproc1: regulator-vproc-buck1 {
 		compatible = "regulator-fixed";
 		regulator-name = "vproc_buck1";
 		regulator-min-microvolt = <1000000>;
-- 
2.35.1



