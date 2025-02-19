Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE831E0DB5;
	Wed, 19 Feb 2025 09:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956303; cv=none; b=gNzXIFV2uF0G26r8AjvEp41v3phbpLlgNq2P0rgDK7CAvIXnDwYi7Di5QYhi+qSh3CErIA5XmbUrpnG/VdrNbZ1aCwX1Et5y9MTyfYzX2VQtgVbj3vPk+bGYN1ChbLpS0ra7Ah5w7VbBV2/s9a/v5DO7w+hY9bBqlVRBsW8RfTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956303; c=relaxed/simple;
	bh=ktkZzCq0epiFFwPGqs7jBtLmSeGldV5SOUIXUBPh5aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYxlUR0tVSeSbCnhoEUdfKsJcg8SLlddQq2/zgYSBt2L4FEC8xTDBmKpLHGD3ZpZy62QMBQov8hE4LDp7JmI7D+z1C4ygF8qQyJH4BJ4CDRMzlmwjjx4JhLR0Dy5zIy6k/H21+gRbFogmRDOcddRLXXHxdNftPxlMVtFXPFPH+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1AYdkib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1AYdkib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A58DC4CEE7;
	Wed, 19 Feb 2025 09:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956303;
	bh=ktkZzCq0epiFFwPGqs7jBtLmSeGldV5SOUIXUBPh5aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1AYdkib77pJwoPR9LTFgaRhBIxo9xlSGCTDSry2YSEUfoijQHWTlSoemmkALWKZ/
	 SytP7VA4MPv5+hijHwIdhVpBTff1eO9EyE82d6VCuMRlCF2DV74amZJ3JWk+ZTS7ew
	 wESTnBjDNF5ZHNqmjpmmWpZOD63lTpAC335fSLHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/578] arm64: dts: mt8183: set DMIC one-wire mode on Damu
Date: Wed, 19 Feb 2025 09:22:18 +0100
Message-ID: <20250219082658.260447110@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 6c379e8b984815fc8f876e4bc78c4d563f13ddae ]

Sets DMIC one-wire mode on Damu.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20241113-damu-v4-1-6911b69610dd@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
index 5cbb5a1ae3f2f..ca4196870f9db 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -26,6 +26,10 @@
 	hid-descr-addr = <0x0001>;
 };
 
+&mt6358codec {
+	mediatek,dmic-mode = <1>; /* one-wire */
+};
+
 &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
-- 
2.39.5



