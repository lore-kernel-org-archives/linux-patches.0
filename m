Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C038922D78A;
	Wed, 17 Sep 2025 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113452; cv=none; b=GPatWTQl0f7wvWyEfGOVnlli16NHXTV3JgNm5M17409YwysMo1+pDK38IX3HBLgE86R1C0p96WWAsNkeXfXq7FEwhy4dqWpsS1cvFEs3dWZgeKm+XDM+bVOL0yV4GExXkrxXb+39wbPTd9Q1HIZ5wu7FOqWJ6Nq4HvsgIDyfCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113452; c=relaxed/simple;
	bh=H5lcQSqiO1RFzI9GUpRPiA9DGlpmFSi0BuxDQDgRm9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmppJ9MNTSchTXQjnaseV9VDHtvsyU0sMeRah72JCpMQdNsGiU/46txphFP8/Raa1+d1hPfddctJ9Jb21+U/KUunqT+Zc7UpuKQt4HukN3Oqi96gaUeJ5PHcgD9YTjjZqwhN2L9JZFp3cSFpzcZ59J+MvCHEcR42mkvO1s2wMio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z11O2N22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z11O2N22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E999CC4CEF0;
	Wed, 17 Sep 2025 12:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113452;
	bh=H5lcQSqiO1RFzI9GUpRPiA9DGlpmFSi0BuxDQDgRm9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z11O2N22/WCj6EKEFjyGLqJj4l+o3RDi8PgZqkiCxkDkYVkq3Zkufdc1MCxOtiOTc
	 iQGeswQON4+jxS9rPzzigGLfXQHPjPNKjD2x3v6f5AeUSzC0cXCd/RzuNwQ872ZNvv
	 PHDAhIFUJ0THwxLaPgGEwYGVYNPAhhUh52A6Db+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 091/140] dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks
Date: Wed, 17 Sep 2025 14:34:23 +0200
Message-ID: <20250917123346.527258299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ee047e1d85d73496541c54bd4f432c9464e13e65 upstream.

Lists should have fixed constraints, because binding must be specific in
respect to hardware, thus add missing constraints to number of clocks.

Cc: stable <stable@kernel.org>
Fixes: 88a499cd70d4 ("dt-bindings: Add support for the Broadcom UART driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250812121630.67072-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
@@ -41,7 +41,7 @@ properties:
           - const: dma_intr2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     const: sw_baud


