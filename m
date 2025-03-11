Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749425DB0A;
	Tue, 11 Mar 2025 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706494; cv=none; b=kYwcB8+JfyXpRa4/GbPt0a6TA6D4f9ZxwDKBFZcznAPkyY6DYDdL1IFBjyi1HchafxowCBQbk4JwR82IKTZIOVe6oLYRpjy4Q6CZXiFSteulLAj3AeAACVsCyJaUA5SgmKBBOjGoRYoyBL++sdLaEDsGsmIcqFw5Gg8DRuyPQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706494; c=relaxed/simple;
	bh=OrX93pBQXV42izM9Oe4rY37y5eDpjI7IUjAa3s+u5sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu5J1kKorMMRXTkFLEt45SfCqCzXnzu2beLZfJwprQpy/aM70cGYRZmoI7F2zbQtqoD30jAA8PXPJRGiMepMSmkfAOsAncVShhfRX+UIW4B3MSWqGWu5M1WZLkMEWZWZe8ZOid6R7Qh0HctSC8igCEY1lRAkfOy9VgQJaVuO4yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX+fiqUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX+fiqUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3CFC4CEEF;
	Tue, 11 Mar 2025 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706494;
	bh=OrX93pBQXV42izM9Oe4rY37y5eDpjI7IUjAa3s+u5sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX+fiqUTyaTe/5V60rR2hrvwBeg6rG7MGFKCqsGpLRcq3i4wnezw5Kh9h3kreCY26
	 /JlCkDzV6jE910WHOoy7iEMXlA/ksYY+OWgNc9f1xfuoQpvjS7Sc/pUaMHww3io2US
	 qWMnmlrMwbAERC4+AvigXOn9GX4KRZGxbW05Ad/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/462] arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A
Date: Tue, 11 Mar 2025 15:55:33 +0100
Message-ID: <20250311145800.996546775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 2561c7d5d497b988deccc36fe5eac7fd50b937f8 ]

The Android DTB for the related MT8167 reserves 0x30000. This is likely
correct for MT8516 Android devices as well, and there's never any harm
in reserving 64KiB more.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-5-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 383ae46891ec2..afb66d1439511 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -144,10 +144,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 128 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@43000000 {
 			no-map;
-			reg = <0 0x43000000 0 0x20000>;
+			reg = <0 0x43000000 0 0x30000>;
 		};
 	};
 
-- 
2.39.5



