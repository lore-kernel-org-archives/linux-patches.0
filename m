Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB75F351FA6;
	Fri, 21 Nov 2025 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732822; cv=none; b=Bmef+c7P/d5ElGmXJ9YWHiHxiyc9eZ2uexMga2fMKCLRzaabCZD7hH+rP9Wc24mNuQOzc46sZ1BJdO6FXejw+sdvGe3CG5yZAdnbEqfekjch/LB34IUV5g+0n8enMmuL8KWPj/sAXwh1d8SyagbHQGjLfB7oDXKcG+ALm3W2F3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732822; c=relaxed/simple;
	bh=VZk8r3Z1aPqMkIkyPCZYgjT/8Ia3MbzSFPKAR3rGQPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4Q9/5ffdS9288vjOVgj/yZoP9S8BHZoR8sNhXIjqvur+MKuFXXqSNjI0HPN5vB/t3OxtLFrAb5eYFq2NKm5fKQT2gGquBMzAThXfgLEkPUXNua9OP3fKiaNSlWpfgF5QEMbwUUK+drQTrI6i+eqLkp9jc74kSXfO+wdvIAnn5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkKTtJtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkKTtJtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41028C4CEF1;
	Fri, 21 Nov 2025 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732822;
	bh=VZk8r3Z1aPqMkIkyPCZYgjT/8Ia3MbzSFPKAR3rGQPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkKTtJtHh3mCXQY8N1rhEMJuXCh8/u4Ev/VqejFPeTnUbuGUfl0ItYqx+J122E5P1
	 S7/6A9BRTAuBDwvlr5Jr5wTYcJiJ68RlSm6VUTy6VFYIFftgNXLEZpN0nDLRR0CoSC
	 Z2zAvT+Er+DyKcycOt4UsR+tC0T4qJpDxxJvun6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/529] net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X
Date: Fri, 21 Nov 2025 14:09:15 +0100
Message-ID: <20251121130240.130129971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 6287982aa54946449bccff3e6488d3a15e458392 ]

LAN969x switchdev support depends on the SparX-5 core,so make it selectable
for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20250917110106.55219-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index f58c506bda228..15b27fc57aedd 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -3,7 +3,7 @@ config SPARX5_SWITCH
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
-	depends on ARCH_SPARX5 || COMPILE_TEST
+	depends on ARCH_SPARX5 || ARCH_LAN969X || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
-- 
2.51.0



