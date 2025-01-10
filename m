Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9382080F9
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548624; cv=none; b=jixWu7dxkZC3qQDmOm8wy3G8t9YGnS/+HpDAyJsa7ayFZ4RUxxRMxTYdpbY66VWpHasqI3oN0JCg4nBqK7Pwyab3qYtOzM8forhURV28tf8WNGzTMIolwDw5EEMdT2e+cBazlr1znspEw29PwKkkAiM0UcmPDBW22HmQ3JkpY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548624; c=relaxed/simple;
	bh=LUxzOfye5x4+wKTe4Y5fcv7stlpWOTaOzJfwW5wdOQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VeS+eR20Ze4e8lnFGi+4/40Io50kDwnKgKaIyAhoE/FLHapz3DGi1BMgF11lflA5DfAxhlq2pcYwlvTfHOW6NTNUPmWvUx2NQ3E4uCxPQrsNFAlGiPtotxggCn3/wh8RONSO2M4rYoxk3EXnezzGFSLUBVSOF4lbUPXxp8GYxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=cnTjW6CE; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=RA618kf+; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="cnTjW6CE";
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="RA618kf+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=atmark-techno.com;
	s=gw2_bookworm; t=1736548621;
	bh=LUxzOfye5x4+wKTe4Y5fcv7stlpWOTaOzJfwW5wdOQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnTjW6CER/q3abT446Xw9feT9eTPt6hDxrArqCLayNFa8PZ70cOzutq39wjDgwM+H
	 6ct70ImWky78P0bcNbt2vTDkLrqWSdS4ppx96UtOvQNWhn3hH8bTMGY1PNaiU/hfMO
	 iL+z8rCyYIocpyfXh5EBkdc1r7RKqKt+AiLFwYOmsZIs69o+DA84xShZ7xZfRRuaie
	 simaOQr0A6DQLTJhHmxyt1RS52SqklWXDiJlIlWFPBOU6TVW1GMO5TLdJfQQ6CZCdi
	 tHh8DAfCJQ2bISnk8Aj2fZkseOobP9c+jWYV73S7CjYH7V/5HUQG0MkIrI65CGJDi7
	 Ebcp7gabMaytw==
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
	by gw2.atmark-techno.com (Postfix) with ESMTP id 9147931A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:37:01 +0900 (JST)
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=RA618kf+;
	dkim-atps=neutral
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 7363731A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:37:01 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-21648ddd461so49372865ad.0
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 14:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736548620; x=1737153420; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvgg6kua1P9/v2m+A88TQ+0zCQUUbkXF3mftz77zLjs=;
        b=RA618kf+H01R/bozz5HFs5GVlpFyX8/wbsvJ/n7kUaTQTCBgTmRg3ECVrhHnVvgGgr
         UJo7GqA8EoxuD8aJPXCVwWS9fcyyo8G8Brh3cUWxs7RU29++s3kb3alVjois4U3u1KWE
         4vsLlBIncCQfJc51mtzrm1f2jp1dgmZp8E7bS5cLv/iohJMAcxZ5HKvmw2Ki8uxezgGd
         buOLThdytmK6pc6qzchFUzWXqtO8RTXe8NJc/8pK2rTqFsaFAY3SQUeoVk+CKWuSgOKj
         9VMLm8FR1Y9vZiwKwTeO4t2IyhztC+1IuF7JRQVhaUsDw1JqdZzE2uX8FeReoMESnlas
         JjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548620; x=1737153420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvgg6kua1P9/v2m+A88TQ+0zCQUUbkXF3mftz77zLjs=;
        b=k0SKVU3LnUxx4CUhTncnsox5ZgfCk0nQZ9gx/mGkZNvkgn2LsUFuUnaKnx43jytEbu
         LEB+bH9M9CjnkGgdIc4cG/iAyXeMGTTrMJh/RjK3ywPDykkItNlOxr4iP7utnsDf97BJ
         ATZk98kqfu+L1ISgW30YW2mMngZAjzkD7u66PeMhNpN2+nMkfyRYtHeSY86BQRoCC6K+
         32iYUiUHIf2qIgctxVDGxDZ95yM/OL0hloVrzE1/1eJXE/JJgtpAb7LKk7qA4JfWxC2e
         Pkil/aRz/kafpW2Lqs5ze/mTh9r8Wy/YzyJk+EkImcvhhl9Z/wcyX3QpiGy7wM1evyE9
         F9vw==
X-Forwarded-Encrypted: i=1; AJvYcCVxvlV+5GxSOMfQtkIlp5YSQNyBR5tasDEv19/vaRpocN38bp/DlVhtuExCWksUlEzYLV+YYfzJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwrxxdSouH/MSDXetPorkvyOmvZ7tUIOSJHBas+NBChh44fWoPF
	0kr4446+NDqQooPHaCOktR5vUoaanuWawl8BHCvcYw/TguqsazernNPRcHS7Jxbkoq8YMLaAgyv
	fDxUOvi5SJ8rv+ozq880ato3Q9uPOfXfMvoseE55oXOb/7bBGeJznMUEx
X-Gm-Gg: ASbGncsB0iBOLM0hg22/Crk1xQEn/5s6QkiRWUtoTPTAti6LF9Vp06qknhGitcbuTr2
	tPWmfpsYp6a1IKOmFrWGVz4x0qNDa5yAZ7CyOrEPaKaQkIr4uKDJSZY9XoS8t04B6qCXbWXSYA1
	K4mfoCNlyKvaP9B1RxSXmayQeQNtvZzUYEPhpyRpHp0YXI1OOdXuxlGXqXTt6sP1FavjkZPwo9X
	HnO967RB8T5gDolgLpoYD4+KMjHs0H2+fxtgtfe0xZDq+Z3Ga3VtLljzVB5+4VFZmt6Ihqx10L4
	Hs6tz1ppUErQGPhdxzCOZoYdooRpQ8z8sULBCxWH
X-Received: by 2002:a17:903:2451:b0:215:b74c:d7ad with SMTP id d9443c01a7336-21a83fc389cmr162419825ad.36.1736495938930;
        Thu, 09 Jan 2025 23:58:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFg7Gtw4+nNFW63rrEUhcY+NXQezUOEG7/RFzXqlN5bHknlqW0CU5RJ/lr3mFFQuF1ETMLkmg==
X-Received: by 2002:a17:903:2451:b0:215:b74c:d7ad with SMTP id d9443c01a7336-21a83fc389cmr162419585ad.36.1736495938615;
        Thu, 09 Jan 2025 23:58:58 -0800 (PST)
Received: from localhost (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219e38sm8884685ad.136.2025.01.09.23.58.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2025 23:58:58 -0800 (PST)
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 3/3] zram: fix uninitialized ZRAM not releasing backing device
Date: Fri, 10 Jan 2025 16:58:44 +0900
Message-Id: <20250110075844.1173719-4-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>
References: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]

Setting backing device is done before ZRAM initialization.  If we set the
backing device, then remove the ZRAM module without initializing the
device, the backing device reference will be leaked and the device will be
hold forever.

Fix this by always reset the ZRAM fully on rmmod or reset store.

Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
 drivers/block/zram/zram_drv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e5626303c8ff..4e008cd0ef65 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1150,12 +1150,16 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 	size_t num_pages = disksize >> PAGE_SHIFT;
 	size_t index;
 
+	if (!zram->table)
+		return;
+
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
 		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
+	zram->table = NULL;
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -1699,11 +1703,6 @@ static void zram_reset_device(struct zram *zram)
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
-- 
2.39.5


