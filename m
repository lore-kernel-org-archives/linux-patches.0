Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634FC232378;
	Thu, 12 Dec 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019066; cv=none; b=MHGtiYsUpystV1diNpGHe55WtuiYIamH4Oo7zxkb0tPm34OsXSsFWW5bAiUhwYc5OR8l99qmDGWesT7SUdq+oSLaoIMZV7H9YaqXU8ZFC7e6yC+he+HUY9TGW3iewz4ruSCKpHtiBGKUTS/pYxBuHH+O9GH9x/FNgImgH8rxFdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019066; c=relaxed/simple;
	bh=Ig+8KNN8Sh4VQrMAZd1MCIXa+ngZOXyhkmGvRzDvDt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxW5c4s9hghGD5RlLhl0j1pQsQTMaYoRr8ndErTpCh7ZvyTBz6B+x71oGhb/w9ej/Rp56XXmqL6YU8t0dFVRBBm6ngEp3/vyjwAM88AL4wbxyVsii8VNIhuxC5aNev7dODIhGKrcqQcfPxm5OpsJf/W89L2omswmKlmFVhr1fFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow00C7OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow00C7OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19B7C4CED4;
	Thu, 12 Dec 2024 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019066;
	bh=Ig+8KNN8Sh4VQrMAZd1MCIXa+ngZOXyhkmGvRzDvDt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ow00C7OR0bDnMyLHebrkAQttEstbePb+zMCKyTd7q2z7B7eIRMJA5oi+MwlvZ5Rn7
	 9qj/mnId5v2foJHgIkxCjgUwLh6eN3grU6sGToKs/Goq1sovHDbwWDqZ5guD+h3Rwy
	 rLX5OO2IeEX0y1NFa9VidF94g8GEvQAAKoMnU0kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/772] arm64: dts: mt8183: Damu: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:50:54 +0100
Message-ID: <20241212144354.431276452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0eca3ff8672a7..5cbb5a1ae3f2f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -30,3 +30,6 @@ &qca_wifi {
 	qcom,ath10k-calibration-variant = "GO_DAMU";
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <20000>;
+};
-- 
2.43.0



