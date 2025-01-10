Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8A1219A94
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549897; cv=none; b=H0Si6qBEgk7NDid3dmyXfnDk+y4FFGE+wBPXZUfOfz7CvrXXBuY/NKDnEdCoT6tgMpzdF8GBPs2SUwIQqEKUqvRMljH7vuIWbxXv/YzhiOqPqCCzltlORT2KAPN7tEJ03g5x++M4YA3Vip806aYnTYzRZBNL3Vikb6OH1+O9trk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549897; c=relaxed/simple;
	bh=E24l2NEdocIuS+niS7tR9PZ+NuhoVhrhGfsNSIlWXmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hgmAWcV38M0t81AtaBkVgmCigncRFk2U6H8qN7cVPRr61j4ndYRQTHfASa8YLpFImiit2uwF8CfH9SRz9hT74DwDuWkLBAjrSMcn5pwhhCoWShCamYgJ6m+2Z42RX6Sc5eSyPHtfA0BonFvSO37g38/6sjlj/WaHwT2x+jp/hcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=TCacPA4H; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=Ws8/MeYW; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="TCacPA4H";
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="Ws8/MeYW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=atmark-techno.com;
	s=gw2_bookworm; t=1736549894;
	bh=E24l2NEdocIuS+niS7tR9PZ+NuhoVhrhGfsNSIlWXmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCacPA4H1syyoNkL9z4zL548inXLk8ORL+s9M2NhrN7UCVScvDjeaiWbZ34Ce7u6J
	 g89IFzdamcpjsxJrscPMIBUqcA3Ai405nwNaFlYJDCgGrkRxk20hASBuJdJ/2HVu/M
	 4M+YaW6U3swI2/UdzK60cwTUAoG4omF9ESy3BtxJWvrpfTjZY1KOiWN4pwfxzenHAk
	 3zPwGxaAlMFBgEP961OKnO55P4AqIs4GWHIEPQILhxyGWBnMl9YGrzV3uezi2kGlNu
	 L/I+lKQjUZS53NTBvs35bYej26Va05HGehbuoDriQ5bfTa+f3q5UNJ4Gg4o7gHVi3S
	 46inRTYwCcEsg==
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
	by gw2.atmark-techno.com (Postfix) with ESMTP id 427D9A0
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:58:14 +0900 (JST)
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=Ws8/MeYW;
	dkim-atps=neutral
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id 25340A0
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:58:14 +0900 (JST)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-71e197d0cdfso1560663a34.0
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 14:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736549893; x=1737154693; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzXaow4OKVTn2usXw2dSsQUncbcTPm1ESbRX/Ahbebg=;
        b=Ws8/MeYW+xFnCAJMUdJHKk4CiNIUlsZauMSL31P0Z4KYCnhPF7129LuckptOKk5VRM
         CyFCfUtVcNevTI7Lf/7jxM8uYuUGm6vBRmzubXXcXYzNDQIImHr2RI0EY/teMPkjKr0h
         +MMdZTdfxmLd1jfAvF8U1GRwlH2+HF99wMWtTSOC3n6bTbf/b08zGhw/q5F5FtBSq8xn
         tUjWl91qPkAamsz9tOaCg37Z+YksmHPQwYPWlZNLKLhSl/M2FQptrJ2nzILGXgHUSmR/
         kXvT4SuQ8uP7DEUnShCTpWKtJnZhb47SygFfVxxV3Dq+5wCfhP9334ll//TL6kXQJ55y
         82ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736549893; x=1737154693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzXaow4OKVTn2usXw2dSsQUncbcTPm1ESbRX/Ahbebg=;
        b=fXlrNEZkFPErsY80sOUcuV2cl/oxIwWU4G6sY6kq2XVwKF9gb4eYwRKp40x4tZ40nn
         YG9heEfKWT5tNRGmzgRVZf1Wa/iIB8VI7uQTIDVTsZOq07mNAccHb3PtqEa3V/sSaHqh
         ggJJqPizsbM+0kErVNf/ef9S5WHtBEwwktBg2LCK/UJIKu/9tBPN3A0fxHFOpCKjq4ny
         Np4Itt6VfJPCSSCArbLyLltIDic6ubQZrEXQDUqzu9PQZfVp7jWJ48S1Pn2QTTgIw3pr
         cnt6fscq9pxnYkWDUr2DZgc6puVVpHeyM0V21gzoeCfgOYevvaJ1OD5UDy5Q/ORzkFF3
         6ZgQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2Hi2iE7Q22KwrRfDL072yTmp4vgQKiqiGzgACBPnfUow9FTzQ+ylgWu4hJJd0V6iqEGbv8Wvu@lists.linux.dev
