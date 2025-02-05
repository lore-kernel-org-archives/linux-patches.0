Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A441684B0;
	Wed,  5 Feb 2025 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766598; cv=none; b=ZrjDvnROeqTL5rwqGEhOsmNZhh5ipC8xqqxGMNwFBu1QGFCVOMyy/0kdXzAsidl5hzJR0beR4EMGAXSaC+PBx7ALWOmx0YLpLiB28/9ue7kHRM54m6lqp3aLxKrgXKqdWv7HEGl85hPnnuO9NejMQpXnZo57OjIPoX3lRH1BXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766598; c=relaxed/simple;
	bh=quOvjSyAGae46+khY1x8eTJ+deuCpeN9f/ZEEFH5N8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ+tazXVwMxXkP6QVpy44/4dkpc25mA75JMhoJBgDQYtz9IUyM65xZixSeB9gmcLL8c0La6DxsP3ktlLCPEW87FtC29NN8srMAFEPzwdGCE9UqK2o54UPgil6D/GdPsBuoWGi/4lNpbHorUw/oCdvNao2lpcvxhLaWcO9ZDMY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDIn0Mr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDIn0Mr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB488C4CED6;
	Wed,  5 Feb 2025 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766598;
	bh=quOvjSyAGae46+khY1x8eTJ+deuCpeN9f/ZEEFH5N8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDIn0Mr2RszZrnKnqpATe6mxXEnj8dHLVm08yT7kcAM/r1FZcplt9SbjqkEwMJNGH
	 qKfTUm9wCJQIKbQoOX0B+/FMq7Tmf0XSMv4dgm1CyFZ3bX9nyCtUTSzUL6BPCQSoVE
	 G6i87CHfoDk497jzA89m6xFsUZni849egFdmglTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/590] arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names
Date: Wed,  5 Feb 2025 14:41:18 +0100
Message-ID: <20250205134507.632772295@linuxfoundation.org>
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
index 511c16cb1d59c..9fffed0ef4bff 100644
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



