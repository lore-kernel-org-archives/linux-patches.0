Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040430;
	b=G2ZDePzsD6Gr0CAytm2qn+nnfORJusJIJmUbTiVoN4ZRqtIQUdbMj+x6rzEqxQcqtyXe
	 khAyeGv/LAjDO2QYoNOCM8MX6gls2G7UTpc0QvMrSk7d1GCO+EffCBLfcjveucLywaVhv
	 Rc6HLgbrTMEr8JtU9t1hSRWMFz3BCc5pm2UHHxL/RB2M/a/3OG4FN8pIyP9Kpq4vIPibd
	 hsQVIWr1vikHncWi2drxx8CcqA8Hgf7nztw6B43ozh7ZnI6U2SwdMO88+F6KMB7aLjymK
	 LOfImI8QYTcsFEpZNPP+sQ5TU3ICfL7onMQbFdpGb1oLsHkQmxFjrlq0bAq2lCUkLOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7y57aRAK7yFWdrvDIQEOrErd5U7sfXVfsSA5moq1m9U=;
	b=4+lgxw1VBi9V/O98nGqWmNoYmj164tdGHB8iCQbwJmP3lWR7mtzt2A15xsyAVL6Azq8b
	 29jdMzt7d+kb2Oyp0egTuHOU8uAw8EBPNrRZdlhX6ZPobLxtHXFtj/nUZifQl9wouiT/B
	 0Q1NgIlXWzbzYhTpKWzDQYxvxdl2biVbNxJkYzMtDmG0Bm/IOZDdjHZwl/S7iQhn4AycC
	 A4BaVooIM7eYsIjdn0an/RWrugzU3q/6tvIIGkGgl1D5EHimVZ6AkMZf1yLfwUzF29Eyt
	 ohQp1rw7Fz0J13llQlCiqLxV2H6sJpJFMXRTmbt2KghHVFqiMHT5ontLw42FQ5hTOTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkSX2mHx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335E6606A31C;
	Wed, 18 Nov 2026 22:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SkSX2mHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A90B1F000C4;
	Wed, 18 Nov 2026 22:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040430;
	bh=7y57aRAK7yFWdrvDIQEOrErd5U7sfXVfsSA5moq1m9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkSX2mHxoWFFsCahk+LbY2FQFBtYtZtztKGItGZhcdsw7aI50YVRpBYzN1py8I1oI
	 ekYlTHiFbEzRlI9aHKjgEEk5a+VxHON9Oy+xVWeeJrq2apNXB6k2X6rp3kw/Bkyexa
	 FEiEmHSnWqVspRW97XCms7yDd+F/QLGEXGZle15A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2447/3318] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150434.854015258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 81551ece0864c346080d241719d458c93f0e7fc9 ]

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index db5571af5c759..1c20e964b0fe2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2628,8 +2628,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.53.0



