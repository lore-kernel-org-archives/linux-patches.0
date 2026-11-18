Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045417;
	b=n+8y6bs4jCBiy5ukuCHOUu66SKz3yxYQu+an0GbeKWI5AIINFr2GGsdfDqPMx3a7qIFb
	 VvgxGYjxehB7dvQRzFAcuD0OXSyBAHN76282eqjNbDAugxMQpT0UVKncicImimksZcCFG
	 1ac7yxRuCIVmyp6KugR6DLfVMWyaoTZsWOyi9b+IlcrAicxPAdu+nLR/4vajdK3VBiOpL
	 s90pWYrTK9UG6uY34R7gtzd7jlI9CkcC1c3bQVD4INgeilpjZVUGhkbs4B9VdL4te7n+S
	 7CJdHG+g/UPenoOMm748CxZf1QkVYKNQ4c6btbtwWxFW6E5r/Qww4xZ5QqHd0utCfiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKgNz1/5TKS1siwUQQeqE30C4amcXFnZALSyEebGIPc=;
	b=aUSYu4uKdg0KVGzKN3JU2Rw44zhhkemfN9MYMmxTEbqW3qidQSH+X/+DxZ4FFFn8jG3E
	 os1rbd+v0PvxM25nSW66Tyq7kM07K9nNK48RPQGwvnro0G1r97dmLwItZ3OOcYqKzu8ld
	 SlJGysublGhMJNhPwkhq4QNPdb+rUABv/ls/EY9h3vfsv2MNOqff/IzK/HQm7A619rYYh
	 WrnRuhNI8yQtV/dZBu4f6aDjKwJNtpPLysp2EvDQQVHwU0M3hgBzeMFP5jybW/7YVHwRa
	 uPSBnYx8A/9Pz0LWzjU1J1FYKlU2Qrx0XMf1+CtPCGrrUgB/85YkjSdzW27dro9ytog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnt8DBBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0375606A32A;
	Wed, 18 Nov 2026 23:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnt8DBBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291D81F000C4;
	Wed, 18 Nov 2026 23:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045417;
	bh=NKgNz1/5TKS1siwUQQeqE30C4amcXFnZALSyEebGIPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnt8DBBEZZ8woKRZqOmWrp+klG263VxRIVcskaQ88UcbiExUfjkgvEm1K7y9DGCi9
	 pbUA1DqXGIjwMEBKiPKysSnXB3dYOzhNfmQjoulZGbu0UqhPu7fMURq4olsW1iT0yy
	 mBFnzFHnQTnrv5BUo/9s+v5UddXMNLOUl1aTIelo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0916/2857] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Wed, 18 Nov 2026 15:32:30 +0100
Message-ID: <20261118150234.563763849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit c26cc979e28f5193310e4379e14aa6417375c565 ]

In slim_do_transfer(), when a transaction needs a tid and
slim_alloc_txn_tid() fails, the function returns directly instead of
jumping to slim_xfer_err. The runtime PM vote taken earlier with
pm_runtime_get_sync() is then never released, leaving the controller
permanently powered up.

As txn->tid is still 0 at that point, jumping to slim_xfer_err drops
the vote exactly like it is done for other failed transactions.

Fixes: d3062a2109309 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101448.1084691-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index 245e9c7f92cdc..e9bb49bbbd082 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -138,7 +138,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



