Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041763;
	b=HBwbkogq/di3mYHH34I9On7HW/SB2lHJEdA+tYOFQwLK/NYYHsSazTK+2ot1jJQgW5cf
	 uZUJiOtZCgS80dKs+w9zu3sqYJbX95x0y2CHqOyUp8A/HouauwikeqKlIQESAHLITVh0Z
	 qM8a25r5XjrUTMceeaKbDQNiWUFiOoJCuaqDwyQEpIEXpDy1FDNWpA9x2Ov7hiS2qF317
	 OfG3+EqKrEuVLssfPeuyKvQaYH5jyk5oz5iAHLrIMg5w2VbQx1uoMqTYF86rkcrjg1H2f
	 LEsPtMYRxTrn7B7uxtkW8U5tJgirraHAJ0H17AoUdrjGz+y2Iu/aTCTL1NQNK9eKGCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6UfqldIkgLOz0UpXKbQJm6ZHyPXECAlzawx/FdVKqY=;
	b=gMFB0tA0L+3qAQzgEoThmZUqJHspUdCWx83AUxIAymjesHD91dG5xegB32nywQdESb4D
	 Ah3bghRRjO45OgGHxzIyHWF4p6XC6BZud/i79JnjQjy90T2+iC1MNESEVfXOFvb8ZRV9h
	 +Y7yoiEhYOUOEj3J154BDGYUlTgQbFAEvLB7q0LWwBtF9C11nbVcRQMLrMdqelhrJ7Ygp
	 GsNV5xQSckAJoUpECSIphgSN/NpJsFB33N2tCh/aO1pM/eYLqFh0I8pOjkG8JR1vD2iLy
	 MPfdRCHC6slcBb+3bczIyrtYKbI1ik0ftubxw4n9yEPJuaFTECA2hIgcG4Eqw9KD9Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZtAe2VP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9F606A325;
	Wed, 18 Nov 2026 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZtAe2VP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0FF1F000C4;
	Wed, 18 Nov 2026 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041763;
	bh=/6UfqldIkgLOz0UpXKbQJm6ZHyPXECAlzawx/FdVKqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZtAe2VPJbgdqb78lO3VhXr11ErnYGeD+/D6GZ1xIROuC8luojr0ro2pBk93K98jy
	 KA6cmgBVacw/Khvoxj4lNlEHqZQd7PGhakbazfd4n5ixD8muNBpcqWHHTWy9aClOss
	 WZKSLM3b9g7Z+6U7Jh6UvPFpNgiK5lf09proq0AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2929/3318] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 15:59:11 +0100
Message-ID: <20261118150448.258482644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 59df57262e6fa9e6f4aa76d6d324134777c702a0 ]

Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
using a mask that was right-shifted, whereas it should have been the
address being right-shifted.

This ended up working fine in many cases because the lowermost 12 bits
are always zero (the addresses are page aligned) and the uppermost 12
bits are usually zero too, but it could break for DMA addresses that
are wider than 52 bits.

Fix this by right-shifting the address instead of the mask, similar
to how it was done in the original i40iw driver.

Tested with NFS over RDMA with some added debug logs to ensure it
was hitting both the direct (single page) path as well as multi
page (< 512).

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20261015161756.3078300-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index c63772d50cf78..01217b9171807 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1326,7 +1326,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 			 info->first_pm_pbl_index >> 16);
 	set_64bit_val(wqe, 8,
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
-		      FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+		      FIELD_PREP(IRDMAQPSQ_PBLADDR, info->reg_addr_pa >> IRDMA_HW_PAGE_SHIFT));
 	set_64bit_val(wqe, 16,
 		      info->total_len |
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXLO, info->first_pm_pbl_index));
-- 
2.53.0



