Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643371D1E74;
	Wed,  2 Oct 2024 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879474; cv=none; b=eTDpf3YK/Hu2AIigojcKz6T01oRNpfib1nf4HU4hXK2/FHnzCr6xDbdkDpq4R37Agre64OWqpmJzd24eZI0N5WY6+PeKFfg1xSsnFFbjKLHgXumAELbscBPDpLoKKYnfrQ2q6+1VluU15PNNDSgiycWcJoqIKP7iTI1BoVJkx9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879474; c=relaxed/simple;
	bh=CqW/JoxyFPI+P28OrrS5925aNSfYCOzdR2tsu9Lxtow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5LNMt+4H1h6wwcOd0KpVGIUUKJJUWjTN5supHyWWlLFruTYeqgTVZMOIF86SHOUV5V75Qe1w/uOMd1mXuS10XUGJeN2a9HejhYd1aIPR+d1o+tGo/YvKlptSAKXXUzqLaqmR8nhz/d0po7TDiBYwRzf+wWT2zTNQC3b2be4kpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC3nsgfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC3nsgfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3441C4CEC2;
	Wed,  2 Oct 2024 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879474;
	bh=CqW/JoxyFPI+P28OrrS5925aNSfYCOzdR2tsu9Lxtow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC3nsgfzZbA93pKqj7ntvp0tBAPVWE0hrY1xLvwolTPZpLkX2v0Txw0Eh9buUpkmw
	 ANptAfqfuatI8Pn459gEsWyXfF4Z3o88BinFlYsyDr+SbKSjfwd/IiptqttYBnZdPq
	 Tw2L/F4oDqS3ZGxbZNjcpLfR0VVsxGrkEE/WL2v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/538] arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations
Date: Wed,  2 Oct 2024 14:55:39 +0200
Message-ID: <20241002125756.179044337@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 9f3814a7c06b7c7296cf8c1622078ad71820454b ]

The DMA carveout for the C6x core 0 is at 0xa6000000 and core 1 is at
0xa7000000. These are reversed in DT. While both C6x can access either
region, so this is not normally a problem, but if we start restricting
the memory each core can access (such as with firewalls) the cores
accessing the regions for the wrong core will not work. Fix this here.

Fixes: f46d16cf5b43 ("arm64: dts: ti: k3-j721e-sk: Add DDR carveout memory nodes")
Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240801181232.55027-1-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
index 42fe8eee9ec8c..ccacb65683b5b 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -119,7 +119,7 @@ main_r5fss1_core1_memory_region: r5f-memory@a5100000 {
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -131,7 +131,7 @@ c66_0_memory_region: c66-memory@a6100000 {
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



