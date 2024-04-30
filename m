Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBD1E50A;
	Tue, 30 Apr 2024 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475222; cv=none; b=AAkDCF7MEqJfj0Mzb6+IA0ubDYkbHf3a0vwSVY0sdjbgMUBGO83bUcAt5k/xhYzjfY0t4HCiOoiGIUq5eJ2zAr+fpxf17Fxxj3NbV+Qd2Lady0pA92KJuU+PMM0NCmuuow9m/NeS8b1/DKP+sXrcWEjlqL+ImtY2NXg9JUoKp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475222; c=relaxed/simple;
	bh=JWL+zLCFShKRtN2Te10MlFcXsRdR+BRR+FPd7VFxXwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VklvQ0nMLvFQ6c1Xv/ZWKZa8SwMYUfUeWkyGeiY4QZkYg2BW2hRO5sKFCErRaO/ygI4rNolGox53WK2GrASY2h+C8C8e3ly0WFzCgyyocvrgpmSOfYBFTrYI8OGNNqPMSe/hFA2uH6CuD3szIJts4gsf9f8vO/0+DqblywvCIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXIPzQAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXIPzQAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF043C2BBFC;
	Tue, 30 Apr 2024 11:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475222;
	bh=JWL+zLCFShKRtN2Te10MlFcXsRdR+BRR+FPd7VFxXwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXIPzQAzLGHRxe/tqy6/q2dTN72l13hIYfy8C6BvZblErjN/9YqbPooEaoimUjbD7
	 BZp8hILsegzjk9mozM+QFufRj9D73xIvf0Bi/3HxlTfoUVeQAni1hOLkcPlyGwU6G+
	 dMxgV0Jt8Va93XvxVnrrYOqilduMVOoblDYkQRuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/186] arm64: dts: mediatek: mt7986: prefix BPI-R3 cooling maps with "map-"
Date: Tue, 30 Apr 2024 12:38:02 +0200
Message-ID: <20240430103058.905186642@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit f8c65a5e4560781f2ea175d8f26cd75ac98e8d78 ]

This fixes:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: thermal-zones: cpu-thermal:cooling-maps: 'cpu-active-high', 'cpu-active-low', 'cpu-active-med' do not match any of the regexes: '^map[-a-zA-Z0-9]*$', 'pinctrl-[0-9]+'
        from schema $id: http://devicetree.org/schemas/thermal/thermal-zones.yaml#

Fixes: c26f779a2295 ("arm64: dts: mt7986: add pwm-fan and cooling-maps to BPI-R3 dts")
Cc: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240213061459.17917-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
index e1ec2cccf4444..aba6686eb34a3 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
@@ -146,19 +146,19 @@
 
 &cpu_thermal {
 	cooling-maps {
-		cpu-active-high {
+		map-cpu-active-high {
 			/* active: set fan to cooling level 2 */
 			cooling-device = <&fan 2 2>;
 			trip = <&cpu_trip_active_high>;
 		};
 
-		cpu-active-med {
+		map-cpu-active-med {
 			/* active: set fan to cooling level 1 */
 			cooling-device = <&fan 1 1>;
 			trip = <&cpu_trip_active_med>;
 		};
 
-		cpu-active-low {
+		map-cpu-active-low {
 			/* active: set fan to cooling level 0 */
 			cooling-device = <&fan 0 0>;
 			trip = <&cpu_trip_active_low>;
-- 
2.43.0



