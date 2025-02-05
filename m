Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D304155747;
	Wed,  5 Feb 2025 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766397; cv=none; b=pymq64OtVQo6+kIhmZRy+gv00ySPLuRUeelgKJqrtvxkTJy8wNj9Cmaubdk/GyGgtpCPorrm8xXxzANYGGBS/nTCjXVfLXazBw4jef2oxnaiVfJK40KX+rfNMLPddc1GSeDA4ygUsCHLvqwWOUBHr85Q1rdYJhOfE3OWOPSDrKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766397; c=relaxed/simple;
	bh=luoH14L8F/vNJ1Z1RKjGIU9EiSk0vUmj1sQy8Y4+eL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnYNkqyaUfSt+XklKyvySJzUwcxHpmg15/CTayzvfw3hDf5otY76Pb6iri7dDEnc8ZflvjCWnYO+Yr0sYgkQzYy6F4siAw94a97cBPuKK2I2AoyywTMrXANIC7SphgLPHKiknD4FomSe2/+1aOl5PWIZ2GAtCLqedOddxRtzHBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxM4hTk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxM4hTk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F311C4CED1;
	Wed,  5 Feb 2025 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766397;
	bh=luoH14L8F/vNJ1Z1RKjGIU9EiSk0vUmj1sQy8Y4+eL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxM4hTk+1wtaTzNKRzPKGvLvrkO/9Ihqd8Fhje+lgxdwv1tYVgKdziSq+eYnj1AdA
	 Acig5/hxrwFn6IOziAPSXxSZEzWQyUjH1nwCao/ia2hrMkzWHe6sQHsvyvMOhTh3GU
	 6cgU0381MXhGExUH4Jiw8f2DjyHmCUu6Xqe86rII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/590] arm64: dts: mediatek: mt8192-asurada: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:12 +0100
Message-ID: <20250205134507.404278960@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit d1fb968551c8688652b8b817bb081fdc9c25cd48 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It should not have been used for new
submissions such as the MT6315.

Drop the "regulator-compatible" property from the board dts. The
property values are the same as the node name, so everything should
continue to work.

Fixes: 3183cb62b033 ("arm64: dts: mediatek: asurada: Add SPMI regulators")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-5-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index 08d71ddf36683..ad52c1d6e4eef 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -1420,7 +1420,6 @@
 
 		regulators {
 			mt6315_6_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -1430,7 +1429,6 @@
 			};
 
 			mt6315_6_vbuck3: vbuck3 {
-				regulator-compatible = "vbuck3";
 				regulator-name = "Vlcpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
@@ -1447,7 +1445,6 @@
 
 		regulators {
 			mt6315_7_vbuck1: vbuck1 {
-				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
 				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <800000>;
-- 
2.39.5



