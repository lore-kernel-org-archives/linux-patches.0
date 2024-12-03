Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D56B1F130E;
	Tue,  3 Dec 2024 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238210; cv=none; b=eNJOsuRkFQhAQwv4syOpvy0N4BvYK8geSRjMHKaGvMZxod5KL7lhI2Pyv0/GishKSJ9DWuiskG50RbT56GOJCFguH8wpoaQfHSN3Ois16VlY90pxaVDj2gzGnpS+S9ehBLJzmy6Lk8DZkPTBr6xHUGZNAnRYpRLwkhYzjS/k90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238210; c=relaxed/simple;
	bh=soNMo/FtRvZEvEN/mkmq5twAiJJdXaczcjmUgH2I49E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOVTFJmu/5Z7Q4N8zduuBJWsT7BqnSUMqMVl9Tvhrt5/vDcQjxVkTD+wWUP30RihWDM7t/ypdMC4J9Mp4MG66DKHnUuCsO55QKV1qorN4DcKfZmzIuxC/AkdhJLLMrdsz6oxvRe+GpQB5kCgEOaP8Hw2N+sCr25LspZMT8G/4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnyrqK3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnyrqK3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC60C4CECF;
	Tue,  3 Dec 2024 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238210;
	bh=soNMo/FtRvZEvEN/mkmq5twAiJJdXaczcjmUgH2I49E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnyrqK3KRc6/bqHq/QE4A6pzRAlklGL4TgFGHUzE0v6s20Y5zB5SlIP7tFFHOS0sW
	 YCQPa6Uk/r7+H9w0rDwN5zW/Pg8ParCPnGoKXtvYnAF9WGZ7U8oYSrMXzbEXcdFx1F
	 0Ge70tUk0JuirM3Hw4zMN4LgSjrt9hHBf5S3xzPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 198/817] arm64: dts: mediatek: mt6358: fix dtbs_check error
Date: Tue,  3 Dec 2024 15:36:10 +0100
Message-ID: <20241203144003.468554280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 76ab2ae0ab9ebb2d70e6ee8a9f59911621192c37 ]

Fix DTBS check errors for 'mt6358codec' and 'mt6358regulator':

Error message is:
pmic: 'mt6358codec' and 'mt6358regulator' does not match any of the
regexes: 'pinctrl-[0-9]+'.
Rename these two device node to generic 'audio-codec' and 'regulators'.

Fixes: 9f8872221674 ("arm64: dts: mt6358: add PMIC MT6358 related nodes")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/20241029064647.13370-1-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6358.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6358.dtsi b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
index 641d452fbc083..e23672a2eea4a 100644
--- a/arch/arm64/boot/dts/mediatek/mt6358.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
@@ -15,12 +15,12 @@ pmic_adc: adc {
 			#io-channel-cells = <1>;
 		};
 
-		mt6358codec: mt6358codec {
+		mt6358codec: audio-codec {
 			compatible = "mediatek,mt6358-sound";
 			mediatek,dmic-mode = <0>; /* two-wires */
 		};
 
-		mt6358regulator: mt6358regulator {
+		mt6358regulator: regulators {
 			compatible = "mediatek,mt6358-regulator";
 
 			mt6358_vdram1_reg: buck_vdram1 {
-- 
2.43.0



