Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD72189520;
	Tue, 30 Jul 2024 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355415; cv=none; b=FNRGtv9mTLiTLQGOcx+5MxjUSEg6nipvYBortAHLLHNW1QWhYbc86BwURc56aHo3Dai4+CB8CnHpuLW0OCFFHQmrMyd62tb5m80QnK+1m27ipDYZqN4NSGfrcGHpWhl1fUPsjTj/aKMD7vImaWmtcJWSYWBFO+WpTyfVxFd3LsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355415; c=relaxed/simple;
	bh=7CTZwIU8mu9MjllYbo8HuTNfuDmc8RkO0ayIGC4JbsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5RG31ivAovptCl7hnX2nFxMxppUIfgYIjiP3tysrcHOuo8LZAfc/vnsACPyVpNBu3rIfbUCWaPVPwyMUGpji7CxObW/kKr9ACUQdldTKhURYBafMKvwjOydU5iMRLCLq7knm4DtxDtgg1M4l87J0D7xMFHjF3m7bCI+Sg31xeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEB9XZGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEB9XZGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA104C4AF0E;
	Tue, 30 Jul 2024 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355415;
	bh=7CTZwIU8mu9MjllYbo8HuTNfuDmc8RkO0ayIGC4JbsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEB9XZGVatgnNK6Rv0eS2emAFUkQxVYkco6pdHOFs6TVPicXyxBtPF5NrQvw5449g
	 2uvsirLeZnt0K1AEx6fyNVmaQD58auO67TNdurjdvJ+UxvkdRHgyCfQhNoifR196mU
	 r+KlBvu6ehctaTdRh+QRcqThWRRLFI973L+7p5+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/568] arm64: dts: ti: k3-am62x: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:42:43 +0200
Message-ID: <20240730151642.045549662@linuxfoundation.org>
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

[ Upstream commit 6ee3ca0ec7fabc63603afdb3485da04164dc8747 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: b94b43715e91 ("arm64: dts: ti: Enable audio on SK-AM62(-LP)")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-1-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index 677ff8de4b6ec..0f8c0f6a0f573 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -481,8 +481,6 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
 
 &dss {
-- 
2.43.0



