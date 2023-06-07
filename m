Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BCA34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EEAC4339B;
	Wed,  7 Jun 2023 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171660;
	bh=F1IG6M+ByKOpBxEAtlUr2+CtScqMVcGuygu6gm48aT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLO3Ptl7MpPQczS2HY7uDKeLaE00TeJxmQMKeLEkUO3GLR533KpYvXdvrb9XQgwlb
	 qXA53zTr7eNZnLwwH2zOotZc5CyjRAVj86bnVCGSw0YMxEu5Q8rtHk6zdamAfnr+iM
	 j8XVQrAWoAEF92VKov35JG3eG+9asV3f3DVchWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 102/159] dt-bindings: iio: adc: renesas,rcar-gyroadc: Fix adi,ad7476 compatible value
Date: Wed,  7 Jun 2023 22:16:45 +0200
Message-ID: <20230607200907.020409467@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 55720d242052e860b9fde445e302e0425722e7f1 upstream.

The conversion to json-schema accidentally dropped the "ad" part prefix
from the compatible value.

Fixes: 8c41245872e2 ("dt-bindings:iio:adc:renesas,rcar-gyroadc: txt to yaml conversion.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/6b328a3f52657c20759f3a5bb2fe033d47644ba8.1683635404.git.geert+renesas@glider.be
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/renesas,rcar-gyroadc.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/adc/renesas,rcar-gyroadc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/renesas,rcar-gyroadc.yaml
@@ -86,7 +86,7 @@ patternProperties:
             of the MAX chips to the GyroADC, while MISO line of each Maxim
             ADC connects to a shared input pin of the GyroADC.
         enum:
-          - adi,7476
+          - adi,ad7476
           - fujitsu,mb88101a
           - maxim,max1162
           - maxim,max11100


