Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153225A2C8;
	Thu, 17 Apr 2025 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914620; cv=none; b=u3Rn9ohSW5Xdjt7LIiEVGwt/44kN3I1LnS3q9YmEJU3lo/5PHH2ORLyWJKKfEFP9050LpSckNwRAiMkZ1LSPG3ufV1e0nPTrjtxn/31W8uUjx5Jm9I5QCUoKm+l3wThFw8s3/7dkhr9o8IcuoUlMxQwifR+0eXrFXHT1Z7dLF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914620; c=relaxed/simple;
	bh=nKmSAOGinwQ5A0z1a0xOiVt1kqvpubVJGuMi2H2jCU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUtbIW1yfVBFdFvC8T63RaFsHGciPM8D1BApr0QNbZllKhOPOtmrR8N6arzwHYWJuXc4x6GI4m19kIKjShtvrNvGMj4c4KyScXyYoglrQgxJFh4U5RvzoNv0cIVQFwnhgyah2Ngjjx37lZZ+QipgL5Rp1D8Y+d9uUjDg6f0aCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmAtB7VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmAtB7VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93446C4CEE4;
	Thu, 17 Apr 2025 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914620;
	bh=nKmSAOGinwQ5A0z1a0xOiVt1kqvpubVJGuMi2H2jCU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmAtB7VFG/+Yv/7FSciVFvvAaYCJOxBEi+FzS3W78K4UfcKwHH2DPRmTHIN4SHFoZ
	 0G/5R50oQ26a7YoZKLUPP7pGGcc1fEKKEeYSzoUTnU2/SfMxWewZHgGfmGo3bSWY3h
	 hM9fG0DEwDDkNRCqYvsHx3Isr9qDoAx+BQmBl1KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 245/414] irqchip/renesas-rzv2h: Fix wrong variable usage in rzv2h_tint_set_type()
Date: Thu, 17 Apr 2025 19:50:03 +0200
Message-ID: <20250417175121.277117037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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
 


