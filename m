Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F031632D9;
	Wed,  5 Feb 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767053; cv=none; b=KAUITNdjjD3llTo14uCN90lshvlOW9upc8R8Ty9uZbcD1XzuN7/yLvdmKYMQWiZmEP7bmyCDd9/BoN158SxBimsasKRONm+1oOorijLqo6pMkugeL5adGYPe33QzVNPUx4L6KYb+PA+s0kMruZud0PzP44yImU5UK3hKuO20D2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767053; c=relaxed/simple;
	bh=JvDyzSMQGicdFezwETN14NWBNYdp8USkVX6LNHluEhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiKN5RwvLFC5zYFuBUB2b3CTQF6pzU2K/XIi1ord2jbwNiTUVfpv3Dso45RXvEtfBL/NKOKKD6vS+CXW6EJ+J51fDku9QA0bXveHZNvXM2KQXpYzKn9ihinLQl7WFsQetnT2HWvKFUdD0HTl8SOfmnhsbyi0K4rz0V7iA5lg/AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0aHEcJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0aHEcJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E8CC4CED1;
	Wed,  5 Feb 2025 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767052;
	bh=JvDyzSMQGicdFezwETN14NWBNYdp8USkVX6LNHluEhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0aHEcJnt8ZxMq/cUoLn1YzmEBOIh5AchFcwtQ4l153LOu4iuf30tzjt7kcxSqlf8
	 x/LY0k+OjgjBDaV+bUZ6T3H6q2C8Tj02xwCYklmWviHo3bv3ECryadgiF8JjNqisxY
	 0i4IISyYf5fOwW2Pn193EVxAaDT9x4yBFL0SfIaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 350/623] arm64: dts: medaitek: mt8395-nio-12l: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:32 +0100
Message-ID: <20250205134509.615630557@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit ab60442f26b15ba69b210974722a851ed03188ff ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 96564b1e2ea4 ("arm64: dts: mediatek: Introduce the MT8395 Radxa NIO 12L board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-8-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
index 14ec970c4e491..41dc34837b02e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
@@ -812,7 +812,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1193750>;
@@ -829,7 +828,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1193750>;
-- 
2.39.5



