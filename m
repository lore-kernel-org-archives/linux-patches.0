Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FEA229692;
	Thu, 12 Dec 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022032; cv=none; b=ImqSR+l3vmOkV6dV4UuinVX7MrAZTdwAAP32INGgmoPyw2028FHi6p+dz1w3jYpxJUqHdVV4mUwuk6vF0EFxah6eMm0qRDEfyGjBzMBw+oarbCJS9g9wyySi0/jU2IZ8I/aeRFqKI2gz2wlqkUM5guEEqgh1txPvwWhiZMELeU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022032; c=relaxed/simple;
	bh=1AmttdjwYf+SGfezzAAsLA7ebyxy38x4AjE7OE2MLXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8QqVwUELg1TeOO7MNuQkMXANhCBLELt9NK66E4wQ0MPWuvYSsI+MdxL9ZuJ9q4ufzQNly82l5vHf07etCYeBUx96G0bQQ8JzJR0Ds0e6qMUkZd59uRfamOhT819FxPunW6y3sNmQIWLExx9GzahiG087CjqbCJQWxP69tUxFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH4j0UEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH4j0UEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D64C4CECE;
	Thu, 12 Dec 2024 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022032;
	bh=1AmttdjwYf+SGfezzAAsLA7ebyxy38x4AjE7OE2MLXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yH4j0UEkoSbmyID3uU4MQ88a0nAsOIgcarcM1cA1ZkdYJQLkThlo+1kvsKtmEYQT5
	 AhXWKBcOXBNOcpY1NKaPiV+BA3RSL4Fds7SdTb6QcduSbfzjKanZ6XEAGsut+FW5vs
	 p+dMiigWUQlAVO4lEt2EmcTrr7v0+ahKfaJ1QJFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/565] arm64: dts: mt8183: fennel: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:55:16 +0100
Message-ID: <20241212144316.264804561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit c802db127dfb9602aaa9338e433c0553d34f1a9c ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 6cd7fdc8c530 ("arm64: dts: mt8183: Add kukui-jacuzzi-fennel board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by:
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-1-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
index bbe6c338f465e..f9c1ec366b266 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-fennel.dtsi
@@ -25,3 +25,6 @@ trackpad@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <21500>;
+};
-- 
2.43.0



