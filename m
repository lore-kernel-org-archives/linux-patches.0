Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA3F18B48F;
	Tue, 30 Jul 2024 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355637; cv=none; b=fn2PDUDUGFSE1HqOIOLOPXtCd0yD3iPC2Yrx8r01xyh5sxdl9p0yeOgZDcAggj23qn+GaTF1COArfX2K9xOS6IzybnUqjzD433znXCymK2rT8XV9hz25uc6cA4bdSuTGezVg+EzwJqqA7QiJFQgs5+sal/SBNipTFyBQlZJo2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355637; c=relaxed/simple;
	bh=KjMGADnrgfZMZjuTnQfsexNh8WK/iz5gRAQdrFur1ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJ36rGmMw8osS27ch2+ATAjv5i5NMFO3QP3Xqfwt6W8UdpkUB6FE2rH6qIOiys9lzcPOUSXVqHETwE3gcTeL9rE7yit7AC9ZF7d9fSlWXVAcmt/Bn1kr43j0QFL/gYYmNRwHNZVLFM9WtnO8z3/OK0UQ0IduzJH5ndd+U4mfJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp/hpuNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp/hpuNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5733C32782;
	Tue, 30 Jul 2024 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355637;
	bh=KjMGADnrgfZMZjuTnQfsexNh8WK/iz5gRAQdrFur1ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp/hpuNA0XGjCsxJSXuwfR2B5M8C1iHpQ4oZhThAW1ecINnXjTHtzqz9IJw34GZwv
	 mWZKu3dli4s4hc+4+aDBTbjY5nt2JMhhL44NKMD8EzOtJD38tbVOslHqN+MXJFZK4P
	 50gmt3djOzrZDELzGkYYhmGgUZ5JefFRYS1ackME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/568] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Add ports node for anx7625
Date: Tue, 30 Jul 2024 17:43:03 +0200
Message-ID: <20240730151642.832586747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 820260348de9b..32f6899f885ef 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -156,21 +156,24 @@ anx_bridge: anx7625@58 {
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



