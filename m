Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1131A7057;
	Thu, 15 Aug 2024 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731939; cv=none; b=TrnLcAtygOafw75v2PbWkzoLjK0zv9zpfgixwsRnI/prwM90mPBXwUV6levpfG4W7z6fNW6k3V578nOUMLQa+gxV95oE44AwNcmmQFo73Ixtequ+g1oZPOSoeH9idJaxvJmmfQYDRwzCEb7qtAHkwK2MDD/XQv15u34lriyRD6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731939; c=relaxed/simple;
	bh=Feyqe1m+Xfxews01yIpdxmP/Th9qyePUaM1ZFyatPjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gexjmncpWrA6sTUNvKXvdIOANSitUlJZ/J+262OmpDdM8Cz+0ipSgurNNiRZ7hBSTR6sKYccFOwO+OxHPDCxFNnrZYRlKSwgPOjVyEFZdPM2l8xM6p3Gv+eERTpaLNYuMWsjQhZVlMzu80Bf7XSU7H0J+zkgZPqRJBQq3EIcFq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2HAjVBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2HAjVBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75EAC4AF0A;
	Thu, 15 Aug 2024 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731939;
	bh=Feyqe1m+Xfxews01yIpdxmP/Th9qyePUaM1ZFyatPjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2HAjVBmen5tTMHQ05rH7adGiQRso086n4+JFT9wUZdUfq1DXcfrK3BWXlnr8iHrF
	 lS6COCVQToKTqpNdANpuy3JwahQFA9oLldTwfe7v7cAJca1wdiwAgFs6wpcnuUVekn
	 czVAxfdSezps5GfZDDZEhz9zPg47dIN8MUD+yNnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/352] arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property
Date: Thu, 15 Aug 2024 15:21:31 +0200
Message-ID: <20240815131920.191785603@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index a4f860bb4a842..ad8b11267c7d2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -628,7 +628,6 @@ pins_tx {
 		};
 		pins_rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins_cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
@@ -647,7 +646,6 @@ pins_tx {
 		};
 		pins_rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins_cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
-- 
2.43.0



