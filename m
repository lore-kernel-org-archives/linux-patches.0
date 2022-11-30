Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42DE79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D64C433D6;
	Wed, 30 Nov 2022 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834299;
	bh=PxbBhqLifgPHq9HvqD2LzN/LhOH9jtfw8IIdMOVcfa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4vguGLMNAaNeEqVJczTClRN3IfpK1FyhKHK/K0gauJjV2aqvryZXo1sFzE1fKXqX
	 GvSSHUaWzyjZSI6iUgcmN5fG3oPVUZTjI8+NdHLfMml91mcV+qL22zxKsJIidI9fYb
	 GPMd0neVH94Q8JehObBIXBfb1F4/6o2RiaA7Ws6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Rob Herring <robh@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 175/289] dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"
Date: Wed, 30 Nov 2022 19:22:40 +0100
Message-Id: <20221130180548.096921200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 398e3479874f381cca8726ca5d8a31e1bf35a3cd upstream.

If the property is set on a device without valid trimming data in the OTP
the ADC will not function correctly. Therefore, this patch drops the use
of this property to avoid this scenario.

Fixes: 2bdb2f00a895 ("dt-bindings: iio: adc: Add ast2600-adc bindings")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221114025057.10843-2-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml |    7 -------
 1 file changed, 7 deletions(-)

--- a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
@@ -62,13 +62,6 @@ properties:
     description:
       Inform the driver that last channel will be used to sensor battery.
 
-  aspeed,trim-data-valid:
-    type: boolean
-    description: |
-      The ADC reference voltage can be calibrated to obtain the trimming
-      data which will be stored in otp. This property informs the driver that
-      the data store in the otp is valid.
-
 required:
   - compatible
   - reg


