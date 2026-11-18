Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023813;
	b=hyKDnktPBdPuJsYaMFryPZXOfHI6FcQfJztc7yhyMakrAwAAXM9PsW2bF++vnCPPNTdw
	 s/VUnJpFB3ABv5xhJS8MHVngrvyN5JTlbEUzAxxWbOX4/vub//sgkzIj1eef2M/0oYMya
	 5i+i7KP++InkFXtV/or8A17mTj8cr7dJM3r6zC52p44ktoi4tnpacvmmykZ+81McbNj2j
	 z/9kMU2aIVKiaUs5ZuIwb5pWCGilu/7370eSSnk7IJysdIjs4ihiyoLUKEjbSksf1t2Ci
	 INUrW30uN2mqj3O/FPE7IHWitCSRyBVpQmDFQYSw3baEx0gDeiobct3WCEurjgJWclw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lKE3GO4x3EMrRf6E2rhbOjQrEMBCPGsfBq2+z7DVYI4=;
	b=FzPNxjUzcvil+O3cqnf7zm7AO52whQM4FagXR8WrhxGGE123mjNZZj3r1B+2C5e1toGv
	 mQRMTp8IrwhzJIqSvoMuiaLpEJEvTBTjlPYdWe8h+BnrRvKbEihwBwYRNVoIoSVG7wuDl
	 FCwQ9ndVUq4Uw0U8ND4zAHxpHxXcNDYh20cvrQZKJT2bEiPPtplLVhf26qd+eVdNCNkjA
	 k6lRaZ9m9XV1siv9JrGSgNXwcFBB/ldtlkkdupJz5P36MNOp6SGh2OiiA5KwNUXTp6z5N
	 eihPZcPP2SeIY8iKfl6KDzdxJxCBXl1AtpkpuTzOzMl6iPZZmnweIAuHdiv1YRIxhiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NFT8kkio;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2C606A335;
	Wed, 18 Nov 2026 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NFT8kkio
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694A61F000C4;
	Wed, 18 Nov 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023812;
	bh=lKE3GO4x3EMrRf6E2rhbOjQrEMBCPGsfBq2+z7DVYI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFT8kkioSv1+bWVQ8XRJvA2OYv/GLP4Dpn8jC0HrGu7+PdW90A4sJu4C0r3JvtTl8
	 fegJs2+Etzf9OvlqLGflDr6WMeKrFhfYphYBfjvzTumxyTyvJhOJadRjY6LWenLkK/
	 gknW08g8wEMHyJ4g+isoH5309X5Ca7jPk4iB6ii8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0502/2151] dt-bindings: interrupt-controller: chrp,open-pic: Typo s/pci/pic/
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118150140.337189985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f0597e96a23b0cc7877581cf907407645ca71c03 ]

The device_type for an OpenPIC node is "open-pic", not "open-pci".

Fixes: a241f1a1b338b714 ("dt-bindings: interrupt-controller: Convert chrp,open-pic to DT schema")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/f2cc11922b3e5dd73997ef8c673137951d3fe715.1788426169.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/interrupt-controller/chrp,open-pic.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
index 642738512f3ce..5363f4c6ffbcf 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
@@ -24,7 +24,7 @@ properties:
       - const: chrp,open-pic
 
   device_type:
-    const: open-pci
+    const: open-pic
     deprecated: true
 
   reg:
-- 
2.53.0



