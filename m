Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028415;
	b=Rs64gIwD5CxlBAoz1H8kQcbdO9VrFulXHy0YCCD6JDEfLb/dzRM1mWDjR8DZeTeh6en3
	 qR6YXHyr/bfHogahOL+oo+QpY8RY9prdd9DqzsBT0IA4PFWqVVLQPADzF6ro97+UlVCG9
	 CqGfbNF4ULSXx19H7nWXLFxNj53laLtRZw6iXmpSliNqjZ/f940aiuBe7gWnrfgslGglc
	 fTm0bey/SoJXPq45Wr+PhMk5HOajvTnF55hCOlMEd0mEroBzrwTcvASAmSbUCMSRVcqOc
	 KypobchiHyEFXdN+TqHsTvT8Q9aI0sOqsFmE/kXaoLt1sCZbMzkU3GmHf6yKauy8aKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hx6ip4BPAd6qjYaDy3MS/LYbGrYcMJocVNjrTz3bNUo=;
	b=jeXwc3LIyjE+7RS+tLdgmyimUIsxId4nbMmh3nF+HoF3cyjn5FGVnHdmko4eTSlHFr2z
	 gPaN7u8Z+ItspODbr/YF9/JufsCRwTTpQPwuLCfPZph3o8ALxknixIu3hmKTTjyZtlem2
	 vGXqrtyqtmbIURD0PK8Ae+D09HjMJuYhuk1LeGzdGrBgPLYREcsOT1vIqNwFsDv/n6+UV
	 zalcr57LxqNfIERTr8QG13mlpP3KsHFLZd3bvcbFBSnw/eU9zjMw0OLxl/di4lt1USq/7
	 f3lQeh853VejuMx2GpEEp4Dn+Xw1o5gFZpayDQ0N5eKqNYUFv1w1ICRjLka4wLXiN/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnsSxD5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05178606A31C;
	Wed, 18 Nov 2026 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnsSxD5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537EF1F000C4;
	Wed, 18 Nov 2026 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028414;
	bh=Hx6ip4BPAd6qjYaDy3MS/LYbGrYcMJocVNjrTz3bNUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnsSxD5z62GrpLbOOQGep7Ta2Oc7aNbaLHYM6M8dgt3hkVGg2a7lm20FBnnnXts/G
	 oB7Cg7zUnDVMJ0efhhWpgkeuVlWcvMkQ1AUkWx8qtFJoQeJU5/uL7fvBTFOp1R3tz2
	 zNYqO9NNtUvxpyqihwU9xh8agB7dGcKhBoGwxNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2095/2151] zloop: check that the zone backing file support ->{read,write}_iter
Date: Wed, 18 Nov 2026 16:03:50 +0100
Message-ID: <20261118150238.013680711@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0c10f8a1a7ae1502ea4ea7e13f222df89c28adf4 ]

I/O to backing files requires support for iter based read/write, so check
for that upfront instead of dereferencing a NULL pointer later.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index a485eeb97b379..3f16e10a6bbfe 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -836,6 +836,11 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		return PTR_ERR(zone->file);
 	}
 
+	if (!zone->file->f_op->read_iter || !zone->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
-- 
2.53.0



