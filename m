Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040227;
	b=qN6hmNWZ2rimVfz5a/YRft2KWtz/+g9FKtk1UX/NCOWqsXXM5zRMqGF+jyy4qxhE3rf5
	 aY0Bl6tYnxfMg8/MkEIrPyLdJZT0XT0FRb0fprpHDdEvryH7KF2O23K0I6qXq8gw/2SUE
	 Yxapbh6YwA4wt3fv0l2bHdc3WnyUhYRpMJwM1k0bwHI6d1YpwKfbCAZyXfrqw6xhl/B4t
	 +qTvKvG/lEdrV0fkkimlF2AMPPFSMptyWbg5EtoL1jmuAcjf39IYzagFFk9XeqYRIUdpL
	 UhEyYOhKty9eDAOrFrJyMOTvFJy7x8OHclpqToJxVOhLkqAOaK1QuxbCwq3AsKLkNdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CvRgga4xAmOnlfL7XPJyBU7QkgiV2pdBWyoSas5Lh3U=;
	b=IXvpHEaYDya/FL40f3R/S618aXNEHq5kxPiJUpeW0B+UyP9sPL10Hmb7+XfuGOQayPPt
	 +WHVmwOd2OiiD36wsVCao83zNKrUxTIIizDSlCu3jiymB+736ytSOTwOYmZLpjC1Hoa1H
	 77xhcwgnEmFbHM6fym2uQAR0aIpqXPyKKRtedFgCyUyQRix00/WnN0D2cBGCcHA5Vsb88
	 3HYj05ByF+h4vUIb+ji7Dkg0+EPM8Z1Z2DDa18+IZ53TpxOuaffGq4Y+Bw/KlcFtvvISK
	 R3Lhx9vp8fLCGMBr0VxbcjhcyrRpcdYXokv8tHyAYxr4XcQL7xoFDXTKwEW9++nmE6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz+AnX7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11657606A31C;
	Wed, 18 Nov 2026 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz+AnX7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6186B1F000C4;
	Wed, 18 Nov 2026 22:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040226;
	bh=CvRgga4xAmOnlfL7XPJyBU7QkgiV2pdBWyoSas5Lh3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gz+AnX7EcGagy1QjjIzmM1sHoy0z2bqEWxrF2Bd7XaMtagAmKIxVvHmWigK9ZRivA
	 hCMZ7sRYZRifP3+GOVZ22ILSpvDQacLaq2nSE/qCtrzjUXyvxQc3/My0KmiwDR+MAb
	 PUYNvLIFvhKdNbfJSClDv4CFy9y8K4/DG6tpJXnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2382/3318] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150432.997386934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 1658af4d25bd3133d1b3403ccdda6214d40c0ebb ]

Add vendor prefix for now dead ecosystem company LeEco

Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821-next-patches-v5-1-ec81cee63e09@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5df24b8ebf647..f4feafdb3cc56 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -763,6 +763,8 @@ patternProperties:
     description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



