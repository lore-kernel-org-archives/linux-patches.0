Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015210;
	b=QfN2kl/3hvs2yinyhJrSyN6JJwgrxJfbFANPiEdYaBn4ZEkqob8diiY0a8jEh83hHpck
	 E3rRA7BYtr8tg8mtt5hbQEfGOmD5fY4HsZVhknY8nH8aQyxMEmX5EdeaW56G8VtTqPL/v
	 pyRE0FuyKBefVTMCnuXr67HpVY/vGCQGKI54RMShy+d0UxSDnNMCl8Z/czDhvA4CGsdTe
	 Ggy+ie258ygf0tVVZM+fvUa6slg4wqTWkkJLgH82gBim9K3cCpcuOi6MqD9asaNt0PftR
	 bm1f747qibSy9zv3R50zOw9sajhxV76EtedwGpSL2pJtGxQPgtN2MNF0Cq4YIDw/0wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BDgTd8sFBpfT5Cw+xZWHlK/6pDZYbnuLpScXVmarz9U=;
	b=Vw/AiUUfeHvTwsQoHj+B2Q1q+kolAQzmxF6dxGsub8EkpLsgbGKihQC/ls7a9Be9iPyp
	 vjCqCN/WfILiphSZKEgp6BWPcMVbyyhJT2gjcfx9dBK3SdR3PGpdCKEIKmhcIENMgNZH+
	 VUYaExB+U3lb5WcCRRr1yYsZzL0jpFbUrEpGW7qQDm1EP8o2ERO+YvLitL+6PXx5VdIth
	 H5F7QR8Tk0q6T4JPL3MyHNPQ58rP5kFyifd8LNM5zjqhA10zney9AHUDBpzNXZilPbP0C
	 yOKCs/AmmgEvMzTaRLABPuyiE12uZhVebWwj7oC1lsxknt6V4WCuuHdkq8g5OxDmuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQCGL4uJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E585606A337;
	Wed, 18 Nov 2026 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQCGL4uJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947641F000C5;
	Wed, 18 Nov 2026 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015210;
	bh=BDgTd8sFBpfT5Cw+xZWHlK/6pDZYbnuLpScXVmarz9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQCGL4uJfgGyOakVg1KpRf/tRcocR3fdGsPOzyVGU3nZUb1YASCkwvcd6i1X/L5vm
	 xtCiI9h2ka5Q43ruuZ0qkR0lOadVsiXevVw2yGX4Ph4B9nN2WEc5DrqcQSOqjdVG93
	 TpbxokK/n5OUuCGhwm15GLYAwBQl/bNCrXvnla8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0092/2651] dt-bindings: iio: light: ltr501: Sort compatible enum array
Date: Wed, 18 Nov 2026 15:22:12 +0100
Message-ID: <20261118150251.219712508@linuxfoundation.org>
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 6c430006fbcb63dc8baee3c3bf356b264ba7f61e ]

Restore alphabetical sorting of the properties.compatible.enum array.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: 198ed7962e42 ("dt-bindings: iio: light: ltr501: Add missing ltr303 compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index c8074f180a793..480523ca37500 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -15,9 +15,9 @@ allOf:
 properties:
   compatible:
     enum:
+      - liteon,ltr301
       - liteon,ltr501
       - liteon,ltr559
-      - liteon,ltr301
 
   reg:
     maxItems: 1
-- 
2.53.0



