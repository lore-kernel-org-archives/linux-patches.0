Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA718E377;
	Mon, 23 Jun 2025 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713403; cv=none; b=A6xMlCs0pI6biky0BouZ9Uy1TWqcVU5v2OiC4gRZ3JrsK4qYMx/ek/3c0TAdPizrOUsg5No+jJJBx1fPf11gU4w1lrqfkMxT4AUd32a+69pS/9gCgpsMFv8qqPPZGkpHHUqboQANuyDWaqToUFaOZIRp/r15DRo/e/l04gh8bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713403; c=relaxed/simple;
	bh=wKBPWKo1PljpuQqYepQ/VdQNliuab85jH2Xbj1oUEqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPueoUFPHN5s3zFb7iTVcfONUQUBtEZnDAj/bkyP+swEPLAYKEa63sPVQRsYBfN1WXqRR0ZATCdhlVBXH89ljRqbBCYO1GAu2l69MHMdRM5ygUrwFMx0iGQe1U2eh/+HLw+R+w2PfgmZOk/M3SfuEZolK2AtBG+hMz6swH8BZY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoD6K2HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoD6K2HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5980C4CEEA;
	Mon, 23 Jun 2025 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713402;
	bh=wKBPWKo1PljpuQqYepQ/VdQNliuab85jH2Xbj1oUEqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoD6K2HLBh/HMmt2GjxcjJkPZH2N2RTmEYusJqjZeUJN5NEVPuKQIM0fsS4xZA8rW
	 pVkVOCTTHOUXDsRpCbJXqwpeP+aGuPK7FyTcQzla2l1J7oZrx8ZJMvHYOnSFcQuQpx
	 /lIERmLM7lakps97iiHAn9gSEQ1ldV8fRokhOCeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/508] dt-bindings: vendor-prefixes: Add Liontron name
Date: Mon, 23 Jun 2025 15:02:46 +0200
Message-ID: <20250623130648.272651171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 9baa27a2e9fc746143ab686b6dbe2d515284a4c5 ]

Liontron is a company based in Shenzen, China, making industrial
development boards and embedded computers, mostly using Rockchip and
Allwinner SoCs.

Add their name to the list of vendors.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20250505164729.18175-2-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 77e9413cdee07..f955db429f55a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -725,6 +725,8 @@ patternProperties:
     description: Linux-specific binding
   "^linx,.*":
     description: Linx Technologies
+  "^liontron,.*":
+    description: Shenzhen Liontron Technology Co., Ltd
   "^liteon,.*":
     description: LITE-ON Technology Corp.
   "^litex,.*":
-- 
2.39.5



