Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D41A6191;
	Tue, 30 Jul 2024 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356005; cv=none; b=tYlGzTLppNMAr9F7tXqg4fJDtx/1coPDpLnRvPTf0QANm+KnDVr/m7s7xiBt650jSWa7rKjufB+SSQpiyENZDQr2th8pKf8L9aVTb0hiqvtOEzWAz13nqkOTv22GsMvLWT0amitUS2hrezSYcChwvlkCdl8o3Cb6lw59IkOVDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356005; c=relaxed/simple;
	bh=mROHMihJ/sA756Mw4Y798hN2/JSBwIgz6S6OGmEcHM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD5sU4b53KRA7uuJ1wRIgDv8p9bU1UHZcCvOUlwh6i4mEa16xy6QHT0TFV44iWOYS9vFm+dSddNwCwXTuNcPiP+Jru8/WtYmo+j8dqNKrMjfLKp7TIkcCfSAEqhaDi2xTFOk66HOVJxrRePS/JVU3vWdlWigGb0kAWrzTcFvxB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbOe0YD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbOe0YD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B735CC32782;
	Tue, 30 Jul 2024 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356005;
	bh=mROHMihJ/sA756Mw4Y798hN2/JSBwIgz6S6OGmEcHM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbOe0YD31jJq5CZ8QspO20Nafuwe9ZpOkOZARQXB2pJ6yu/aGfwmctKW68ZYbJMva
	 plQ69XH6vZQ/19hfZb5Hu3ITAF/c5o1BFPVOjnaUVpLm+sGIyowGtY8MR2i6z6p+Uw
	 6ye3dYCH6tDozt19jPxLH/fh9J5TrbyMVtvHhp/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 108/809] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add ports node for anx7625
Date: Tue, 30 Jul 2024 17:39:44 +0200
Message-ID: <20240730151728.890234187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 4055416e6c51347e7dd5784065263fe0ced0bb7d ]

The anx7625 binding requires a "ports" node as a container for the
"port" nodes. The jacuzzi dtsi file is missing it.

Add a "ports" node under the anx7625 node, and move the port related
nodes and properties under it.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240131083931.3970388-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi.dtsi    | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index 7592e3b860377..fa4ab4d2899f9 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -155,21 +155,24 @@ anx_bridge: anx7625@58 {
 		vdd18-supply = <&pp1800_mipibrdg>;
 		vdd33-supply = <&vddio_mipibrdg>;
 
-		#address-cells = <1>;
-		#size-cells = <0>;
-		port@0 {
-			reg = <0>;
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
 
-			anx7625_in: endpoint {
-				remote-endpoint = <&dsi_out>;
+			port@0 {
+				reg = <0>;
+
+				anx7625_in: endpoint {
+					remote-endpoint = <&dsi_out>;
+				};
 			};
-		};
 
-		port@1 {
-			reg = <1>;
+			port@1 {
+				reg = <1>;
 
-			anx7625_out: endpoint {
-				remote-endpoint = <&panel_in>;
+				anx7625_out: endpoint {
+					remote-endpoint = <&panel_in>;
+				};
 			};
 		};
 
-- 
2.43.0



