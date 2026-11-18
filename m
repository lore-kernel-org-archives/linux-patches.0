Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061769;
	b=tLh3P+9DtpGwiq8Jm1XLYpngHsC60A/HcviUbdgOWQGUAPgjJKIUrig/pZzV20GNpQ6V
	 kJFCNT6lAQaqxtjC3FxmKOTTG1MWE2i/hCFEQDxJYl0GhefX7WopZMDx/plJgIZhSvSX1
	 F9lgVMj3IPg8h67QigQ+hHD1zcI/fjifAnuDUTMekrt14pJi7BuDx542O61VFTVJFGFtV
	 1F88X/D8UEPFRtidHSXCO1gW6AkgC5xK+f4LD15G+aAiJemz9sX8jdbjN0wUgkUdtiIwd
	 VpsVvOlRFR5UMvAxfPFJn1gEjatkyfWd7Qtk4oCNPahIhRdGHAf/IEJdGbVyW0aJ3oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0SKswKHh+nYRMNBykFens3fn2AsWnFIgL8TZqaoBe8=;
	b=eQ9jKjTRioU1QrjrauXU3R8yQ24aZ6RgufyeE+QD9HJGhrueyLN118AqG9+z91vgm7IR
	 JgyHoSBIyOzWw7TNndVqSuq3UTQkoF1jB0o2kb/uGlElRjDe4nnMHtME5lu+8pU+EQCoi
	 +0jtYj2Q5zcrKby75RDIK/JVnWdrnNOkek6dnVP7uMxOBSckNGwYGmuD/LJI2VuHBUGzl
	 hubcMGnaiFB/+vTGyhYdOlCAw58nrqAfLJf2YVxZl/eCwr7Tb4scw+tpxFXAbrZrFae5G
	 /LWwKfPRmKL/BaOBYuSEQEMepz+tOBWzz6JR8crChzBO6jJWX/zSGrFSr/cIP3NgUBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljA8f76A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BF1606A337;
	Thu, 19 Nov 2026 04:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljA8f76A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F581F000C4;
	Thu, 19 Nov 2026 04:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061769;
	bh=+0SKswKHh+nYRMNBykFens3fn2AsWnFIgL8TZqaoBe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljA8f76A74txn2fiSLto9dkVJ2dUzAaiox1pTHKzz17CUhIaOeRQHRGGiY0yrRHjE
	 D+IpSo6A3n19E/WfhtnoT6D8H2a5ow1Pq70iDyvEwI0ImfxyxC2xMEUkXdCoP89Mjk
	 KiBx85N4mJKwG1kmXD72FN4cMtKxDXKWKIaV5KWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1670/1848] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Wed, 18 Nov 2026 16:01:48 +0100
Message-ID: <20261118150029.744580709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d758760b9ae7..3c70e054fbe4b 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -213,6 +213,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);
 
 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }
 
-- 
2.53.0



