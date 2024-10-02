Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D077A1D016B;
	Wed,  2 Oct 2024 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877889; cv=none; b=Of0kX8vzLMhMo7MrUjQA8tC+kg5RGz65ck7gOtd/Yud+L1wgMIn8u0tR6soh8UGKbHrWbmlr8l+Kov2meZpHJdO3BloneA1W9bfaxRT/dVSpCNQ47AwLIWPe8H3MeHk4DBTrB+UebrBlWOTuV14qWZGqBYJNJeub7HkGiD4x0dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877889; c=relaxed/simple;
	bh=qcDyuJ75Jlu/CRxIiL71VDymdJl78ZJrMaA8zYE2gTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW1KwknJgjTC552BEn4PCVbh67jTD4dIM+2stzfnen2gjks/ipUPwtXESKC2nUB5shJOTPAAamJtadXiD/WY2GWuim8XDH2rJQcCegsWSHN6EImvsO0Tx9W6OKR8wgaIEMSU5cgCPDz+Z8JmDEj8L7OeGOnLFjFTVXqEdExfdOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y360fxjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y360fxjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B525C4CEC2;
	Wed,  2 Oct 2024 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877889;
	bh=qcDyuJ75Jlu/CRxIiL71VDymdJl78ZJrMaA8zYE2gTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y360fxjt7jOm1QQ1v8pKXeP9dRiYP4BQWvxxzkh8zBP58TCeT6J+9uISA+Q/5/Vky
	 Cy76AVQKT5kRIQOi2267o8sRlbbWsH6kYg1heBmRsgVzIbJBFumEOzsMcNO6xu4/95
	 1DmOCU3X/LYGYdgRXcF+Uf5hvWo98JmcLEzVBdmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 202/634] drm/msm: Fix incorrect file name output in adreno_request_fw()
Date: Wed,  2 Oct 2024 14:55:02 +0200
Message-ID: <20241002125819.080741636@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b93ed15f04a30..d5d9361e11aa5 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -475,7 +475,7 @@ adreno_request_fw(struct adreno_gpu *adreno_gpu, const char *fwname)
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



