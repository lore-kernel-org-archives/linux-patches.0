Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE31ADFE3
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 07:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736234183; cv=none; b=pU8KhfwGpNLDlbaoUz1HPwijH2tpNcEIfxFvlb5ggpJXJIps474qVsK0k2de3nSkQhKTZ6nEhxOeVJ2MsSSSc0eWl15SGBEx2FR/fOqyi7MJ8h2k7/pV4Z3lzIF4NRbZ6U7HNR/YOVF4ba+vph149GgTtq11uq9mYUui0Lso8YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736234183; c=relaxed/simple;
	bh=4JOf4vQJKySbNhFzUeO9HfqnUcNDwDoaMz2y5skl6qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hy74VZ/3r9pmZETFJ0gmcnrNtvlzUYdEMQecF16SeIiPr70CajOp8wuyZa5AM5eD8+9+Bti293TvtH+8s8BvLF/6M24LqSeAej0jljoiXEotHGQeGBJh1z+bhDFt+xP2jCS0s/VoKvWKN9O/DXI3tlL2573zk1o+DIQQQBRQf+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=LxqYsGP7; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=hFmei3Kr; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="LxqYsGP7";
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="hFmei3Kr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=atmark-techno.com;
	s=gw2_bookworm; t=1736234172;
	bh=4JOf4vQJKySbNhFzUeO9HfqnUcNDwDoaMz2y5skl6qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxqYsGP7rd9rzP0Oj/1U29fRCe9Y1fnmoOk58JDTaRQOs56OC86uGrd09ssh/xVg2
	 dEWvfi4vneFm0XElCTxppqKCAo0pv/Wdd260CBAx4Ii/pU62q5ulgR7dYi4yVHv78n
	 I2jVJpRlBdMHqBIISNjb6THUN/+9cuihH/HF18r4YU8u6aZbYSfbqgz5LHv3PkVLgA
	 5qeqcz9MwzHri03hhDXkDORp+88yOY5gncW63VZDVmtgvgEuBqnkDI4McVnplDYfip
	 LenHxnV2+ymqg7PSLHX2FK+F0y7Cx74MB1vOlXvRj56loz5uAmVLTqiAs0627ALad4
	 QO6wqAGsdlwyw==
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
	by gw2.atmark-techno.com (Postfix) with ESMTP id F22DDA5C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 16:16:12 +0900 (JST)
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=hFmei3Kr;
	dkim-atps=neutral
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id B7BC0A5C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 16:16:11 +0900 (JST)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-21a7cbe3b56so4099955ad.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 23:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736234170; x=1736838970; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpDKhWdhWoMNZAx6W+tFqQ6UOWX7FUPFoMzc+kYG/bM=;
        b=hFmei3KrH4QIvYrMR4bWn5CyUu0WFUZgCfm/FKNzfvuRs8iaruZM7WIm8V/V4q0V2L
         OqNcUQkNAq1T7BCiT6ZkgW54esndaC1ywjqEpq+3MklMzrh0OaQ1am8RYi0nX53ZxySf
         USzGdpNm894j9MTUvglL0l+jMYPUj783Ug+SRgN3BkNCIPq1StoSM8DNKW6NCafibWZc
         PP4rI8tmoUTd2y4M6A7SkvhT9xkBLY5Sv8kbsK42aW9nXSdVi/p1IjgHwC7mWh1OX8VQ
         Hb+GNMW9i+8YhEsSmt3ypHJ5MDg9d78ubXSqCNv/TPc+LUFYMTkCWWdHbWw/UL702822
         wm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736234170; x=1736838970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpDKhWdhWoMNZAx6W+tFqQ6UOWX7FUPFoMzc+kYG/bM=;
        b=eqKa4aAdldLUbIGFcYUtWcbBNt0egdqsO1OjpkTyTO9Swc8NsmErkC+Yg1GbJ+/6lm
         9b01Boamu5qQul+2Qxm0tAvwbs3eabIMBOhvjTkyvLXi2BYzMKe49gx0iO9bVsHBa+CI
         uU3GrD0MRfAp3TREh4Ko22R7P2KDEcw5rPxnN4P+3ptp/mtdgbYV7pnMR9kbk/2RjWjE
         BVSuWEAxge/mVqGF7E72wrQC3kIWGI9sdCR0BLIEltanl0VSWUnkf6CHZc8+v1wUM733
         StkQZFzMP0dmPKzFUnI3LBKTyA5mHFGJqfp4NKUGn4Lo8UtB3Kr/2HJRV2D7tVYuTgob
         kJbA==
