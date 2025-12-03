Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C6303A28;
	Wed,  3 Dec 2025 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777991; cv=none; b=iR5IVuJigD/zSqcPtklOypErZVGy7sk9JYYxXj2yxiNASsuU0PcVNnNsr2S2ZXQXgtQyovrgIveH0+EJTedrAb9ORPwWgfliDAHiY1++cRQu4rypPt9/MTxintHfSJFmPJxgMWawVtl9rDuQy05JgjUTpv5azsdJTZzay9/3D3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777991; c=relaxed/simple;
	bh=aSsTR5TMgeSQXP3t78UN6a6vl76em0lSPsq3n+2octE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmvh6C+EsPB5AGkx1wK+Vzclc7hsHEHHRcnI3YPcjjmyE31O5Hz43hB3BwhPCEqQZSZ7X8dTp6HS/zLIPhIHoEnEbcSx8RF6vrLN8yB/GOF8sSat1pRe77wjZpWdQiP8+wXNvmoORXYAMBM6f99ad53bZ69e7x9aG2sWxaxsmHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWjbXGC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWjbXGC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D18C4CEF5;
	Wed,  3 Dec 2025 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777991;
	bh=aSsTR5TMgeSQXP3t78UN6a6vl76em0lSPsq3n+2octE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWjbXGC0Z7MMji3Z45M4fsJ4yOlc9Q+j5na3Dkvgjap4TQt3gCvtJKNXusxk7bHpb
	 UN4h8tTtKjKQ8j41jDrodKLXlH3k2AoOYoFLSt7CmlRdfevQFPxVqNMrJiTrrNmbFU
	 TIgKWtkcKSFS2hzZlrz/3WUQii2ggMZYGqUtaUJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/392] net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X
Date: Wed,  3 Dec 2025 16:25:16 +0100
Message-ID: <20251203152420.187187002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc5e48e1bb4c3..a66a80e297f17 100644
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



