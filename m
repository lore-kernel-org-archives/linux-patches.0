Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5EE189B84;
	Tue, 11 Nov 2025 01:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824141; cv=none; b=Lob1QIX8HQ9zsX/7dS+7RSENyP3xtxhygr8nLafF2eMUOcRDlNAyax4f3qNdRTUWM339AAYVvr2UM93AwMhVMTWVObRt4FzU4hv/cxh2wa8ug7MqXTkLTHAQVhtxH0bp6C6NehtNnCarfMT+HYVPbAhjHkPaON8qpi2rB09HU74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824141; c=relaxed/simple;
	bh=CPRThx6CN5yvEYn1+f0bOnUh6vOZB3SXYM+bl/OUU+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miPk1zpRDy0ZeEHkN5AI4l99j2umaMVgCym83V6BmXpDzEJApju36T1pYtxivoqC/1dCjEEtV02BJN/VhFsptgykHHu9biK8DI2aj3eJ9aMHpZ9fVkpLzKETRbbOXQcqHrI3BpaW6CUgW/tw4iiFd0s5I363VJZ4a3VvclyjyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lvrDzRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lvrDzRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0094C116D0;
	Tue, 11 Nov 2025 01:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824141;
	bh=CPRThx6CN5yvEYn1+f0bOnUh6vOZB3SXYM+bl/OUU+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lvrDzRRz4XswEqzDGXXoxgeg4YQXMpqnw39wc/zo4KPYokolzvWoVbWdgvyNEeut
	 s6luprQpOWUZUH/hNo6all200dPDs+Gic/k2CPt1NTBDrBMLhx8X2N/TYThPKGP/R3
	 fkaIOhTQlrUbPnIs+WfWoQC0vcuFjAgCelauNuzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/565] net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X
Date: Tue, 11 Nov 2025 09:44:11 +0900
Message-ID: <20251111004535.759004265@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f04992eace6a..64d774f64b12c 100644
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



