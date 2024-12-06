Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DA149E0E;
	Fri,  6 Dec 2024 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496890; cv=none; b=oFnbZe7BdDbj1wTn4Q9LOHwlNm/R7pXZYl7BAX0MeJ5zR2vsZFstswCR+HhIIJJBmZxwLX+EOeRBXDyFiUqM/M6ayMXyHVCVZjt0QRDqXTpaOck2xPkAvQGb7ZhTQ0QMQinPVFvtuhjuhZYpNhFqvBixks4EOtVqgi3L6kyj4Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496890; c=relaxed/simple;
	bh=OxtOOG5d77UW+0yx64RiIr1uYqsKbWqImultRCyNFNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USAwXa7aUvFAv9ePbjfuo5khIfbfMjhULCclFaZNuK0VjsRtbckPKRAZlDin6qvGGMx8qdJaN3QLpTEuYAJUE0gobOnLWOUECgNgtF6wkEbB8TcGBCE2mmx7Fk/U9QlWEmfRPiRtAbJjErX2pyxTvajsbQ7PeY9m1vbryyEIy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkBwABTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkBwABTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF30C4CED1;
	Fri,  6 Dec 2024 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496890;
	bh=OxtOOG5d77UW+0yx64RiIr1uYqsKbWqImultRCyNFNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkBwABTfHQEwNGbUs2RHIhoWKfmWvAd/DB4CD+SzrqXEyypxlvfCca93XjNaCpNnl
	 7NIIul1xYSndJVQI3ewwRTbjQdN/0yfDSufCdSt+8XyGdPdVfPH2lhQzql2KfjYf3d
	 RvPq1YC0uyMn9GRuWS9ENM80JBOXDLOLJS/5m+Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/676] arm64: dts: mt8183: Damu: add i2c2s i2c-scl-internal-delay-ns
Date: Fri,  6 Dec 2024 15:29:14 +0100
Message-ID: <20241206143658.629045732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit 6ff2d45f2121c698a57c959ae21885a048615908 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-4-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
index 552bfc7269994..9a166dccd727c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -31,3 +31,6 @@ &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <20000>;
+};
-- 
2.43.0



