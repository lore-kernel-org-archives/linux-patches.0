Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD4A288B9;
	Sat, 12 Sep 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231342; cv=none; b=R1FqO3/C31GGcxIkWJY0J73KCgNZ8SJk4vHTNb8dEP3OcCmcOVno+n7q2p+/3AgbCzIzyO7vzJXJEgsfzi74Zapes5JYE7tq6Gvfn1JBtlvYTKoHgqHXKjL5t/LvPHQRBUVtHQ66KMMJI1FolIvx6igOrX7DBRvsaqdaOD/PAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231342; c=relaxed/simple;
	bh=vcLUVj/JeRVn3S8qonwVBz8kwl5T9knJBZ2AcBp/3eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aitvbMnJv9P0amFQcx681g/XHr4Dky0J30kt8EkJLYLwxE9N3vnSOja7nHkhAQIpxqQuQWZmunGPLfBa9FXkuNNlZH60Q88P538Tt+56o6LXEVZZ8af2pTZHEmo9R07rLQ/kIiIqRhNgHIl1AlCMwMVTMq+GTunDIVu4mfBGqC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkeWYjnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkeWYjnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830D1F000FF;
	Sat, 12 Sep 2026 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231340;
	bh=CDh0Syc+BB1AoWW3H64ZQkhduBQYElrDLNsGS97Z9d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkeWYjnbIlO8WG+2cecN7ekwhCZX7B8UdFRbkU+g/eilmHIsnIT70RbH+ALhdWCb4
	 2mM8RkeTUGUK9/Kpib5PMbI2m/6/cBLGJ/dESKugItoKH2Tpv7phkto8KQ3Om7ZkdC
	 jD1++tiZvSToAPMQWeX1IV+u4Gx2rFRn/8voAT58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0980/1191] ubi: Simplify bool conversion
Date: Sat, 12 Sep 2026 09:01:48 +0200
Message-ID: <20260912065610.219534338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b55f886068ecf..948b4c0184c42 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1273,7 +1273,7 @@ static int __init ubi_init(void)
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



