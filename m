Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625222;
	b=iBcijIS7u1jq3v8pMjAsi8EoJ/sly9Na2GJysYZxM1vGVbWg22Nn29WcEMWeU3AQddFD
	 +PUkE+hxritOo1jNClerSQQZRMW0qwoptV2A627856VbvM36Iee/lD4WqTtL4GlKxomc6
	 fHIohmtORDkhzsujyiTCtqHCbhuHcj2Kqz8cy3PJllwdXIA3S30Ty/yzvQxH77orWKHC9
	 gYp7Oa8cqNz/VqIvCH4YOh6zW+c3u0p5Jsc1jr8+zATk7pX0y4DqM1mIATvFGi5dZ50If
	 8uZ0C0n0WRpZ7E8Fa4+73sZNO18S50NFNZZVJkZg9yS9HuCNulgXjA+tUP2pjY8/oQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4dPDKc2KTJE+ovsidbvvnABuPECwX0Ry41v/vaOk7AA=;
	b=wTXLmArdmqvOV0nL0Vjakc10MFRRExQX539qGIGN1H2+1WqOTrL/2CuQRU09k2RNLXWF
	 Vy/K3oYbP9J8yLAM7hRLYhBdTCy6dBidsbixKNskFu3NuqmJQ77P+5yiDMff9bNPNiFPE
	 ya1orYE7sY4D/c9Vhh725uhwLceyWyPfA/gMdeo5VjxS8f62w4Z1//67Xdo+snHOJSgjQ
	 AJLj8TBckhpT/yB3j1Kw8iMOnj9KTdUns0FogUl9YSYerQ/c+E5QBNkRDkuqbZwYnT8ih
	 TOZxSwu4ttkE27QhWBpxEp5WZYCmoQ8wAWnkzec6wCywbYY86esocwRxGDgjCdFTVEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7tfgCIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484AF606A321;
	Wed, 25 Nov 2026 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7tfgCIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53C01F000CA;
	Wed, 25 Nov 2026 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625222;
	bh=4dPDKc2KTJE+ovsidbvvnABuPECwX0Ry41v/vaOk7AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7tfgCIAKy//v7VgpB1a4I+ivIRSlWFP7ZFx7wClfZCMyK+wLsrr9RynT0JHhUTUH
	 soh3Z2G6vg3t7cXT+/ALdZESPcUX6T1fZpjdZyAv+c/1tdTzNkD23s4vHKF5GJ/KYt
	 CCZBeB9lUsI+P4YoPQHQgVZ8M+Uj2hXSofIhOWLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/816] s390/ism: Zerorize dmb at allocation
Date: Wed, 25 Nov 2026 15:33:13 +0100
Message-ID: <20261125143859.491712332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit a0227fa24e8a2a0397cc4eb669731ff8d9161bbd ]

Sashiko reported [1] that 'Missing __GFP_ZERO in folio_alloc() causes
uninitialized kernel memory to be exposed in the receive message buffer'.
An ism dmb is receive-only, so the data is not leaked to a remote peer.
In general the smc kernel module (dibs client) will only push newly
received data to userspace. We still should not have uninitialized data
in a receive buffer.

Since
commit 750afb08ca71 ("cross-tree: phase out dma_zalloc_coherent()")
dma_alloc_coherent no longer required the __GFP_ZERO flag, but when
commit 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
switched to folio_alloc(), it should have added back the __GFP_ZERO flag.

Add __GFP_ZERO flag and state in dibs.h that register_dbm() provides
a zerorized buffer (dibs_lo already does).

Link: https://lore.kernel.org/linux-s390/20260903143746.A5CC41F00A3A@smtp.kernel.org/ [1]
Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Link: https://patch.msgid.link/20260928151420.383105-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Dropped the include/linux/dibs.h comment hunk because that file doesn't exist here, and applied the __GFP_ZERO change to folio_alloc() at a different offset with older ISM context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index c728095fc5059..0125168a45cb7 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -328,7 +328,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 		return -EINVAL;
 
 	folio = folio_alloc(GFP_KERNEL | __GFP_NOWARN | __GFP_NOMEMALLOC |
-			    __GFP_NORETRY, get_order(dmb->dmb_len));
+			    __GFP_NORETRY | __GFP_ZERO,
+			    get_order(dmb->dmb_len));
 
 	if (!folio) {
 		rc = -ENOMEM;
-- 
2.53.0



