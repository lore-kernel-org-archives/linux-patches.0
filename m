Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F884399351;
	Sat, 12 Sep 2026 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243255; cv=none; b=USm7aHxMvk13Cm9H+cwFxU9wpN1hyNOSiKWkczf+LE61GJJUlwN5ShHcHmZSg6ke9pCOgG8AnMm8KBnUBCzFHNuIpljHlL252jVdlrk9xvF9t1JsRe7+Tkb9GucZh2YjFJjqm7adDPXEKzV1Uhi+KeprRHBoyRjYwtICr3nmZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243255; c=relaxed/simple;
	bh=/0ltlKIwohv3P8E/n6woQFcVPWeS+mosnYDz2h62lt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/acF0fUbvLeUzDgHe/aV+RhJNuwAfyrA2aFtkad6h1X3ikJyTHG+/Xb54oGkaxr2s2bE+Ai39fZ5Mz8LIRPWfBCE75aQTZhhRz/N6gnARpKHkg0sRhBLotwyEZGL/hupVxGNI+GhZETV29Pxlo8vMFAbGZw2hFbL7JbABOvweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e80xAm93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e80xAm93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992341F000FF;
	Sat, 12 Sep 2026 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243254;
	bh=vAwc8RaCJnMp4ggUuW2VlapOVA70VHQX1tuUKw0NMzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e80xAm931b7uEgznObSCznm4kt1joAP6dzXv9lo0PgvB10nCdQm+It6J4fzgL4Bjm
	 Ow5FGiqXajSRaORz7tHea0vh9tndastLfF5+q8jpuo0JV3eVRDkSyfcdTwAyJjKXKT
	 PSh+rG/Z7PNJaXT/999jZKrRY4dukvdfgcAni1ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 689/798] ubi: Simplify bool conversion
Date: Sat, 12 Sep 2026 09:05:17 +0200
Message-ID: <20260912065532.892902439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit ef5031137b90c5338792f7073ba3bf38d14c8cf1 ]

./drivers/mtd/ubi/build.c:1261:33-38: WARNING: conversion to bool not needed here

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4061
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 5b0a6b554e12 ("ubi: Fix rollback for explicit UBI device numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index ed87f33f3a0fa..0d9f8d36130f8 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1274,7 +1274,7 @@ static int __init ubi_init(void)
 		mutex_lock(&ubi_devices_mutex);
 		err = ubi_attach_mtd_dev(mtd, p->ubi_num,
 					 p->vid_hdr_offs, p->max_beb_per1024,
-					 p->enable_fm == 0 ? true : false);
+					 p->enable_fm == 0);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			pr_err("UBI error: cannot attach mtd%d\n",
-- 
2.53.0



