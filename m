Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039139;
	b=Odn/hpwBcKXN0Ub/7qqxxyga8AhLl9o7nl6FZ6CGrJJd3ks4pIpb3oAQ31MiNg4Y4yq8
	 TYpT50pooaVgVLpD3vnrIsr8IKvog3PUdF8iXSjMkxSBW6e5mlezbVqtLevyeYj8cP9ad
	 T7CDrAXooYGg/V7HjdjmFkwQ/I/yXDKY939Id82iUBvB66r30R0iRIOMOOwvFVsTUncS9
	 R5zvaZve1biXCrFBuKqvFKaPlMNA1UPEu60Mro0hDuV561looXKwlBQawbxBtOX4DAGDo
	 8EmuIliytO/JXdxRlohgfbWl2XzlW3rZsO4KXeCwGfMeSaJBtNYAR2S8Z5NMtyS9aZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4LywLkDKnVESBHtC3JHfW0vdW9ZQevhhrYay9UQNbeg=;
	b=G6p/Xcz0YXZmi7i1NjPcWvK78JOl0tRsLimUsVoSyYkSzysHkW6nMdfK3Hw8GKoR341s
	 GYTCaIVAoL+qWxc9nt9g5IRRSnAZeMifMBREvuYw9Cy/ag7Jm21AdXnV3VHOuwKAFpvYU
	 +2utqIcB3INWraTVyDNq+1tZO3eKL6OqY93XqfYTHN4NRi/eFT9NVwQwhbm0N08fr+vQn
	 s162H+OGACKsJz1lryxmn2/DuF05cMlPxX1cw5Aw+pY501UvkKOBSr1+QDhBeALX6c+B/
	 KAza6FJs+BtUgfxBwsq15v8qqxZCBdLa0qPFVzFvp8K4/zbGz5k7kR6b/s6rQTwrUMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wK8F2Axt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F13606A325;
	Wed, 18 Nov 2026 21:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wK8F2Axt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7055F1F000C4;
	Wed, 18 Nov 2026 21:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039139;
	bh=4LywLkDKnVESBHtC3JHfW0vdW9ZQevhhrYay9UQNbeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wK8F2AxtDtEj5XWgx8PB8ZCG+7IjeAmYfM4AOznHpj2Ur7u2CrDJ7vhkCJyzgAR02
	 jfVJ7XumEi+J28yZpFVDKtLWMKFOJFvvv36Bdb53S9BIspJ2GE+vVN+RJoH04z4KLH
	 xsS6lN+UX3KlIrQ/9VJz1dd3kNoKeCpJPO/YwRKs=
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
Subject: [PATCH 6.6 1992/3318] dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118150421.818184039@linuxfoundation.org>
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 198ed7962e42f1e45b7f48b9abc70aad9e3185f8 ]

When support for ltr303 was back in 2021, the bindings documentation was
not updated accordingly.

Fixes: 7d71d289e1ba ("iio: light: ltr501: Added ltr303 driver support")
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index 480523ca37500..6234e2eaec2e4 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     enum:
       - liteon,ltr301
+      - liteon,ltr303
       - liteon,ltr501
       - liteon,ltr559
 
-- 
2.53.0



