Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049930;
	b=c0kUntkynjaYbIxhkuO48wQ06mS5OxYH11s+hd6FH6UdwhTcPrNCGN9RmmTc0rzug4Sk
	 twnz1fqYn6CLVUjOujXUnZI/IvPv/AUsNKm1j3rk174P5gBv1A7b9jFXde50n21UlLiT+
	 CbdZ8KHm0jjtYTqYgOEjsdjGfO7eaT0Dou4RBYj7FGXsdDmY3dSZ2fIItAxwxMKczuxMf
	 E5sLgdFu37zCtYUjQL91x4aRI9u0owbxOGNwyS1fRRsMb+S5AI02mLrDbiLc1OzCaE2Eq
	 m5Twaz+t91WFH5y11kgbyOF0o5meuzdJ8p62OJw6szO8aI6UjcTWzxMylg1I7IT9M7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tXg0iptJriSAZ38/XJGWgr5lMQALI7cFydqSHlnonus=;
	b=UOO6A6mZp/saH0UMywAlTq1vi1f1tthXazneGI6g3wlS72LivcfPbOKTYOu47hPax5f0
	 E4LUrrB8cwk7l/4jvE9xSFZXsMDgLK5GHj4T0P5PG4y4btXhUY+/JH5++6ulEhUXpm2C6
	 7HIYckhCPFoofcPLQBEW60AnvoM3IVcq1iAtoPSiNBtS+5yov9fLmEmIJdFL6qa94d/Gj
	 MiF93YOI6FoqtlKcUTxDUJN48vJjj01QgOtUMInd6k2BjaZzVP7uwzFyaw9qtdYLid+PL
	 hBrldXrePs17La0n7bRDYItyUabh0GePw9TQtj79K1IfSu1OFxRsAd0sdq/2U2fmW2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWiNeLGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F1606A325;
	Thu, 19 Nov 2026 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWiNeLGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC7B1F000C4;
	Thu, 19 Nov 2026 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049929;
	bh=tXg0iptJriSAZ38/XJGWgr5lMQALI7cFydqSHlnonus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWiNeLGXTJHGROJVG5sbLe6/FL7RFMw7iHPbdtYbR/kPXl+sHgi8xWp1/UbSrnJaC
	 E8zBlPUKuD941G+5Lt/kxBq4CcLPC/piwGEBVMdpxiPkiJnC1PgqaFtU2UjHA7rRP+
	 BkB67/PjuJV09tlDyYUmAP1YfeVqhl9exHG1GS9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2526/2857] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 15:59:20 +0100
Message-ID: <20261118150332.493378601@linuxfoundation.org>
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

[ Upstream commit 33afe9909f213d8bb8e80f0b93382dde0f56e2c7 ]

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152426.3259522-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 80e2d631fdb24..86f65c17e9b2f 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -570,6 +570,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		pr_warn("%s: mr->lkey = 0x%x not free\n",
-- 
2.53.0



