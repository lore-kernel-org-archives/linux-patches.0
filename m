Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024817;
	b=ThNOzctG7PPJgfmWJRwjXvrcPjWgn2lpNg6vxLPWrytUwi3zUvwjGjeBXqLvrRejQoaM
	 uolQG9cjg9C/loTjAaKoIasbMydiiHeJGRAEy8JX8TRFmxcBJCiou1j7Dk7Ib5Z0kILsP
	 jr86Sn+z1AqadrSPklWNNrBD6mHTIUo2j7+hUKDi5D/K3RShPTn15phmb4fc8yUFKymXb
	 rtYVdepgprneu1N6wYMfodzDn92h/MwkxNDj7QyFeR1CeAMUhbLXI4R4en27wyd7/h8T/
	 6iA/WuwKk8LFz75sm66Ppv7T8wTsJiENRqKvq4yatm/2Ei2CeL0BdJksS0uOQGaHYIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=coWZPiRNLSrXflgGOUFWVbNDRbkUK5ShIIOjy98JiZs=;
	b=EkDNpE+AtpBP5ssHgmT04EbOwK2Z2ZXdUzR0avzAndlW631F6eQMmGePe/BM94pI3Z2H
	 HORXVdU1B0HqGKeXZB3e+MB/RtYgcsBcOO8VsVa5WgaaOQR6wd1+GZYKW3uICVYv3/F0B
	 LB583NJ2+ld2D13w/3oW6Eoazycz0AxJ4FJ/ZY4HUgMQI/VplGIi7NPR7ytACZaaZKIyF
	 gEAtvD6quPUlCWcRVJwu6+3gmFdQ8Koy7azKCvBYjTb9yuOM1kgKGj5D1t7ePPhwmL9Cj
	 XZl15rEtL5yjWMLATRtxdwPHZbMX73JU8yTTOvZoNtROmgymsLLB+MtpQ1/x1KBecZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khoAVu+P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AE3606A334;
	Wed, 18 Nov 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khoAVu+P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720841F000C4;
	Wed, 18 Nov 2026 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024817;
	bh=coWZPiRNLSrXflgGOUFWVbNDRbkUK5ShIIOjy98JiZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khoAVu+PIxwu5oMWRf46VbgW/9+FV26HKTvmkVOEs5SRs1M81Hp96kHfrpF4GAUOI
	 Dk9rTY7vCS5qHayjead7bpCQqc/+RWnu88lf+YKlcl6ky0ND/iACTSSZhM63cLJoGE
	 oFB5m7CtqunKtVOxHGDbuUzOVvcJalrlpxn+0rjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0858/2151] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:43:13 +0100
Message-ID: <20261118150153.487672304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0252cd6711a1a..7c8aad8a12405 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2777,8 +2777,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
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



