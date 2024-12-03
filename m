Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7631F6696;
	Tue,  3 Dec 2024 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238111; cv=none; b=UnoVT+KRWcSGFyys/ANbNgIAv7hPkIKQHB2KEo8MCAac/A1JypmVCYUeDFmQ1UV0wRQ0DIlrVgJiqsT4VnY0WpaHBw3fPkiQA9BTad5AN+kkO9f5EWUivitZd154rcaIHQCeo9VU3UilAUd5OgvHuqrSjnh7m1DFLL8yZEoGof0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238111; c=relaxed/simple;
	bh=UIMYncGROH0B3g8x7PF2Uzl2L2cJfIvXJR+Nd/+yGKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbQt7nsPQs2tmy4oqN21BGuKDptjB8F7cVtZYGyKZidMLYTfUVoRy0EhP3s/kiClHaZe8HV5bFHAS0cxkEanFGkFuccBctsQ4zVEYtzbEDc7/4Gmn3cI30LqXDUUs5OhF5SMXX7iJSU3B9GTyaStfOo6rybF2GE2AnQ++D7w1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQZgdkE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQZgdkE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223FBC4CECF;
	Tue,  3 Dec 2024 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238111;
	bh=UIMYncGROH0B3g8x7PF2Uzl2L2cJfIvXJR+Nd/+yGKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQZgdkE533knvf+KiC/qhRTLmFTqs5XwRL/LZT6q++CmWcbpBy+HoVhpq9FCsqR6F
	 1Q7iqJYl+aByZDfyqoiZEVyOtjcJHTpg8KsH1oG1Zu2XdZJ/uLHWr0xog7E3/VeKnB
	 go3xFdXCCvyUhULgPJai15DNos+EsaHLLVZ1Fcvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 164/817] arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4
Date: Tue,  3 Dec 2024 15:35:36 +0100
Message-ID: <20241203144002.129489857@linuxfoundation.org>
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit e9c60c34948662b5d47573490ee538439b29e462 ]

The address of eeprom should be 50.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20240909-eeprom-v1-1-1ed2bc5064f4@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
index 0f5fa893a7742..8b56b8564ed7a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
@@ -88,9 +88,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c32";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
-- 
2.43.0



