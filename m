Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC7E318EDC
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 09:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775466595; cv=none; b=R4IzQG11eAUbGdKdhpV+Ey8jagDq5H5RdDCUksZK6SSPT90X+OiVO0X0/NJpXN5OOBIsupNEXjK+48ZFrS2M/ZSr07PapIO89PwE0OtV0IDGFMX54p8PPxygqzBlnPDmURu8oY9a+4tRsC8kznxsuwVhIQIw/Mtxg3gHjoV41WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775466595; c=relaxed/simple;
	bh=dHkShzaaB1FzwSSJnCTbci/A1jSN+Xil0HDTvzSXpKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dMtK+3UUtsyFYmUPqVewCwGkprENUo/Ar1+uec5DHzUQrTwIatUl60mTyFlkRYFIuA1g+ST4Ah7VxZJGe2ioyzM6OGWxQwLKstCArHyRSRRiQs/SOMwzs6NJ2JDxvSPl85Auzktx6Sf/BnSrQ7bqhFGVD2+KxtgajRKxf/sfl9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUagxtVT; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUagxtVT"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4889e045bc6so21596585e9.2
        for <patches@lists.linux.dev>; Mon, 06 Apr 2026 02:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775466592; x=1776071392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AXHc8wsb4o8lZNG+myCrfyCC4E7lywwXo4HWR9KJ3SE=;
        b=NUagxtVTUvjhQnLbnF3lzl3rzCzpa1QgZm6/jZ1meAVIE1Pt+B+WPtBtgAFYSR6hdL
         oFv172mH962tFdpKtU2yLdyWplcvQOV8SYsfQD8cve09I4bJMvJJAUUJ54RMNpWH6V2y
         NpSSeTcbkvlU6bd5blG0zUW/Yft7+V1NeDoyeuzhxi2TaEP/6slT++Qgr5GgkrR0oIDs
         QqrFlgd8CQOdDOjUMSF4uAsQTxYZJhq1iFOMyXUOzcEhjL0Ek/lyHdG21fHprWu9vdbL
         8izrxwBrGTzKA0wM42L/hmqCRY1kPfg83LNP9iPZ7SF7lF9gwawZDwHzBUxpEE0DcrpW
         xEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775466592; x=1776071392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AXHc8wsb4o8lZNG+myCrfyCC4E7lywwXo4HWR9KJ3SE=;
        b=hujBrQWw3Tj7CYi29Rwtt+6AhtGb7j0jXswRaokYwNKXzdI/Z4LvS7uIRrAm8eCHQd
         XT+Ag1+4RGoUOd28cKHJNwvnAHo0oSndylqE0rqdApl0Z5QVrwYf8W2DNhrIK3XS2urR
         LQdZ9Ny9whEHq3F0qdbaEi8LvgFuny1Lr4Xdf95ibdGPFNiEwxb2w0h3gs8o7GHr4cAf
         LMcRam96jegDgnefieTHPw3eCHaDE5XKrxuxGJ575v93HaHBoNSspbBtdkHkUTCdhKCq
         dTXCktKIQKVqoPeDgVxOCDGqlRfD5iI3vu3ycRchtMH4NBFRfUNB6vQIrIbyhasT3ClV
         0Dug==
X-Gm-Message-State: AOJu0YwY23gK0QOSzOeOtF+BGPMkHiwnhqsALI5R9sv7aYubOgghNcdD
	i+Qo1GeL5+bmiYD6oaYMs3ZcwX3oNOJaZ4go+6NWLKv51QR2/9qoZuGX
X-Gm-Gg: AeBDieup3utAgvu5XWh2EtjxFjgo4uWBOZK7qFonHRyXpFPjLaTepdKf5G7SbzixXCn
	OXukd3RcrEgeXZv2P5+m3B7aXEfpdh/rwCulSJVk36d6x7aOjDd/+J0qgufoOW+1RC4SrJe13y3
	ohtT12g8xY5MxOD5I1DlCJFWoyS3kq814VL2SD8/9YAHj12KSNaOdzE4AKKM20VDSxxCqIBzzUP
	xx6BfdzChFD7Ha3r8MDOfARDyjMUAjyVv/ThyIh9lFZrMN+3ZHiiot6Y9G2pLGjGq8dc4lge++8
	YKLXbNr9nHfR81baH/sVgnHhLcxjB3kBVdDubnipXhAUOgjr6mWy3JfuEVaZxUL5UVKo+bQWPwL
	HmUQ0Hk4mvWC+iDiYP2eiTy8yYuFxgL/BAAWrkWQ9gJztly53SNJMApgvKxb7yz5MjGoe/MsjNn
	cxGNXNDchqxcn6NDcy8xI=
X-Received: by 2002:a05:600c:8b84:b0:482:f564:d613 with SMTP id 5b1f17b1804b1-488997b2345mr174598415e9.15.1775466591913;
        Mon, 06 Apr 2026 02:09:51 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4888a7165aasm427753755e9.14.2026.04.06.02.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 02:09:51 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	initramfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH] vfs: init/main.c: change comment: opening /dev/console may fail
Date: Mon,  6 Apr 2026 09:08:15 +0000
Message-ID: <20260406090815.1495095-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is for VFS.

Today comment on console_on_rootfs says that opening /dev/console never
fails. This is false. The opening may fail if /dev/console is not
present in internal initramfs. So let's update the comment.

I tried to fix the problem itself in [1], but the patchset was rejected,
so I will fix the comment instead. :)

Link: https://lore.kernel.org/all/20260219210312.3468980-1-safinaskar@gmail.com/ # [1]
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 1cb395dd9..40cfda9aa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1645,7 +1645,10 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/admin-guide/init.rst for guidance.");
 }
 
-/* Open /dev/console, for stdin/stdout/stderr, this should never fail */
+/*
+ * Open /dev/console, for stdin/stdout/stderr, this may fail if you supplied
+ * your own internal initramfs without /dev/console
+ */
 void __init console_on_rootfs(void)
 {
 	struct file *file = filp_open("/dev/console", O_RDWR, 0);

base-commit: 591cd656a1bf5ea94a222af5ef2ee76df029c1d2 (mainline)
-- 
2.47.3

