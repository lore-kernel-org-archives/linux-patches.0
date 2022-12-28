Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AD21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DDBC433F2;
	Wed, 28 Dec 2022 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239833;
	bh=rurmLy+l//J7T7+v3pCJXG7BvUV3hDarUo5QFUAG0O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sn96q7ao9X7PxH9eUbwjpp/5jn/72a3Rkjh4eSgjLaOvMSjA8RDrel7e/Eq3C4Pi+
	 XhB4jHKpD0VSGkGm0hirECAgvX5D9Y8q6rX48Uz1iRaR8akkRVPkaIeN3VMd/INFzg
	 kTPMYtkUWJXTt+OwIDNXxJY3g4UhdFXym+flOKWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0048/1146] arm64: dts: mt7986: fix trng node name
Date: Wed, 28 Dec 2022 15:26:27 +0100
Message-Id: <20221228144331.469366705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 07ce611c705217507c2a036bba8695cbd82c9e36 ]

Binding requires node name to be rng not trng:

trng@1020f000: $nodename:0: 'trng@1020f000' does not match '^rng@[0-9a-f]+$'

Fixes: 50137c150f5f ("arm64: dts: mediatek: add basic mt7986 support")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221027151022.5541-1-linux@fw-web.de
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 72e0d9722e07..226648f48df2 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -168,7 +168,7 @@ sgmiisys1: syscon@10070000 {
 			#clock-cells = <1>;
 		};
 
-		trng: trng@1020f000 {
+		trng: rng@1020f000 {
 			compatible = "mediatek,mt7986-rng",
 				     "mediatek,mt7623-rng";
 			reg = <0 0x1020f000 0 0x100>;
-- 
2.35.1



