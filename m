Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4A18DB24;
	Mon, 10 Mar 2025 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627040; cv=none; b=i1EfWqlQoPfA0sfwk885mAleqZm3dQqgs2OtsmS4vXtL+2esIvooyDRoq3TAYjZCpRNkOKM3/rfHOmw7edxHUUMiIwkUc63M8acO+I6tuDgUpfsGBTvF9avwq7c43nDCHt86U4NBOhxTcbSyO39Eccsi2QvEbYEdtFY+5xSderg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627040; c=relaxed/simple;
	bh=AiozW++0Z8C7zBMfxtvEGAth/zd/dzykyYKk8jvv7n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syv8AadaKx89Oqnbgj76tWyAVfb0RCQ7HxxehJAhV9VE2oZSwB78jnq829vBsC88YKQz7L1m36loo0LwxvrGVGbsVnyFjl0/0dinifdEBuiaH6fjcu4P8QMaWWYp6kkfd7X0voZ+uACjDRw2TfgRTtikWTYs+01EpFtB/KylKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KAcf0w+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KAcf0w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A59C4CEE5;
	Mon, 10 Mar 2025 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627040;
	bh=AiozW++0Z8C7zBMfxtvEGAth/zd/dzykyYKk8jvv7n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KAcf0w+HluzHsgcaUWXjW80kEd0EAXZrPCuJPC56PkZNW7NlksaV7XKQQu78s/pL
	 JKk1k94rGrWFNO47Sdv8xR7KJmahm6PLQy8T7DIth+JNNwgbnRMNONs60RHNfSDf44
	 kKbRRptu96+JwvOp+Uqb6v1HrZyb8fAjsWOdK6mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 200/207] dt-bindings: iio: dac: adi-axi-adc: fix ad7606 pwm-names
Date: Mon, 10 Mar 2025 18:06:33 +0100
Message-ID: <20250310170455.733600193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 02ccd7e5d81af4ae20852fc1ad67e7d943fa5778 ]

Fix make dt_binding_check warning:

DTC [C] Documentation/devicetree/bindings/iio/adc/adi,axi-adc.example.dtb
.../adc/adi,axi-adc.example.dtb: adc@0: pwm-names: ['convst1'] is too short
    from schema $id: http://devicetree.org/schemas/iio/adc/adi,ad7606.yaml#

Add "minItems" to pwm-names, it allows to use one single pwm when
connected to both adc conversion inputs.

Fixes: 7c2357b10490 ("dt-bindings: iio: adc: ad7606: Add iio backend bindings")
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20250129-wip-bl-ad7606_add_backend_sw_mode-v3-1-c3aec77c0ab7@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
index ab5881d0d017f..52d3f1ce33678 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml
@@ -146,6 +146,7 @@ properties:
     maxItems: 2
 
   pwm-names:
+    minItems: 1
     items:
       - const: convst1
       - const: convst2
-- 
2.39.5



