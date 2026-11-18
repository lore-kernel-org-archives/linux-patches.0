Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047707;
	b=nCovzu8I/sWcrLGtw30fB1HWLWezLEShebU0rCu+v20pamccgtlHzZaUnNZ5rDiqChrE
	 zTV5UwU9vQd/ca9XmQbsG0u1nR70ouVjaEuhgDKFtGlQPxC6h+eBmT595bYrKnXvQr7O2
	 9FczOek4z4Zxp/0whqWc4AejrfyTmvKKpLW+r76ld9vdLT15wlieIJPMQ76NWKcUUrM22
	 YdaMgcccc9B92oLOA+3i+II5E7t9bSOWjiY2zK86ftO7ss/EFX1DbZEQHLN8mk59Q7F7V
	 ByQfdPRBqKXMw0gstXEkUoFpWTZBvuQ9z7KAnNzohc6OMlLfAwY+7gBmhKPZXTBKaHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1REtMii15yGXjj6MrHcgyRVtj440h2qkY2j3DljDHIk=;
	b=UskPS31tt9uHkSF8CdM9u8XuGOZYrxXrb8ZUtu/4AmXoph5j7miIFhy19u/09HgGi08g
	 vCRq8AAG6ZFhmbad2C5f8ywYvWreMMgj6cupqlsvVqsaUwX51W8a4FmhDC26ZkgtQR+12
	 T6TisVd7nwhRe9/wyT+iv3p3sC3VtojV2AnIggp3rgS9qE1A+rp9xQ7XCzrsZ8UNA/w6Y
	 MXy4OPU2Zyj5aBNSZWiTynSEpcie9/8iqLcmTVR7V+2JB9/EIKcdQ/EXdeq9p/sesk8Ta
	 F3p6f8lXOMc8DFzbYjIeeNa5lpto70kuBFbqp/0ibCgQtIjONM8mVVZw/O1IxhWQt3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KeDod/BL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC1606A31C;
	Thu, 19 Nov 2026 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KeDod/BL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1131F000CC;
	Thu, 19 Nov 2026 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047707;
	bh=1REtMii15yGXjj6MrHcgyRVtj440h2qkY2j3DljDHIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KeDod/BLTmbtd2VAX4iJ1jIAxF88o+mpCMBkN+lR4z6IFm9I5GU3d7qX45GRWJoxj
	 qc+f2KyyfWNVc3RKeln9Q4+St1DPsqD1U0O60fxTUhdcS2HJVpjXGVq9evO/YFaw2p
	 kvjfUg+tTkuchyb7qhAogBvte/E5F3IW6G+G5C64=
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
Subject: [PATCH 6.1 1736/2857] dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
Date: Wed, 18 Nov 2026 15:46:10 +0100
Message-ID: <20261118150303.817218204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



