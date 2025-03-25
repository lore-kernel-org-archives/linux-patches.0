Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C155FE55B;
	Tue, 25 Mar 2025 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905912; cv=none; b=Udhp2hzDxLgpKCP9yIJeiHFPo04sWK9ehE+q2kh9aDtyPcTSWPuRaCMouiAXB9nx5yjDLB48pRhRXPJ5O/+yiFsufW9QMS1wY78LpRAbx3zvVNdQ+E/JRt0SG+hUSVgvrPE1lNzT22r0CIhcrcYe/NHjFh4miyqvXHkmIOJmdM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905912; c=relaxed/simple;
	bh=kNN7Tbx4i9qLgQ5G2RSxBs1xy+vcXGHxZrskrja22Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK5kB9L6J5aevh7IqDFuR2Y5Lo7h1FcHXVeSggFAl0YCXKPqppi+mLPGWr2NxNDPlrMXgu5juk1HgTtLeNR8zfUgLgIjeEGfeVzz3tz0418NC5AorvB/UzIivfxiSbPpzvIHWPuGBkOVlvlkOpCi2LO/ZSJ6L3/tx92CUcrkVC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck0+dUgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck0+dUgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D4DC4CEE9;
	Tue, 25 Mar 2025 12:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905912;
	bh=kNN7Tbx4i9qLgQ5G2RSxBs1xy+vcXGHxZrskrja22Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck0+dUgibQvIlfZNzoc0WYZyYQeDUYku9zgyOQHN3poWp6sSnLt9pP3WA/Za+bIVM
	 1X+q8poelpaLZXfmTabiSU4ckvvLsnvGjkO9OG4sUVgUe6n1d/5NXDnIKnbWFgzS/g
	 aZPh/lHOUGTD5iKN8RLDKdBs7K93hKGXnbvkU6zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Huisong Li <lihuisong@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 033/119] soc: hisilicon: kunpeng_hccs: Fix incorrect string assembly
Date: Tue, 25 Mar 2025 08:21:31 -0400
Message-ID: <20250325122149.910572116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 262666c04be6afa8f15b6c318596b54c37499cda ]

String assembly should use sysfs_emit_at() instead of sysfs_emit().

Fixes: 23fe8112a231 ("soc: hisilicon: kunpeng_hccs: Add used HCCS types sysfs")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://lore.kernel.org/r/20250314100143.3377268-1-lihuisong@huawei.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/hisilicon/kunpeng_hccs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/hisilicon/kunpeng_hccs.c b/drivers/soc/hisilicon/kunpeng_hccs.c
index 8aa8dec14911c..444a8f59b7da7 100644
--- a/drivers/soc/hisilicon/kunpeng_hccs.c
+++ b/drivers/soc/hisilicon/kunpeng_hccs.c
@@ -1539,8 +1539,8 @@ static ssize_t used_types_show(struct kobject *kobj,
 	u16 i;
 
 	for (i = 0; i < hdev->used_type_num - 1; i++)
-		len += sysfs_emit(&buf[len], "%s ", hdev->type_name_maps[i].name);
-	len += sysfs_emit(&buf[len], "%s\n", hdev->type_name_maps[i].name);
+		len += sysfs_emit_at(buf, len, "%s ", hdev->type_name_maps[i].name);
+	len += sysfs_emit_at(buf, len, "%s\n", hdev->type_name_maps[i].name);
 
 	return len;
 }
-- 
2.39.5



