Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514201E7660;
	Wed, 20 May 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295625; cv=none; b=P3VY6Sn5z3ajh0RH1D1J7/8zru9hp394Fm88Qy7z0piZasuSLAYtkaT6mDxMLkHnr7Rfv0mztfK6psM9NSvxALBCPDK08t0L6cVCRX/BNnyZpDpRq6GstVk1gYxCWVEHtjZwUJr/gw512bh1SzFX6uinP+hTuNNzCEeKjA48zVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295625; c=relaxed/simple;
	bh=vR6hl7Re9Z7ZXamhwMt8w25rAOj9Fxe25wmjDmBl+mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDQhWvgFe578VOw65KD2yuTMpOhFW0GO+q3qGOyHWtEZONwqubDAqVy3jU5Mq8ZqPOTRilge/oedfK3/41oKRLWUQ0p8g8w2VcvX3NkXJau59fui6THBWG3Lj2xMzZsVRSUFsdeEzbDqF8zHIic54QPi3WbPRd3UCxerLSHKl4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ur/ra8Rn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ur/ra8Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB8E1F000E9;
	Wed, 20 May 2026 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295624;
	bh=v+e4ey9ff/dh15F/So1W/9043L5z1XRvnxsTBmHYZYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ur/ra8RnrgNCR0w0/jSjAmrdacVXLjrf17tFkp0y1zip9OIt1TPA9ndVgOjR0N+A8
	 CU+/MdO22nldnfpPHjSU3DDnLdmmkDOOAUcypXxqtwJ8iYvkHqzsYk5UHcyLBZS5j/
	 ObTkfU5ZEW6qe9MZChdDpe4+vGxKLfDo9YKxoqb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0473/1146] arm64: dts: mediatek: mt7988a-bpi-r4pro: fix model string
Date: Wed, 20 May 2026 18:12:03 +0200
Message-ID: <20260520162158.896863618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit e4e6f0c5a4dc238684acef079e792c81d37e3226 ]

Fix incorrect model string in Devicetree for BPI-R4-Pro.

Fixes: f397471a6a8c ("arm64: dts: mediatek: mt7988: Add devicetree for BananaPi R4 Pro")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts | 2 +-
 arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts
index c7ea6e88c4f48..621d01e3cd896 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts
@@ -9,7 +9,7 @@
 #include "mt7988a-bananapi-bpi-r4-pro.dtsi"
 
 / {
-	model = "Bananapi BPI-R4";
+	model = "Bananapi BPI-R4 Pro 4E";
 	compatible = "bananapi,bpi-r4-pro-4e",
 		     "bananapi,bpi-r4-pro",
 		     "mediatek,mt7988a";
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts
index c9a0e69e9dd51..bb15bfa5e6ae5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-8x.dts
@@ -9,7 +9,7 @@
 #include "mt7988a-bananapi-bpi-r4-pro.dtsi"
 
 / {
-	model = "Bananapi BPI-R4";
+	model = "Bananapi BPI-R4 Pro 8X";
 	compatible = "bananapi,bpi-r4-pro-8x",
 		     "bananapi,bpi-r4-pro",
 		     "mediatek,mt7988a";
-- 
2.53.0



