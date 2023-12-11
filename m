Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6AC321B8;
	Mon, 11 Dec 2023 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyAmtqa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FE0C433C7;
	Mon, 11 Dec 2023 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321059;
	bh=v6ZJQl9B3f7WtrBJmnw4GL0JoW2ys2FvweA6/RTWO1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyAmtqa5/BjB8PqWKwWSv+MqQwYhwvy3p5kTuDq8hUu6SJSGsZGPU7hGmAck/+T1o
	 a8MjxqZjpWFr3JmYUx3i3m8fsolV4PQcRYdY4g4aLYqwdS2YKrdGD7V6+0+Vc4KeAz
	 5xawexzSWE3eXy9C/zqjkGV2eBjTE0FAuvbCnAv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.15 093/141] arm64: dts: mediatek: mt8183-kukui-jacuzzi: fix dsi unnecessary cells properties
Date: Mon, 11 Dec 2023 19:22:32 +0100
Message-ID: <20231211182030.592803767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,6 +102,8 @@
 
 &dsi0 {
 	status = "okay";
+	/delete-property/#size-cells;
+	/delete-property/#address-cells;
 	/delete-node/panel@0;
 	ports {
 		port {


