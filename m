Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213869;
	b=yD8nrD0sgwLkKPgzM5iWTaDYNL1WfVIZBxNeWVCvXwSuXDz04WsF6pHcDYRofPRevbiM
	 E2E0NzdstMopnphEeK4hWlwkaKsdKbuH1DizA/OQQauJbRbCsjHYG2LNZYg8cWjq61N30
	 cQyDVnyAk6Yc24bEAgKH8Ab8vRIWh9WxIGAWafy2aLy5t8HWnuF2CyrQF79IdZbUjSW7N
	 Qh8caVZrEqz21SuyuKTebIGu/Ck4FSbld7icuYlhn/MZ21OfLbkLFhOgZ1kxcgmuRL6ZR
	 Ph56WB7cwyC213Dn1kkCCsm4BQ0tt5pxjEJjnnApCWwvpSqUhBtq5CGA4XbCM7V9CjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iMjilSGP6+JrEDWxLpc5ZQwk7eP+DURI42nX7ypTxCI=;
	b=0arhAXFD5NasLZR622gzHwdz4L59ntL5V5d+31zqfeYeUsPDUMvajhvXSyNJrAO2T3DG
	 WucxNGywVcfs9ExF5BI5FwrMshs2ZEtBJjtEvYbK800D6byhqYt8svnxng4CNEAJDmmH2
	 yxrQhzT7dH9Nsnez2hYQxmrKCBIrUG1+yVEeQUfR+VC7ljfHEJrglWv0p/SY/ZQ4Fnoq3
	 laMMAn9Api65vAuOnpK1kBykMTjXfXbQ29ZR6q7aAaswm9sy7ShPxA5Yzu151kkwQu9GX
	 1pu98QnjOgEuFhxZQKn9OHYZjmTSMdrECeHQ2U30pZ4jUZXkRwtipjQCr+e3olbkXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATTY9c4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D34606A31A;
	Wed, 28 Oct 2026 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATTY9c4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BEE1F01825;
	Wed, 28 Oct 2026 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213869;
	bh=iMjilSGP6+JrEDWxLpc5ZQwk7eP+DURI42nX7ypTxCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATTY9c4Wt0BTIoaE8TJpU/MrtZLzwqpDQmoxegSdSqMWmDUXe4HqLThkCWpiorZdR
	 TawyhxahHYT4ktSOinrpx9GRZaIN5tJFTHd0GfbiObrf2DVfhvDb6rzCOUFC4rTtGO
	 eCm6f8mSVKUnOBlw6Vzc2Eld/IhwRINtoyYqRzf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20M=C3=A9r=C3=A9?= <maxime.mere@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0657/1887] crypto: stm32/cryp - call finalize with bh disabled
Date: Wed, 28 Oct 2026 17:45:53 +0100
Message-ID: <20261028170514.361143029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Méré <maxime.mere@foss.st.com>

[ Upstream commit 56ddb9aa3b324c2d9645b5a7343e46010cf3f6ce ]

The finalize operation in interrupt mode produce a produces a spinlock
recursion warning. The reason is the fact that BH must be disabled
during this process.

Signed-off-by: Maxime Méré <maxime.mere@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 59ef541123ae6..9e7e4bdd1ac5f 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -4,6 +4,7 @@
  * Author: Fabien Dessenne <fabien.dessenne@st.com>
  */
 
+#include <linux/bottom_half.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -249,7 +250,7 @@ static inline int stm32_cryp_wait_output(struct stm32_cryp *cryp)
 {
 	u32 status;
 
-	return readl_relaxed_poll_timeout(cryp->regs + CRYP_SR, status,
+	return readl_relaxed_poll_timeout_atomic(cryp->regs + CRYP_SR, status,
 			status & SR_OFNE, 10, 100000);
 }
 
@@ -1538,8 +1539,11 @@ static irqreturn_t stm32_cryp_irq_thread(int irq, void *arg)
 		it_mask &= ~IMSCR_OUT;
 	stm32_cryp_write(cryp, CRYP_IMSCR, it_mask);
 
-	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out)
+	if (!cryp->payload_in && !cryp->header_in && !cryp->payload_out) {
+		local_bh_disable();
 		stm32_cryp_finish_req(cryp, 0);
+		local_bh_enable();
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



