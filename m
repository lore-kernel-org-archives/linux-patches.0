Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97E112C462;
	Tue, 30 Apr 2024 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475177; cv=none; b=Frs0ea42p35ZD6CiiJGNSIXE/hCnNdmQ9sJVOaf8cjGU8QuDvg47uNSGvAp/tssJhy3ZxqQ9TRJ5KtrWsnXl7mXTUwq2ui2orEP6tbJZOd843UER/K/1F4WvCgY2yyp+YYrc3c1JVOAHBcYchkgWx26yPZbnMcVaVzyUvacVYno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475177; c=relaxed/simple;
	bh=b3qKoj3EoVq6Lt3A7TCAk5pkCU07LpAx+niu9tU7Xfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsjVn2c+IIsyxvMIiQdUTgqzqkgtSUKDndNOso/5RDTrY3I14DwmkyLNUq6OrdW4ayx/EvO7OcloT+7rpMzgxAhQ3Yb2BULhA5Fu5PI7E/rEHNqv9WCaoh6thPl3wa1QMwpYCiVJyaIM28QYKBOscWiP+G/qvL/Wa/+cNyUEwI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hB8JmvKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hB8JmvKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4633EC2BBFC;
	Tue, 30 Apr 2024 11:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475177;
	bh=b3qKoj3EoVq6Lt3A7TCAk5pkCU07LpAx+niu9tU7Xfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hB8JmvKzFBCJLgUJzgpuQeaOk0V5f0WNxqFkeI4zU8AdzVwF1YDncYDGgBMHfy6CF
	 XZAm2cFtISkHm+CKL4NmgJhPJNh6e7m8qlnCqDbKwFSAnO5sVgGjxlOHovxS7XanWj
	 sZQJ1UAmIJ5jBuq0iYz2ZvMxwiHcjR6R5+3ofTO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/186] arm64: dts: mediatek: mt8192-asurada: Update min voltage constraint for MT6315
Date: Tue, 30 Apr 2024 12:37:50 +0200
Message-ID: <20240430103058.549937520@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4bd1494b354c0..dc39ebd1bbfc8 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi
@@ -1392,7 +1392,7 @@
 			mt6315_6_vbuck1: vbuck1 {
 				regulator-compatible = "vbuck1";
 				regulator-name = "Vbcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -1402,7 +1402,7 @@
 			mt6315_6_vbuck3: vbuck3 {
 				regulator-compatible = "vbuck3";
 				regulator-name = "Vlcpu";
-				regulator-min-microvolt = <300000>;
+				regulator-min-microvolt = <400000>;
 				regulator-max-microvolt = <1193750>;
 				regulator-enable-ramp-delay = <256>;
 				regulator-allowed-modes = <0 1 2>;
@@ -1419,7 +1419,7 @@
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



