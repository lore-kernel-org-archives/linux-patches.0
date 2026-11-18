Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020513;
	b=r7W0MkkjlClg+r8+DYZdlHPtwoG2fC8/j/tEppJjSrhq9WJ3CymhxIewX9iR0Ec5Mtpp
	 J8d+H10XPxXhb4kkek9oPqBK7rtKTWWyav81tcGc0S7zP3Xp+hEA3WYsZ+bQk7+8Mg2u4
	 QKv0OyokIAKv0ZLhaGaqEhr9oQ0I557YExS9RiDIP3T3L6u3jLG60nFbRjyBcUwla5sDg
	 Zmm/WDkYvo18+Xv9K6Io4GuVMr/RUCyerAwXoZ0e9Sjk+Unduqst9R/8LB01S37XBrwt3
	 p/6qq5DaG99qa2G4gBNODL5lUYBxwf5I9LC8lQDyn5RvG18h1iupPMhQIcXK6YxCU6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMWtgOzP7KFA8d39Aht4cSF6AGDIfPWHNh9SSFhJNbU=;
	b=iKg8Ys7vnEcnTxqgRppf0GbPkXrDftgBJXGgccDLZGxYug16uPJMv7lH0kMdNQ+E99Bd
	 2hqk+WlRtD58Iw7r/G6i9QHbpJoZo7+K0cbUlu5eqdYMVy9xsHYNt5Kw5eFwnG8FU8ouJ
	 PNraduV2TMAXUfELPl9ZmrciphskCDg7oOZLV7YxfI1Yb4xAZiDkMcpJ8pzTbYfMoj2Uo
	 hP2wjKnXFgQ54oaymXtctXc++GN8hrDQi5tQUKgjk3WXWLtH3Zw9bme953nlOOklzUaMr
	 OlI+iV9PKeWwDjueLRAz3+djNQa1eNqlSfIxaOnOV6fm+ZDmkRsHfDHv5dBkc9DcIdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mT6Di0I/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC39D606A31C;
	Wed, 18 Nov 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT6Di0I/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2DC1F000C4;
	Wed, 18 Nov 2026 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020513;
	bh=EMWtgOzP7KFA8d39Aht4cSF6AGDIfPWHNh9SSFhJNbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT6Di0I/CuZgxUyYaGPVq3aNq5wD0Kb2cZyaFv6WSBX5qlFXV9XFiPnB4tc628Pth
	 Jwq20qC5dQWPdfxRjvvF/zAuRiFjZ+4AB/MmceEILk8nWS0VPon5yF852toty2iwKL
	 X64WFpQeZEFrEsIYy8gzkmckP7tlcilfDOKdHLzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1979/2651] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150357.663379843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7af1c68b2fb26..970b61aa3e24f 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1729,7 +1729,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
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



