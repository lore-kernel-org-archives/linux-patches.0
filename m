Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613B32566DA;
	Thu, 17 Apr 2025 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913313; cv=none; b=BiYLAHqpr0JFJYBU3m3sEeGpzBl6YpzrCm3736ZqxWGaJ0gZCTjqGcMFgUeF62/o5BSz/VOTzTQ9HIvDGmwqUjiWNLirTPl+8aHVZBo7e14WMQm0cWAXOY+a27iKW5yjY9if2+depHzA4ovZSMFdqNKZ4CCxYJntqg9EyaJvA3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913313; c=relaxed/simple;
	bh=slwk46eklvW6fNoeOluymadwCxm3SRwwBWLN+rWVdyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKw6whLEkHdYrAu45bkYnriXksJLncG0ei7vYtHQ0CLPO1sY84D7Ed09Td+0UE4OPHFYBlx2ZvIZ+CG6tqpXIMrdBeiIsv2RC/OlqOyD50VfhnYb5zjqsoGSrfpQqLnpJWdF3gBad1l7IbyXqiW8amRGpJnxpATSWxeWIWT+/Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbfZI65u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbfZI65u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2745C4CEE4;
	Thu, 17 Apr 2025 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913313;
	bh=slwk46eklvW6fNoeOluymadwCxm3SRwwBWLN+rWVdyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbfZI65u0IGt6uCpmWrA2uCRGbJir+dfr2je6ATuQAXtbjxZh6TsLDnZbrOFIO2nF
	 T1F81kpP8Emne40sm1Gl1qO+kWFHSLiHpM57WeeXPW/0qgBaaKAFieGnEYHnqVlKPR
	 k21hY58aigqhpO5MqQF3Q2k0pchWg4CBnpHh4BmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.14 267/449] irqchip/renesas-rzv2h: Fix wrong variable usage in rzv2h_tint_set_type()
Date: Thu, 17 Apr 2025 19:49:15 +0200
Message-ID: <20250417175128.773467052@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 72310650788ad3d3afe3810735656dd291fea885 upstream.

The variable tssel_n is used for selecting TINT source and titsel_n for
setting the interrupt type. The variable titsel_n is wrongly used for
enabling the TINT interrupt in rzv2h_tint_set_type(). Fix this issue by
using the correct variable tssel_n.

While at it, move the tien variable assignment near to tssr.

Fixes: 0d7605e75ac2 ("irqchip: Add RZ/V2H(P) Interrupt Control Unit (ICU) driver")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250224131253.134199-3-biju.das.jz@bp.renesas.com
Closes: https://lore.kernel.org/CAMuHMdU3xJpz-jh=j7t4JreBat2of2ksP_OR3+nKAoZBr4pSxg@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -301,10 +301,10 @@ static int rzv2h_tint_set_type(struct ir
 
 	tssr_k = ICU_TSSR_K(tint_nr);
 	tssel_n = ICU_TSSR_TSSEL_N(tint_nr);
+	tien = ICU_TSSR_TIEN(tssel_n);
 
 	titsr_k = ICU_TITSR_K(tint_nr);
 	titsel_n = ICU_TITSR_TITSEL_N(tint_nr);
-	tien = ICU_TSSR_TIEN(titsel_n);
 
 	guard(raw_spinlock)(&priv->lock);
 


