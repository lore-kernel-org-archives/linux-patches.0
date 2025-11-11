Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572C5255F28;
	Tue, 11 Nov 2025 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824911; cv=none; b=hhJDtvdAyPSgM2XiBo6IGkdZffDhMm48WrndxbplzQBLLnBUYNraR1x+EiiWYkmPwjdoKL9zM6W17qC7mYzTbIU9LXTRNGtmoH8dJv55h7VtxTLGU0wYSNivfrBkzCzqstDLVM4Y0MoXBEYgBocfcGOMEbkdiyePmsqjKlpyONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824911; c=relaxed/simple;
	bh=aluxYcoqOdkO56apVt8bRAZMYp1snkhSDYfu4lPIqlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4x/eaQCrzU0Vi25UneOFIxr1HXh4xT+PoqlbJH5xw0axUHdPINOWHRa4izhYwRXsoQt8L/OLOs4i9yV3VZ7QgEMXAIXSfFSrGqNU409OXo7Mw1JIrOqBjL3w0UBT2Zl8/TufbqpEHxPJBWCGT7RJIJn2eOARfMsecw+GPv9TCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQWQOh6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQWQOh6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8ABC4CEF5;
	Tue, 11 Nov 2025 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824911;
	bh=aluxYcoqOdkO56apVt8bRAZMYp1snkhSDYfu4lPIqlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQWQOh6pSnfubFiP8CLMQ326aFQXEGaA3uEMh7sPwAYgFb3WYuK7dhwo2mtTedTAd
	 Jx//uwiWKDgin817txJHHLZgsw/+94dwBscbv4ibivXoK7ebB/OC/Hj+ZfPhfIz7ov
	 6Y6656C0WDxYajpROS5u0DMkO6GsdU2GfKEfeAIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 596/849] net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X
Date: Tue, 11 Nov 2025 09:42:46 +0900
Message-ID: <20251111004550.830554645@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 35e1c0cf345ea..a4d6706590d25 100644
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



