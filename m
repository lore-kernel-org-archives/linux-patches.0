Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F384F218;
	Thu, 12 Dec 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023821; cv=none; b=JU+dBxrJdMj/xBIODi2j57AysNEotBMwbhQmA3UXv/tiUuepuU3f8sg1c+hd5pYql9y/6VTNokFRrBTZLTKPwIQ1zJHfiTJcJUpFJO36TMNqeAvRM21WNeptk/ua8XjuQ0VtvkY9Tx6sqovxyN3/Uu/uCycne0MzL5UoVmNsPhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023821; c=relaxed/simple;
	bh=lDWz8YHm2rnzezLNnylK/rS9sQ39mjf3yLseVhNHnI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg22uTfSjA7efJM+en/EecimPJCqIQ4rOv9z4LaxIu+jDnfeNyzJoEOzC8/leG6PJcmwd02VpJMe+x86bz9lCB0jqIi59f2KihtRfNvGvThneZS97bpzB1CRz9O671pUvW4de55EfQINa40kJZVG392uG9SWlx344DXXZZWLN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN3VUPvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN3VUPvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20185C4CECE;
	Thu, 12 Dec 2024 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023821;
	bh=lDWz8YHm2rnzezLNnylK/rS9sQ39mjf3yLseVhNHnI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MN3VUPvYhZUjZvglkIpbJ+faHlxwCaG/VPIxoJcdPXoDG1vLYF/C94wTnBTqbINLH
	 cvsL8hadLH4rlT2dZqaHcfm1quKn6632n12ahiBIY049do6iArnug8JHtO6O0GKlb+
	 ajlRUTW7nyQl1HmA9py5snAfh2Bdkf1bd1SJxCCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/459] arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4
Date: Thu, 12 Dec 2024 15:57:04 +0100
Message-ID: <20241212144256.915699889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fbc471ccf805f..e61ec0229992e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
@@ -85,9 +85,9 @@ &i2c4 {
 	status = "okay";
 	clock-frequency = <400000>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c32";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 	};
 };
-- 
2.43.0



