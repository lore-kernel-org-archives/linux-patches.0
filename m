Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14451373BE6;
	Sat, 12 Sep 2026 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201888; cv=none; b=lJqEoNZhd3/etsjayUOEdwIIXEDdwopp56t25IzE+q8ZFExcbM4coC8VOJkR4XvLONOJgqX/jKi5uxfhhD2mhFTTBq49hWLSc4DerTsdgMhNK1j86OnML6GskQ94sp7xNsUJLS6No75qEkHg+bXxcEpRm0ANXgW6qMchlq1UFao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201888; c=relaxed/simple;
	bh=XBFHYJvNg2X4Iez4pgNEHvI7LXoOSWGB4vaUxqUAa8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDdwB7JKz0ug8WqFgVE09OB1iI42hkujDBhgxuv9i51o+Epw35Yro7CFWRtjB0WrO8raNKcyHnC0ruFO+QE7SpjMlDYG9C7l90t7G6oR++f+9NHh9ZvkJu61gW7xJxbw8v8lbHScsewTl74uVVlMbBAHDE2i7MQRUtm1xtqyFYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epIDdoNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epIDdoNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C308F1F000FF;
	Sat, 12 Sep 2026 08:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201887;
	bh=DjlG6fduqDUPQYDKEyr18VEmvPJ4qNzrXB/3KZjVoHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epIDdoNqzwd0rwNeHXaeIi94r0AwRy8FZ0oLkXQxJaW1jL7aYS4idSLu+Ek7eBhjp
	 BCzxDwLwOP+f/G5DqdIcuiwkllNnWUjd/YAhU23TWnNfoux1kHoD7Nq/3Gil6pwP46
	 fjdlr6TNKpmoZUWXWm5u4aNxpkDorD9uQ5KonVtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1052/1815] block: lift BIP_CHECK_FLAGS to include/linux/bio-integrity.h
Date: Sat, 12 Sep 2026 08:46:42 +0200
Message-ID: <20260912065713.714554942@linuxfoundation.org>
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

[ Upstream commit 738f01912a1ad68c81a6aed06cac94e09b5f609d ]

To allow for users outside of bio-integrity-auto.c.  Also add a little
comment explaining it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://patch.msgid.link/20260804123928.736596-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3bf9a21e7bcc ("block: handle nogenerate/noverify properly in fs-integrity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity-auto.c    | 2 --
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 43ac9f338183f..9456dcffd17a6 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -44,8 +44,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	bio_endio(bio);
 }
 
-#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-
 /**
  * __bio_integrity_endio - Integrity I/O completion function
  * @bio:	Protected bio
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index c3dda32fd8030..0ea2a8bf7efb7 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -17,6 +17,9 @@ enum bip_flags {
 	BIP_MEMPOOL		= 1 << 15, /* buffer backed by mempool */
 };
 
+/* flags that require generate/verify action. */
+#define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
+
 struct bio_integrity_payload {
 	struct bvec_iter	bip_iter;
 
-- 
2.53.0



