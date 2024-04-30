Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246E212C46B;
	Tue, 30 Apr 2024 10:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474092; cv=none; b=iziYI21+XlUvwFn/Bakm0lHlH6xL8Wf11QAWNA9ZmZ/Xak/iVKmJexn/dxJsHEmAGN+eNV8OdiE8RiTXtKuyz2AjIt04ZQ+XdKTAyWXKtFr9qLEJHptFvBC9ZtK0jXrQ61z68/LMaMOKnnWfXSN9jeqWRkLNWw/7iXXMwVocZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474092; c=relaxed/simple;
	bh=qYYk5KQXlxxE/cJA+8S4KcuPhNQM7b4a/si+9tiiQY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FV1GS105gHm/xqkV4TLOo/OQZwlTyGG/u1v34xmfMxSg5tHdO47lfI9c8jumuqrvXzbO342LIjsrOww2TxxF7VYZvZpelQM93na/9WMTsdvGtRtL6fJixZGmBbf7EidfPwgN4X3kMd+MVgC5DTE8FmdP1Umpc6EglWmvx48J8RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM8ZEtQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM8ZEtQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A067CC2BBFC;
	Tue, 30 Apr 2024 10:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474092;
	bh=qYYk5KQXlxxE/cJA+8S4KcuPhNQM7b4a/si+9tiiQY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM8ZEtQJ66OvsoOVJTR8wJgzT3rFsY5w338ewadIgBaXU8AqVDuQaSEMQ/OUY+5G5
	 GtXsKZGxJJ66fs9Oi7HSZxpElmR6Ttqg1uiaiKCtxPDYV+ryofi+o+dWj36pLDJRzp
	 g3VR9SCKHql9/kvZdGJrq0V2v1DkDDmX8waYNTYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 018/228] arm64: dts: mediatek: mt8192-asurada: Update min voltage constraint for MT6315
Date: Tue, 30 Apr 2024 12:36:36 +0200
Message-ID: <20240430103104.341263996@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 374a7c6400e314458178255a63c37d6347845092 ]

Update the minimum voltage from 300000 uV to 400000 uV so it matches
the MT6315 datasheet.

Also update the minimum voltage for Vgpu regulator from 606250 uV to
400000 uV because the requested voltage could be lower than the minimum
voltage on the GPU OPP table when the MTK Smart Voltage Scaling (SVS)
driver is enabled.

Fixes: 3183cb62b033 ("arm64: dts: mediatek: asurada: Add SPMI regulators")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240315111621.2263159-2-treapking@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
index d4dd5e8b2e1d3..f62b2498eb1c7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -1420,7 +1420,7 @@
 			mt6315_6_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -1430,7 +1430,7 @@
 			mt6315_6_vbuck3: vbuck3 {
 				regulator-compatible = "vbuck3";
 				regulator-name = "Vlcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -1447,7 +1447,7 @@
 			mt6315_7_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vgpu";
-				regulator-min-microvolt = <606250>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <800000>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
-- 
2.43.0



