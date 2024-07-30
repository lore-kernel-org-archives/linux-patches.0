Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295C61A616F;
	Tue, 30 Jul 2024 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355891; cv=none; b=RH8vhFbliOVFT08+A35wjKSXPd2e5kldtNb9+u6oX2ICa9MY1yXS3cXPKA+NWGevDiA0nNnWwKozdl9T2wsHjNJ2Y5rRIcnD9wkkfTQQXNK6zF2bC58heaVlmFrdEdyc0cgO4tCR/OOAPPdG92/XNe0kR8mKWpXAbim1RrYTKM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355891; c=relaxed/simple;
	bh=VlOo8zUak99bL8jBg9kBBgLVL8Ixuz74aCsayeIvUgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M10fIIvnEg5sMadGUJMF00db7m7ho/D3/C/pmQeFtlma/I7dyJbvE4pmvAzkhmvdomiMxloDyar84YbomBTkIi7Z1fnyfQyM9bCkxzRtDDFTTlbIKSLOY8QHvsswVVFB1uWdQf+Gfj+z1YT37YRi2ibaRAVj+0asP7QwotVKIPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH+1TGqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH+1TGqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A743DC32782;
	Tue, 30 Jul 2024 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355891;
	bh=VlOo8zUak99bL8jBg9kBBgLVL8Ixuz74aCsayeIvUgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wH+1TGqIvLmIw8XkBE1YJiVUxW/jR4OWRO4vcKgC7RuSMFPBQqCB8+gqNLLHH518A
	 C+xQV+M70IJBVHTtOQne5G/yxcd7heRmlNigtH/hprA632Mnc/JOIDJyvFx5CqBe3W
	 NK+MrMxFjca6Nx9mgLi4KXaDxqqvxMCOQV82jc0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/809] arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property
Date: Tue, 30 Jul 2024 17:39:38 +0200
Message-ID: <20240730151728.658319395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 100191c6453ba..feb8a5acf2cd6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -803,7 +803,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
@@ -822,7 +821,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
-- 
2.43.0



