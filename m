Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C575374C4;
	Tue,  8 Apr 2025 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110738; cv=none; b=sg7ugCdUzR8qSzntimaYaOT2Z07bGYgR8g82JpoNISq2LKm17ELHMJXYEkEEI/ny1XXXLae4yhYkhP+uz9HwnWYqxKSqFWtFLiZWn26MTgvZQ6AkBi6SdCI+xq677Xz2Dlb+BrDBLWmy7FxcUY1QgZ9jmP6A/6z4Nks1YbosWig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110738; c=relaxed/simple;
	bh=0J1emmOBCffqiH7ZpzWvVHnlWqQlp8h/V+rhN/6Pxl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuPWrXkiW/jjkbVINVGuU21t0esyDz764/qyLBWQBx9Sxq7PCL+q118S4J6JqnRDNREzkD9mu6bb+odvzNON8LJX0sO2bczWPX1M5YfF71Pm2NYw3g2xVI03s8ELoP45uHvJIK8BlGKX12Chl4cCb444rD2szu3AVr0X/jCK6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7l2cPSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7l2cPSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D165C4CEE5;
	Tue,  8 Apr 2025 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110734;
	bh=0J1emmOBCffqiH7ZpzWvVHnlWqQlp8h/V+rhN/6Pxl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7l2cPSeSoOAsNb1wo2bKTl67uvrs5T07oHDv9rIXp/7hx2rKJ2aN5fxhzRM601uX
	 fNsSUlilb6lmpFg9kCtfA7O9Ru7h9OBwPLkZVxSAHW4v9DkXxmbU9Bj4VsGuBKbqcf
	 8RAqv7ZbwfD0odOu2jsbQU34FzSd6f0hxkCAynY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 124/731] arm64: dts: mediatek: mt8390-genio-common: Fix duplicated regulator name
Date: Tue,  8 Apr 2025 12:40:21 +0200
Message-ID: <20250408104917.163360317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 18aa138d125dd56838edbdb8c813e91e5e95d496 ]

usb_p2_vbus regulator has the same regulator-name property value as
sdio_fixed_3v3, so change it to avoid this.

Fixes: a4fd1943bf9b ("arm64: dts: mediatek: mt8390-genio-700-evk: update regulator names")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250221-fix-mtk8390-genio-common-dup-regulator-name-v1-1-92f7b9f7a414@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi b/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
index a37cf102a6e92..e828864433a6f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
@@ -213,7 +213,7 @@
 	/* used by ssusb2 */
 	usb_p2_vbus: regulator-9 {
 		compatible = "regulator-fixed";
-		regulator-name = "wifi_3v3";
+		regulator-name = "vbus_p2";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 		enable-active-high;
-- 
2.39.5



