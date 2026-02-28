Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EC5377031
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301633; cv=none; b=a5GcC8us0YngeS4GNlPwLzop7MZ+Dk8PtJB4LFLVa9BFBlznHWZca/jHe5V+Cq2xnEG5yJAV5PO9jIHt/EkT9PhkPcWeiql+YGKziQsy7FDS8kgoQ+mBoFkMKdaHpIjM++Z+5z/QM7UsjOXh9aQcI3wCkeGEQ7EX7ypVCsqod0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301633; c=relaxed/simple;
	bh=2/ObjYxlJfK7ml+w3G+Sn8zUsfj5cKOo1KBq9mdBTgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzrgaWHrci22uuwtm8wbhoLKCiQufteEpKqSocH/Zc9zwvcsOMs9DOBuaEunCpfz/wXvE+U6+Ktbtz0zZCZ4JadmUECaPUXUeFkaZDSEWuzO2UUqf6bwyI4AFWXohpY8h/C3CRL5SHYY3uiCQlPeegZ5pzqjfd/LnSZdi9J7jsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZcCTgyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZcCTgyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B358C19424;
	Sat, 28 Feb 2026 18:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301633;
	bh=2/ObjYxlJfK7ml+w3G+Sn8zUsfj5cKOo1KBq9mdBTgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZcCTgyTkc0eqqOoy6QLwlj7iRQRzRXPVZyk2ru3XUYzwcfgmftBHMpiuhpEBs82x
	 7A2i0N+BJ28fFz/78s4+9dxiLwxGBLSSsKQnnnn6iHNGHhnB1YQb860IQ9Tpjhp7j7
	 H1hzKhNZZOileiahrgLIgoeVtAIpaB+xkjo+cURxBCKxXkZWCRFQBDo57CRZYk4JgV
	 xHH0KF3pKebYuYIRqIIek6TfFkiK1eHuukCNE+xZQejjG4HeS1cjwxxyDKtjKbhv8f
	 sluw+S/l29jpvpuBRpHS3kHgeYNZwmJq64zAJ6yM4P+y8thSrWmMLzFAevK9tFzQ6o
	 E6xPztt+XOv2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Jack Wang <jinpu.wang@ionos.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/385] rnbd-srv: use bio_add_virt_nofail
Date: Sat, 28 Feb 2026 12:54:07 -0500
Message-ID: <20260228180011.1568201-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a216081323a1391991c9073fed2459265bfc7f5c ]

Use the bio_add_virt_nofail to add a single kernel virtual address
to a bio as that can't fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250507120451.4000627-10-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 4ac9690d4b94 ("rnbd-srv: Fix server side setting of bi_size for special IOs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 08ce6d96d04cf..dd4d813718fd2 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -147,12 +147,7 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
 
 	bio = bio_alloc(file_bdev(sess_dev->bdev_file), 1,
 			rnbd_to_bio_flags(le32_to_cpu(msg->rw)), GFP_KERNEL);
-	if (bio_add_page(bio, virt_to_page(data), datalen,
-			offset_in_page(data)) != datalen) {
-		rnbd_srv_err_rl(sess_dev, "Failed to map data to bio\n");
-		err = -EINVAL;
-		goto bio_put;
-	}
+	bio_add_virt_nofail(bio, data, datalen);
 
 	bio->bi_opf = rnbd_to_bio_flags(le32_to_cpu(msg->rw));
 	if (bio_has_data(bio) &&
-- 
2.51.0

