Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30BC1CFED1;
	Wed,  2 Oct 2024 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879555; cv=none; b=IE4NwWjfGT5++DejCRxy8Uwqnk/Wt8ZaVFA7wSqnXQ9g6+wV1qk/zcuW8gT9oNLGuyVyvZ/4Xq1sEtoTfoCiJHcY4ggp7v+LXGViAgA6iDvosNp0QmcSgG11qL0+RP63GXfMr7kq0ECrClJFORk6D6ORGyUMeHZLIp2cTkyD6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879555; c=relaxed/simple;
	bh=Cd9eMAAiMjui9gPwJi5cuWDhS0S2y2X+JR6HQNDhM5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeUl5q+btPslbKcvXk5heOW/So8ATcrKV3FyXGpS1yNg4zJddc+pJllHWIejqupIC5yLOHJ2kD5ZiXfJcmG3POog8ZCp1LL2OcIQWRdIBEW/COmR6VOP65wmfrAHIR/lYGT6+73J6GdUdyxZlCc0Ve2cfOAbm47e3GcWTmWdy5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOdn8o02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOdn8o02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9B4C4CEC2;
	Wed,  2 Oct 2024 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879555;
	bh=Cd9eMAAiMjui9gPwJi5cuWDhS0S2y2X+JR6HQNDhM5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOdn8o02wBpFzOla7qrRH67UwsxehJHLPAHvNH3rXwrrsnQLIgOO214SXMOLwnyas
	 j3WjPTPhzaOb4C8v8iQLf7RM8wIkAOddZQAAefTPeqSScsrPggYVETdnUfXeMCL/Vy
	 Igjo0TdD4rfc5AMlBHnRmeHrtbO3BfM3JYm1rHs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/538] drm/msm: Fix incorrect file name output in adreno_request_fw()
Date: Wed,  2 Oct 2024 14:56:37 +0200
Message-ID: <20241002125758.490604758@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit e19366911340c2313a1abbb09c54eaf9bdea4f58 ]

In adreno_request_fw() when debugging information is printed to the log
after firmware load, an incorrect filename is printed. 'newname' is used
instead of 'fwname', so prefix "qcom/" is being added to filename.
Looks like "copy-paste" mistake.

Fix this mistake by replacing 'newname' with 'fwname'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2c41ef1b6f7d ("drm/msm/adreno: deal with linux-firmware fw paths")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/602382/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 96deaf85c0cd2..4127e2762dcd1 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -468,7 +468,7 @@ adreno_request_fw(struct adreno_gpu *adreno_gpu, const char *fwname)
 		ret = request_firmware_direct(&fw, fwname, drm->dev);
 		if (!ret) {
 			DRM_DEV_INFO(drm->dev, "loaded %s from legacy location\n",
-				newname);
+				fwname);
 			adreno_gpu->fwloc = FW_LOCATION_LEGACY;
 			goto out;
 		} else if (adreno_gpu->fwloc != FW_LOCATION_UNKNOWN) {
-- 
2.43.0



