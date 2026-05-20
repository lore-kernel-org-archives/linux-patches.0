Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549433F8707;
	Wed, 20 May 2026 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300857; cv=none; b=RXl4hJ6q2AZhfwTuYl2VPETyGvRFYUg8KHsvNggt1EyYIAdqkyYpuJb0DBj89TUsGtHopw8oULbM1Gs4kpiBsbeQRcsgsiQg2hjiyzeoTKQfdP28xoqHlpWMA3DrCErpMoo6ZmFfUnkMvIjbLbjahTcBhSDeq+/V5UNrVnoqg/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300857; c=relaxed/simple;
	bh=ayB5LISmOZllfjWqZGowuRiticb7P12YdZXVlEMThb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMgbHH/It/oXHRK7Z9s0dRbQSH03Own1MIn8Yiry1f/kQwWYJWI8r3cIimUzu0FeZ7KlAApZNtsSz8tqth0mHXNdgIUcnXnVu6+8AeEKPwnY8VE85kbI9vfsA66wCjRyaEHwzZEku+Zs+bmxSM+vpulAstyptwMO5SXIA6v0AtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu6xTk04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu6xTk04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3D1F000E9;
	Wed, 20 May 2026 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300856;
	bh=ekJRZH5AaLc1hasOvQzyuU/hgGecOe2ne8waqosiSho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu6xTk04sbkFA45KUFgpFDMxGPzBpOE/M8hUDZK+t4Kd14groGfgZakBiv/Kgm+cY
	 7WwoOFBgGbCfR2s52k03dWNXtnu74LSWvtyO/h3fa0I4vlq5hxJaeF0qV7OJ5DcWj3
	 yCRac2gwvzDZzG5LXLdTrAJ5Z0hK3nw4dESOTS0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/666] dt-bindings: interrupt-controller: arm,gic-v3: Fix EPPI range
Date: Wed, 20 May 2026 18:19:04 +0200
Message-ID: <20260520162118.448567996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5f051c666cbe5..9deaf132d0e9b 100644
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



