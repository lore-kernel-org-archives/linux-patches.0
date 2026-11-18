Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023314;
	b=mOc89C4OssnT4rQVUVdcugl42CEfMcpn3RF1BurmOEvG3hISI8wBZ8Usd5NA6SzDgtVr
	 ojSge9waVkx2mgW3fjbwg0kNT0Cr++PKpuiD+j+SgDRBI8RPbZ9c+qG9x5E9dRiCfPW4t
	 Ih3XYYNSzS7tR0DGDD3rGmW5Cm2uP4c4mN34n8zjqgmPCJyETdg/bGspjcsPd7xgq+wIr
	 UsxbRCLCI/8JxA6QVuTFpXMmL72vl41pbftZzF8U0CIpJJJFyUoRCzUc6QgO987ZEAyC9
	 /LDiGGvNq3HYZgHOfl//NWDIA8tmxfI1Iy7X5jlHZd78hEclyAuwNEHmP896AuA3Kxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35zjKuP0/RmtZLoVFn+D/hw326wm8fI0sbBHReDc9dQ=;
	b=3bUOSP9BHV7S/eDmL4YdO+XzpKshI/CN9M1MeDwsT5/XnZ5W2tYg+3D+bRbT6l1tZ6E6
	 k2nITo5T/PBKVtg2MDvjHT30+yHyF3mkSH2YHok3b5z3kyOqL1sb/oMBYH/7omC72dlrP
	 Os0JzOsgqwclMUqnJppfMUBynFTXia5ZLT8ytE/W8w4Z/No1EEe3IpzYQDrIPJSb/QMU3
	 PTPtgLMq/Qfgz0theIkyYFn/XIS6v1ipfz1JZORfuB+dDaBehSwfJt9QLOoaNWTkg5kOc
	 wjgfg+hSLbRZHphTe2Oz/SODWWlytEWyFEbz99g9XIELFEKTKe9oYnvLmei3w5g54RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TyQGNHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B3606A325;
	Wed, 18 Nov 2026 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TyQGNHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE8B1F000C4;
	Wed, 18 Nov 2026 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023314;
	bh=35zjKuP0/RmtZLoVFn+D/hw326wm8fI0sbBHReDc9dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TyQGNHNuBrvDdV4eL6oal4Ld/zcqud2FYTZ6zkjxNNJphmuN8/oRbXJHYPoAg0AC
	 5cHzcsPMnJmbqB3CrNFJ+EHpFbTooCWMOiJZlzHaALiUfkBwMUUg/eWFs80yUdJIem
	 uhqbQu+mQmHSVj7f+3imD0dFcywbuqbzg0pvsGk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0324/2151] dt-bindings: power: bq27xxx: bq27z561: allow interrupts property
Date: Wed, 18 Nov 2026 15:34:19 +0100
Message-ID: <20261118150133.758495756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit c3a6ff174c98f2c7ea213765ff6969140c381e90 ]

According to the technical reference manual for bq27z561 it has
support for an interrupt on an INT pin. Remove it from the list of
devices without interrupt support to better describe the hardware.

Fixes: b4f7a727c29c ("dt-bindings: power: supply: bq27xxx: document optional interrupt")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260818-bq27z746-v2-1-0371e206665f@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/supply/bq27xxx.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml b/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
index bc05400186cf1..d985ae6325994 100644
--- a/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
+++ b/Documentation/devicetree/bindings/power/supply/bq27xxx.yaml
@@ -91,7 +91,6 @@ allOf:
               - ti,bq27742
               - ti,bq27545
               - ti,bq27411
-              - ti,bq27z561
               - ti,bq28z610
               - ti,bq34z100
               - ti,bq78z100
-- 
2.53.0



