Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABEE44AB84;
	Tue, 21 Jul 2026 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667806; cv=none; b=pFV1RQPcKJGPECxJERrKI1MSXcAa4svyXuITzqnqIRrsZX+vOnQE4tityFtPfN0sWadv0eupQuexVa/d3qBXZdL9dyujJmYOqarp2BGQ0hdQv4yDpIyXAodJIyYSkymdZf8rv4FGItnO5HY3BvfeYa5q+dBZ2aSFid41oHUJLCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667806; c=relaxed/simple;
	bh=kM+Ud+gROYiZ+9fFdst+0tmKY6RxMEgQB36w7kIORto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1L9+7Wz3zPCB6+MZu57BqjGXUqRySNhKZk/JvCkYuWb7He10X+XF3SZXRAeuUdDZr3kg5yJwcR2eDFNE3ly/BMtTMW68MHcIuvyLcBJbBxbnHlLhieBzK7VjQ/tIj8mqqa3HKB3tgSigO50l97EkHjQCwCR/ln86b7LTkNpwOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re5F2NYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re5F2NYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EAF1F00A3A;
	Tue, 21 Jul 2026 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667803;
	bh=u7poSlr1hcJwXZ4Jsr55c592MYZo1w1rRlCGoVCP80Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=re5F2NYkwRY26yNqhISbYmWrE3u5Z55W9Z6LrO0OAaB0yuR6Gm375aWxRzzSapGui
	 0U9gniJYI5oI5Pxqpm2orsRQ8/zbyuTS+uERwrbb8hAb/zWbhTyAr0ouFI4B+pLhLk
	 6OywFx2yfp6pgJEEYGVwBCSag4V1HxmZwxobvlEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1157/1266] iio: invensense: remove redundant initialization of variable period
Date: Tue, 21 Jul 2026 17:26:34 +0200
Message-ID: <20260721152507.673680144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit b58b13f156c00c2457035b7071eaaac105fe6836 ]

The variable period is being initialized with a value that is never
read, it is being re-assigned a new value later on before it is read.
The initialization is redundant and can be removed.

Cleans up clang scan build warning:
Value stored to 'period' during its initialization is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240106153202.54861-1-colin.i.king@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -139,7 +139,7 @@ void inv_sensors_timestamp_interrupt(str
 	struct inv_sensors_timestamp_interval *it;
 	int64_t delta, interval;
 	const uint32_t fifo_mult = fifo_period / ts->chip.clock_period;
-	uint32_t period = ts->period;
+	uint32_t period;
 	bool valid = false;
 
 	if (fifo_nb == 0)


