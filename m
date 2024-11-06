Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DDA4207F;
	Wed,  6 Nov 2024 12:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896212; cv=none; b=HofGvYp9g+eMgIBeIisoSCfbazbA601sHRh9GS00zMtED4z12wqm+55+P0w2nOGwreanWfURzgAv8WX13SPdtnlHYKB2DOVzTAYnCynZQ52t8+R68EmtaMOOImXi7ISCA3ft56BEnjAI4jmdVhjm3vdYUCNo+QhNCCZ0Kl1KDq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896212; c=relaxed/simple;
	bh=7Xrf1lWUc4e4FhfMkIHCC2N/sURic1yJNu7rnDUHGek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVMP4U2kCtHMf9DLSEtAPsTzKhA/D2AwdZuPgsT3CQMksxUq3iQv0afrKRv0mm2NkcTYcLbZ8awZQAqAaGemFg02s+sO47nu0dkZe0wfQHm6Cd/Z+ow3YKn9biJ7x/CoXKZase4vCqv0S6Zh5/ZP8E77TaHSGgl+cBh2mQi3vac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTyMrd+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTyMrd+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8C7C4CED3;
	Wed,  6 Nov 2024 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896212;
	bh=7Xrf1lWUc4e4FhfMkIHCC2N/sURic1yJNu7rnDUHGek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTyMrd+wNOjIso59J7r72d+KQ4ZJQS0rNuqqwwduay8XmPHPuWyIO/2gkzxofebfT
	 2Ikqh+uhSjAxw3rd5+TGSiTNv4OI8QQ63g0WThnDCr2O6QPNvJ1+XssEK2jT9jTSA0
	 64KK+bqeu6itjvvkG4mUqWdd9YgTrzKSDaKA2k00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	David Lechner <dlechner@baylibre.com>,
	Julien Stephan <jstephan@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 128/245] dt-bindings: iio: adc: ad7380: fix ad7380-4 reference supply
Date: Wed,  6 Nov 2024 13:03:01 +0100
Message-ID: <20241106120322.374488062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Stephan <jstephan@baylibre.com>

commit fbe5956e8809f04e9121923db0b6d1b94f2b93ba upstream.

ad7380-4 is the only device from ad738x family that doesn't have an
internal reference. Moreover its external reference is called REFIN in
the datasheet while all other use REFIO as an optional external
reference. If refio-supply is omitted the internal reference is
used.

Fix the binding by adding refin-supply and makes it required for
ad7380-4 only.

Fixes: 1a291cc8ee17 ("dt-bindings: iio: adc: ad7380: add support for ad738x-4 4 channels variants")
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Julien Stephan <jstephan@baylibre.com>
Link: https://patch.msgid.link/20241022-ad7380-fix-supplies-v3-1-f0cefe1b7fa6@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/adi,ad7380.yaml |   21 ++++++++++++++
 1 file changed, 21 insertions(+)

--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7380.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7380.yaml
@@ -54,6 +54,10 @@ properties:
       A 2.5V to 3.3V supply for the external reference voltage. When omitted,
       the internal 2.5V reference is used.
 
+  refin-supply:
+    description:
+      A 2.5V to 3.3V supply for external reference voltage, for ad7380-4 only.
+
   aina-supply:
     description:
       The common mode voltage supply for the AINA- pin on pseudo-differential
@@ -122,6 +126,23 @@ allOf:
         ainc-supply: false
         aind-supply: false
 
+  # ad7380-4 uses refin-supply as external reference.
+  # All other chips from ad738x family use refio as optional external reference.
+  # When refio-supply is omitted, internal reference is used.
+  - if:
+      properties:
+        compatible:
+          enum:
+            - adi,ad7380-4
+    then:
+      properties:
+        refio-supply: false
+      required:
+        - refin-supply
+    else:
+      properties:
+        refin-supply: false
+
 examples:
   - |
     #include <dt-bindings/interrupt-controller/irq.h>


