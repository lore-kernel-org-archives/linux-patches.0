Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1CD17CA12;
	Mon, 10 Mar 2025 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629026; cv=none; b=BiqP7pGkJGmTwBLzcBR03WucY0j8eKapBxVK7xjffthqc7fioRjXtXWosFDE7/sZlxvP7tjGaBsik2xkDFQV3ygMbxGyFubgMB9/tDcnuRBUboSyY/YnxKPEjXhEJm9K04zjIuiU9UawxpGanu+sZVDqXhj3PcZjOLoYftTrzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629026; c=relaxed/simple;
	bh=Z9JhkaJ/nODUt1zmUcRRTVQosQUvzef7mL/EXaYZY5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VclpCajODZ6P63bYXPwXpFDX2kQ4vtIgNrXrE+kuKncLYUJjhvhHoKdIRKHxvP8+Q92nm6UAiqBnOiFqSCzGEf0s+n78/1/YOxIlY4ZV1ItzdO4DF0Bj4M8vcO//7qGZVKVsoXGAVpKAnQUTDN7DSx1I0xRQ/EudTzuFk+Z5CPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aidG+tsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aidG+tsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A5FC4CEE5;
	Mon, 10 Mar 2025 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629026;
	bh=Z9JhkaJ/nODUt1zmUcRRTVQosQUvzef7mL/EXaYZY5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aidG+tsH8f2al0InNIg6C6+4HOqpH59Z5XLkRM/RmtoUzgVxXBp0eYJXqtXXnZgCD
	 IRaVexmdUHV93Xxkp4HEGk46sOVZmbOc3HYO06BQYBPIe6BhdiGB2FB6HRMIDRhL32
	 3ii5Xa50xIJ7gSQtMrTUABcCQ5/7X0wfOO9KnUIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/620] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Mon, 10 Mar 2025 17:59:16 +0100
Message-ID: <20250310170549.948144239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cd52926190470..52b56069c51d6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -307,7 +307,7 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
-		mt6397regulator: mt6397regulator {
+		regulators {
 			compatible = "mediatek,mt6397-regulator";
 
 			mt6397_vpca15_reg: buck_vpca15 {
-- 
2.39.5



