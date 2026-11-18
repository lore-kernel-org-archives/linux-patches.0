Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049935;
	b=O3CvjSoh1dwTT6+b2dW6k0Bv6Oit3MaWtGtNb1Z4D86zV8ljlFBl+wsK7gxPWrpwO913
	 L7hOpDTDyezB4Myy0DBau/sHDBgOYvwEQzdTKR+clj+68Csy8WctRqKoNkVaIDyGC60iu
	 H6YSUzaGFNVb1OObx5DPpultt4OyQDrmGUW/1TRyUAohWp2bU5qhllyvxMzcnrUzhmWhV
	 Gs676bFJQamtyl5WjUVKA7NkLvhoqr/2BztSO9+sIcU//SVJQJMthf3oL3bphjCutwdge
	 MYeShahUSFNtak4fGZPXHCjQ1jQVMZPSXeOJQOrJyalR3lEroX4W2LTcnAVUKmM429w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/BCQpm98mS90pPRWTztYoSfxTtVV7cVsV7+nXRMGckw=;
	b=v+7ACZ1ctqq1bNqr0Wvm6NIJvF7qGRm5EhZm1Cild8GYCA/ajot54G5BiQh68qy6Q9HC
	 qqKljdQjLwbv1hqU6hbdhAuc1bbFSSuLjobQRg2AsVDW4PAuwwZGV8UKoIK3n8pKLa8/0
	 u9UGPC/cC2K4tVJ+P8xE/zG4sl05GgsuM/bUWQdP494FklrpIU7/3cZx3bP59fGCJcHrp
	 4+tVv8juv2SLfKowIJPwGzwCyt+6wmhcFpn3M76GmytvwGUlXFn2rCih+Ry78o2gZkTvz
	 0LteQamM2h2dNj6MQz3dmdssfdFcgcb8g0pRNWxC1KBO3crerW7oiuEIYtzFcYfj3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx+JgP6Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9685A606A320;
	Thu, 19 Nov 2026 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx+JgP6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C81F000C4;
	Thu, 19 Nov 2026 00:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049935;
	bh=/BCQpm98mS90pPRWTztYoSfxTtVV7cVsV7+nXRMGckw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx+JgP6QqFZYpxZkDz4xAOIldHZz9sDyjVbCHnEXhDUzXFosyIqydFge6m04lNgAt
	 OHu3U2oTdfxYfLO4y58wxYJmctWUwkG2OpkbK1tJ6Gzb1wOsp1oXeWUYLPxA0UsSAw
	 JP4VQb4V9/9NQJ4Y0YRPoWOeQI6j51F0KW5eWWJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2528/2857] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150332.562148970@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit c887e53e1c852b88bd5442d1bf4717ee3e7aadda ]

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
a caller-supplied opcode and no bounds check. For a user QP the WQE
comes from an mmap'd SQ ring, so wqe->wr.opcode is an
attacker-controlled __u32 read back by the requester
(req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
qp->is_user branch and never runs validate_send_wr(), whose only
opcode check is itself !wr_opcode_mask() (it indexes before it
checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
so an out-of-range opcode reads out of bounds and the result is used
as a mask and dereferenced; observed as a KASAN global-out-of-bounds
"Read of size 4" and a wild-pointer oops.

Return a zero mask for an out-of-range opcode, matching how
validate_send_wr() already treats a zero mask (an invalid WR), so no
path indexes the array out of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261002164552.294749-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index c2a5c8814a48b..ab638db78594b 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -185,6 +185,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



