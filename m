Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128211DAC9F;
	Tue,  3 Dec 2024 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241041; cv=none; b=RNQmHciPbPlDXoN/yE4iFhz+pxvGNg+Slzyr90xQ8Hnk8Eb1Dk0oL1AVvAiu9LIkf82vjmFPklzES75V5LtcvsCRkjhtMz5hbCUJuGoWWqBoqjUktyJPjKRUu8RHkj0v1pi6gJ8aLuXOpQT0xndQSca4hStBWDPmLr66bBtkd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241041; c=relaxed/simple;
	bh=eEcnM+6JzH/2xcB/LgrXBa4pi+RbXsrvTwbTklr/eU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLgrQa9mUQ4yTxh78W/CpfdLExFlkIyxyF+rcRtUf4s08xk7X/VOpOE5tHDj2dcOighkTAIEMRj8jtfoVebWBSnzaWv0+TTVnYVSw1DLI6/SBYYasJEuCh7Xn9oI1qirX7VhPSNLkWqrxCfN1Y+Z0wBy/sHvoJ7K8TkidKXOTek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKrpZmM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKrpZmM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B49C4CED6;
	Tue,  3 Dec 2024 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241040;
	bh=eEcnM+6JzH/2xcB/LgrXBa4pi+RbXsrvTwbTklr/eU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKrpZmM++9QgrHiMvuMkGvRgRD/e+Amk7bY0hU2aDV1tIb6w+unxrVvTu0kxWZ9F/
	 /K6aimDgZY4B3fMbdwrqB/KDbev6hxfT7px9u0PTVgJ+n8y/QUzfVfF7nNtHOIUL9f
	 Vv1LBR6h5vct3G7tcw8nducyz9zcuiOHTGyg0riQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/826] drm/panfrost: Remove unused id_mask from struct panfrost_model
Date: Tue,  3 Dec 2024 15:40:03 +0100
Message-ID: <20241203144754.542656407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fd8e44992184f..b52dd510e0367 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -177,7 +177,6 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 struct panfrost_model {
 	const char *name;
 	u32 id;
-	u32 id_mask;
 	u64 features;
 	u64 issues;
 	struct {
-- 
2.43.0



