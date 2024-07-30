Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF018C918;
	Tue, 30 Jul 2024 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355704; cv=none; b=fTAmn2HzUQqAh+dkQzJ7pz9nPTEPr90V2P27TsDkbQ+rxVs/6Wo1pUYQo9RU0CHBfIzS9SRH4ak7YGt9wBhggPFzAONwzJdaArzFNe+/QNw5mZ3zJD7hOh65IeG8mpaCuTrU5ylb6J4lSkbIYezIrNgiRj3V3vCQLV+ai0D61tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355704; c=relaxed/simple;
	bh=x+6sPOWKdKiL965tHmNBISMO47pGkmbcj6wR3suzfnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwM7x2olquA5fTdxMP8rmN6qk6EzZz3wNq6N6uEnx9HxmrCPFniCf3EmA8sv5I4GC1kDGqCsaLOU3wtCMVV9/1XffzcrWizDdN1flbrUmDhkSqMXeYr57kYINv7YA7lPt8D5Aw9tBPgvtUKLsk3oT6bSlW2VHaTd5oYE16D79Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBr/NCJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBr/NCJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6105FC4AF0A;
	Tue, 30 Jul 2024 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355703;
	bh=x+6sPOWKdKiL965tHmNBISMO47pGkmbcj6wR3suzfnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBr/NCJyeISgRkvxIGBJXp6/6YNa7+x9op08vAqiWDZQ7GTVUmIwo99RoPomZwUQa
	 Dqn2CYTkosHiooDNzPq4paeCFM3p1XTTZCuN/LiI87xih2E50cxj70n1KzOhTpD/WA
	 yVmtkPIDlJisruf7Q60D/3JZuF6/CJRv+Lov7C8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 081/809] arm64: dts: ti: k3-am62a7: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:17 +0200
Message-ID: <20240730151727.838735572@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit a931b81072921a11d5bb8e8201b6228b791d40a9 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: 4a2c5dddf9e9 ("arm64: dts: ti: k3-am62a7-sk: Enable audio on AM62A")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-2-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index fa43cd0b631e6..e026f65738b39 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -701,8 +701,6 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
 
 &dss {
-- 
2.43.0



