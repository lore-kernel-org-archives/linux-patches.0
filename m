Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843DE388E57
	for <patches@lists.linux.dev>; Fri, 29 May 2026 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780095513; cv=none; b=tOwjFqrl3zUiaLSHay/CBzmFZsQ5PGxn3IXvBoxtS+NjGfO2npUWZh3Vi2af38xMD0e/VjA3QdXtZai759cvGt/dU963y7zjH11T6VGmM7/TCzrMMGh4NqXhaifzKrY/yGAauR12f8Kvy8b5aDA0MA3oC7k54qva2Ea6cQ3IWOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780095513; c=relaxed/simple;
	bh=ptw36ihhOIzTsxqr1eMO0bzZoqrv11FTm8UZmCwLNM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cTPE1BJ64KHkNvK1DtYY4cKGow1e8h/TH4HqMGQt+evvWSo5CWARzEudbZVTleQqgrKFb0lJjNxj2DUW8YUzOQwjCuudRwMplDY/I8A/ZAvkzF8XwP+OXzLnQhWd3+kdp3w/tWp2ZB4PQE9+KwCodNBEXJCa60oOd4SDjFolD08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ob7Aso3f; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ob7Aso3f"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ed18d8a1bso2968093f8f.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780095510; x=1780700310; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4iesyYDPlSTsntkLH8m0VqrZNjF44k6q6gTGsFUht8k=;
        b=ob7Aso3fe/zTBK9v6tjwOZrSpWHm9yKGEZO+ut6HBDDDnvOyRSoQnhoK5rfyjj86J8
         UxMrJkYfbgfb98ALfM51hD9szsgNLcHMqdwwynNxdfO0IxqqUt6nkKQt4/P+3T3joom/
         xAVa+T7egCr5qibbhou4NOgM9L6QGzUUZRNzC95t5Odxfe+SqvmcYd7CiBS4t3WdgaWX
         wMjuuHoHY+yEUM+it+yarqMNE/OY8/MHZ+mC5pzXhHKhQfYzWPkb8forAS1jkDK/18q0
         AG6KkHakS8M+D3Kalyx7j6bzb+QDDm2HB5609AAetwESHe15YDWsoQ9nj15LUYCL2DY8
         S4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095510; x=1780700310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iesyYDPlSTsntkLH8m0VqrZNjF44k6q6gTGsFUht8k=;
        b=YZnIZMbmREQE/6UN3tWwpOjW6Ph735qZC7N+GHLuC3KDWAkY4EDkxXpbUZNe+tQLt7
         L0rRZAASzuCjWIEDWb2iDiwKaeTCnmZbe2273mGNx3vYaBjXkjgmz/ExPJAbOsv1v7K2
         WB79DpAVc+vVLzirhcpEqJJ8GZmcE54I7IhDCeDobwkuqFksTZGB1wgWKgQckmlOHhV1
         Er/vktRUSbBNpPes7k2lyZL677QowbPQvxFlLe7Rbbw6qPnvuc7yEN8LkV3/817dlw/x
         Qbg0lsdIWFUz3ASIiZxbVaqh1K0uV4hrMHdDlhN+Y/6alqMvfIrPyu/iN8c3FhpkJrc6
         P4yg==
X-Gm-Message-State: AOJu0YxKYZ37r/d1rAT073tZirVvKj/E2gn5LsYDcebn1NvQKa3zZQC3
	5TP2rqbHOCF6Mj1bTVS/VSBogwoQO86oVY17i2vTSILCdV1Ino0VygBa
X-Gm-Gg: Acq92OEzuoFPtRkOyNLr5hAxld81qIBShaQNfBGtnWgMxS2kh4HnhhLI1qSh12UTNfr
	eX/T2Wo/kiQ/3sZOXZufa+Mt+K94N+Mj5Q55u5MgvvKpqQ2TyI4WHHSzICKw0Se5LLMACiS+1Ii
	OhruiJByTr6A2SR02apiNTIoVFmxeaEA85YdTF+y+9iEHfCapUXV3hXnIswWw3GlfQy6j4yhaLT
	zE58CvQe3pfBXn9SBgwCIUON0V9BXEzRP8sgiILUEPZ5WkwbGh0si/aVSdeJ3FT9hxl/TJou313
	vZdGZs8AYlPZXTFfRT0VW9cBzZv3s91BWfSX9fefm+ZB124guUlQA+WO72mf4v2mkvVZwgOZmdv
	qA3HmQnmDhwDhKOaGrhRFp3kXmpe9oNydq4szc0g8eWFl1t7AB9UVMtUDyDME2V77nnTwZGEVrv
	vHt+K5GB2FzDqmi11Yp10E36jq3USG6V96PifMUDQY
X-Received: by 2002:a05:600c:450d:b0:490:778:4fec with SMTP id 5b1f17b1804b1-490a2951a54mr22943045e9.33.1780095509756;
        Fri, 29 May 2026 15:58:29 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909cab7b00sm73451845e9.14.2026.05.29.15.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:58:29 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] include/linux/splice.h: trivial fix: declerations -> declarations
Date: Fri, 29 May 2026 22:58:13 +0000
Message-ID: <20260529225813.546405-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trivial fix: declerations -> declarations

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---

This patch is for VFS tree.

---
 include/linux/splice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/splice.h b/include/linux/splice.h
index 9dec4861d..8f6b17079 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Function declerations and data structures related to the splice
+ * Function declarations and data structures related to the splice
  * implementation.
  *
  * Copyright (C) 2007 Jens Axboe <jens.axboe@oracle.com>

base-commit: 9215e74f228f2b239f41271da9e5076ee3439d1b
-- 
2.47.3

