Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FA2D7BF;
	Tue,  3 Dec 2024 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240568; cv=none; b=TR7aUTDCLN8RJAIFHII3u+R173ThdT06qAjZaQZonV5iX+qAl57Gm4xE/p6T5yu7b7WavJoJ+s3Bkcv6OGWbNfp2Saku0gWBuuqAZ+RlajETxMcEJp8JQPo2Q8hk/IWXnDPijw62rxgolBYvsJArQN+sgZNyip51vctlardhyUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240568; c=relaxed/simple;
	bh=pfQ6qY24PHdWBGhwpUJbp3UUwAB+8sktT1XOMigiWM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd3IRN5z0JivRfhcBIXmMrwIp4AU/C7z+TcRRReN1VrtLNlPwtls11mihZpJDHC3gfeAJbbtbhKKixcKuUS19rm7JN4ueuYRISMWElyIQtwnZYL1jUPIWST117byX3ryUcorQOyWOisewqy7ElXtRKxN2ZuRCNPhbJZyWzSjvmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNZ701a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNZ701a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46C8C4CECF;
	Tue,  3 Dec 2024 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240568;
	bh=pfQ6qY24PHdWBGhwpUJbp3UUwAB+8sktT1XOMigiWM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNZ701a410ZHBw4361aoTfJiSIAJA/pRjQPd1mRMJLAcF0N8g0ipQdvDVJ8QXnVeL
	 c3VJDZfaRxQlQ4CqrcZ7RU5iPJ7JgqMGKwOqY0H7OXSEiDscirxkLaFAV6hepgBZfx
	 mk7ffNzq8slhWFBE4GDGFr/6qgyKf2/VydM0tsZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/826] arm64: dts: mt8183: cozmo: add i2c2s i2c-scl-internal-delay-ns
Date: Tue,  3 Dec 2024 15:37:50 +0100
Message-ID: <20241203144749.325851553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>

[ Upstream commit bd0eb3b1f7aee698b86513edf10a50e2d0c7cb14 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: 52e84f233459 ("arm64: dts: mt8183: Add kukui-jacuzzi-cozmo board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-3-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
index f34964afe39b5..83bbcfe620835 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-cozmo.dts
@@ -18,6 +18,8 @@ &i2c_tunnel {
 };
 
 &i2c2 {
+	i2c-scl-internal-delay-ns = <25000>;
+
 	trackpad@2c {
 		compatible = "hid-over-i2c";
 		reg = <0x2c>;
-- 
2.43.0



