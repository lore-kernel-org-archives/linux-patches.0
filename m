Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2D223338;
	Thu, 12 Dec 2024 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019388; cv=none; b=drgWNUO1Z9yWMGxyJ2FUd2VzY94gEfr3ALoXIbWAgP89ZB4WxJvCDcnyUthNnh0CAUimd3mhPoOQMM9KtlrNuBP7pNowT53bBAlG/erTPWfR789E0XrxaWq+5mOGUuUjZ5IRNvIbwfLxxY1i6CK6NPiIpJZCrRZUqdJlTgyJJVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019388; c=relaxed/simple;
	bh=/z4QII2Y/OZv3BmQqTw0UKcvzAwnI5bKMaqo028XZq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kf/E7wMRV6GaDTvdvUkD2YvDaOvTVy6ySkvza7PKPxrSquYh9ZCSKepeMNiJol9Cm4j52rm11CmGXs7/w9q0EaDHzEj61ARC8ui9Aq7v6uypiu1N+45NE0jGFhUsV6cGD7miLsOgCg7dDzRvP0PlrALgDJy4QKJVtBn4tUZoiGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCanIpfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCanIpfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA85C4CECE;
	Thu, 12 Dec 2024 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019388;
	bh=/z4QII2Y/OZv3BmQqTw0UKcvzAwnI5bKMaqo028XZq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCanIpfdNeJ5MmEnXHfUWb4Qld7XDEsqvBiQdKZDHMsD7EQqKYzMJdPgDxqoYkd4G
	 8Q1b9o44W9GZMFGN7/QczyRwJ+j9Uqe88vURq+EX3aAxS+8Me/v7+BNBSk77bqgYlA
	 jM/cs3NtntFNATjhY/HZxBr4stZakeEPgu5Lyaiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/772] drm/panfrost: Remove unused id_mask from struct panfrost_model
Date: Thu, 12 Dec 2024 15:51:49 +0100
Message-ID: <20241212144356.723033411@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40b6314459926..62722d9ff8eb5 100644
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



