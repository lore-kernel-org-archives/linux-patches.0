Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9861A4B3C;
	Tue, 30 Jul 2024 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355713; cv=none; b=pi67hyQuJsbLzh6kyUuiY1xecex+ZSNt1j6ViQEf7qUUODLl8MDJm2GdmGYSeM4jdqNSveinA+XkW8/UiWqe9HBHqs8B+cB6I6F052XnKchgMf6xdXC30Pw+OaqaS3YRR7A3PrunzRtYP+PkNzDBg67EUj8PGOeDUnx70pi0Dwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355713; c=relaxed/simple;
	bh=8pWWzbk2AO4iU2NAmhwniXenYHSCfS23pOqT/9LrVkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWv1btE17yie+euk1u6yWZOSw2pY7JtCGCLL7Ze2aiTY6mhQaNYjzp6b8j2iNF+I4yT33CKYt7h5QqR3rvlz69v/mrXPHyY9EGP0UxeaydMUFzLszZc6aH0xp88V0OaUSBhbMQik1J2GqhA+1Qzd1FTlbhuhHH6oqYizTRu426Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha/ktQg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha/ktQg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016EDC4AF0A;
	Tue, 30 Jul 2024 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355713;
	bh=8pWWzbk2AO4iU2NAmhwniXenYHSCfS23pOqT/9LrVkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha/ktQg6mOCIZ8I04mx9DR+gewJFHBtS1NZxt1w6SrOc63mfcVldnttGo6RY8iwep
	 iyMYgQaI5lkDlO2l/yGsbEiUmj+W8i33VfFGMPEywumQUl11ZfQQDXB2koJtzOntU3
	 f8qdhjR8wPiRsuItUiTUY3gcMX+wWQ+vmPmHi/DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/809] arm64: dts: ti: k3-am62p5: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:18 +0200
Message-ID: <20240730151727.878205198@linuxfoundation.org>
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

[ Upstream commit d3fe4b4e2e44de64ed1f1585151bf4a3627adbaf ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: c00504ea42c0 ("arm64: dts: ti: k3-am62p5-sk: Updates for SK EVM")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-3-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
index 6e72346591113..78d4d44e8bd4e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -549,8 +549,6 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
 
 &fss {
-- 
2.43.0