X-Gm-Message-State: AOJu0YzSqWwHAFDMmXlOjPbKeBFoeYS64p7F0sO0uEmiNRitLsXsKSJE
	lBnqMqZg8Dz1hdDwQ+SJ9JUS53WxGNJ+DK/BeipAdR8EqN56j/TpNTH31JP72e4diLPSFTQ7F5C
	5rGTfT73nXqy5TvxsL7dcRUqlPWCiJ099MtFAKNM58n52V1S2MEhDSrmK
X-Gm-Gg: ASbGnct9esPMuRG4pKYXtrE7WFOUhAeafoUhueM2AiTleCnw841wgMv2Oie63n4C8M0
	N5h+VlK99sD1txN7gPxLk11ANdXBOYIAFjmK9zbbojGix/QUxhbR6w4MRSm2kKJwo+EldB0XLHR
	nVLJyRoBUuQi9/UZ+ml8cqyeyHcdYg03jb4xc3WQxHkA/6+3KBqbWFtXm+4i7WdHplIWggpTLBO
	PjIik1JkNDFd2IFUo/pKW7PklW28f5eXoFN+LqjWTxcBM8yByidmC+tYanno5wQzr0f7uh78UnS
	9vXrtlwGF67EhFSmUeA6fgJvCfySBVsA83gB5PZa
X-Received: by 2002:a05:6a20:9185:b0:1e0:dcc5:164d with SMTP id adf61e73a8af0-1e88d0a2ad4mr17590497637.8.1736495936582;
        Thu, 09 Jan 2025 23:58:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7KMUqmK/amvBFF39uo8qX8lRwdic3kWHeFWOWkvP5T4KzKcVFjU22go/UgnH1YyVP9QgkEw==
X-Received: by 2002:a05:6a20:9185:b0:1e0:dcc5:164d with SMTP id adf61e73a8af0-1e88d0a2ad4mr17590471637.8.1736495936217;
        Thu, 09 Jan 2025 23:58:56 -0800 (PST)
Received: from localhost (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d406a5a32sm1044357b3a.173.2025.01.09.23.58.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2025 23:58:55 -0800 (PST)
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
Subject: [PATCH 5.15 2/3] zram: check comp is non-NULL before calling comp_destroy
Date: Fri, 10 Jan 2025 16:58:43 +0900
Message-Id: <20250110075844.1173719-3-dominique.martinet@atmark-techno.com>
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

[ v6.1 stable tree commit 677294e4da96547b9ea2955661a4bbf1d13552a3 ]

This is a pre-requisite for the backport of commit 74363ec674cb ("zram:
fix uninitialized ZRAM not releasing backing device"), which has been
implemented differently in commit 7ac07a26dea7 ("zram: preparation for
multi-zcomp support") upstream.

We only need to ensure that zcomp_destroy is not called with a NULL
comp, so add this check as the other commit cannot be backported easily.

Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Link: https://lore.kernel.org/Z3ytcILx4S1v_ueJ@codewreck.org
Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
 drivers/block/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9eed579d02f0..e5626303c8ff 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1712,7 +1712,8 @@ static void zram_reset_device(struct zram *zram)
 	zram_meta_free(zram, zram->disksize);
 	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(zram->comp);
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
 	zram->comp = NULL;
 	reset_bdev(zram);
 }
-- 
2.39.5


