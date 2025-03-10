Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721BA17CA12;
	Mon, 10 Mar 2025 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628875; cv=none; b=AtQuzhqEwKYJ9UN0RvHRYax+MHlfY+Cp6J8OHsL8e+9GQXJ3HW4DujQzZV9jELgM1aLxCG6IskhznRyQmuJYMs+M0WdsU1xFaSZvO/w6iV+geXLlaiXlWP4g1Jqbu8fw3VkcSgJ9zE/JWM1uuYuOLxcqMRKTN54joC3QXiHPKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628875; c=relaxed/simple;
	bh=dv9EEwupkhLS7+1n6fbBxmZKLPF+PmcB3B41yC99Zug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLI6gynCTnzJ6XmhnQkfEF+dhVGsrngK3lAf2WrUmlZ2xpVXAhZNNK8Ig/Lj2XP27IUWEjuqu5+tCKmvQJ6jgLPRg3+omPscP+ppqLFX/0y0rJBe3xAy/E92I6U9ciEvbsVRtPHslYjqdlDOu0QBFzUo6kvhsN2DtZYJM6YGjtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la/UW9NO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la/UW9NO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26E1C4CEE5;
	Mon, 10 Mar 2025 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628875;
	bh=dv9EEwupkhLS7+1n6fbBxmZKLPF+PmcB3B41yC99Zug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la/UW9NOwis2u+DL9mMw4hDD+QVntl2CVx/FyPLG4aBv3xt6QrRVgYCXMKhKohNvC
	 +6g2n64Mn7UXhq9K5NUSIsNDlbWRUpMyZ5y8zsGEB8sSv8d6JF9lgZ9t0DK/KvK7rg
	 M8JKqKElMN70qfYuERYPCyNaJf9nVk87jxabU+nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/620] arm64: dts: mt8183: set DMIC one-wire mode on Damu
Date: Mon, 10 Mar 2025 17:59:05 +0100
Message-ID: <20250310170549.510273881@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e0cba4d23726..9a35c65779962 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-damu.dts
@@ -25,6 +25,10 @@
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



