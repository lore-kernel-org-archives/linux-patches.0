Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6BC1B6D0F;
	Wed, 19 Feb 2025 09:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956416; cv=none; b=H6XqvnDIzqMGWNW6CRWjKhZpl3EWCuKDsShyogdhDkex7DRUWxQTeiP4dK60Hs8IKIucENiJ3u9E6qW3b+tN7ycyDs0UD1dY+9Pc7UBvAxPHwPGrdSqn7MfP2NgNfkdrASqhNROILd+qBZoFK5K5/1ga8L4yt4dPzejzuOjwnA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956416; c=relaxed/simple;
	bh=4VPXf+9RwtNL5bpgy/o0iZct5yFCM0ICl6F3Wqm4HJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LONDN6rPhXVsaa6pb0QyPV/avJMSI96AxektMIGexBw40zgBnB5EEO/wkRAIDs8jToHZcncHoMRlfC5hB0mwWXFNsMbd7zy+hNfY0oXi8riIpAK5q4Dql3gNiN3iWa8RaeHyl9j5UkKn+csRV+xcRYDMAZ0SqUyEwiohMVGo8CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hTiTjPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hTiTjPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC7AC4CED1;
	Wed, 19 Feb 2025 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956414;
	bh=4VPXf+9RwtNL5bpgy/o0iZct5yFCM0ICl6F3Wqm4HJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hTiTjPW87f5QAuKV4lFf2Bkhb7cOebpoL1+PoRLohToSuglpXEY1mu0VyWfRu8yT
	 7ZQ+kCujo8vD0X/p3VqkLzb/2ir5qLM2b4D6cIbQ9IcHpvgo/e4B6R3Qc+6fHdX7H9
	 /FFMjA6+hoUWlrg9hocIWWBAENT0m9Of5yx9P0nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/578] arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible property
Date: Wed, 19 Feb 2025 09:22:28 +0100
Message-ID: <20250219082658.646335627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 4dbaa5d5def2c49e44efaa5e796c23d9b904be09 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 260c04d425eb ("arm64: dts: mediatek: cherry: Enable MT6315 regulators on SPMI bus")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-6-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 0243da99d9c69..e4861c6cd78e1 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -843,7 +843,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -861,7 +860,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
-- 
2.39.5



