Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC6320A02;
	Mon, 27 Oct 2025 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593541; cv=none; b=suhcG9yAnJkGg10x2SgvxZcWJWg5zkPBaSnQFcIpM5PFOmHMPoYiiJMBXqPfAwqaJrJPSx9AeNFJSZcnbo4Vegq9oliDLh6ub8btgOCVShraH0/T/0ZFuhO9UyToeRsINH5kKQpvSl06GpkRkhI5CkZd1JRPaDaMMKHifNM5hBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593541; c=relaxed/simple;
	bh=12kK6FCbYiDsbb+HlVYspj1895t8uW1DQde/Z7s2TU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBS2hvRmIoO6ppVT7uENsp3O/NA6h0h/EkhkVZiSMYJALq10Gb5Kqzd9aEWx6a2k7+o8mJ28wlcZiBPl5DM73nNCKaCjyZKchHKFqEXhPcnS9FbvITFxx2SF0Qns6l1z0JDXbQH4YcOiKcMnJeO0fHqzO76Ly8OuhjrLmP208Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=betl5HzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="betl5HzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA0C4CEF1;
	Mon, 27 Oct 2025 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593540;
	bh=12kK6FCbYiDsbb+HlVYspj1895t8uW1DQde/Z7s2TU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=betl5HzUZByyeJrGAP5uOMn7r+7/pM0ZelI0E5vDr18xpdGUvIHXlvsV7MIgzVmFt
	 tFDbDzynYR+q0xzLsZai66MpHzZ10TCMyOIFHSUWfNu7vHof4OVIzLSUuBgaei3vBc
	 iYB6HQTuYIat0VqKqsklBX59w7PTB30W3K9BiDss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.17 167/184] dt-bindings: serial: sh-sci: Fix r8a78000 interrupts
Date: Mon, 27 Oct 2025 19:37:29 +0100
Message-ID: <20251027183519.422996304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit ea9f6d316782bf36141df764634a53d085061091 upstream.

The SCIF instances on R-Car Gen5 have a single interrupt, just like on
other R-Car SoCs.

Fixes: 6ac1d60473727931 ("dt-bindings: serial: sh-sci: Document r8a78000 bindings")
Cc: stable <stable@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/09bc9881b31bdb948ce8b69a2b5acf633f5505a4.1759920441.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/renesas,scif.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/serial/renesas,scif.yaml b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
index e925cd4c3ac8..72483bc3274d 100644
--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -197,6 +197,7 @@ allOf:
               - renesas,rcar-gen2-scif
               - renesas,rcar-gen3-scif
               - renesas,rcar-gen4-scif
+              - renesas,rcar-gen5-scif
     then:
       properties:
         interrupts:
-- 
2.51.1



