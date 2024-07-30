Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE01A3053;
	Tue, 30 Jul 2024 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355595; cv=none; b=a7Ns97j8jgOpnCdS2mu3WN44Zzvcj3i0RvRqUOxFEXXr0loEgvES2L56Lb4oB9VTDRCmCbFzQRsYFeAKvpTdFzUmVcxKHyrOIGp9UWf3pz1IbUw29TEezbx9Yb/9hdQlxISrPWXncxe804e4xG6xPWVVM6uCuAY7DLiS82QycKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355595; c=relaxed/simple;
	bh=3UoIHgLPFT5Ncwbcwg/qw5Uay7vUcpPqc+c35Z1okhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMbBoUfm1kb6gZg12qPPvkbIiMhPp9Z1/wDTgoEfrJwJozsLo8ak3R5FjWvaeVOEV129eACmH9xesBoR8BTV7WRGx0M2sXGPDxxUc4F9698yD27eDDx9GArBZuTK2qYVj+rpLKjgt6VvbXtk+BVUv0IxCR4MkpNHFstHPwTp+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0o6/jj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0o6/jj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851CEC4AF0C;
	Tue, 30 Jul 2024 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355594;
	bh=3UoIHgLPFT5Ncwbcwg/qw5Uay7vUcpPqc+c35Z1okhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0o6/jj1vYUTw1HRCrJsx0XJMRvlSBsSIDP4lMnLv32keOkwqE+aWdDMVeZj+G80e
	 hNZKN03WB/6SR6IXAa1lYy0DumrEAm1dANoaFBvyXZMQeWczb+eRd7sFiJEeuwDvnj
	 GC5xHKAKvOkBhzB5pJ/w796uGrCUu1DwUtoAGNkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/568] arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property
Date: Tue, 30 Jul 2024 17:42:59 +0200
Message-ID: <20240730151642.674925055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit e9a9055fdcdc1e5a27cef118c5b4f09cdd2fa28e ]

The "output-enable" property is set on uart1's RTS pin. This is bogus
because the hardware does not actually have a controllable output
buffer. Secondly, the implementation incorrectly treats this property
as a request to switch the pin to GPIO output. This does not fit the
intended semantic of "output-enable" and it does not have any affect
either because the pin is muxed to the UART function, not the GPIO
function.

Drop the property.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20240412075613.1200048-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index d846342c1d3b2..2c6587f260f82 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -775,7 +775,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
@@ -794,7 +793,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
-- 
2.43.0



