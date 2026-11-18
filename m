Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050506;
	b=A6FESNw5TGqCv8kzpTpfu34VgH/RVVIy8auvMw79pcThhzTrtCxhi9Rj/0q/6rYxmzCj
	 jIbWjYl6EllpDAPgau0l8CJFHTgy1BGuAOqz3rBsBJZAgvK5y3d3/yuS5VVjXRGiI93f1
	 wgFMOsC/xVPvzDfDf3qcQseISBS9+pRs9wCBCJ5zTL+N5OGq6K2hwP4IgdelMdJXCl6Zq
	 7Re17W9ILZ8pzgbjxQVocpEgT3fJzZlRTjjVdhKs5vGisNPVKZJvFa+T0+A74TESBgDYY
	 ZECAmHo6MzFF3UqfvzRd4jzq+7up29outVMmKpjdS59WjTVYpUCRi0Kjzlto/YVMvjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gB1Yhd2MHcCGHIK5G4WjtBUHx6p3PIpO5/si6o+/VXM=;
	b=DVHqiiXRNzZbkWiUZ1f2TxFCc5BrEq7ltEBJgvbKw0eMpy3KydEPJ/ip5+t3aL0Zyqy8
	 O8iOcGAJGUFkyRtqXrWGbBQbyvCI4MoGk0d+OiSsubKP6wfJW/6cCm/DPWZNpOyfg2vJw
	 qK5Aau9tpJN1TvPzydbk73SeNas8WAel4J8TLu+9ZyfuGbQqNwK3epzp3H8F71UOvPau9
	 4SxjQRYsdVO/nEi9D4TOpwgN0eVeVxjv73nxxW7aFqjorYURTPagYoq30ElVhM01w/YZK
	 nnWNs06OI0bbz6MmTvfiTCLO5XrMICSn30Dy5HSvmgNjGHd64ku4HZePOo9jdrrYBMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tb2KFLr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AFC606A32A;
	Thu, 19 Nov 2026 01:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tb2KFLr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0056D1F000C4;
	Thu, 19 Nov 2026 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050506;
	bh=gB1Yhd2MHcCGHIK5G4WjtBUHx6p3PIpO5/si6o+/VXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tb2KFLr2gnxp5jCZRUkmz8/VKK2TQnzU635Co12qGr2oZIc1eppCgoBUUJl13ajpe
	 hIQLphuKXoGu+KuelYVRogP0KVjA9bpqv3zQRY5bsEMKRBzE+vZFGWhop9X+4jHE9q
	 EKrQa4t09MTuj5dS3leJPwPj6twp2sk4I8drgJGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2732/2857] block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV
Date: Wed, 18 Nov 2026 16:02:46 +0100
Message-ID: <20261118150339.997047465@linuxfoundation.org>
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

From: TJ Adams <tadamsjr@google.com>

[ Upstream commit 82e72ea18d0af724914c31a1f274c1aef452aad0 ]

When a passthrough request uses transfer direction SG_DXFER_TO_FROM_DEV,
bio_copy_user_iov() sets up a temporary iterator iter2 with
data_source = ITER_SOURCE to copy user data into the bio pages before
execution.

bio_copy_from_iter(bio, &iter2) copies the data and advances iter2, but
the original iter is never advanced. Consequently, iov_iter_count(&i)
remains non-zero in the caller loop in blk_rq_map_user_iov():

	i = *iter;
	do {
		if (copy)
			ret = bio_copy_user_iov(rq, map_data, &i, gfp_mask);
...
	} while (iov_iter_count(&i));

Because i is never advanced, blk_rq_map_user_iov() loops indefinitely,
continually allocating bios and consuming map_data pages until it
exhausts pages and fails with -EINVAL.

Fix this by calling iov_iter_advance(iter, bio->bi_iter.bi_size) in the
map_data && map_data->from_user branch after bio_copy_from_iter().

Fixes: 13f3956eb568 ("block: Fix WARNING in _copy_from_iter")
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Assisted-by: LLM
Acked-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://patch.msgid.link/20260929160813.1599129-1-tadamsjr@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index a2fa387560375..e9321fbfbecac 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -216,6 +216,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 		ret = bio_copy_from_iter(bio, &iter2);
 		if (ret)
 			goto cleanup;
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
 	} else {
 		if (bmd->is_our_pages)
 			zero_fill_bio(bio);
-- 
2.53.0



