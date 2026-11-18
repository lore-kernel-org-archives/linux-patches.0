Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016589;
	b=m+D42NKcM7K5hIv4d5GGtv38B6rYRaz5HEDZclDgCcbtQw5pBmVOsMvTj1My1CV4E0pP
	 tcMHUJTaN93OU5OIrO83MRTjRxjc8zfCkmMWOyXhVcyxvgaG1KKRMgd/cEW+6lzTJfABc
	 LKe8vZZkO4cSQ3SqJbs9UkP0BxZZJo9szgKIYTaf9z7ZlMOLDGvDl/3JNMl0r5g0lTjGz
	 P2YBT+B43DPqNwDnXFBKibdbHWfmnihkQAGqF2YL6F2TacTdZ11cz87iVGV+ifCBrrpWd
	 YhRjyTw+aVoyG/LxOX17+iVRJTQr2zfdqkdZSGS2RBtArx7gvc4Xow9tSisc3giXAZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/HJE85Beh4rhE8xbvnfo3k87KBk02pYzshRGdrnFNs=;
	b=3fY2hjOj4l4FnrqvG9s97LTfO4NvaQ27aX42syahoTYOWMHdEWjL3GZTjO7KfxHSN8Dg
	 eEWsOdOb+jv5GnpiAqpBf/20b6brO8DYOz7Nm2elKoNbN+M1yQLmyZGd5+mU2oCS4nrj2
	 00xuPVZ2ue7+lP4uoqtcT5L1m/YFqKaESIjZ0+fsde7ytbCGIfRAPsue/qkXY3KXg5fEA
	 kRN/CsEGbqWaJy+l4KIL4x14LGmYf3+TqLZZyKnYDOhCDzFPc7wyvcDkx2pf6H8MyTrmM
	 Jgnf1zlJhnRUkN4owbeF6jadVg2DiIiNoWjkFPMm+o6TdBkwUlLf8P5PYE2aQ1MLwSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thZIwz4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799DF60A2600;
	Wed, 18 Nov 2026 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thZIwz4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D233D1F000C7;
	Wed, 18 Nov 2026 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016589;
	bh=t/HJE85Beh4rhE8xbvnfo3k87KBk02pYzshRGdrnFNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thZIwz4mLOa7ee4U9ORWGFwRtLPv+QnMSCpmaAs7rcpdAMXj61oBmKn1wTo1UbzX3
	 I6dFMQarMVkSkHivhb0U2kh0rHlUQTa6InCcIJun7RA5phyReG0pL+xfp3kxYGEkvI
	 xvF6mmGx0lZcA2Xbt3NHdpvqBqWjwn6i4BIT2KPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0582/2651] RDMA/restrack: Dont set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 18 Nov 2026 15:30:22 +0100
Message-ID: <20261118150308.679309245@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 391c5d826fd0a5dacad54613dbef74c50e966f5c ]

When adding a QP to the restrack xarray, rdma_restrack_add() does:

	ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
	if (ret)
		res->id = 0;

	if (qp->qp_type >= IB_QPT_DRIVER)
		xa_set_mark(&rt->xa, res->id, RESTRACK_DD);

The xa_set_mark() call is not guarded by "!ret".  When xa_insert() fails
(possible on a qp_num collision or memory pressure), res->id is reset to
0, yet the mark is still applied to index 0.  If a legitimate QP whose
qp_num is 0 already occupies that slot - e.g. a normal QP or the SMI QP
- it is spuriously tagged as driver-private (RESTRACK_DD), and the
netlink dump path res_get_common_dumpit() then hides it from "rdma res"
output whenever the caller does not request driver details.

Only set the mark when the insertion actually succeeded by folding the
mark into the non-failure branch.

Fixes: e18fa0bbcedf8 ("RDMA/core: Add an option to display driver-specific QPs in the rdmatool")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916073042.1746-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index f89a81dad72fa..a8b838fdc7b5c 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -250,8 +250,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 		ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
 		if (ret)
 			res->id = 0;
-
-		if (qp->qp_type >= IB_QPT_DRIVER)
+		else if (qp->qp_type >= IB_QPT_DRIVER)
 			xa_set_mark(&rt->xa, res->id, RESTRACK_DD);
 	} else if (res->type == RDMA_RESTRACK_COUNTER) {
 		/* Special case to ensure that cntn points to right counter */
-- 
2.53.0



