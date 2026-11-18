Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047705;
	b=h2f9vqR9+kaMV3ziBxBil+FkJD6AJL97HJz9rZUNL63lYKC0Ww/KNjkQzNCKbciaMAju
	 qbzIYiuAN2hRLhVY7jKuggXKIDnsjxSVYCh0f1N2ZkK3bjg5527mOOpBnlZO/i9iUeo4e
	 y5HMy9N3uT/Gk+yqQvkNEfWtxE952N0h8DPW/PYEVPnfUVov1iVWgJoRhMUzkFRswCONa
	 TbQY+M9KoW0ySz6IahtnrkP4roLkW5giji5zjUkSsVXZDIcucT8geYribxBdcKWxZD+MH
	 8840Uw4mY7Mia0a/BWmx5RrBMDlwSQ5Ne2alph5Kk1sQvPyEPLMCAcSnKaFdspUcEvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dipybhFAgIKL4ka8i/8aNLWwrGU0ISSD8w0tQ/aiOkA=;
	b=fQ7Ig3m9cYQNxbOvN5iA5Lzo+Jz99rYsJPi6ms5WxyQ0H7plPA46q4ZTozn0C+JswZlE
	 AYXfn7XHq2+lLb5bsvVz+kyxWFBAGSlJj8D8pnsG2iS1w56pBj08xlvdQ5pfuje9wttLE
	 ZChJVwZLBJNiQD9W3zKQeRlnkAZxmDAQe5lUxZG6nkkI8Xf9vIMdgW4rlBu6rPtRzRDKg
	 G7jodkt2DgkiPy7Tw6CS9jkeGYAlFDkIX5NgIJ2uENdxRJiwq10fYtkK4YbzI9jznqkEW
	 2zvWuiRSUG1lD/55OwkuRmuXo0C4UIR1jDM8qJbey2iKwfZI87H8Fvqcbn6kUauo/Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7ZfgWKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44191606A325;
	Thu, 19 Nov 2026 00:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7ZfgWKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA51F000CC;
	Thu, 19 Nov 2026 00:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047705;
	bh=dipybhFAgIKL4ka8i/8aNLWwrGU0ISSD8w0tQ/aiOkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7ZfgWKCyob5gyZbYyqlkcpKhNXFeAs+Guwna6KS9hA7p8fqR3gHg/G+VAkJ3Gqbz
	 EIxmyWelnclvgJTf5hiOyHayg9afDkwUraM5DQ/nq/XRh3PabC1/aDAV/pGWNXV0lf
	 D/pWCIYJOO1XWLauAfPKR+WfxJTgvvDuwnU88Mh4=
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
Subject: [PATCH 6.1 1735/2857] dt-bindings: iio: light: ltr501: Sort compatible enum array
Date: Wed, 18 Nov 2026 15:46:09 +0100
Message-ID: <20261118150303.783485827@linuxfoundation.org>
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



