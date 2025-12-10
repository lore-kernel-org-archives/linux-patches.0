Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C5C304BC4;
	Wed, 10 Dec 2025 07:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352219; cv=none; b=aIZ2ve1JkDO5TiF8QN+FYF6Eyw72QSov/Q46yoa00h+q4WOPrFD9+09RoVokrrRvJgondoLCx4Tx7VPTntiXHpvW6eV827Oqhy4BMbzUzkw3R2fZhjgogIRJhCvCSPJsBZVTIYP6+EwSGgc6UQxyFR9BQMHp/CtRXbmREXQPksg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352219; c=relaxed/simple;
	bh=14xJZR1/f5nzhQ7x2uZquqTFMBueXyTW55r/meO36cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtIpoizetlh+CtyXyj5StXxajOdedbYnVSKfd8a/slHWGfGdDwsbJXi/xToBo5avh66SKK/PTtqxZ3+PlxrocdcQhAog7VL4IN/WvEs+39Ebd5WGbjXm+fKAXPSfM8U7bQ5F416xV2mA3a3sfCgTsrqKUWWEwouW7xkuEYhetLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1iwgQrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1iwgQrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD62FC4CEF1;
	Wed, 10 Dec 2025 07:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352219;
	bh=14xJZR1/f5nzhQ7x2uZquqTFMBueXyTW55r/meO36cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1iwgQrNoPENUPzvAAUnvhZfHmXKljBC9h7afObp0qC3UQ9uwfbPvKa9q/jw9XmSe
	 FijiKDt5F9/axXxIjfRY0dwqyaO44deIk43ZuS/IaXoSMD0DiRfTAhIfv6xBLg2sf6
	 OVu6eZwXGu9Pbx3TgWVfBgGeOls7iRJkbpXkVfJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Conor Dooley <conor.dooley@microchip.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>
Subject: [PATCH 6.18 16/29] dt-bindings: serial: rsci: Drop "uart-has-rtscts: false"
Date: Wed, 10 Dec 2025 16:30:26 +0900
Message-ID: <20251210072944.809558984@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit a6cdfd69ad38997108b862f9aafc547891506701 upstream.

Drop "uart-has-rtscts: false" from binding as the IP supports hardware
flow control on all SoCs.

Cc: stable@kernel.org
Fixes: 25422e8f46c1 ("dt-bindings: serial: Add compatible for Renesas RZ/T2H SoC in sci")
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251114101350.106699-2-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/renesas,rsci.yaml |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/devicetree/bindings/serial/renesas,rsci.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,rsci.yaml
@@ -54,8 +54,6 @@ properties:
   power-domains:
     maxItems: 1
 
-  uart-has-rtscts: false
-
 required:
   - compatible
   - reg


