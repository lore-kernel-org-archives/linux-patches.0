Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB9818C937;
	Tue, 30 Jul 2024 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355881; cv=none; b=K/AGaiyfY/O3hmIy7zZe4iulGQTaz8ENFx3nptj+emaiO/0WMukJCZG7uBvZozIYgMXtEwXyUhGVcdGdSuvbtMFtWAjRC+9gWapnOtpNyU8kqF303hSVdBq+DeidN20CYi/N0GuDkQ5rgifgKDHqhewFn5VclVSAlIkjFDEjquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355881; c=relaxed/simple;
	bh=kMXK/ik99becmGfltXAp6KUaygTZSFbeF6nONuhEICU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtUlPC6CpRJjCqKLF3OI+l+l1J/IBR+UoB7rE1Zd0jnUtVzWUhKccy3IbNjo5qX2SDSSdDI+KBVzpBvBVPLXcDnH2W3+GXnLvqwJXH3TUXUpoi8iidyqUIvNonMBnB8rFhqqGicCPBP/WMrMBDglgZaPNn5g+rbwKRMq+hdw7C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BRFiKuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BRFiKuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F121C32782;
	Tue, 30 Jul 2024 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355881;
	bh=kMXK/ik99becmGfltXAp6KUaygTZSFbeF6nONuhEICU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BRFiKuhfQrsUKogcjav+w4Gjf9nGQ6YLDmiaEww6iEeJee1u92656NFSwgx3xd6P
	 n1ZCq57n9pFNfWcfbpYdOpwiIs5lu0yKbQD5ylmRq5WEtcCiOQyWrDW+WndZ6mCspc
	 PR3kOE7qFzZqodTbo1XN+xolgNQGpAnhOL+y+WuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 101/809] arm64: dts: medaitek: mt8395-nio-12l: Set i2c6 pins to bias-disable
Date: Tue, 30 Jul 2024 17:39:37 +0200
Message-ID: <20240730151728.619676865@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 32b33be8894f3389d15b409140d663acbdf9de1d ]

GPIOs 25 and 26 do not support pull-up/pull-down when those are muxed
as I2C6's SDA6/SCL6 lines: set those to bias-disable to avoid warning
messages from the pinctrl driver.

Fixes: 96564b1e2ea4 ("arm64: dts: mediatek: Introduce the MT8395 Radxa NIO 12L board")
Link: https://lore.kernel.org/r/20240409114211.310462-3-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
index e5d9b671a4057..97634cc04e659 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-radxa-nio-12l.dts
@@ -528,7 +528,7 @@ i2c6_pins: i2c6-pins {
 		pins {
 			pinmux = <PINMUX_GPIO25__FUNC_SDA6>,
 				 <PINMUX_GPIO26__FUNC_SCL6>;
-			bias-pull-up = <MTK_PULL_SET_RSEL_111>;
+			bias-disable;
 		};
 	};
 
-- 
2.43.0



