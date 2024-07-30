Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C6B1BE221;
	Tue, 30 Jul 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355089; cv=none; b=E1XC0QxrMvKisdfDsOBUiHxYTjxygciG5qauCP0hfxggHmR5SKStInwvJAEmoRaHctPKffthV4nqGJrZn1QM/CRP2npc6LLuS1nAmNSh5AfOHBxxVFO8PubRTCv0oyCqOdygKnOGSxC+xy4uX2dd74SNBuKg7dFpgnnfthr6r4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355089; c=relaxed/simple;
	bh=EwbYtVvpl7MeSZAJZcdatoQ/Ub4vWCNEeheB42ShC/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiSatb1hSyeV5vh3cD9MaYRJtmBSF2KhNBq4fZZ2Pk+PIgwEGp6R5uUExCsUFqQ1ADnOuW4eU9iqiADDY0vIXT7IPhr0qs0kkpdAacF/LlRwcgdVHf+HXn78t6S0pvmDTuPHfvbtZU+rSrh+QMWRkLJHe+w28/0O9MimUhDuHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6tQF6Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6tQF6Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB74C32782;
	Tue, 30 Jul 2024 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355089;
	bh=EwbYtVvpl7MeSZAJZcdatoQ/Ub4vWCNEeheB42ShC/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6tQF6Kk852VQmHj8B5sppEHN4Jt/+BQ7jkkHJ5vFjEvNu9htRT0Ij1Mc9hhattUl
	 mxj0vH4YrRNMO4kFj9svWdyYgjr/cYZK8iG/S52OQQ6z4oVabrCNJCpnlNXBhu0tHi
	 EzEwbO6H4bhOxER5IQcu8nJK8zfPujLob9eGpGPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/440] arm64: dts: mediatek: mt8183-kukui: Drop bogus output-enable property
Date: Tue, 30 Jul 2024 17:44:50 +0200
Message-ID: <20240730151617.994183929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 1db97d94658b9..03ccdbb1c5edd 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -767,7 +767,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
@@ -786,7 +785,6 @@ pins-tx {
 		};
 		pins-rts {
 			pinmux = <PINMUX_GPIO47__FUNC_URTS1>;
-			output-enable;
 		};
 		pins-cts {
 			pinmux = <PINMUX_GPIO46__FUNC_UCTS1>;
-- 
2.43.0



