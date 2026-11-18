Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029373;
	b=fhVqBdQmfcAIoyPblrXSMEMemut+bIRYb8XX1Z0++COan3QPV4MkpgMhk/AAvb9G04z8
	 QsYA2hYntmSPc0Vik2U2vsawJx+pTiaEO7jsNgeIgkn3Rx0UmuDy1LzZscI376E2QSojA
	 kPuTgOJ8zSo7KUreu376N7JLspuAxedYfxR9/Xb8dmTOzNMKpXdu3i/TqANq9Ff7ISHU1
	 lzWEhAR1jhP6q6o98RBHqEtMYLFozE9Cm3pcEd9FL4vKpjJ8wvLUnk/DovF+p8VTC3ynH
	 9Sw3l4cdzZPPDDdZjaKXVkzkOJXywIOqj6SMjGKRSNWdyVkgVKI37mqdgeYcQ8Oi2nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eP/JTj81KoSsCFzFkpvI1BeeVTwfvP0ONpIsv4NotG0=;
	b=mjTClryjB0k9lBbnk+FLHLxYplvG1SpDocI0fyEynSWYaocionX6bVhbQ4z0JXiJmAhW
	 kldDPR5WJ1xo396VyUn+bvccDqvP8oShcqPHsVSZ9j2+54lxj8w2BVlaXLGwolWSgvW6M
	 XrilWi4Vv/bjWq6uXEZr/+r3LNc+7AUMxReZDpfq/5GPLNfN1EfKA55jrUz2xjiJnOWqy
	 AdcjAExu0sfdiqZzQeAia98Xeq4hWWY7EcHu5rnoIM4A5etxYgdMhihQbzfdB33yRPpjS
	 a72m8o5GLM0Wlf2OpOQwv/BvqflcDQAASrIHN5bfbTZEz7Cxj5hLS8NcTJhbj98tHGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXdMHkC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66007606A320;
	Wed, 18 Nov 2026 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXdMHkC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBEF1F000C4;
	Wed, 18 Nov 2026 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029373;
	bh=eP/JTj81KoSsCFzFkpvI1BeeVTwfvP0ONpIsv4NotG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXdMHkC2XNUydHvRfJrW7ZF4C7Jyfx74s6ZqVAr7beVYnuga8jJXIfjb6ulxo3NTW
	 sHER1mCEPFWF51Bj/a+FEMXdDGvCjun6sbvPsR63ZbpuoIT/NzI0nCEumXucagfbIZ
	 EUmV67U+t5J3csANgwiGe/rvpb3N6WgKydGOnMyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0320/1756] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118150021.038612423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c12a3a4b35e47fd511fbd550d3637318be41c4eb ]

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index eebcdf653d072..a2838e36f3f9f 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -220,8 +220,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.
-- 
2.53.0



