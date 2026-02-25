Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FFF24677D;
	Wed, 25 Feb 2026 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983335; cv=none; b=MWHAFgUWMer7MJCEb+faWi/NtBt01aKy/7+RmU9mVR6whX64fDnX+Ylj12fIKPMBt4EN4lzAf3Lk3QXpvwRCyz/gGlrcNVLgP5M/L8+LwrcsbFXAvd4VmcqD4nF4/JjVanc/rpczO09fQ5umSPUsdO0EfF6UdYRRU2VsD3aOoOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983335; c=relaxed/simple;
	bh=TZWMZyqCeDbBoib3+W/eXPGitzlSrz6PWb/dldcbXo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0pf5tkD4aZj+AA5K0ZMHLitnQGNHHPRkq8pP2xmRkYUqx7HF834VTzwFWdQXejV9IraceMHv4W0ZbcTgrwDaUYXVVSUx3J/oYxMF7H2/SAF0wRHdhTZmEiG0BtoMM5YRqhctm7uRYFmOy+LqFV5uhINjQonsNU4q6AHbvH5AJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpUyP0L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpUyP0L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90861C116D0;
	Wed, 25 Feb 2026 01:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983335;
	bh=TZWMZyqCeDbBoib3+W/eXPGitzlSrz6PWb/dldcbXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpUyP0L3B6hVJDKI1T9H0L0KQm5lvQBIWukmbCxRkPjjv85yZcUX5didZJxhSXZRy
	 kmuG7IKQBPL2ji49HZ4sXEiZgFujLbebbNpN7Qxt0uS3mLqpU7ELuT7VkNSEcxjj0O
	 HmncmgTsxmYaMtY6XxiZkYfl9TNmxRoMWkGCD7e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 439/781] RDMA/rtrs: server: remove dead code
Date: Tue, 24 Feb 2026 17:19:08 -0800
Message-ID: <20260225012410.469154881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

[ Upstream commit a3572bdc3a028ca47f77d7166ac95b719cf77d50 ]

As rkey had been initialized to zero, the WARN_ON_ONCE should never been
triggered. Remove it.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20251224023819.138846-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 9ecc6343455d6..7a402eb8e0bf0 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -208,7 +208,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -240,11 +239,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	wr->wr.num_sge	= 1;
 	wr->remote_addr	= le64_to_cpu(id->rd_msg->desc[0].addr);
 	wr->rkey	= le32_to_cpu(id->rd_msg->desc[0].key);
-	if (rkey == 0)
-		rkey = wr->rkey;
-	else
-		/* Only one key is actually used */
-		WARN_ON_ONCE(rkey != wr->rkey);
 
 	wr->wr.opcode = IB_WR_RDMA_WRITE;
 	wr->wr.wr_cqe   = &io_comp_cqe;
@@ -277,7 +271,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0



