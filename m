Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8E518B473;
	Tue, 30 Jul 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355749; cv=none; b=rl8a5rk3pehwiTGItE45s5jgON/oHK9rQQJA96AhUfoJrg0wJL7DPuFxKlTm9xlBdC0IPzExYgpVH71P3/fwrmzTf+XzQpxyNq7fUIBfxC7Rerxt3WCXplSoNeGi9LaG+v82HVC3kXP0VRt4FIq6IoD5+8DplAivvJAmp7THjDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355749; c=relaxed/simple;
	bh=MFKUJgxe93hcvW5eVBQqopclHsGjjlgNpYo28Pxa8Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaOheWP+LHZDGH5hMV/hASK1rPdaYSXcriRP19Mr4olzkw7tlRf85/zjiHOo7G4nN+gK7gWsXdaJ2y66XL2sb7b8fuwvYackusCvmzBupVEB/bTuZ53tjRQ+/W4TbPpY/1A+Lupbt5oh+N8nnXE4r7BfXjTy3H+yR8Aq368t1JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfCUCULS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfCUCULS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F21FC32782;
	Tue, 30 Jul 2024 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355748;
	bh=MFKUJgxe93hcvW5eVBQqopclHsGjjlgNpYo28Pxa8Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfCUCULSHOpkkm83mNXXx3Fu33Twd3mQM2ofJVRGLHFGAA26Xg2AuG112FGVb0Vyn
	 kFd/7KTyZLB7390E4eSwfZXfBLPtBAdVsAYO4c+eyd9TQ0yIF5qLXXXXE/wzLzmQYe
	 tENJZWRgmOMEEcxkbcceH71nHemMWPFXnF9E7GHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 085/809] arm64: dts: ti: k3-am625-phyboard-lyra-rdk: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:21 +0200
Message-ID: <20240730151727.996216118@linuxfoundation.org>
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

[ Upstream commit 554dd562a5f2f5d7e838f7b229a1c612275678db ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: 28c0cf16b308 ("arm64: dts: ti: k3-am625-phyboard-lyra-rdk: Add Audio Codec")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-6-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts b/arch/arm64/boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts
index 50d2573c840ee..6c24e4d39ee80 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-phyboard-lyra-rdk.dts
@@ -441,8 +441,6 @@ &mcasp2 {
 			0 0 0 0
 			0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 	status = "okay";
 };
 
-- 
2.43.0



