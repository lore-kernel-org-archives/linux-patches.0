Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806D36405A;
	Wed, 20 May 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298348; cv=none; b=Y/e7lNV/ZEtiwXTZDeHgwGn1OfaK9cXmC+nfuUsjQvGxwd85y7HkzFtSHW9Gbt5yjkYb6ew8uEVZWr1twcPPyplW2TOvAmFEY3cVQQRgdPuu4SYWuYH46mbx2j282d0YdMnxqcQ5rpcUXyb2PYmljHi3L3/qIdmngkKvhyIv2ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298348; c=relaxed/simple;
	bh=mYvFl1fjzvNhmwObKnaqN/vPlvWN0ySxLjxCSjMJ8kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXaHE7U0SGE3BHj1vi17ZU0JZmkc7BBFMXedMrwtNhpCWeRi5MtLoRsVAZV0HdHAY1F7wsvCek+rIduk6+Xc39UilxZQ1wP8c7La5M97/xleqtHDenGVTkGtOTus1sIT9JaVlFbeCReyLFIZhrdRPoeKnTc+5Urd57XXKpM2O8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKk/ii1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKk/ii1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765651F000E9;
	Wed, 20 May 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298347;
	bh=Kbrl+O4u0YZsxr7VTjO7i5FSrQwnZVnZizq9V6DWO+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKk/ii1moFg/Og0oOHIpAoBBc4pVll3IhpuS2ZYtqmFJVy1pFZ4fGNdjXcpAdr1Lk
	 jbm9JOk3UDb6T3rOglfPE6MCCudBk4iTswf/UadhWr9HXu7dxixNBA40pptU+cT6Hi
	 +/FU1BJ0E2TtxLDJokKB7tp1T5YeccfMCSYv4lK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/957] arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:14:19 +0200
Message-ID: <20260520162142.682551121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit c4c4823c8a5baa10b8100b01f49d7c3f4a871689 ]

The gpio-ranges in the MT6795 pinctrl node were incorrectly defined,
therefore, GPIO196 cannot be used.
Correct the range count to match the driver.

Fixes: b888886a4536 ("arm64: dts: mediatek: mt6795: Add pinctrl controller node")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6795.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6795.dtsi b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
index 58833e5135c8e..9757e37a65d4e 100644
--- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
@@ -372,7 +372,7 @@ pio: pinctrl@10005000 {
 				     <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			gpio-ranges = <&pio 0 0 196>;
+			gpio-ranges = <&pio 0 0 197>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
 		};
-- 
2.53.0



