Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B3325C6F1;
	Tue, 11 Mar 2025 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706514; cv=none; b=OB7b8yi0KnEUcrQY4B3NNDI5GJ+ukOgoX+vH03knfv4IJaxd95jxqYIg++fNs3UFHHWk3b1tGy09YZTwe9bwNoNtdFJEOHSblvsSRqgOR0D2pTueCiTJdDdIWiQbikS0E5dkPcd1ICg22O6bR0UsIJN851nK5sN7bpy+6c9Zlew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706514; c=relaxed/simple;
	bh=Vs+9uHLWbgW7Uzy9tIUZJvr0/O3gEj6p0Dz8Jex9A10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMSfPSacfwOarN9zpc4zzsGE5Z5Qw0McsH+qG1QDRGPAWHH/RIPAqHh3b5VMv0SOhB6gTSZwVuUKuf8FA7fAsLoq7yGsHLqg1zyGmgtLc6cpKb3QlY6wG4yyQWIfZt+9INa/XSC0K15JzDbaMzZHp1qHSNzX1Uh1S6dPdbHc36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oX213ILG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oX213ILG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19078C4CEEA;
	Tue, 11 Mar 2025 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706514;
	bh=Vs+9uHLWbgW7Uzy9tIUZJvr0/O3gEj6p0Dz8Jex9A10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oX213ILG+lDvYa/ljEdX3rBikw2TATBgP3ZpMoPUUwG0NJr8Op9dgE6v2tSNhr0fp
	 U8QJkQ5UX3PdybwiHP7iInhh0qNwcdj+dATTpvdWbmvlW7TlS1omOBRTJFbZRAHknU
	 ddQn/EtA4dDjOqD2Jcwa+y0+44ahlmDISKlsQLCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/462] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Tue, 11 Mar 2025 15:55:39 +0100
Message-ID: <20250311145801.234082596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 9545ba142865b9099d43c972b9ebcf463606499a ]

The MT6397 PMIC bindings specify exact names for its sub-nodes. The
names used in the current dts don't match, causing a validation error.

Fix up the names. Also drop the label for the regulators node, since
any reference should be against the individual regulator sub-nodes.

Fixes: 16ea61fc5614 ("arm64: dts: mt8173-evb: Add PMIC support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241210092614.3951748-2-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index 66f0e5b24fda4..1158bee050e13 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -303,7 +303,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6397regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
-- 
2.39.5



