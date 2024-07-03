Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BCE16F8FA;
	Wed,  3 Jul 2024 11:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004816; cv=none; b=PQdIww8HsqHIQcd5ggnF8qrZqYRW9xoVVvNktWaTcXM2PryfMK1Pk0890FqiET0aSVDi/i4lgWCecx9b61ZWFg8J25ZxgWKVl+FGNdwmALpU/0c91/vvXPy0gIHnUnzFgWlfLdRkp+Fb7cOyPZQRc1skVaVLN+To2ET7aYX1wrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004816; c=relaxed/simple;
	bh=9Ru+SI5nT6hBDkEsFb1StFcT2K0S8zvDBGb49ECGoKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bN5PpvRP8VG5mEW4246OL5fvxEYN7YCWeVxJyQYPFnExQj/PQTDLxX2Kk/r3bPvNUBp6IlxzfvYPihcJLXNIZNV7QnLYl61UFh2C1N1HgatTZuep5I16f8jNx7oJqwgv1IKsKXQz97JXr02bxNxEnNS9APmwcHWTt39+kMDB3qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT9R8OB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT9R8OB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9EFC2BD10;
	Wed,  3 Jul 2024 11:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004816;
	bh=9Ru+SI5nT6hBDkEsFb1StFcT2K0S8zvDBGb49ECGoKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VT9R8OB35x2bUZglOE2RrvNdormWDsXqUbBfL3JipN6Wm09bTzsKL9HLkmlUCnorz
	 pr8oNK4gdjj8aQ9YzMV7DuzIWCptaIVCPDVVhNHRgYmd3HijqEuDlSI1PRNLonuYSy
	 w4OPldskn6TD/chPEHITUDCd2sS6bqHL8F0gzvvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 169/290] dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema
Date: Wed,  3 Jul 2024 12:39:10 +0200
Message-ID: <20240703102910.559286879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 5c8cfd592bb7632200b4edac8f2c7ec892ed9d81 upstream.

The referenced i2c-controller.yaml schema is provided by dtschema
package (outside of Linux kernel), so use full path to reference it.

Cc: stable@vger.kernel.org
Fixes: 1acd4577a66f ("dt-bindings: i2c: convert i2c-cros-ec-tunnel to json-schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
+++ b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
@@ -22,7 +22,7 @@ description: |
   google,cros-ec-spi or google,cros-ec-i2c.
 
 allOf:
-  - $ref: i2c-controller.yaml#
+  - $ref: /schemas/i2c/i2c-controller.yaml#
 
 properties:
   compatible:


