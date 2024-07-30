Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F007183CBF;
	Tue, 30 Jul 2024 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355429; cv=none; b=mOfVlfy5WA4snRT/QbEFPN61TdjddRn8Ys7nrkfRqyZ7RB+tLQpm+OY2IIcWisucKzdPuP+/oPEXgEQ3g94wdT0XXeFZQX4VsmPsUYs9TJygNzsfzi4eDdcerVSfSh1ernqyvDG5ek7ToQE0Ky7QlTk86o2xm52dW/O+ezscyb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355429; c=relaxed/simple;
	bh=Sih6RoXnVAHcbGgPsvjWRG1wsl8a1fN9ku0R8IZIfxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fsz4xugB81hEB9Hw1iwhquNLBb2xQgoPNG6YMPmXp4yjchAOONPo8cQTEHIYSvt51NDL9bU5zx+DlOF83KyqS6RjFnzEacQ0H9W9pLdGceycyMJKDe557Kg7hNEPvhHmJpsiPeGUVVScR1Ll5EVBjbVa2AOFdx9hJcnoY/pj+dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US3uFuC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US3uFuC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D42BC32782;
	Tue, 30 Jul 2024 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355428;
	bh=Sih6RoXnVAHcbGgPsvjWRG1wsl8a1fN9ku0R8IZIfxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=US3uFuC4de1606ddveRbZ8jFK7pnqw26ekMwd+PnC/lJYqoPr1ZC9EYPEkl2pZUGO
	 EiRX/C8cRUW58skQngAJ2jp64pq1U+Z9WYJu4hv4QlWPjQN9Ntu0YDqdM+4JFJ6ylq
	 nTAE+21725WXdcAzrry77NJ2N65+6woLf2u4Hd9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/568] arm64: dts: ti: k3-am625-beagleplay: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:42:44 +0200
Message-ID: <20240730151642.087832427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit 3b4a03357aee07a32a44a49bb6a71f5e82b1ecc1 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: 1f7226a5e52c ("arm64: dts: ti: k3-am625-beagleplay: Add HDMI support")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-4-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
index 2de74428a8bde..3560349d63051 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -903,6 +903,4 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
-- 
2.43.0



