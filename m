Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E29381B0F;
	Sat, 12 Sep 2026 08:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201834; cv=none; b=FZRavjCHJJGtNKAtogZUNp8db1X08VV1egezRVeq6gCbMNweJhur+EHUV6ghRDt7h1Nd3rLKkTO6imiSBX0b/lDBP+yEaM2fOx8q9s75q6Hk9+k3tRYXMFMp1Koi542+mk4WdqswMLSRfiD8pKdLP9aWPBGmcrYYzBbS/42FJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201834; c=relaxed/simple;
	bh=UcTOjh+AjOj8mmYhJVycH3k5gNzz1mmXCzsMvqLdQq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMtTj/2oQ+HPQnL87YZbK07sVPdlNTH/ZR9PILEIEhV4KH85SxPJmGSMBaEjUtemu3MKJ6p9iiRvA5HR2rasVbb3lhJbBhbtmVxQVf2UhF19ANJ3bTw3e1+G+Aa30SmFA3OAC4pCEOpEkqCVZOwt8nWJxOPo81iIspYtkT4Ri/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdQKmNfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdQKmNfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF51F000FF;
	Sat, 12 Sep 2026 08:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201833;
	bh=js5Jpho0A3/Q7burOUk5Q+gPRBl20yf0oi52t4T/Sg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdQKmNfxYocgZ9N28yrxKug/DXY6Fh4txwA7T77DBkgMPI9kJDkPNxm+3S+IqAJA6
	 0pjFFC5TKI/yHhOWpeAqQYPX91O7oOsmNPjBCZ+ZQkRQDrZ4oNSaSVVZRFxyGdYdYJ
	 MXvORurl7GUKwgCdXi1LO0RmGkj1x+ZngoWUoPd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1051/1815] block: remove bip_should_check
Date: Sat, 12 Sep 2026 08:46:41 +0200
Message-ID: <20260912065713.690703692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6c13180dba60f835d6909e2a3b4f50862de156c6 ]

There is no benefit in using this helper over the simple flags check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://patch.msgid.link/20260804123928.736596-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3bf9a21e7bcc ("block: handle nogenerate/noverify properly in fs-integrity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity-auto.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index b1c733ecfd2e8..43ac9f338183f 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -45,10 +45,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 }
 
 #define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-static bool bip_should_check(struct bio_integrity_payload *bip)
-{
-	return bip->bip_flags & BIP_CHECK_FLAGS;
-}
 
 /**
  * __bio_integrity_endio - Integrity I/O completion function
@@ -66,7 +62,7 @@ bool __bio_integrity_endio(struct bio *bio)
 		container_of(bip, struct bio_integrity_data, bip);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
-	    bip_should_check(bip)) {
+	    (bip->bip_flags & BIP_CHECK_FLAGS)) {
 		INIT_WORK(&bid->work, bio_integrity_verify_fn);
 		queue_work(kintegrityd_wq, &bid->work);
 		return false;
@@ -99,7 +95,7 @@ void bio_integrity_prep(struct bio *bio, unsigned int action)
 		bio_integrity_setup_default(bio);
 
 	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
+	if (bio_data_dir(bio) == WRITE && (bid->bip.bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 	else
 		bid->saved_bio_iter = bio->bi_iter;
-- 
2.53.0



