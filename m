Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCA826E6F2;
	Tue,  6 Jan 2026 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720774; cv=none; b=hPJfWFYNhK+H7WuJL5G/I4QkNg8O5Wr5kVgqG8o2ZLuhaVfiOuV2+ktugHMdQcjAsGcElMO1HPY4XI7l3Euq1giyLsScpMkJiHLawIhdbcORgV7XPzjEvBVmoeU9CYstfkIB27o0VFW0cHHICAJLgs6xQXKK89XCg5AWktuL5Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720774; c=relaxed/simple;
	bh=K17Ud0/hn7c9lvTKMHh4TlZ1YiVwgooU6OK8R6whzKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyjkJCtsWOnFCEX++6Xc3kUf7pReScFMXp3aaAQhMWhRvzjimVw02Dpy4kCaL2wbM+13XFB5gZiaPbjqRPxUao2YC7sNRGPr8gvi3PVecG4CSqw+dOkpkUPbECKYf4iEL0nwDI0UWneft7R/njvyInrfOZfqWxd5+vFhLeffhKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7Cr8gGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7Cr8gGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F67BC116C6;
	Tue,  6 Jan 2026 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720774;
	bh=K17Ud0/hn7c9lvTKMHh4TlZ1YiVwgooU6OK8R6whzKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Cr8gGvTxCGbAJG4Q3z05Y4YJ+IY+RB/Flb7i9o4DjlARwjAMosPnwnaI7kkEPET
	 1ZPRDUtYjQCfT2RjRn9NuH/wUgFoEVbB1DoYHoxJhGm3AB3Z86WesmPRWa0oNXXJGo
	 W5Q/gFdTd10zJCcFQRhx6kCgA5V2Pvo0PMn7IwVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/567] md: Fix static checker warning in analyze_sbs
Date: Tue,  6 Jan 2026 18:01:59 +0100
Message-ID: <20260106170503.796392265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c39246c467e..26056d53f40c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3729,7 +3729,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 static int analyze_sbs(struct mddev *mddev)
 {
-	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
 
 	freshest = NULL;
@@ -3756,11 +3755,9 @@ static int analyze_sbs(struct mddev *mddev)
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



