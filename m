Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F22FA645;
	Tue, 17 Jun 2025 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178056; cv=none; b=tRO/S4J1Ac7e8+AtzKXE90g7AKJgkmFcG/jw2b3kLTaO6q9ZWxDAyKtyvXeIkNLEmj28bktqRW56KX4JUxUUNnH1ctuqpgDIp8ifQXDd6BQTDc8XIR4lLqtwT6sRtnaf88SSfBeGJDZ4q+UoPoHjtDwTLCiqp54Th749D9Bhs/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178056; c=relaxed/simple;
	bh=47JCxQQ68lRFiHm5kFAVA/8T0wn+b/RYmIrgrb7cAQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+xxfVrIqY5qei+1Aa9Tyhuc6Qdq2llantkbgkG2OxJ2YBZVPMYYQ/LIPp72fpFgGbM6GulIiOqrMTUYsjL/Lt1O4XabbhdsFpjxuxDFKp8nh+vVnglFofhZfESWhguMXOc/Y/EEMXHXHG9y8li/Z0nH5IU5jNyAfWlMf+I3oqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXy4EFNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXy4EFNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E46AC4CEE3;
	Tue, 17 Jun 2025 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178055;
	bh=47JCxQQ68lRFiHm5kFAVA/8T0wn+b/RYmIrgrb7cAQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXy4EFNeqhxBBVsLcCHbkaxASkNp/ZqrsqQmFBUca1/azvrRKwAqxeYFJoQnIk5dL
	 5pP7T0EDY3QiArTqQ57eIPzk4rWWx/FUeAc0b2z5qtm24nA8il+bm1uJczztR7pvZH
	 csA72WRl4tTAVwd/PdUghi9RGKAaPZe3yLqR27Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 402/780] arm64: defconfig: mediatek: enable PHY drivers
Date: Tue, 17 Jun 2025 17:21:50 +0200
Message-ID: <20250617152507.826021041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raman <vignesh.raman@collabora.com>

[ Upstream commit f52cd248d844f9451858992f924988ac413fdc7e ]

The mediatek display driver fails to probe on mt8173-elm-hana and
mt8183-kukui-jacuzzi-juniper-sku16 in v6.14-rc4 due to missing PHY
configurations.

Commit 924d66011f24 ("drm/mediatek: stop selecting foreign drivers")
stopped selecting the MediaTek PHY drivers, requiring them to be
explicitly enabled in defconfig.

Enable the following PHY drivers for MediaTek platforms:
CONFIG_PHY_MTK_HDMI=m for HDMI display
CONFIG_PHY_MTK_MIPI_DSI=m for DSI display
CONFIG_PHY_MTK_DP=m for DP display

Fixes: 924d66011f24 ("drm/mediatek: stop selecting foreign drivers")
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Vignesh Raman <vignesh.raman@collabora.com>
Link: https://lore.kernel.org/r/20250512131933.1247830-1-vignesh.raman@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index c4ce2c67c0e06..8e5d4dbd74e50 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1587,6 +1587,9 @@ CONFIG_PHY_HISTB_COMBPHY=y
 CONFIG_PHY_HISI_INNO_USB2=y
 CONFIG_PHY_MVEBU_CP110_COMPHY=y
 CONFIG_PHY_MTK_TPHY=y
+CONFIG_PHY_MTK_HDMI=m
+CONFIG_PHY_MTK_MIPI_DSI=m
+CONFIG_PHY_MTK_DP=m
 CONFIG_PHY_QCOM_EDP=m
 CONFIG_PHY_QCOM_PCIE2=m
 CONFIG_PHY_QCOM_QMP=m
-- 
2.39.5



