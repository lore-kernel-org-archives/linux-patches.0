Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8F720A5FC
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 22:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549272; cv=none; b=kP450zQZG/GgE1LBUbFmYCiKdw5fBLtI5LMZMrIu8dO1UEcRng7ep1Esa8Ks+w5ppxcQyhSjiFSoM4tkj9gteRCkeRDowkxC4yvHPcFnsd9ThL2qJKPyz+9UaGJnHF5sTXbHWlTl83YsPF2RdktapvmREf83oTvShKRTbSkftP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549272; c=relaxed/simple;
	bh=RURSYGI9XASBfgKIEyI0b9Kaq4tXDohLi/r41DOBgGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LsZ5vjLylH6T86+4hdl5DMtkHAi8+x0ut8PqHNYyRFX5YQfWFj73ntNwVKxW1kwPGprBRXR7zdA14lZzEX24YRUeMlBNEXH2icAgGGQwBEaj6NriYfbkO+LpYMCmM0Mn2YzptbU4USrgeJM7veOa5cVhgbZNo+VrrtRG0NKSZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=Kschi0Hy; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=C/cAlOX6; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="Kschi0Hy";
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="C/cAlOX6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=atmark-techno.com;
	s=gw2_bookworm; t=1736549269;
	bh=RURSYGI9XASBfgKIEyI0b9Kaq4tXDohLi/r41DOBgGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kschi0HyF4JQ64x+Q3ulYeeGpyViJz0/rmGB0aBZ0Zv1cbwzKv01wFKYa3BFUsC4b
	 ZuzMwgb/40XBM/OyWILPE3leF5Lcjk116RfDWi6McEodB4ohSOPgFPCRcCGzmax3V0
	 4h7rh/9NhelQcH+NT1tTh+5SNEX9MdqLyXHXtSpHluvhn6Xg0xxh579EXQBsSv+syw
	 DvZQq9ajawpJt9z9PX89lK1hRpcwIZZhi+ybwkFhUnjOwIl+qxkYLWy14aPsYxd6v/
	 W4RwLDzQkRt/2N88F75cuuFWSGWqctBHkvoqFxQGDTIsdSrNGGaz0Lsj6JNe4E5hy6
	 P7cOVezPyUg0A==
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
	by gw2.atmark-techno.com (Postfix) with ESMTP id 9488731A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:47:49 +0900 (JST)
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=C/cAlOX6;
	dkim-atps=neutral
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 751E631A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:47:49 +0900 (JST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-467b0b0aed4so52234021cf.2
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 14:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736549268; x=1737154068; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUjvhArvz4Z9lyGZ4erNAYq0JBaJkrgop4tJc4l0rQE=;
        b=C/cAlOX6hbtbAMJM97CCRovDztNvfUQilk8WvIYopehNUKIeMX0VwQX1KiJMMdu6l9
         r6NIVkeI1ZJx6A4CFNWKMgYrmUenEZ7gNM7LSZKy5n1H/Ub8ldhkDbLTId2boi/cwsnl
         pIEjJRd7DGEVgJplUDJiyfGuBYqw/bnXccek8Otf9GOtYQ12XT7u5yvXxAma0PopZm2V
         StkXM+BovtfCwbTpyT+7Rzi+NDdEi7lIO1U5FXvBBxYJYc8v3MUJZTpStNunKVPFQY2y
         9a2QBZi4lm3X6GhOI6x1fTsNKP1cNi9JHHuLeT5C1NH9iHy78F1y81krwwaMOiO4PFjR
         8Gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736549268; x=1737154068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUjvhArvz4Z9lyGZ4erNAYq0JBaJkrgop4tJc4l0rQE=;
        b=UYs7eYFVdczQqWhwln4QYqOZN64GsTcvR5A68/q/PaUxidH4K3IYsNUQdxweioEWNR
         Rs9OiYZ74QfzJ8h85IiwYi5wGh3bGdhuqM8Mzu2Of/WlMZEX9K64wtfXS+dUnuyIuLpv
         ZbjvAomRtvHqEirZjtn3wOBNSlGteqFqheh/cbQCgI0wmV+yJOKwa9aqyAVSYsqz7xsy
         6tS7ZLzdiMKzkm6GMd0TL+vNK4uh/KQhkQwUGWoPGhtuU0scJG7l6sQLoFpS/IeH/SZr
         B5Ip4Kj9H1Wb2AGtMrCh0pWqN58B50GBGNARoW6brYKuQfDJsvFW0yY9f+XUSMAAGQ1B
         ui8g==
X-Forwarded-Encrypted: i=1; AJvYcCUERO9CllIJeO1Qp48JkZvCiPj6FcSZj5ISnvNc9yuJzckMS4uk8ZALRGho5MND5ilDRprth5jW@lists.linux.dev
X-Gm-Message-State: AOJu0YxpZYiM6QScx/WwnspWbNBSozoDEr286jyMwN9aafKDGUUBwwi0
	isQdmw1rQID2EivQzFOGa21IcFeE1bTMB1eo4tvc5mEGbeCuvPK1EoK02bKwuHIlll4hGzcKzuC
	ICDTsL7GMTUWNWA5iKeJyTUDTV+nwp1eH446mORM17nD93Yu7R0aaDCtb
X-Gm-Gg: ASbGncvkJWf0o+5r6stVq6ai40hip+XAUsLcWAuu4IFDGQZo8+OZL58+990bv8rfExz
	CtMPG4+xWPCOvGUBc2cHO0ngXARWqTShti5o9pGk9CFDQWVdtCTvlZd+abSsgVq4HE1ohRCTTVt
	h4zvWjlEXgtFcrif8Fm9W581j6JEP2PdWRdMKHw0KRh8nEqlIK1sAXe6MrybP5bAr0/z/DlRQTW
	Y5lSdqw4FhvW4xayLnf6kr6E95b/FxPxuYkuSZ9F/LV9yNs8SxAdYt7lEWGbXEygmbcZlmSR4pZ
	B2G09dgJarz1/Q+kndv1AteC7iRn7ezwMJGIi13c
X-Received: by 2002:a05:6a00:a8f:b0:725:4615:a778 with SMTP id d2e1a72fcca58-72d21f32481mr13665595b3a.7.1736495933465;
        Thu, 09 Jan 2025 23:58:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6T6qNg7lpXyjmcNpj2ioKSFYp3v2oidclmQlZ4501snSmtGcTcYi78rLFnNvVeI/UJpY3OQ==
X-Received: by 2002:a05:6a00:a8f:b0:725:4615:a778 with SMTP id d2e1a72fcca58-72d21f32481mr13665567b3a.7.1736495933059;
        Thu, 09 Jan 2025 23:58:53 -0800 (PST)
Received: from localhost (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d406a61f7sm1029606b3a.175.2025.01.09.23.58.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2025 23:58:52 -0800 (PST)
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 1/3] drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Fri, 10 Jan 2025 16:58:42 +0900
Message-Id: <20250110075844.1173719-2-dominique.martinet@atmark-techno.com>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 ]

We do all reset operations under write lock, so we don't need to save
->disksize and ->comp to stack variables.  Another thing is that ->comp is
freed during zram reset, but comp pointer is not NULL-ed, so zram keeps
the freed pointer value.

Link: https://lkml.kernel.org/r/20220824035100.971816-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
 drivers/block/zram/zram_drv.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a9f71b27d235..9eed579d02f0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1695,9 +1695,6 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1707,18 +1704,16 @@ static void zram_reset_device(struct zram *zram)
 		return;
 	}
 
-	comp = zram->comp;
-	disksize = zram->disksize;
-	zram->disksize = 0;
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(zram, disksize);
+	zram_meta_free(zram, zram->disksize);
+	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(comp);
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
 	reset_bdev(zram);
 }
 
-- 
2.39.5


