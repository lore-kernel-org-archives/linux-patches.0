Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022278;
	b=PGQr7TLn8KairPmrMgH30Ovdy/2ylSdgtBphrJ+20SC41Sk/4UjfMGqa8m2ZnHy+6FDC
	 mZfRqlnrXfIE0YOA/hHS7ZtwNSgM6HxLww6Q+sHXqMB2PjQifBxTINj0+/ZXbbgfw3F9s
	 qtox+a4FABLJ7HlyCO9vHOliV12iUVntawICkTBSWOo2i1dVd6CxLsJLKN9cym5T29K2J
	 1+PO82lbzKVC/QqbF7bHOnYgQlUDbADc6c6dDllnSBVp3iTEdIJip3nrFpwdN2fPzBspW
	 Iac/ZhmVDcmG8Z0au97m4Wzbdr2P8DRydha8K5Na8SRw6QTPaOPxi7niZsQnO+I4wEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jTBK+xt6lYy8a+bcLdfjXp4tXnEkB1u/k0lQCP+zjcI=;
	b=Kycw6uRN8NtxTbGMMBQt0wVvd6pmV/o2Kg0sqwC9kIf5OK+ELmKk1qFDXQYk1vws1QL+
	 eVvxoatThUe3axdjUDg5ulikA2ic/YdDExDbtvPeRGJQubKOmDcg6piihppL1b+BRTu1K
	 1rC33fLPAbr7eQeHetXisMkDiPP6V0j19kRQXHpbduz10NkOZ1TUCkm8JqcrNdFA+3HOs
	 QStd/5UthYHKflO2tgl0VinpzDOOW2+Bxn0r9ZugGrlSS8mqgRzkSMgvYfW/qOgI01k1c
	 esyIYjZXxp2UW8QPaaq/yZedz24t8yYPZhL50LnxxOZBjlTBRVd4Qd68Qpx7DAHWQ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC4ZshaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE67606A31C;
	Wed, 18 Nov 2026 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC4ZshaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF7C1F000C4;
	Wed, 18 Nov 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022278;
	bh=jTBK+xt6lYy8a+bcLdfjXp4tXnEkB1u/k0lQCP+zjcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC4ZshaW2D+MPaFBgeyJvOq3bnV8EppK0GHFbcmAh58tu5vNpMfFP9s/1+ee5/Yag
	 UnK+4lSkCY7jVupoCqtfOW9q+xIqPY9xlPnQjoguYTFRhtGdBK1oS7T/ZAdmMpCPOZ
	 Tq2xGlmvEy/2EvSryNOCCm7bOfj2JVEfZef9Dotk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2605/2651] zloop: remove a duplicate call to zloop_get_block_size
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150418.044036399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0835f4909553e78a97d1ac59ed6eb776b4f78c92 ]

The sequential zone path has two calls to zloop_get_block_size, one
conditional on not having a block size, and one unconditionally.

Remove the latter as the block size only needs to be queried once.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 394dc2408ed73..c61a93b806894 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1173,8 +1173,6 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 			return ret;
 	}
 
-	zloop_get_block_size(zlo, zone);
-
 	mutex_lock(&zone->lock);
 	ret = zloop_update_seq_zone(zlo, zone_no);
 	mutex_unlock(&zone->lock);
-- 
2.53.0



