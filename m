Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F2522FE04;
	Thu, 12 Dec 2024 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019056; cv=none; b=qeV5ys5ZU6OE8GeZaEM0vvTfxp2PxARQ9ACVv35NG+SkEc3rCAk8TReZAunjenwpvbod3paRuJoVKYIxyLv2YaOOrn0/GaZrwnH4UgRKlbJrNntRZMEoGu5EcCabf5x5kydvBXp1YSMevJYKi6h5ANrSpOgf3yPKstNnkpgWteg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019056; c=relaxed/simple;
	bh=OW9p/S4vDez05a9Xg8JXxSmsM/OGus5JCM7TGTdSgAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dirn7nD9zBq4QCQKj5iQN5TraIM/ad+6aoJVQjW18ghTVnlYrKhJHDc5vLSVlVmXPfvWK9OICKwV2WfW5jduxGipawDHEkDD5+J7cYdUbOCUzxFLt11A7TmC2B4ZLEHep0qFDsvCdM/K+UaJVc46FjFzDXeJRts0DVDFpXHETwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRkntum6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRkntum6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22F7C4CECE;
	Thu, 12 Dec 2024 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019056;
	bh=OW9p/S4vDez05a9Xg8JXxSmsM/OGus5JCM7TGTdSgAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRkntum6MugF39TI0cYO7GouMx7XJg0MZnzpiH6zCQ9L3t9nXvibHVsYTgf/dxjQh
	 mmDNwjxeIWmWFAZVPBeEQkZExf+JxamaKzqa2A3OXlWJRcQkv7M5rxRflJOP09iH/J
	 aLFLBKg+dOWy/34hGnobqXMQ7e5xWv6uuvCriOtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/772] arm64: dts: mt8183: fennel: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:50:51 +0100
Message-ID: <20241212144354.314760938@linuxfoundation.org>
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

[ Upstream commit c802db127dfb9602aaa9338e433c0553d34f1a9c ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 6cd7fdc8c530 ("arm64: dts: mt8183: Add kukui-jacuzzi-fennel board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by:
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-1-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
index bbe6c338f465e..f9c1ec366b266 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
@@ -25,3 +25,6 @@ trackpad@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <21500>;
+};
-- 
2.43.0



