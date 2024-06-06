Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC61990D0;
	Thu,  6 Jun 2024 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683128; cv=none; b=gMPAyVbfzzim3s+nLhFZ5wzUSz2Kox1C5Yb0PpYPu1tNuDLIDuqVrwhTpvXTyq4jpkkRMBfGXEkpF5kMqXWS4OzZi43S2fHB6UiGJWsVM+b3Q1a1Ue9PCcmfu1699AT08gI5f8fIu5JQdD//f8drRso5FrlPhSTj30cqZhIuQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683128; c=relaxed/simple;
	bh=7lKKqqH3b9KWlV1Z1HmKQKYkVxwsV9Cg5Y3FhRfwebc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbMuLbUIzrzXmSjKoPC0pQCJDnaj6xoG+/k2IGGXx/5nT5U69ZsDjeo2E05Xnzm4PvRNktTcX5E+A4Qmzr1pJK1vv5q4m9u4CucPHwaA2q03V1L2KPbXFQClI/vTHwjPEValCctzN1b7SHGmxsMVE7nCrilwBiB++n3JjXX6HqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqaZ48Z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqaZ48Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92FFC2BD10;
	Thu,  6 Jun 2024 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683128;
	bh=7lKKqqH3b9KWlV1Z1HmKQKYkVxwsV9Cg5Y3FhRfwebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqaZ48Z1obacNAZQIBVSfsOWSjua+xyU90ZE1AcgxIDRR4IkUasbWvOXPQ1zqpmFn
	 +l7cywCu7BBLdS/dFGEuD/pq+UjjXeo4/tXPc2TR4KLl3aQmQCqv2XVYU09hepMsX/
	 I8Ga5abgQHiaY9gos8sUlD4pQ/1wFU46IwuPB1bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/744] dt-bindings: rockchip: grf: Add missing type to pcie-phy node
Date: Thu,  6 Jun 2024 15:55:09 +0200
Message-ID: <20240606131733.639102312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index e4fa6a07b4fa2..be6ffec2b0749 100644
--- a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
+++ b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
@@ -163,6 +163,7 @@ allOf:
           unevaluatedProperties: false
 
         pcie-phy:
+          type: object
           description:
             Documentation/devicetree/bindings/phy/rockchip-pcie-phy.txt
 
-- 
2.43.0



