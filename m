Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060715;
	b=m6cpYdnG9+YjsZaZtDEApG7kKAslG9eIlywCFz9FuArYzQ/eAggSjybTCvPoonzyTXEM
	 yJYDafglyIWuJ99TqXYKlh45933NNhLv2mv0o84LDTGXuG439pTgtTHmPlHn/Drzicb32
	 xvwA7M7QbL7gS5AsSWn6AMiCabtJ3/OjoJ6P1PhPR9hF/EU2D2EkH4Bbxrj3y2bdhscvS
	 D27CR4JSyzoidGP73JTkKpZUnrUStMnP4ufm0EgSjddfcBZolAldzYV38wOCp3+s1tZlk
	 biXmYvWuiG/z6r7O4BF/+wPb4g/96jP6G7TTIeRAuS5t/92YGYT25PutrtK2BuA0XRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=le+7bNhi8kXFXOo8EWbQxsDvHsNWWIuZOozNZ3qvWY0=;
	b=NGhJ4mtOD60tJfXBdqbvh0ARwBBKWbyK27AAd+65GHCyNdpJH5TOWj5OuzeRcoIzhD4m
	 o/mc7wt1GKtvOD9JIqIGLFdaXwbVbwwZirX3AkrXr3ulkok0QpOyaHdDCOWI7+CrjrtKj
	 JquqmBH27+NZ+PslBfsI+hu4/awMYvyIbUCDjVE89oxFqnzhAP2ejG0FTzWRhtuakvbNn
	 DY73WG/uosNRn6goYT3cL4PvaB/84/KLqfuB48CF7blaInYYM3G93DBIxGj/lV6AyjW8H
	 CPGjBWlyDNbxTI5r6IoUpHDhlVtjzCjagK/47RG2MFqB8G4tQIgu/tQtCRA2pZspG4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRuhhjJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23273606A326;
	Sat,  7 Nov 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRuhhjJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8CD1F0089F;
	Sat,  7 Nov 2026 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060715;
	bh=le+7bNhi8kXFXOo8EWbQxsDvHsNWWIuZOozNZ3qvWY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRuhhjJxEXddL14JJpK1dNgBkKzMBUK0Y38L6qHvDMyM+7D+vjFYm6wUh1VVpo/5N
	 jlzh0F8oWfJ3Nqb7LujVKMyzRX86+UO9gf839UlZaf4R+sFUDvx5aht+Cn9L/TkHcR
	 jfXTNwuwOFe2piGwTQTsD39dV1CojSFj3yfGHUKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0139/1536] media: cec/core: drop cec_post_state_event call
Date: Sat,  7 Nov 2026 08:35:55 -0500
Message-ID: <20261107135001.593509705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 2ff4b91e82bd76e1a6e1ff22bfc9aeda08e12a61 ]

No need to call cec_post_state_event() if the next call
is to cec_adap_unconfigure() since that will also call
cec_post_state_event().

This fixes the case when, when the physical address is
invalidated, you get two CEC_EVENT_STATE_CHANGE events:
one with a non-zero log_addr_mask and one with a zero
log_addr_mask.

You just want to see the event with phys_addr set to
f.f.f.f and log_addr_mask set to 0.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index c932c29386a7a..7b4b8d1c3d4bb 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1707,7 +1707,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0



