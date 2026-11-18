Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028294;
	b=W7CLIaERTtLXrxMcYFSnSDeZTcdS2J9LYyjst/YKnDamIGuY7x+tFUxfKqPdfPCG4r3U
	 qU//Z/W5L0gtUV2aj8V3rdS7+maOADSshil68giKG3Pm//tFBUgkYytwWcozCQR+6GYld
	 KmHIPwrQW49NGSzsvYwQHW/CwC0aqdzWpKSwBSoZFNCS1zDIHuVRfLQvY056n+CibrfUQ
	 r1stXyBIq8naXKbrPz4iGzJ5dheN/DynPk1R/2cU4IFpDH90VR4d+K7dFmZ+S7bB1+loD
	 8TSBYnfYuG72ZArMwOrnOVjBLXhf/wt1aWZ79nVX3h7E68402jwlL3PWkikyNov1sgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8j0ObH/UCqTtYTJI/1GrEXs8+V1OmrZYW/B77kCa+sg=;
	b=aMPNOdEdZHT4VeCu2CWW1sxEM+7uVbRLPDFVwhtKwmF818HJW76vxR+kbV9QvLFLJXqy
	 egR+eRg5IrkjETmlgcSVrl19GqUZpFT0+FAQpsGQGdk3+1JYO/8AT3VRFnTVAPEdAB3ur
	 bKM/yrtN8YNsayrSrEPe11x2ZaxU7wnvcw1NkAMwANdCnZmN1cKchCITH8wt2sYkzIRQ2
	 9OFIx2oJgCGDvcEJQ1Rf1wkWtwI291efaiH/okAt9CQjDgnT5y+dSxNSC+aczWvxz3m0I
	 Ne2DwXlSiB9nTdRW5Uka4QnmZHkx0ifVUe6kWWrApKBB65s5v4/Lz0wbZCx6B0mntcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3zIg4YX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679E606A325;
	Wed, 18 Nov 2026 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3zIg4YX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D7B1F000C5;
	Wed, 18 Nov 2026 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028294;
	bh=8j0ObH/UCqTtYTJI/1GrEXs8+V1OmrZYW/B77kCa+sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3zIg4YXkkNiqewpHEKFY3LSSuFfxHfnXU9WojiRfdCsCjNWrXtNpJKmT7ML4c2q2
	 TPwtwgOPiZnlYLgsrSlJMuuEZE8h2DEpfLo7mMv66+j95u46Jdl/GPUD/UQRg9Y59X
	 KrKuO76qr9Q9I0Z0tIaXkvxaEVbbMczZcKH5TkYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2042/2151] blk-throttle: pass the I/O counts of a dead group on
Date: Wed, 18 Nov 2026 16:02:57 +0100
Message-ID: <20261118150236.112844877@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 587edb931fdda032bcd63fdfb0db4ded75159ee9 ]

The recursive io_service_bytes and io_serviced files sum up the online
groups plus what dead descendants left in aux_cnt. That worked while the
counters lived in the blkg. Since commit 7ca464383aec they're in the
throtl_grp and nobody passes them up, so the files go backwards when a
child is removed. Add them to the parent in throtl_pd_offline().

Fixes: 7ca464383aec ("blk-throtl: stop using blkg->stat_bytes and ->stat_ios")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-26-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 03c3bfc165161..43d33adf21d69 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1676,7 +1676,18 @@ static void tg_flush_bios(struct throtl_grp *tg)
 
 static void throtl_pd_offline(struct blkg_policy_data *pd)
 {
-	tg_flush_bios(pd_to_tg(pd));
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct throtl_grp *parent = blkg_to_tg(tg_to_blkg(tg)->parent);
+
+	tg_flush_bios(tg);
+
+	/* the recursive files of the ancestors go on counting what it did */
+	if (parent) {
+		blkg_rwstat_add_aux(&parent->stat_bytes, &tg->stat_bytes);
+		blkg_rwstat_add_aux(&parent->stat_ios, &tg->stat_ios);
+		blkg_rwstat_reset(&tg->stat_bytes);
+		blkg_rwstat_reset(&tg->stat_ios);
+	}
 }
 
 struct blkcg_policy blkcg_policy_throtl = {
-- 
2.53.0



