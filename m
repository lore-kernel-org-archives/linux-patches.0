Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA4F18E046;
	Tue, 30 Jul 2024 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355872; cv=none; b=lcu4E3Da6dJ2xZFig6jH3muqjbu4y7vrSM4ujLYRx2AWPENn4w3R5uFSmCyp84ffOV3m/WE2HJrpx8vbPfFHO1wQsWeUjpYmNoYFH6U1quZqOpJiEYgR+UIYsAf4sPtU+DhPgdNt8F9EjiSxErCnCHSnYHeLxIq7lQMkJhE5iTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355872; c=relaxed/simple;
	bh=miuhHvxhMnNNKcojtFl/yUZjolRMlnWNrsiW2Hz4zPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twSdr6HPfvR/wRJlgYxNmMDGJdbdW9xU8SIu2Y9OnE4MznSs9+3mScKB8TvH4Ak5lKGQuhnyNirHgtOxI8ZF12jCT4NQVGqbkZd0Rn6W8lkmQkCFVzbshv3PqQRNJuqTAkR+OJ9v+NUh3TSG1bOkPguZhHawd3/QxH5wOql8xfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzId/ufl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzId/ufl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17656C32782;
	Tue, 30 Jul 2024 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355872;
	bh=miuhHvxhMnNNKcojtFl/yUZjolRMlnWNrsiW2Hz4zPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzId/uflQ+NuIXwf7AL39YvFtpO7QNgR91Bn1cwojPcThviBHuspoNmgWWuOXZif7
	 a0MkRm16thbRnS9Xtl8nvSvH9EB7Y1OKG59sbktQ8JOE/w6CCVdwsHnEE9lXZfYC2u
	 cL9orR0R8OGTt61WIwKf0FMzC3XRp4uUBUuugnjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 100/809] arm64: dts: mediatek: mt8192: Fix GPU thermal zone name for SVS
Date: Tue, 30 Jul 2024 17:39:36 +0200
Message-ID: <20240730151728.580515947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 86beeec5dd2b8e28217f67815a3fb15752031667 ]

This SoC has two GPU related thermal zones: the primary zone must be
called "gpu-thermal" for SVS to pick it up.

Fixes: c7a728051f4e ("arm64: dts: mediatek: mt8192: Add thermal nodes and thermal zones")
Link: https://lore.kernel.org/r/20240410083002.1357857-3-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 84cbdf6e9eb0c..47dea10dd3b8b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -2234,7 +2234,7 @@ vpu1_crit: trip-crit {
 			};
 		};
 
-		gpu0-thermal {
+		gpu-thermal {
 			polling-delay = <1000>;
 			polling-delay-passive = <250>;
 			thermal-sensors = <&lvts_ap MT8192_AP_GPU0>;
-- 
2.43.0