X-Forwarded-Encrypted: i=1; AJvYcCXWXQNCOPStV/VuBXZt+SwX1RvxlwKFx909jc/PFTgqugFMlJQwaWfxhNJUqynCWm8DrAWfAXQV@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh6VnRgykZ0KqsRK1ZGyKbUy0Ag7efecJMTFPiyPYQFnWWs3gz
	Kw/gN0WL9AClixwGpooEGXUw9gGDV/qtU22lG03bAEhZaHAN941nhAiSA8T/xgpwcMuiUcV6OCB
	udUcLfnJLIGEuxVMbFlHfEXRMD/toN8u8EJQ2u4vZifRfWjimHH/UZBUo
X-Gm-Gg: ASbGncvImhKZBi43h7hShDAo/qpi8yF0LGME6Yc4GtQfn73iDjNaFtZu4YkfsVBKq3w
	hQAd6qnUYF4GXnhtKN5VoORng04dLEsc8GL10xtUVP7J8wBlkujXPK5IF3oy+FxGoWi5tM14lpT
	EPuxeAnmUNfKtwpZ/UJFmn8QZAnByLVo1xKKUwr2/stv1xGoQ7drvQK5HLuckYjM54B3adh77Tr
	B/hxX4GkvLHleUL2FG1UEiGuddUlUaBRpgbDlpbrLV+bE3R+5pz4siG3xHW0wCne6T9XGHVjSCG
	nztBT2rvlZuG+JrsDM23l5A78mLKzOwmJbUKznOk
X-Received: by 2002:a17:903:94d:b0:216:46f4:7e30 with SMTP id d9443c01a7336-219e6f11764mr946279455ad.43.1736234170647;
        Mon, 06 Jan 2025 23:16:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGAAlP1234Rnr9ldpY2k0GzJjVBsLLDKGARicFLlaJ4wlVFeOd9XKA9FdNXUOAGZRvRjOTfbw==
X-Received: by 2002:a17:903:94d:b0:216:46f4:7e30 with SMTP id d9443c01a7336-219e6f11764mr946279245ad.43.1736234170365;
        Mon, 06 Jan 2025 23:16:10 -0800 (PST)
Received: from localhost (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cdd9bsm303236805ad.132.2025.01.06.23.16.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2025 23:16:10 -0800 (PST)
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
Subject: [PATCH 5.10 5.15 6.1] zram: check comp is non-NULL before calling comp_destroy
Date: Tue,  7 Jan 2025 16:16:04 +0900
Message-Id: <20250107071604.190497-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <Z3ytcILx4S1v_ueJ@codewreck.org>
References: <Z3ytcILx4S1v_ueJ@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
This is the fix suggested by kasong in reply to my report (his mail
didn't make it to lkml because of client sending html)

This applies cleanly on all 3 branches, and I've tested it works
properly on 5.10 (e.g. I can allocate and free zram devices fine)

I have no preference on which way forward is taken, the problematic
patch can be dropped for a cycle while this is sorted out...


Also, Kasong pointed to another issue he sent a patch for just now:
https://lore.kernel.org/all/20250107065446.86928-1-ryncsn@gmail.com/

Before 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing
device") that was indeed not a problem so I confirm this is a
regression, even if it is unlikely.
It doesn't look exploitable by unprivileged users anyway so I don't have
any opinion on whether the patches should be held until upstream picks
this latest fix up as well either.

Thanks,
Dominique


 drivers/block/zram/zram_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b83181357f36..b4133258e1bf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1734,5 +1734,6 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(zram->comp);
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
 	zram->comp = NULL;
 	reset_bdev(zram);
-- 
2.39.5


