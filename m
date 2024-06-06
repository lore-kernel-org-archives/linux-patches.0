Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFD1991C4;
	Thu,  6 Jun 2024 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683159; cv=none; b=R/djrl/SWqfbytB26/JJTOVqNnnAVJg3fvbq3a3nFBDPJ49yUL3VTXpBQECoGOXyrXn998kB4NoxmbfR4WCNfvsNGTqvgZggqYzsdIq/dqIiLI27Sld67VFUdnEH9gzRswCfRTa+/Dg9NAWCK8ddqIeMBSgKuERFkPOoNbBJPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683159; c=relaxed/simple;
	bh=D1eFd6U05ad8El0Ui4jqOK9ykrHLmDQKV7L28NKeYbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wnhpu6dVllHW4lAXRkkePJKliyxMXVY/KqQiYFeWI9KXYl2xqsVMOnClqm2VFlcBconCYthvaRMwv4o4rsXLzyvsMOkO8lKKtclRgqcbGb4IhzPBV3InAIkx2jbujKKhPeeV6MoJuSLA03/Z+zuZjh04LFczrmhebmPUZIlmzhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VleG/aRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VleG/aRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600C4C32781;
	Thu,  6 Jun 2024 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683159;
	bh=D1eFd6U05ad8El0Ui4jqOK9ykrHLmDQKV7L28NKeYbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VleG/aRsWZLEN2hGZy6XWFbebshqex9EQ2AyF2IZuL1Kmb2CL5ulweDWxAazcajSd
	 Pn3LiyteV5PNRH8ggKU5NKF4/M6XBAolEn573ptilzT8a3fqU6fbVozm2eXtZrwxSs
	 7iHGDu1BXC308bNpIJevM7rdAQ8MGcDhu8hhJPH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/473] dt-bindings: rockchip: grf: Add missing type to pcie-phy node
Date: Thu,  6 Jun 2024 15:59:19 +0200
Message-ID: <20240606131700.871679994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit d41201c90f825f19a46afbfb502f22f612d8ccc4 ]

'pcie-phy' is missing any type. Add 'type: object' to indicate it's a
node.

Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240401204959.1698106-1-robh@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/soc/rockchip/grf.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
index 2ed8cca79b59c..e4eade2661f6b 100644
--- a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
+++ b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
@@ -151,6 +151,7 @@ allOf:
           unevaluatedProperties: false
 
         pcie-phy:
+          type: object
           description:
             Documentation/devicetree/bindings/phy/rockchip-pcie-phy.txt
 
-- 
2.43.0



