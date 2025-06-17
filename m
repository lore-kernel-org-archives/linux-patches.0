Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C872F2C4C;
	Tue, 17 Jun 2025 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176781; cv=none; b=Vjxe5dZyezG/xzlzXEJtDLPjqi5DjXyujLJ4bCnG4x/174T7X2lNAH37nSBpWnGreax03AGDfFS+oTHSsh3gf92iKBGevkJge9DGCvjECQZDqylizpIzNfqW9ShSvjPauGuiTS0Pc1RQhSQvUYdpmCfhl66n/2Hu2vthWvgUERQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176781; c=relaxed/simple;
	bh=3EMR6JhJJdWTN3PtdI+jV1WNyGINwjnxPselo2K+85M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDKzrDEqMLLXv/IKJ4b9kStSlfmH1okTutTCga+kihzhH24YwL5vO61viNnMn5WEc0DYjP1A7Cf53iCO9sv+cvr49TKqMXAQkUM0kJKAVpQ4uvmurCmCsdFCKo6D9jnqcUA9SF1JjE+QDWbpmRRdlANJ7DQ1Aq754Aq2/lRz1is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrmSNJIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrmSNJIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551B2C4CEE3;
	Tue, 17 Jun 2025 16:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176780;
	bh=3EMR6JhJJdWTN3PtdI+jV1WNyGINwjnxPselo2K+85M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrmSNJIl0hQsie1ns5HHZM1nAShuQDMTjxImsGFuk+0CIlgAN7dEgtPjYuGEh7Bsl
	 AhCeZVd+mRs7qpA2P3way78oCRl+mUR2//0WzyQNFwIwhqpxlAU9DLKPBY7NhbtloP
	 kXk9uvyNqTwVfZme3xL+QaUGLc7ENAcf446LYvq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/512] dt-bindings: vendor-prefixes: Add Liontron name
Date: Tue, 17 Jun 2025 17:23:42 +0200
Message-ID: <20250617152429.968435094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 71a1a399e1e1f..af9a8d43b2479 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -846,6 +846,8 @@ patternProperties:
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



