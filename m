Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054910;
	b=IjtBfh65xv4vx8bbikv4Wu7yuDJ7cQBrim8c5ByQvCPM+uBbV+aGzSIF0mGiSYWl+0Z9
	 TYXM5THcov7mRw1/1gJ6tJdPoTkXZlDTiKYa3sW5RYGkK9Dail/lTFg76lftCrpUG1Mg7
	 mOA7cWQDpFLVctzpi0S99Rag1BdyK5MrfCl+FHsQZCpTBPNe1XCa9aZhQXpZpsr34Blgu
	 EWo8Z2/99sQhPhWfaUu2WnXiUY2+L9iE/jPZ5oeAr8aGsZ3BU66rULw5DQeQ1uW2L4FSQ
	 yRk/SaV+lU+KM3PHobQnyjJqzT0lo5LD793MINgMRwRQpuMd30+IErtZQsfldKMmEdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5vW7DhcM1vgJV9JjHnmSrv3/fwVdXoPdywIFpWMLrUU=;
	b=ZODuSEMv+v5yinGCcy73cblkE7LFVxvuowBqqEGZK5LS3bR2kJAwtAWTwBebdWOPWOtQ
	 UAwrPl6FKkmi+mB2uclOxvtFitU22iCZc6aAN80rYfgUrcijr1EGAWWM8CRvccwDqPlCV
	 nr5rDGD2tFs1wXPmt4fiESjvcYRdJxQhvR8meoYxMf2DEIzx7DU4dRmHRirzmLeKgxAP0
	 2jH5lzgp8BEnS+NOmfeKW55ZbEbTrkUrSiXyMi5KKfc4oaIiY75VvGipKgd04ELf3nsPT
	 K2ZlQh8Q6pFIP0SuXOuerJ/w4I3tCo1/DEfGj/7wp2cFFknIlX2pEtlx279DoxadXJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRCcM3KN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7703A606A31C;
	Thu, 19 Nov 2026 02:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRCcM3KN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C717E1F000C5;
	Thu, 19 Nov 2026 02:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054910;
	bh=5vW7DhcM1vgJV9JjHnmSrv3/fwVdXoPdywIFpWMLrUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRCcM3KNX8E+PDnX656J3rg6Ne4jBvUvEor+1pS8pKp9Ad4gy/w06ySlweE4Q3DgF
	 V9bWrBxsymaUO4bijighQOi4OzM1P9rMJuy13qs7BjreGvaWsfs4aHtvaVoJMKi6DG
	 s55O6eNtXcyJfQ7XOch0DoQCDiHJOoQC8Jmpku1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1443/2214] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150108.851771107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fbffdd7290a31..10cac59b83969 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -181,8 +181,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
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



