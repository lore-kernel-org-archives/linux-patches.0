Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F92F5A10;
	Tue, 11 Nov 2025 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825393; cv=none; b=nvQ5CTlOelPb9V3u3MzEgYUw6pbXFz4/zORwRVu1CxLHAKrAAefrX679QX3G2nGddY9goMbmKGGOYdgVKKKX3ykhU+f6moJbx9trbigR6WjVCE+BgKr5hy4se+JQsowmuypYHnMM29DHSqXTQ/J+Ts8vfMxubxgmgQO1pjgywXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825393; c=relaxed/simple;
	bh=qO/cQsTqArRwvyNo1CWSPoKh0eLARbE3FuPt5sI0mM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUyWmuPOb2evNA/o2r1KChUREe6UPe6oo5kYDVbVB2Qeg4X3E42NRM4xVBW06B3Wp9twQ7DvLWvF6hVT0aezw9ibCfLiceyTeyXpWQ5xrmPwNWDbkwdBd740Uv8OA+sUK9slzYZsqIWOKQd7uld3xzZ/LAfv+PVJ+Z2LMs32Ybo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOWbOqy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOWbOqy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A33C4CEFB;
	Tue, 11 Nov 2025 01:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825393;
	bh=qO/cQsTqArRwvyNo1CWSPoKh0eLARbE3FuPt5sI0mM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOWbOqy3Z5xJcVKl2IOGLX1tHwK7UdyxC+wynEVaG2RQNvhn7AGA6kxzZwX189WYl
	 n8lDBK5v0PK3W3qWxO7yl222q78iqNK85EpbyyvSI1rMoXJzxk+RFd73czyb2uwB/E
	 R/5Ky3TS86u3Dz/RE5W/WYu3cH2vI7PgC1he+ZgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	Gautam R A <gautam-r.a@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 783/849] bnxt_en: Fix null pointer dereference in bnxt_bs_trace_check_wrap()
Date: Tue, 11 Nov 2025 09:45:53 +0900
Message-ID: <20251111004555.364110417@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam R A <gautam-r.a@broadcom.com>

[ Upstream commit ff02be05f78399c766be68ab0b2285ff90b2aaa8 ]

With older FW, we may get the ASYNC_EVENT_CMPL_EVENT_ID_DBG_BUF_PRODUCER
for FW trace data type that has not been initialized.  This will result
in a crash in bnxt_bs_trace_type_wrap().  Add a guard to check for a
valid magic_byte pointer before proceeding.

Fixes: 84fcd9449fd7 ("bnxt_en: Manage the FW trace context memory")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Gautam R A <gautam-r.a@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2317172166c7d..6b751eb29c2d4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2148,7 +2148,7 @@ struct bnxt_bs_trace_info {
 static inline void bnxt_bs_trace_check_wrap(struct bnxt_bs_trace_info *bs_trace,
 					    u32 offset)
 {
-	if (!bs_trace->wrapped &&
+	if (!bs_trace->wrapped && bs_trace->magic_byte &&
 	    *bs_trace->magic_byte != BNXT_TRACE_BUF_MAGIC_BYTE)
 		bs_trace->wrapped = 1;
 	bs_trace->last_offset = offset;
-- 
2.51.0



