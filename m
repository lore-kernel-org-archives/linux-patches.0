Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B341E871;
	Fri,  6 Dec 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497260; cv=none; b=eAm2ExjaFR7VK2Tn2f1RUi70K5PHCg3xPlw+Kp4EeJ8hOBzSE3ratS+FzyTDKz0vYyTjiwmdhQ5rlj4DzK2qB/kTpA/petwpxJwE5cnZhmMvdsW8OZsy2UdSx3bMOfJXZ8pgD1KzvlwUA3O+lciRfqFlzAa9UcwHoC8RdGrlGng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497260; c=relaxed/simple;
	bh=cKKoyPVgDdy4ujgqy88L6rSBLqvwSrzdd7ip1n4b/5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvHo9t2ec9iLHGErflzPraf7JeI0cypTv+glwxZaj8JiDEUF5HyT0+33WXmMIhOyBJnb15V0KHrfCDMwQ7Qwcj/MrEWvItwxmRgfezSz12SSta9uFANJH5poTfBXfUHuGF8zHRwIadfy55tBwDPkb5G/ZchdK/AXIvO5SP7qA/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymV6uyfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymV6uyfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A5AC4CED1;
	Fri,  6 Dec 2024 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497260;
	bh=cKKoyPVgDdy4ujgqy88L6rSBLqvwSrzdd7ip1n4b/5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymV6uyfcy9MxqVkG++DmZrUv+mfgfSx/wkbbTTUf+NDzqikCIloQYm3yuuYHIXYbW
	 2sZwMZ0Ihq23O64VHajWkrD5gdh+bxKcE/tTbXrtfkzgrSQLcZxp2uUCa8iyN31lz9
	 i8jxC8ZIp3KI9Cg9whInPUy/1oc2VhcxF1T6SXk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/676] drm/panfrost: Remove unused id_mask from struct panfrost_model
Date: Fri,  6 Dec 2024 15:30:32 +0100
Message-ID: <20241206143701.662210621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

[ Upstream commit 581d1f8248550f2b67847e6d84f29fbe3751ea0a ]

The id_mask field of struct panfrost_model has never been used.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241025140008.385081-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index c067ff550692a..164c4690cacaf 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -157,7 +157,6 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 struct panfrost_model {
 	const char *name;
 	u32 id;
-	u32 id_mask;
 	u64 features;
 	u64 issues;
 	struct {
-- 
2.43.0



