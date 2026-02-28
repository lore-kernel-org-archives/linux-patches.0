Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7BB328B71;
	Sat, 28 Feb 2026 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301338; cv=none; b=KYlACdTnTdLRzl8iAYVniedL/fChdRo+hL/t+YDP4ULgUW8bkpUiIJ5AGjIBZKsmu2nJIAAuo+Rz7uWa44gfx9IVnNBmGQhDfrOjCewdaKklKZJWqN1Za+e+wTtEdktsydotxd6VpYOalheXQO77NMOe8qtwpI5cxRI7ssSaUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301338; c=relaxed/simple;
	bh=0QaQnWkvIXvBE9XpsdBu7sO72Xv5kEXcQG12BIWTGsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzfz0hiSdTKPdfIc9Op7jDOUHk1/D8sp2wbF3Av3euXtrsAttDkUgpIRsPGf76CSbdjb6b55CcglpTsop7CWJfQgSjwH57GKomAOh5opiC0sVYxpocpboAQ8y7ydkOrsIqIcFIYynDbcU2ij+TBeWDdGYf4uhuEUMGKjVyLwCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QB17cpf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QB17cpf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF4C19424;
	Sat, 28 Feb 2026 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301338;
	bh=0QaQnWkvIXvBE9XpsdBu7sO72Xv5kEXcQG12BIWTGsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB17cpf3P3tse7Ml3qLKhPS03Ji8JCyWf477TAlCBXvwgtuQOob5GmoRLZGGWkkjo
	 YSKhxuwjLKVs/n0PP1fyUDddI+TmRkeLn9/tVhGRcM0PjYS/jgfFHaRA8WdJcF8KZg
	 bhRlhCVVaCaJ8d2Lzyyx7ZAtUwjm3AscW/vmJ5JoCivKAW8Bm4xKw4VXeNSvS/XSVI
	 6WhsOdHpU5cAMH0Tt6/MZEU0Y/2HKj+CWkuxLE877ydWgDW88AxBlQ9YJtnUfJaBG5
	 sX4KRJ4/V8RGo0FLc5f1EMZ8ugJ4fcHomm582nEknEJOgMseRpRT+AQrbDk8co5GC+
	 a9+EK0B6TAymA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Plowman <david.plowman@raspberrypi.com>,
	stable@vger.kernel.org,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/752] media: i2c: ov5647: Correct pixel array offset
Date: Sat, 28 Feb 2026 12:43:56 -0500
Message-ID: <20260228174750.1542406-525-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit a4e62e597f21bb37db0ad13aca486094e9188167 ]

The top offset in the pixel array is actually 6 (see page 3-1 of the
OV5647 data sheet).

Fixes: 14f70a3232aa ("media: ov5647: Add support for get_selection()")
Cc: stable@vger.kernel.org
Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index f9fac858dc7ba..d9e300406f58e 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -69,7 +69,7 @@
 #define OV5647_NATIVE_HEIGHT		1956U
 
 #define OV5647_PIXEL_ARRAY_LEFT		16U
-#define OV5647_PIXEL_ARRAY_TOP		16U
+#define OV5647_PIXEL_ARRAY_TOP		6U
 #define OV5647_PIXEL_ARRAY_WIDTH	2592U
 #define OV5647_PIXEL_ARRAY_HEIGHT	1944U
 
-- 
2.51.0

