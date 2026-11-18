Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052571;
	b=UAY+bU87oXKdOojTlE+DlQ5xeDBBYmbXAoG7sCXfnzZpQ/YTo6fhFxcsHxMEU9oCNbyh
	 RqeXUKAxn4URjZxUBI7hXiWAZeWPZnPRKc7dcAPquGxIUKYQDok7Mfvc+Ji9KnHv1MyRE
	 EuXv7qa9w+jVthbZKLWiMFoO+HfMulDQySCS3dcNb4oVVYiOX0smK1ppYNIRqTy2N26g5
	 pAwG6OMYvgaZPtPyOGtVYZIcZ+u8a6jC+E4c2bHY2CXgb346zTnII5tnOiAKZsggGMiaf
	 hYHkBdW4sGoKaQWUIkAo96bI/jUwlCLWKK1sWej6yTvgNR7y3n9A4HIey+zK4Rif8/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hHUGk1i+8dlXAR6pwv6P5BN3UF1gS7w+B54m+1W5cT8=;
	b=XWL+ZPN5dJaQaNEv4OMP3U/i5XshNOYV41OOYagRdetiaquDwjBcnec2rizlHrMGkt19
	 4AuaJBtTO0Yt5IuBH0tvKiWgXt4dyaouiT+KiyYauwOEewJPds+Bg13ANJ/weD7uCIBNy
	 amZOajgZCH31YUmvWNLhzEIa9MjTmZSdShkJfRbSdySH42eL1iCRR4KZquwhl4JI4jfEO
	 a4sXZvR97aofrd9C6DyRzVVyvXEcReyLdeXrDwBjuquv5XPciwlWEkPFnQlIeyMCk3OsM
	 czwX0h5B8Z56NX05GSIFYKNzSWTkgGyXqaWk8MfrCO6PfalKQ9d90paDsPiUx4JZhpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcdDJPu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A610F606A320;
	Thu, 19 Nov 2026 01:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcdDJPu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C378C1F000C4;
	Thu, 19 Nov 2026 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052571;
	bh=hHUGk1i+8dlXAR6pwv6P5BN3UF1gS7w+B54m+1W5cT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcdDJPu8Uaq41RS4ie+bGtLSd4lGdGPxwUBGqNqpSpH7OY8KXJ7Yi5wgglqzQ3u0J
	 c00YaTYsi7RsM+TXnVGcpzdP7QuROA1ovjWIpxnvQOmy4GFjjLvOEaohLNKZgvxG9H
	 dCL0apO03nxUzQtdIymyuiGVh5cZW80s9SYAjBVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0610/2214] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Wed, 18 Nov 2026 15:38:06 +0100
Message-ID: <20261118150035.637076040@linuxfoundation.org>
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
index 0deb4c291c6a4..c56dc26875fc5 100644
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



