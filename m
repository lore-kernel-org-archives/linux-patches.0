Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029512;
	b=DfvZOcFlra1YbjSil3j50BA/oPWeDQk4DPNRtUgV7p3KCTxdNe8sC34JwCLuRmTG36/d
	 lH0pPeJV4nTcj1l2KT2tB3qPr9g/NZhOklNKBQ/GxAr41LUhtiBkKSKjlgoU36X2DocRI
	 KbcEXFrrHDFx6cAAFFuJYvUwQuZ2u1C+vTdgo/AF1D6r6Q9JRwOBtmsk2fiNgOSN3mOZd
	 EGeek3vpFGZ1lL5LVGj4qSf7hMkgv8Rjhz2hEQXF0FyW9zBr/IOw8pmeqFwas9s9HPS6B
	 lIjklmnAEE9mEdi/EzvkpvoELbCbVsawbjzottevaOUkEuS2y6mA9aKPMDOB+mi3Xmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DP5VGVlWYm6Bt8vEVURvErm4KVJznyu3HiaGImYWJXA=;
	b=PGY0R2obXwvN5GMlcnelv6pcTCh2PDPUUu4o1WxONni1p4HAf4KHo+AYv3yMvT5GX/xd
	 Nb7Z2w1S8VFTX+2Lw4qCZcxQaX45SzhKs7dRe3PC3JCfpVdNzGJSY5pJbg91ON+mob0ER
	 Xf+JK/6G6CGL7rFQfMNDkUD/8D6g7S3xnLvlIJ8b2SCocqFoMRjbZ1qf+Re2cyBAGGW0w
	 NYe5z3jSwbTKUsObq+OdX2R36aBb/XvkuLkHubhZilTh7abhT36i1xLtF0VUZ+hH4MPCZ
	 cNiZiCxGKFhZgqxqpTdqLpYbi+8cqTpl5+Gxu66rj/ncoEM16EQ9M0SXXcOxqSujItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6vcnQJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04080606A31C;
	Wed, 18 Nov 2026 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6vcnQJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5B81F000C5;
	Wed, 18 Nov 2026 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029511;
	bh=DP5VGVlWYm6Bt8vEVURvErm4KVJznyu3HiaGImYWJXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6vcnQJqq8gmOVE39czSMtyI4Q7i6eK8Cs1b8xoliEFz91AJhBlV08CwnZn6BY8pG
	 Fh7PVuKKRi3JISXyQRdfivM0v9hMdGnCpJH/ZRAUS+ouTqHbMJNAe9MVJrCfX04s4d
	 QO/CdXHe10AXTI0+cleMzh/0PfyeSPLRkv1pwKzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0325/1756] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118150021.216776941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit d937ca39cc44a01ce64865dd25b1e205a05ae3a0 ]

When an SG URB completes with an error, mts_do_sg() calls
mts_transfer_cleanup(), which completes the SCSI command through
scsi_done(). However, the callback continues advancing the scatterlist
and may submit another URB for a command that has already been
completed.

Return immediately after the cleanup so that no further processing is
performed on the completed command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260723195654.152104-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/image/microtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 9f758241d9d37..c1f4eca9ef547 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -495,6 +495,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



