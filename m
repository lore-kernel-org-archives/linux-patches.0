Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A317A720;
	Tue, 23 Jan 2024 02:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975555; cv=none; b=RacVh8QPb4FEgGPRnsH6iafEQY0hbGbBHMwVmj4X9pvulFU0IxJInw3msXPgeX3J5WROb2i+8kYaBUfs4lFPIQcCT8DTgTGfHgueohOmke8c3V5STK6dZVdsqbfSE2hHGryAkeo8ipnspAhsC8QsswMWA4Rzp/e6UXO4PkbzrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975555; c=relaxed/simple;
	bh=u4e2FdkUvM3DV4YoqiKFPmVJ6xPXarNUbn8FeLtrwYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn7Tih6Bb3SiUZfL2pj/1UIWTT7zpK13f6YLWAwmpZ86ypt9ZxNe6Ip+4S9LF3f3aj3Ysan0vNbSzghlSsP1ZZZIj5iMharyyd4wEh1VaVd8rZftGoWD8akRTmqXO6aD9FowbON9yA2Kf0z1fDZpNxXJGhvJ+nZ3qrALItGiJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SumQO8mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SumQO8mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE81C433F1;
	Tue, 23 Jan 2024 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975555;
	bh=u4e2FdkUvM3DV4YoqiKFPmVJ6xPXarNUbn8FeLtrwYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SumQO8mfWX68Xt2DLxflCRtTMPbcR2EKwQXWYLwSP+2SPMUY3sedRqvylbSjoC+0e
	 QM0stmO7ttHLE7GEW/D9cddOd8wlVDqlDm/srGQiIRKCtTyqHYwbfOoFLuWfA3xNBu
	 RNgoZbEkGrpA8hOoc/K12EzE90lDlnwRyY8/D5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 507/583] cxl/region: fix x9 interleave typo
Date: Mon, 22 Jan 2024 15:59:18 -0800
Message-ID: <20240122235827.561023640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Harris <jim.harris@samsung.com>

[ Upstream commit c7ad3dc3649730af483ee1e78be5d0362da25bfe ]

CXL supports x3, x6 and x12 - not x9.

Fixes: 80d10a6cee050 ("cxl/region: Add interleave geometry attributes")
Signed-off-by: Jim Harris <jim.harris@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/169904271254.204936.8580772404462743630.stgit@ubuntu
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e7206367ec66..472bd510b5e2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -397,7 +397,7 @@ static ssize_t interleave_ways_store(struct device *dev,
 		return rc;
 
 	/*
-	 * Even for x3, x9, and x12 interleaves the region interleave must be a
+	 * Even for x3, x6, and x12 interleaves the region interleave must be a
 	 * power of 2 multiple of the host bridge interleave.
 	 */
 	if (!is_power_of_2(val / cxld->interleave_ways) ||
-- 
2.43.0



