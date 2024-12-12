Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5615B22969D;
	Thu, 12 Dec 2024 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022072; cv=none; b=XcKBDKbsmHxdQCdU9N6Hm/rryQfCSUdDWt5qIiVwbtWohcC9CXWO/gaUtPs+rSuaxMq8c3qXyGo5MODEG4ipupmjMwhJNgYg7YV2nwBbCi7nob4APiHq3P7auA8p991Z+thyvMJpIgcRevlG96Sh5k2DQZcWiBULMnBqmN1T/YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022072; c=relaxed/simple;
	bh=qaJgUDCaj7T1ntOGe+coG2rKWa+EOvYAjMGbLe54KxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDOQ213NAwzoI4Yg/NQ29OVgTq579g+E25oLK962ytm6Bfdz2TPCfTp9syMeKBEOZRVO0m7JnA5fid2Fg7UW5NPaUULVWYuAl+I9oeS9dZ2FIP0lecM5t1h4xVbabKsF/0FZKJbIBx+pE/+PwcO+8cSwbnBNtYPB55pK0v7/Gw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZODYhSoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZODYhSoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B970DC4CECE;
	Thu, 12 Dec 2024 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022072;
	bh=qaJgUDCaj7T1ntOGe+coG2rKWa+EOvYAjMGbLe54KxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZODYhSoW8tA2zH1XZC4RbSMkqTI+jE8uqLWqjb4AQwDosEAGzrMRaLlfXIHHh6vGM
	 qer7pyd+/cqeDa4vVYtCTa9rnh8sgnmkWkCpklrvCwsgyPqs+amjsnKubXW8vLwUzW
	 jSAC2Jq4DeHzkDpF8HO1Ee3Es2zhnUu5gi4J2O0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/565] arm64: dts: mt8183: burnet: add i2c2s i2c-scl-internal-delay-ns
Date: Thu, 12 Dec 2024 15:55:17 +0100
Message-ID: <20241212144316.306625846@linuxfoundation.org>
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

[ Upstream commit 85af64983889c621e8868b744c8ca03bd5038c02 ]

Add i2c2's i2c-scl-internal-delay-ns.

Fixes: dd6e3b06214f ("arm64: dts: mt8183: Add kukui-jacuzzi-burnet board")
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daolong Zhu <jg_daolongzhu@mediatek.corp-partner.google.com>
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241025-i2c-delay-v2-2-9be1bcaf35e0@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
index a8d6f32ade8d9..0a1b79077bc45 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-burnet.dts
@@ -28,3 +28,6 @@ touchscreen@2c {
 	};
 };
 
+&i2c2 {
+	i2c-scl-internal-delay-ns = <4100>;
+};
-- 
2.43.0



