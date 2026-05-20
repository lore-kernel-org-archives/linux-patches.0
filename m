Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC2E3DC4DA;
	Wed, 20 May 2026 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300689; cv=none; b=qeiZ6Be6lM3H9UsBcaswAONjTWUTlnwimyJZP4osNBYp1FMH7k5WVj246mfhjKECwqrZXq65TMVTkOu3D3JSR33s78ye5X5kvGe1mMv5HBmFyu8iv9oF1QZv93PNJXnElbQOBwgkcoXhilDJXcNOhpzeAmXqETv5hripIH+Nee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300689; c=relaxed/simple;
	bh=yfByzIFQ4E0hBa+wdLHsTocPb2KCOogil/Y4lN5N+Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0Iuz6MyP/lv3oSjimaiM5+RlRuE7xQHm40Hc9nG+ipNjKoqfysAcGspTl6uq7jWf8g6f/33mDCxafJ0EfIZ/+DD55DKcUtGhjI2hYc79q626VZmKfYMCkXcUa/c2yyNq6Xa0pRj2tD+jH78grQ+xfjp4U+gOOiuux/l89YC70c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hs3U/Wka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hs3U/Wka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26B81F000E9;
	Wed, 20 May 2026 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300688;
	bh=vKgAlEoDMGPASXZodvmmNI4H701jP1mQ+K2LFXZFYlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hs3U/WkaW60swfKRQFTj1/BR81N5dbiKX9I5DhxhSPTbznvo3NSTaiFLllmUCqTZz
	 hReoZ2mtM4i18/NAiivmxoIwxs3WguEVZxjz5jGbhY4quDzgTkXxLyP9t1IjUmDUuY
	 6iNHaGp1nu4DvTNhOSmHJf9jCnNohqimtEXyPnbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/666] arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count
Date: Wed, 20 May 2026 18:18:02 +0200
Message-ID: <20260520162117.089815077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5e269a660b11..5dd822d470e89 100644
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



