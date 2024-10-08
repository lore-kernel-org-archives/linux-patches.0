Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE6A1DFD8F;
	Tue,  8 Oct 2024 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394196; cv=none; b=HbHhWrDFAvHJCCHzGoR6yQi7R5OlzHR+31iCx5/3YxU6DKfw32HEn9iTeVhiPwmLAg7PJUgpJx9goqeE9/ux5kGEbEwltcaaFKQKUmXTnEh0fAIh90idCKwSf157TUxvbfMlq9tr5G/zQ5oyzsPwQ6HLSDzZZ0HGN+sGhTXN2b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394196; c=relaxed/simple;
	bh=fsD0qSSNyGCxd5++lvzP4/dO6Q81tesaQ1tF+LdtI00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxAR4yovg6pm0mRDI66qunk9oh1mli29bz/3pXX374LKY5nnfw0VGBRbZyOdas9Ag+V9XvSlaG18jb/LHGCERGSzRxR7saWx0rkXX92VImn3NC5x3pDvynNPTuKk2KaCEueys1+YOKz2AwomTgFhn49n5T0+HDjxwO2yXO0jtmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tpuh6zCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tpuh6zCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6615BC4CECF;
	Tue,  8 Oct 2024 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394195;
	bh=fsD0qSSNyGCxd5++lvzP4/dO6Q81tesaQ1tF+LdtI00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tpuh6zChd1MG9s/PLK05wTcX3vM5m+naI9DjCOOw5xlOcmwiUDZnIMvairgAn1omz
	 VIxYMR2ck0tT8L2sWu1bg/3giBtBiqmO6eVuULk5QcQ7yxasGhMkmRwKxISHUiZ1EX
	 C6Av5/tJ6fHCzQd5Z68N5YBfj8VT80RhuWrDVQ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 376/386] null_blk: Remove usage of the deprecated ida_simple_xx() API
Date: Tue,  8 Oct 2024 14:10:21 +0200
Message-ID: <20241008115644.187675092@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 95931a245b44ee04f3359ec432e73614d44d8b38 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/bf257b1078475a415cdc3344c6a750842946e367.1705222845.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 95931a245b44ee04f3359ec432e73614d44d8b38)
[Harshit: backport to 6.6.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1819,7 +1819,7 @@ static void null_del_dev(struct nullb *n
 
 	dev = nullb->dev;
 
-	ida_simple_remove(&nullb_indexes, nullb->index);
+	ida_free(&nullb_indexes, nullb->index);
 
 	list_del_init(&nullb->list);
 
@@ -2154,7 +2154,7 @@ static int null_add_dev(struct nullb_dev
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
 
 	mutex_lock(&lock);
-	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
+	rv = ida_alloc(&nullb_indexes, GFP_KERNEL);
 	if (rv < 0) {
 		mutex_unlock(&lock);
 		goto out_cleanup_zone;


