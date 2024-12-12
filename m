Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BFB13792B;
	Thu, 12 Dec 2024 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022216; cv=none; b=bYJ2sdf/nZxZlIfnmNOSoSyitzp4rcpfLx95To8Y8IpkOqINUj66WTCjiwOs+jPYSyOylHsX8ZKdat1Vyjds+wE7va0JBBRo0mAPW9ed6pHXMF6oBlQDCF+bozRun90blTxGHuAjrlGl7f8vKMQOvyWMxV2YLBWMSkBxHXjPME8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022216; c=relaxed/simple;
	bh=Myo+rapvEVB42EF7SKjEH4KI0+quwg0FjSkdY6GSEug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZrW+/My/yu0oSMUkFtIdobk829sr5/7Ns0MDx/7/NLf1xi0VJsbLnPx5Ou7mZC2pxs8V5WME4n3i26KJIVTfBC+TE0CXOyMIR6wQlr9Xm6UzilFmYNFqghEYBzYGtvUY0Hm7qh9a72NESk6s2co0R5RS5SiIQ1KZX+dRHjskmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjV8AqON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjV8AqON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DBCC4CECE;
	Thu, 12 Dec 2024 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022216;
	bh=Myo+rapvEVB42EF7SKjEH4KI0+quwg0FjSkdY6GSEug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjV8AqONE0CplY/HfR2ZmGpQqhf9wb6h0cwvBy7Ccb73tVFAW56J15xNxKojIcO5s
	 Qk/i0s00N2SPHTDZnfN/4gFJj1fwB1fCy4jDUlXY7KNMiyArTdHzgUoM1p0iESG18/
	 udoHMa6wRizdM0B7V6aH43ejfcTVav5hTTSE9uyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/565] drm/panfrost: Remove unused id_mask from struct panfrost_model
Date: Thu, 12 Dec 2024 15:56:14 +0100
Message-ID: <20241212144318.550168575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f8355de6e335d..813c759505e03 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -158,7 +158,6 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 struct panfrost_model {
 	const char *name;
 	u32 id;
-	u32 id_mask;
 	u64 features;
 	u64 issues;
 	struct {
-- 
2.43.0



