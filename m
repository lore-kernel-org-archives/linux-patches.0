Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028883;
	b=ZX4khC3YAkVyfoy0eLEFuQgcv/rkLx05eX//Ftn6tIoHRQbEv0nDLyprP9KdugNtDhck
	 mq5o4Baw116PQ96KDCzX0SGKkkqhNqJOETRo7rHcrsekSCwdQipwnvP/TmBZdzj8aF0HH
	 vwCF9dnjnu3QjBcv94GCf+z2ivJmLSB45fOzMIop1nQtuIXHCNg06xlZ+Oh+EFcdzSOFs
	 6CvHTbobtonDOMPMO4IzuHd/fI31BTLYRP7uZoq3F0eEVkNlcPq3XpVdSMMRrSHVPqwLu
	 SA77kq9M+EQNtPUTbWwjZQ4IszCSTIFdX2R1+v5W+WcEOmZzdcei/7kKE5opn5rv8gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DUJ2E9ErOPyqFX8BZr+ykPBJGR1xJv546zrlHe98viI=;
	b=T+hivPmaFN/rYNXj/g1CXYk/zIlLy7RLfWoqS/3+wbjxEuwDD5S3hT7H0UMSge6L2kHm
	 axHQnex0dTHVBNuDIt4TBv6gjdsbH2mWQAek1+llKWjiWOk33weV80VNbdCxSfIukykM1
	 Q6NNMXMpOoaJCzhcjASMEk+RtRWL4Qb00tLWyj9LadcUnGWJZQJjhzfH/XlB37yzPJzxt
	 waAfzwZrZY1eWzIxZt4reIHDqlVvNJyfj7Q0I1WY/KzGKcVWiX0mVKTMpkssCVgcsei/0
	 t0kINsedOL7bcNn0UAzC44MobKqBaErAtVKG1njdp41Fca0sRAvgzgSr8G9Pm6fXqzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPAydUFo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B567360A2607;
	Wed, 18 Nov 2026 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPAydUFo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C362D1F000C4;
	Wed, 18 Nov 2026 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028883;
	bh=DUJ2E9ErOPyqFX8BZr+ykPBJGR1xJv546zrlHe98viI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPAydUFoBbNwt6+X+aBfWHqoyQ9zEQBHvCy3toqhyIqOL+/j2OaroBe9JTz0VreSQ
	 afifJ0jk2ci4y70gCxw/n5jsxXPlftpQehVWq9QI5AVVvnhTTwOlgo9v9JG+ZSjsV8
	 9iF5BtSDG+M1Fguw0bSat5uRrUruAIDphjBhy/xo=
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
Subject: [PATCH 6.12 0151/1756] dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150014.144143471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



