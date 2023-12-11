Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF8DFC06;
	Mon, 11 Dec 2023 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dk/xw2M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8177C433C7;
	Mon, 11 Dec 2023 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319638;
	bh=5PnVgIhtpX6qEq47F1gohtk55as6KO8WVBZYDNNT3FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk/xw2M2OYeFYcBhH0SeM9WWda7jr6ETILg4PZbl62vpOKpt70/lEo7Yv2+dnQYjX
	 VQaC7+eZjx58iNEL1CuGDNOgaxHMNm/5/mA4cZ4hDzOC/g7eryCmKXzxD/xMezJRYn
	 FmYQJhf5xxJ+2p/KnT7Hw/q1W5BpanSqVqfrPZfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 180/244] arm64: dts: mediatek: mt8183-kukui-jacuzzi: fix dsi unnecessary cells properties
Date: Mon, 11 Dec 2023 19:21:13 +0100
Message-ID: <20231211182054.017160375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Eugen Hristev <eugen.hristev@collabora.com>

commit 74543b303a9abfe4fa253d1fa215281baa05ff3a upstream.

dtbs_check throws a warning at the dsi node:
Warning (avoid_unnecessary_addr_size): /soc/dsi@14014000: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property

Other DTS have a panel child node with a reg, so the parent dtsi
must have the address-cells and size-cells, however this specific DT
has the panel removed, but not the cells, hence the warning above.

If panel is deleted then the cells must also be deleted since they are
tied together, as the child node in this DT does not have a reg.

Cc: stable@vger.kernel.org
Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230814071053.5459-1-eugen.hristev@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -91,6 +91,8 @@
 
 &dsi0 {
 	status = "okay";
+	/delete-property/#size-cells;
+	/delete-property/#address-cells;
 	/delete-node/panel@0;
 	ports {
 		port {


