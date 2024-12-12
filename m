Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A4216E0B;
	Thu, 12 Dec 2024 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025151; cv=none; b=quOmtd3mtR71ywqbRAvUVDIgXA6WJbCbvTdnTRkel3oXUpDDweOajPoftIp3gRAP0t6orCJ4bypUp3yAV3AIQdj9EWEtTEiLgpkp80ynBKknXoKB6LxM+S9Sxsg5AfPKYDZyCnmSQJCiDEiCPwH9zncIWFMNjUwu12r8n3keK5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025151; c=relaxed/simple;
	bh=le5UrBY/3ghraRSe0FAHj46ut7xExlY4Od9KXkZd5yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF6LQP0rDTibB5m+mBHT/eb/TS0jMPtX+ea38vHq7wwg5gtIi/HHzOurtPm38xHICWGWn2mzUay6ONwyAnJXqCt/eTl3gv24V3XcXsXkc/HKQqmzsz+KIZQjn9HUFhPTCd8bte0VO1TAnaprHFCll9MkqghgtNHVWbWgQwsIg9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/bbN6I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/bbN6I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF20C4CED0;
	Thu, 12 Dec 2024 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025151;
	bh=le5UrBY/3ghraRSe0FAHj46ut7xExlY4Od9KXkZd5yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/bbN6I/rKjvOAm28uFiGuerAUi/Fj+iThVBhw/uXoInpztdJVoaEG66QqjGrS3jX
	 6uOgulGeNz9Q8+woDDCUtunhuFl42AeW0ciKY6IARcySHkYXBrXqkelam7rB10jhSM
	 xrDHb3M04S7f+nKQ3kMeJ6QeJSgastsb/Wwdsdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/321] drm/panfrost: Remove unused id_mask from struct panfrost_model
Date: Thu, 12 Dec 2024 15:59:50 +0100
Message-ID: <20241212144232.834283616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0d39a201c7591..c0260a14639a0 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -153,7 +153,6 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 struct panfrost_model {
 	const char *name;
 	u32 id;
-	u32 id_mask;
 	u64 features;
 	u64 issues;
 	struct {
-- 
2.43.0



