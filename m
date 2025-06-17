Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFC6285055;
	Tue, 17 Jun 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178026; cv=none; b=ZoqSlYvnHB9MgfhRrS0Ccql5yGhuLw3ue5efNULeK3Y2/ynoP4deHgHpPAlPVM1z4wI7Go5oQOrDIVHEct7WgYRwFNR5LzQ1aBqJl5c20690sfQDup/837zZT1SiPSEkhTH5LUlngHI+KH6nFQbJxTMTzr2u39sn0blFBlZezGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178026; c=relaxed/simple;
	bh=hOZXAYhh6oNIppwh3fSTMHCa14n1/ntTnck8PPm4EIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky0yfR1D6VlfcsXFbVaX8WuDdEX+Z9IROVfQvVkcgWI81WEKokkgPpM3Eof9MbRcs6KQex55eyZEBxwKEuWvOVC8ufhEruV+nNFvRLn0Q+UznNYzrp/l0vU2DgQ/GqOMC55bD0SPa/ipm0yzX2knMv9wH2VC/Dq0+nUdd8bMIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2AGAQ5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2AGAQ5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC3EC4CEE3;
	Tue, 17 Jun 2025 16:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178026;
	bh=hOZXAYhh6oNIppwh3fSTMHCa14n1/ntTnck8PPm4EIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2AGAQ5mOyvxYBQnZw1KCxI/VRPhexHZoHlfnmL/DNPrk/mnKYEXa0/ekNjfHBg1K
	 Fibfz4/MWt7pXTZOd5Db0NxItD9IZXrat10BA1+RNXtSx0ep3oDCP9z4zW6wwuFeWP
	 cARPsGP/3KuJpCOOw6GlBPT92rSXHLsOx3gYr2fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 398/780] dt-bindings: vendor-prefixes: Add Liontron name
Date: Tue, 17 Jun 2025 17:21:46 +0200
Message-ID: <20250617152507.661336553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86f6a19b28ae2..190ab40cf23af 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -864,6 +864,8 @@ patternProperties:
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



