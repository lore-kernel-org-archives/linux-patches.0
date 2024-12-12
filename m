Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E78231A33;
	Thu, 12 Dec 2024 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019063; cv=none; b=nqKs4SsHKMCGXU4sCDzsWlcaoww1t1YoMjwx12SUfNIATPzu6zvrPGKrr+kppPA+x2rhKLm49UPhBxqNaph3ijFHhr/3st6N47715PKpdfFAqD7xLeFlyGY4Yobz1p5uLFcqR8zqrlnujxKJ8fv1v7IKlNZkobU5erPUm/yob08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019063; c=relaxed/simple;
	bh=HxFufyLF3FH+/VlfoJfHrSJ+08VsezSQvNRffEsXAy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr4hjqtmCh0wAfau6ct/ZNAmwYhdpJyKucNhv76WdPgpChw1YcdJ5BtVi48ifIPT14fq6eJY4gSSoZSgEunlxGWqu333x3bcjm+ieRJ2xsr6spcMZqxyrAucvwf23ct9lGrZFnnxVamfEIIyRu6NFQfEsm8CJ0DrieSbfLUwKhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iedcAbNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iedcAbNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D30C4CED4;
	Thu, 12 Dec 2024 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019062;
	bh=HxFufyLF3FH+/VlfoJfHrSJ+08VsezSQvNRffEsXAy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iedcAbNCgKW8nNv1l6Ar2zPNM37J6mXhOPM9SWgOSc11pTa9VzqgbRfdkMcFwhUnS
	 qkVe0UqepSwqdv8rUIYXQNv7kW72rgtwgrh0yKbGRLoGJXVewyWRaGGVMiQVAZtTFr
	 ZeEnB8PgukWv3k1vbCUw1MchHRzaHsJme+Rilg4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/772] arm64: dts: mt8183: cozmo: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:50:53 +0100
Message-ID: <20241212144354.392826344@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit bd0eb3b1f7aee698b86513edf10a50e2d0c7cb14 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 52e84f233459 ("arm64: dts: mt8183: Add kukui-jacuzzi-cozmo board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-3-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
index 072133fb0f016..47905f84bc161 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
@@ -17,6 +17,8 @@ &i2c_tunnel {
 };
 
 &i2c2 {
+	i2c-scl-internal-delay-ns = <25000>;
+
 	trackpad@2c {
 		compatible = "hid-over-i2c";
 		reg = <0x2c>;
-- 
2.43.0



