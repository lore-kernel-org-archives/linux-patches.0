Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F7023B61B;
	Wed, 20 May 2026 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295898; cv=none; b=og3QKFKRuF6bGr79XaVDrOernK+igIuhma49q8I5sQUJiassRhLT1Otgcjmr8K+kp1HDSwJcybVQuZOW56JpduuhMRARNyuAekjayutL29AG/aZ2x1wboOX2hE3NJ4DEtyYor7HoZeyd1eliG9aVW1FV3a7/bD3Jr+e/8Q6nqeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295898; c=relaxed/simple;
	bh=knfMAbMjCoOFG9iCcFkGo7Hge54R6k61Ftj6jRSyG58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRREZ2fxNIyM6ULLYvhRDpBDZ+siNd/yfr+d1PGIc8IAw+kBwd007mf14BhYRAvv/K8dcFcRpfVUSKXKet3tt87I38W3Ch3/5YpoP+eTrsTT/IYK+7oUFc6zjPWmJqegmkG07zVlClp71yaVGRRQFOvfcpPbZHlUSJc+u0ZS9Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGV4jde3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGV4jde3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE321F000E9;
	Wed, 20 May 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295897;
	bh=m2xbqkonBKHj9CdxnWLARnKMtbZYmj4vbLaB4O4iYnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGV4jde3cBOgxJEghDGElQn0RW0ulb7PoUy7H5NBORkcoVpAe33/fAkO3Jcfg/qGC
	 9pJbKxx5oG/e1KOoO/vC9QaJ8WsW7tJj7WAS0gPlIgVki3MjT5Vn1Ddoq9OKJgAXYK
	 sszZTuWQO5ofTZTRM0sKFBXU9xTzrkHm0/2LtF+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0593/1146] dt-bindings: interrupt-controller: arm,gic-v3: Fix EPPI range
Date: Wed, 20 May 2026 18:14:03 +0200
Message-ID: <20260520162201.597882352@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 15cfc8984defc17e5e4de1f58db7b993240fcbda ]

According to the "Arm Generic Interrupt Controller (GIC) Architecture
Specification, v3 and v4", revision H.b[1], there can be only 64
Extended PPI interrupts.

[1] https://developer.arm.com/documentation/ihi0069/hb/

Fixes: 4b049063e0bcbfd3 ("dt-bindings: interrupt-controller: arm,gic-v3: Describe EPPI range support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Brain-farted-by: Marc Zyngier <maz@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/3e49a63c6b2b6ee48e3737adee87781f9c136c5f.1772792753.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/interrupt-controller/arm,gic-v3.yaml    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
index bfd30aae682bf..360a0643a0b56 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml
@@ -50,7 +50,7 @@ properties:
       The 2nd cell contains the interrupt number for the interrupt type.
       SPI interrupts are in the range [0-987]. PPI interrupts are in the
       range [0-15]. Extended SPI interrupts are in the range [0-1023].
-      Extended PPI interrupts are in the range [0-127].
+      Extended PPI interrupts are in the range [0-63].
 
       The 3rd cell is the flags, encoded as follows:
       bits[3:0] trigger type and level flags.
-- 
2.53.0



