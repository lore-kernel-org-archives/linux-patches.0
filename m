Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD6B33FE;
	Tue,  3 Dec 2024 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238143; cv=none; b=WPVqZhpGIWPyb6li4yIhn1I8x8UGyaDpbWvEZuCK0n9Ve9xT4rcgV3437iuK+aRKjjbWx360Q/Caj044b/P6TflOJzjx8G4k0BoHPiEM/OL0d74L4w2hft6TRQ22KylGX21u4Lxq9TsAbItK+iM+WnAe0ydHNGCxWXU8an+O9AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238143; c=relaxed/simple;
	bh=Q3DUTYFc0mBzuNmaTCKzwPTV/Bt96phQ/Gc3IkAMQyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spPjyayKnCFzmFUoWbfKpf14cfnVekqhCX5ckteKxvlQ8i5zRf/2xtCR/FdzQpqWgej1smalEYXz6aZy0hx8+QHh+PQvDM4iyKth8xYJsY/zXTO3XEogmmjw3v8eSI+hs+ZUXPNXf2wNHM50Ye4CACYQD6vXcCuLhfXb2ieL0SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzRo0jah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzRo0jah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFFAC4CECF;
	Tue,  3 Dec 2024 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238143;
	bh=Q3DUTYFc0mBzuNmaTCKzwPTV/Bt96phQ/Gc3IkAMQyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzRo0jahC1u+Kp9fvw7PPaczsREF3X6ywlgKUGJu+Jz7n/Z8JjSzRbrcqlkpWcj0l
	 Lb8i/GsFmafQpoV7Dl8QhROlvbnQnciJEzrnNl8uPfqOFgIePYWFr7J8M7OWWcQsIx
	 PXkwZsVzdy2F3+Sw693CDHSUMGwZ/DkbatQTcyxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 169/817] arm64: dts: mediatek: mt8173-elm-hana: Add vdd-supply to second source trackpad
Date: Tue,  3 Dec 2024 15:35:41 +0100
Message-ID: <20241203144002.323721576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit f766fae08f6a2eaeb45d8d2c053724c91526835c ]

The Hana device has a second source option trackpad, but it is missing
its regulator supply. It only works because the regulator is marked as
always-on.

Add the regulator supply, but leave out the post-power-on delay. Instead,
document the post-power-on delay along with the reason for not adding
it in a comment.

Fixes: 689b937bedde ("arm64: dts: mediatek: add mt8173 elm and hana board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241018082001.1296963-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
index 8d1cbc92bce32..ae0379fd42a91 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173-elm-hana.dtsi
@@ -49,6 +49,14 @@ trackpad2: trackpad@2c {
 		interrupts-extended = <&pio 117 IRQ_TYPE_LEVEL_LOW>;
 		reg = <0x2c>;
 		hid-descr-addr = <0x0020>;
+		/*
+		 * The trackpad needs a post-power-on delay of 100ms,
+		 * but at time of writing, the power supply for it on
+		 * this board is always on. The delay is therefore not
+		 * added to avoid impacting the readiness of the
+		 * trackpad.
+		 */
+		vdd-supply = <&mt6397_vgp6_reg>;
 		wakeup-source;
 	};
 };
-- 
2.43.0



