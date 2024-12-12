Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92179230D2D;
	Thu, 12 Dec 2024 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019059; cv=none; b=hV9Hr/+Tsxa082RVBCLoA9oBcnGikToIpUkA4Rx1+XQtgiCSODm0A9As5BWgqfawbJU90wEhouBkinzJb/DNDaEZuLSpzPofGl42tnlIKC3s3Su5DWWmYY3wkLCa5AudfqgvP+wHOaZ10MtUgmutM9OctdoEZkyJ8WXzdmZA6Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019059; c=relaxed/simple;
	bh=0NZN3ezSizWWTxy2cHgtqNay19pAOHvLkBGIR1j1moc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfLEdRwpkVOkfJgSnwDA+HJDvLSxTh4RfMcXjYXvaAk9NudgB9QTT9eOieu76C+ret+Os+i3E/hfrP4o0sS80xoOSONLLbb0EpxG5wJDM9Z9BF1yV2eDPGmI6UTfPgd2IHy39gPCF+sPWFT1IUZdDbdPF/6L40V4okLEd3l8x3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm/EONTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm/EONTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DCFC4CECE;
	Thu, 12 Dec 2024 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019059;
	bh=0NZN3ezSizWWTxy2cHgtqNay19pAOHvLkBGIR1j1moc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm/EONTECB0kKNHyOrX1PNJZzF5Lx7yoEb+dMy13bW+doXRREO26NJ9U6EBTy8TR0
	 5/o8VLTqC34WSVfLRI5ZAQzti50KD9MbRqhmWKzirUFr4/zFXsDhLDpu8RlcOi+D2z
	 Sg5cJzV5wQsp0yLRk0bcEJMDG3Fze4qqovZECxHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/772] arm64: dts: mt8183: burnet: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:50:52 +0100
Message-ID: <20241212144354.354733636@linuxfoundation.org>
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

[ Upstream commit 85af64983889c621e8868b744c8ca03bd5038c02 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: dd6e3b06214f ("arm64: dts: mt8183: Add kukui-jacuzzi-burnet board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-2-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
index 1a2ec0787d3ca..09c5dca12fb0e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
@@ -29,3 +29,6 @@ touchscreen@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <4100>;
+};
-- 
2.43.0



