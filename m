Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8E53612D7;
	Tue,  6 Jan 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721810; cv=none; b=T8RLnaTQw6qzU+0nT5B+N+8wkBnILgmdBto5X/NQzMnQUZvJYkh8qlse4E8PPAcNQlzwLqfj3bccoxnjmjt/BT/dA/4QCuO2Sr7jUybrLLu8oenJsK6gbZBuE1Eg0M1Qq/987tfYgnGBMOhdCEj+g6G/+I1b/jBVPiqTrYMJFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721810; c=relaxed/simple;
	bh=UUD7Lv5dg2xcSFyZKFC5B8X7isSYE2+UKfN4yfWCHsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW7PVvbYcZEorgYXvltZ+b1i4QeZE+C9Ttz6zebFZi9xvwDTLT8xfKs1Lle3RtZ+ttp1cSzxMsVE0tVPgxvo8RKkUH4CCNGdXFGPYMjq73m93TquYe4p0gvImE6pIKO7DJFvokyZGO0P8SXddFaY1QCKBng0E13HQKCLRVa73d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGABdbOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGABdbOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FFBC19425;
	Tue,  6 Jan 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721810;
	bh=UUD7Lv5dg2xcSFyZKFC5B8X7isSYE2+UKfN4yfWCHsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGABdbOHUewTwJOsoEMjjXIvHOmz9nPdZQN2SxZKBl9RtmvbsQMs7+KmdebKInTA1
	 6jOtCibDjDhwt47M+fFjxUXW9U4uw1AZOtTZU/3JwTQUGixQUxYkMhYtsqXuEM92D1
	 5UuGvB8tZhbkCKAdxr3VwHy/edymw1QX0uwYJGyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/312] md: Fix static checker warning in analyze_sbs
Date: Tue,  6 Jan 2026 18:02:32 +0100
Message-ID: <20260106170550.663451733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 00f6c1b4d15d35fadb7f34768a1831c81aaa8936 ]

The following warn is reported:

 drivers/md/md.c:3912 analyze_sbs()
 warn: iterator 'i' not incremented

Fixes: d8730f0cf4ef ("md: Remove deprecated CONFIG_MD_MULTIPATH")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-raid/7e2e95ce-3740-09d8-a561-af6bfb767f18@huaweicloud.com/T/#t
Signed-off-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/linux-raid/20251215124412.4015572-1-linan666@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cef5b2954ac5..7b1365143f58 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3874,7 +3874,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 static int analyze_sbs(struct mddev *mddev)
 {
-	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
 
 	freshest = NULL;
@@ -3901,11 +3900,9 @@ static int analyze_sbs(struct mddev *mddev)
 	super_types[mddev->major_version].
 		validate_super(mddev, NULL/*freshest*/, freshest);
 
-	i = 0;
 	rdev_for_each_safe(rdev, tmp, mddev) {
 		if (mddev->max_disks &&
-		    (rdev->desc_nr >= mddev->max_disks ||
-		     i > mddev->max_disks)) {
+		    rdev->desc_nr >= mddev->max_disks) {
 			pr_warn("md: %s: %pg: only %d devices permitted\n",
 				mdname(mddev), rdev->bdev,
 				mddev->max_disks);
-- 
2.51.0



