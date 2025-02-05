Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48C151980;
	Wed,  5 Feb 2025 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764926; cv=none; b=ESi2RBvTLonHTyLu3idUYCrDlzCRLeaLL/JeKrrc3aW0btlHUpzzzOmLQUbCj8Jn27n9L2ltz+z1kU8qfbU55x9IfXejm/1K2/6diHdhg7Yz5b7Kx4hJvPODxOoylAuMSeeNUtputbYhVEjCbmCBBvU30WjAXQ+ncn0mIgEGEr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764926; c=relaxed/simple;
	bh=Z1VwCjF52JNoSdU923KMQlaM13wrZ/upOKs2ByagGfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx+QwGAYasAy662vqOyPagE/avEt5Gfvqs+gjMp3qIFUDjZAJr2K/ax0ShusWJyTH326HUflsXQ/PrpJMLG8ubuLNM88Pb3+LpqQC7liEh4CYy+eoWbGvh2KnMKQh40r6leKHLJh3hzfWXabrDRSHBUbbn7Asa3NYtjmW+svRC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lveGXW5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lveGXW5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28FFC4CED1;
	Wed,  5 Feb 2025 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764926;
	bh=Z1VwCjF52JNoSdU923KMQlaM13wrZ/upOKs2ByagGfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lveGXW5WrlUom288+Mm01lHLnFGcIsimttnDGpuMr2tyw/H/oHyPjlDui2gF4Ocz+
	 EIlda+qna9cebP3Qs0KU06aax51osY1QlL0/Ge/7j+vwDx6Z8/0C0M5NzUz5Dgwena
	 Sj2velFVsN+PE5zpOFmyeRvU67prSOdWD8R6Zmfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/393] arm64: dts: mt8183: set DMIC one-wire mode on Damu
Date: Wed,  5 Feb 2025 14:41:56 +0100
Message-ID: <20250205134427.836256584@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a166dccd727c..8f95b7270c3fa 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -27,6 +27,10 @@
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



