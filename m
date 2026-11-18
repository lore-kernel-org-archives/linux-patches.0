Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055368;
	b=cBz2opJB05ij/Ido9vlyZ4DOU3mVmGcgRhaGuVsxI9TGjjPM9AHvTX7wDxujCd9/LS34
	 W9lPEpvjfok60q7xzc9QP9qkNWosiJDFC1SEZihfx94HDOIAZ10WOD/+HWsXO0/F8kxjj
	 1kgHe4Vuy5+QijGLTN/tKDU3HO3qEB+6WXOSxaiBaHhKDGMbcSEKkSCiIazZTWcghwPfa
	 6GoGs8OPIZbxkFtGFgASrajcj2MaCTzsej9AYF1Bu1ulLBs3flJA4Ic7BSyyxHCivY9v4
	 7xkXqi1k52ZmvYMZEAfIC/anGB8TmLqjZutD2XJhEn9F1ST9E3JLw0qpR/lLPBLWjAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bIGVyF73HEA0QkC3vjqpUM4lKOrA4T4og1/hN1cnS1E=;
	b=TEdbTw/Mfxf8Q/Tcgn8F2lWMKKuRJwa4NugpGJMGGrwIHFDA+Tz648IuDHRAysAJi5fv
	 WajrQCRsq1is69iNA/Is1dGDF/xv6QR7kVMhboT8LWMe5Nivgwx9MgV0zw/zbfRen/7Vs
	 t3bDj3/nmG57wXhLY01I8wV/QKyOR3rrEktu4A0nypFzN6JcYWHRs3P0aj548/bTaRiU/
	 nhUX6miHrHWf7yOPoL8vymtcylj3dzKRvUphznX5BGzkx2kRFAqvb5I5pwPcJm2ou3A+H
	 VwycnRufbrg5D40qrwZF8E/R0AQ9uWYbewjsOMzv37EKQhy1PPl22pepVyBjR9v/3ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhnuTtOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CCD606A33F;
	Thu, 19 Nov 2026 02:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhnuTtOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BDA1F000C4;
	Thu, 19 Nov 2026 02:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055368;
	bh=bIGVyF73HEA0QkC3vjqpUM4lKOrA4T4og1/hN1cnS1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhnuTtOtRzFEkgy+r+9mtaTfAt/FeXKi14w9YOdVjQ4HNxtNddTaqYEqOuasZc4fs
	 5JMZlzTiYaZ9nzoQLCsOAkztc3e957SphNIzWTosYnyd4qCygA818yVSkqb/uXebnF
	 aE6/B2jMM5hQkIdQY4atXk/rspZjd0IY1NKOTLOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1607/2214] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150116.229827767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muzaffer Kadir <muzafferkadir@mainlining.org>

[ Upstream commit 7034bec693b752bcd7ebb4fa00dc3b429b4dc4f7 ]

Add vendor prefix for General Mobile.
Link: https://www.generalmobile.com

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Muzaffer Kadir <muzafferkadir@mainlining.org>
Link: https://patch.msgid.link/20260921-msm8952-initial-support-v3-6-b96fd3fe298b@mainlining.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 9de9c419f043f..c5fabb4692902 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -457,6 +457,8 @@ patternProperties:
     description: Gemei Digital Technology Co., Ltd.
   "^gemtek,.*":
     description: Gemtek Technology Co., Ltd.
+  "^generalmobile,.*":
+    description: General Mobile Fzc.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^geniatech,.*":
-- 
2.53.0



