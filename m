Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31818E025;
	Tue, 17 Jun 2025 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175556; cv=none; b=BepOwgbANIppiNFqVe/wQ0/TsGKa8g4cGVOVjLaIgihqymQv9y8jKNKoKvwe3eD5twgixcPVe6qAxzts4jhUzaw09EuLt0qIihRRzElEje3ITjBDYjCz2f6erPmtdRpuZnJBevTzBPFfY73kVcydPFX6rz7EeAEmjOSrpYv1Y2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175556; c=relaxed/simple;
	bh=wENov77cS5zMAjA0CyHk8BRrls21uN0wSQROBck6DRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3uOANbHJHe5RtVwvSBptDDpnK9qhFZhbeGlSZ+Q2W0zEZBcavddgXvaZHWXDnpCvSwkWSl3ZLZt1TW7JbzIxeXakKW3JpAod3iXacbm6+7KTHKNOWDr8DE3C+wLijppfQQjAqq9hdKxBcSkSUzwEn/nJo+KetNF2FuJ7AtSmNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3C1Njn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3C1Njn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7E9C4CEE3;
	Tue, 17 Jun 2025 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175555;
	bh=wENov77cS5zMAjA0CyHk8BRrls21uN0wSQROBck6DRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3C1Njn0UYc+ZEk5pHwhsd2Okc8dUvyD2EC8+nvyQrAIIbUM/2B9eEh0jCFPOCLFG
	 g6acHVp9nXPkTqnbKbSfMavZn64+0L2la2h0+GwRr318FnF6LKmB5uBBJH/xvRbrGM
	 gDm+Xf8eCmtahfZ+xf0TRRxqBYtKHdNb3d3eDIzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/356] arm64: defconfig: mediatek: enable PHY drivers
Date: Tue, 17 Jun 2025 17:25:03 +0200
Message-ID: <20250617152345.780889975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60af93c04b45a..a4fc913d1e494 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1412,6 +1412,9 @@ CONFIG_PHY_HISTB_COMBPHY=y
 CONFIG_PHY_HISI_INNO_USB2=y
 CONFIG_PHY_MVEBU_CP110_COMPHY=y
 CONFIG_PHY_MTK_TPHY=y
+CONFIG_PHY_MTK_HDMI=m
+CONFIG_PHY_MTK_MIPI_DSI=m
+CONFIG_PHY_MTK_DP=m
 CONFIG_PHY_QCOM_EDP=m
 CONFIG_PHY_QCOM_EUSB2_REPEATER=m
 CONFIG_PHY_QCOM_PCIE2=m
-- 
2.39.5



