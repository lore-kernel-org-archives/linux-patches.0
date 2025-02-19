Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB811C6FE3;
	Wed, 19 Feb 2025 08:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953932; cv=none; b=XZq2QgLHDt0WPcczXVdt6YV+10UTIBP71/bU9JSUmAskdLl/PM9013q40XriRm2fKyQXhju+LW1KgeuXTUE34CSX1j10AQHdp23sWL7kpZICu8wMX59O7Hb7NgsyEEN0EeHDsKhTYwdJ2qLn9wSWBy7aHDNMKF8KygCF3m22NTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953932; c=relaxed/simple;
	bh=Ynhag8F+6Nzkl3CPrKIfa2OBQJHQ1EQ59JyucLhqbBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9sMURRB5V5PiROpJ4sUKVsEGrIgqyJgQSGS3LQyYkyyrV/U2QqnmM88eH3nddGZel4NFn3ZdwFBk7EsoAW5+F3Enxi5HkXu/pF419WwUXFP5r/D5Pxlfqq9/OfhOZ8m7pNSqzAVW/vkiCS13v2eOtTajJrQz7wBQwnRdzsLgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrX6BDLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrX6BDLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D700C4CED1;
	Wed, 19 Feb 2025 08:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953932;
	bh=Ynhag8F+6Nzkl3CPrKIfa2OBQJHQ1EQ59JyucLhqbBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrX6BDLcz/Pb9X+NzfDc/S2FtzhgQRIwALo/qVatvoTZCVB543NVXbzFOCllCcf4c
	 LuUzGyR7y7dW8b2HsDLP3W4hxEmYdWK+E6gRUBHyI7G13umnrkyUkqDbNOL4FyvI0i
	 5K2d8EtVRf3mTJIpBf0FClA4/eE/luCrM7UYuC8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/274] drm/panthor: avoid garbage value in panthor_ioctl_dev_query()
Date: Wed, 19 Feb 2025 09:24:57 +0100
Message-ID: <20250219082611.211278228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 3b32b7f638fe61e9d29290960172f4e360e38233 ]

'priorities_info' is uninitialized, and the uninitialized value is copied
to user object when calling PANTHOR_UOBJ_SET(). Using memset to initialize
'priorities_info' to avoid this garbage value problem.

Fixes: f70000ef2352 ("drm/panthor: Add DEV_QUERY_GROUP_PRIORITIES_INFO dev query")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250119025828.1168419-1-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index 0b3fbee3d37a8..44f5c72d46c3f 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -802,6 +802,7 @@ static void panthor_query_group_priorities_info(struct drm_file *file,
 {
 	int prio;
 
+	memset(arg, 0, sizeof(*arg));
 	for (prio = PANTHOR_GROUP_PRIORITY_REALTIME; prio >= 0; prio--) {
 		if (!group_priority_permit(file, prio))
 			arg->allowed_mask |= BIT(prio);
-- 
2.39.5



