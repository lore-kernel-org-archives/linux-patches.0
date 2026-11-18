Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015875;
	b=AQ/+9UjZqv6OXlbTgLBqn9ZDOx11ol+XCj2i3T4HlNRhJ6LZZ78U3wq5q+1woobTGCcd
	 CYNJ35v7Y1cZ8VdiiB7lGjfTRQ/eHPlYGZdTwCXH63G1GU+pLVN9tugahshuTWms9cFWA
	 79uOrEZ8MTCz1BKystAMaz2n9kqVyTXDWAnwolW5nPIJ1Ip20mQZldVhmkL3ARVtq32Mn
	 dEklwKlzO0cbDcCJMEjEEHehCIxok1Tybclt3H9eT82xOLOO9bMy1Yz2Snek+cY5iSyHU
	 th9lrTV0e+ksQZ0baZB6gYmP9CwNNjh5bHJCI1h4IWdVHElBIAth0zPyFwcSoy/uIaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8xYEEWHcEowwikh4ur6TkIWsxMBU0ioQq02oJKG4Uw=;
	b=XhH6RHj04vB9lOiUJiunvdYuiLXRKIA+XIusK40X9Y/u5MRtc5Hi4cbe/HGPaJj4gSGr
	 efWitnhdeqPIxKh3nKTwsDHW2PSLrsHfrLq+tYTQ8Jf1pA26yM73wEtyBeDXNDNlA6XWF
	 Md4oQKMtim+qbKV5rcBQpdPAplJwn6xCBPddc2CLRwoq1TvDZcVQkdPjd38531xysKwLM
	 YMvFcxLOWTnvS5pe/qvy4y/+rRhNN0HEGgnY0sidc8dChU/x2znowI640VWcHP8FakMHe
	 x1LEFEkxmmbdKvgRtOPdoF7BAJGWNfYXvB1Iq7BSzspYcFIYPIOq3MYSiQ6ln3XK3dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoBsq0Vl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93761606A31C;
	Wed, 18 Nov 2026 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoBsq0Vl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D9B1F000C5;
	Wed, 18 Nov 2026 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015875;
	bh=I8xYEEWHcEowwikh4ur6TkIWsxMBU0ioQq02oJKG4Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoBsq0VlFQWwUnwiPhPGqzCRXlccuZhW9037fDQxsCys3LOX8VY+ML39CiYrodBsC
	 p9/ooiMOOeFPDGEqczzVzFDxKni0oQwsT1oKQOY0I5cOi5AwiJOvHr6eOJOQA1vrOA
	 ZQsUWNdPrGQAf5XCYHPOz9NC7ItANJh3hzZ8jqrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0328/2651] dt-bindings: power: bq27xxx: bq27z561: allow interrupts property
Date: Wed, 18 Nov 2026 15:26:08 +0100
Message-ID: <20261118150259.668590267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



