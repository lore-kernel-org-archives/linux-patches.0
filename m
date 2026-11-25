Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618530;
	b=4Xwg8awx/wRgPrgwRL3rQmPWB7bXBkpuHqXmcejlgo0Qpvsc5KWSl1f8AGkdFwNZjRwK
	 DaA52f+28Uk5esdV9fnAOa25glikPiEEdOyFwhw4zYaqBpJocJHVSRtF2rznihuo7KiEv
	 9/BVtiPODdn6O6r2sGvOkHgdAqVxO7XgDFwUxsd22DUjMRDtWdfMdWK6r/iGkiXK+uyIS
	 b2ZgaWXIJ4Hm3vpzhj+xiAnY/8Sz1iKwMbZ/pcHeAag1vnXihJleBBy8y6uUqz85hqwjs
	 i7QiAi69WprOkbraf6JofPGZbgFU/HQICKpC9pk9+OFG1SAkcS0pSA14cPJTFaW4dgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E6FKyEIG0RuQ2D1IlaN5rvJ5Ql+PbQXXMxQmLmNkSw0=;
	b=o6qD/kiFjWekOO2a0cIezX63Llhd/GgM1NyDrIusr39Zv1yclJIBmp37t7h1VeYh+/0H
	 ugW4G+ylDWHFpO4jRFX1/hw2lrrWnaN18YOlD1GwneKopWbbLavCNGZLep5NWx/dssUHT
	 knQD9X4CceuvWJMDE3KXWhWvIjNgQaj2vq+PDt19Cfm6WJSkDaoh6DBiOJK6kl/CQE3XJ
	 5ZZYlTHrGK/V7AwYM6KKArcCORRHaMLIZoM9jOKz/m/m9ixH+cK4vfB5oYaBPZkczT8Q+
	 jT4Cc5/k1wGEelYoiwtklWTkPGt2dCVzg/MDjArtJvYcBwUCSuENRz9ZyfM35/c9o2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0hV7eHa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CDB606A326;
	Wed, 25 Nov 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0hV7eHa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA231F000D3;
	Wed, 25 Nov 2026 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618529;
	bh=E6FKyEIG0RuQ2D1IlaN5rvJ5Ql+PbQXXMxQmLmNkSw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0hV7eHaluezRP1WAWmMo4S6ITWzXnsNKRYJG4mvokyN53HN6zOXi8lOlNkcxo5Nw
	 nTGmk7EXgRoP132xi0KIcOmYWcZ6pz1Jc+3e+hyjtHg1qsNcdy5G7o2oEx4afoWUjL
	 feooqSE6S89/mqCZFe/hzZsHjpSi7uKWdUrWLR8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colton Pawielski <colton.pawielski@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0307/1005] net: 8139cp: keep Rx masked while NAPI is scheduled
Date: Wed, 25 Nov 2026 15:27:25 +0100
Message-ID: <20261125143828.925727495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Colton Pawielski <colton.pawielski@gmail.com>

[ Upstream commit 547b1ae5ec50b7d81b05b4219e0db7e56279d65f ]

cp_rx_poll() calls napi_complete_done() and only then takes cp->lock
with interrupts disabled to unmask the Rx interrupts. An interrupt
that is not masked while polling (TxOK, TxErr, ...) can arrive in
between. cp_interrupt() then sees the Rx status bits, which are still
set, finds NAPI no longer scheduled, masks Rx and schedules NAPI again.
cp_rx_poll() then carries on and unmasks Rx anyway.

>From that point Rx interrupts are enabled while NAPI is scheduled:
cp_interrupt() leaves the Rx bits for the poll routine, does not mask
them because napi_schedule_prep() fails, and the level-triggered
interrupt fires again as soon as it returns. On an SH7751 LANDISK
under combined Tx/Rx load this interrupt storm was captured with a RAM
trace right before the board locked up hard.

Mask Rx in cp_interrupt() whenever Rx status is pending, not only when
NAPI gets scheduled. If the race leaves Rx unmasked, the next interrupt
masks it again, and the pending poll unmasks it when it completes.

Fixes: ab1e7e1d2666 ("8139cp: use napi_complete_done()")
Signed-off-by: Colton Pawielski <colton.pawielski@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261031-b4-8139cp-napi-v2-1-5824797c0fe6@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/8139cp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 9016527e229ac..8f81dc7deef1e 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -600,11 +600,11 @@ static irqreturn_t cp_interrupt (int irq, void *dev_instance)
 		goto out_unlock;
 	}
 
-	if (status & (RxOK | RxErr | RxEmpty | RxFIFOOvr))
-		if (napi_schedule_prep(&cp->napi)) {
-			cpw16_f(IntrMask, cp_norx_intr_mask);
+	if (status & (RxOK | RxErr | RxEmpty | RxFIFOOvr)) {
+		cpw16_f(IntrMask, cp_norx_intr_mask);
+		if (napi_schedule_prep(&cp->napi))
 			__napi_schedule(&cp->napi);
-		}
+	}
 
 	if (status & (TxOK | TxErr | TxEmpty | SWInt))
 		cp_tx(cp);
-- 
2.53.0



