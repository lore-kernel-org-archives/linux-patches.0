Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CED146A7A;
	Wed,  5 Feb 2025 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766958; cv=none; b=MwoFv4WcxfTSflGNCf/OfC9KclrlUTLefOHv/wY775Usc8FkI1GYXbIigCM8aWLb7s9ybmw7+l4jR2dgwygJWVq+zlJCO7isnL0Xv8Z2QAnqhDzPqPAPrXxqgoKUDAnDG8V5DYRVKBs+mTMdxN1SP3m4DDejYjHSqDL6zHVEArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766958; c=relaxed/simple;
	bh=Gydyi4er4VRLxO6ON+3Zo5FO/l/Gx0eboVUrid87U3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urhBz4H2ivs3z9JV4MuRKPtInpfhvgZ3J6clThJGIQSh0adhB6gOoh+XwyDjXBGZF4BGn16SartLxRt5CrKSrFCsCUgeEJtCsLE/fzkLCY8MICf1GZBHyIjv4r0Ngxg79/XmMyoa+uxac3rNv1+Mi4FFrX7yY01Nvf7GQDcHxWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjlAfAQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjlAfAQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336ABC4CED1;
	Wed,  5 Feb 2025 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766958;
	bh=Gydyi4er4VRLxO6ON+3Zo5FO/l/Gx0eboVUrid87U3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjlAfAQGpAcAzVDxSxAc4U9IoHNbU216fhkau0RQcN1cpAkgqOumzThIl183jX/He
	 /3PULJBKwQ5fQfX6kRV57uphCJ/w/NYD+2Ib0CDP4icBBC+O/VQ/vP2+dp8PUxOH+0
	 gS/ju5HRSpYy45HmMTzIxVH89sJh4tz9uHoMg3h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 334/623] arm64: dts: mt8183: set DMIC one-wire mode on Damu
Date: Wed,  5 Feb 2025 14:41:16 +0100
Message-ID: <20250205134509.000824926@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 65860b33c01fe..3935d83a047e0 100644
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



