Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062236;
	b=SMkmMhGIBHLnQJfxVwvqlrna6/IpXcRhBfN/HnsrQrO0SVgt6bsZETVLqi3KERFtOZ7P
	 chcoO/CW+PUAQN4j/MZAyooW3g7IWH2QdFKzbq2U0f0O9jaqIyU33Lqt1Yx36nM5C+/u/
	 rSQQQlw5z4rntTjThfX1DKTIHKBTonMK6LuAlu3R7Kl6U8X+gNmuiJkLRo+gkg9Qy6LzY
	 HBbdK8N2g3UCS/Yol+uaUAkltCEoX7RID54eUyqGEcPpv2diFXS8V5Nu2JZDyRqsNfjk7
	 wsaYa28DYsvFnG2N7Us4bt6NSqgNOMb3XYcT08CWUoiFsO9KgTGYqAFmqmV3HAI2Lgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVNcXLSrSvGJOsbcpBgWByH8bVF59nR9b6NIaMtRR8o=;
	b=1V/rUUTC2jPRXdWOctJ/ZP2ZhnLcqXFx8428sqS3JwEfFeCHRsxsbNYJ84Rww3IeN0x7
	 xZfrsDm7+DyRjgUY28qO2h4wCHnBNDA7EE256iNn3Ugs1R79JwOFzmkOprZVXt96gQs11
	 hmAMNTN5Isi9nRx/sdshAZEqpbCHYegZFXSnB1+HF71SqtPk1/QceWT5kmayUSl8RcWWc
	 5aEtY9SkvHfyLs9rzKwOGd50kHGZI+Vvv0fw+xYNu+5Lgu4LkVV7ydtWvsV7zZM8PxwOH
	 aXua2TX2ws8eipB8HdP2M2Sk1Iq+PFvYiphg3n89/odlrSN4SSf6EdC428b17FFzsfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zg/Kf0/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B84606A32A;
	Thu, 19 Nov 2026 04:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zg/Kf0/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE6D1F000C4;
	Thu, 19 Nov 2026 04:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062236;
	bh=zVNcXLSrSvGJOsbcpBgWByH8bVF59nR9b6NIaMtRR8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg/Kf0/oC629tTTM0ggK+afIQsBD3I9ik651fMWnTPs8aobn4PFq9ZduG/FbZyHT/
	 wqwFMIqtEvTWK+cHF9zME1RcUV1Wr+ZH49f0Z4JQA7WRRzocH3kjoxigaMTaNPOZUB
	 vy8LgqFPIrYycpI0fBLRTkvb+bHtUnropD3NPwAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixing Liu <liuyixing1@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 1838/1848] RDMA/hns: Fix some print issues
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150036.538203495@linuxfoundation.org>
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

From: Yixing Liu <liuyixing1@huawei.com>

commit 125073e76ba3c7cdedef0fb538d2f22be1f33f92 upstream.

Remove redundant print and fix a character type mismatch.

Fixes: 0e0ab04b5bbe ("RDMA/hns: Refactor the MTR creation flow")
Link: https://lore.kernel.org/r/1624011020-16992-4-git-send-email-liweihang@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c |    2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1028,7 +1028,7 @@ int hns_roce_mtr_create(struct hns_roce_
 					&buf_page_shift,
 					udata ? user_addr & ~PAGE_MASK : 0);
 	if (buf_page_cnt < 1 || buf_page_shift < HNS_HW_PAGE_SHIFT) {
-		ibdev_err(ibdev, "failed to init mtr cfg, count %d shift %d.\n",
+		ibdev_err(ibdev, "failed to init mtr cfg, count %d shift %u.\n",
 			  buf_page_cnt, buf_page_shift);
 		return -EINVAL;
 	}
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -628,9 +628,7 @@ static int set_kernel_sq_size(struct hns
 
 	if (!cap->max_send_wr || cap->max_send_wr > hr_dev->caps.max_wqes ||
 	    cap->max_send_sge > hr_dev->caps.max_sq_sg) {
-		ibdev_err(ibdev,
-			  "failed to check SQ WR or SGE num, ret = %d.\n",
-			  -EINVAL);
+		ibdev_err(ibdev, "failed to check SQ WR or SGE num.\n");
 		return -EINVAL;
 	}
 


