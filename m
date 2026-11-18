Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056391;
	b=YVWkLXnFvRKYWPGsMEX2xDwa7g/Ay/WjMZGr0z20F79cHx+saQoI5FkBZMBYi5v+njZh
	 MrhliazAP4gi7bDt//0/dP5vmBeHJpyf7kTFXtZwdjFd59DrjLrssEfyTcB/Qk9NtkF9A
	 cpSQKFExBpPtiLbs+yeCum3Uqk0zx1IQOymXIJ3V2vY1s/IdG3t8ZGjIoiPFBRC7c1lTq
	 KH0IThCaplh5CLFKmHwWN+HRSgftu5+59Yr6PBtEjuO5f6ny4LTu/QtowF4wER92D0wSM
	 srgiNv2+iFXxifEWotALXOzH9TTYqxwzRBrdsCM8MHLGIVqiA+GpTsdzHoVVJmSyMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAtUvE7j3DOIW8j3VQgPBp5w1ssVpy1xwCsekYlGX5U=;
	b=cMeVZMoMSAffJWhgOBRLX0TainokL01PKj3Ko1H6S1FYCs9VN2w9Mk9GBWWJJ4k/nhHq
	 T9XiBKjOmsyUgFpdM1ul2QrWBtVUH6GTGYiB+ZOoVcXxuYwlhLpg0u0fZpLi8q7EI3pjZ
	 Mka8cwxP4YgeQ05sqV0nzZpmXd4TyQ9sKUxjM15dOCaP7IlfaALCmNfOlrEA2QJyXYfWv
	 fSveE1GVgx2hGw+ItxF9IBn0t7K9PteeEdCIPZw2lKkqQy1ZURURbo/Xz/oV3Z0tGvqRZ
	 FtcZ/RIFkEctikv0PXOGF3QEoOnAYpx2iYCVBrq8ZW5qw69HPQzWQ82gGMJeCk5cv4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+1+tKZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A440606A320;
	Thu, 19 Nov 2026 02:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+1+tKZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686261F000C4;
	Thu, 19 Nov 2026 02:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056391;
	bh=AAtUvE7j3DOIW8j3VQgPBp5w1ssVpy1xwCsekYlGX5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+1+tKZ5IDmtYnphzJDCAHhgCq8a55Eu/2AWeXUQI2wL9vdzPHi2UkRMJsJNBDMPM
	 ZOW7BhLXvCYZcLUtSoHwgHFEcgdgyqzIYBNHnMVP/+VQ1Buh+EziDrlKezsZ/pSNg0
	 eB5K2DXbfhU3vK090uXzCQR2tK0rgrgnu9sX0490=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1971/2214] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150129.762463119@linuxfoundation.org>
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
index 6e4c68a32e522..8282f8efd57e3 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -205,6 +205,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



