Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BAF81749;
	Mon, 14 Oct 2024 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917844; cv=none; b=a/HQINSEkfouXH6ZTYwL2bALC2OY+bB85f9cBMCOBFJO39EQxp8UTX159YYrs98DZbAvcoFeBep7aSrTcKYG/aXHjeAhwpvSnosqanmAcwwTuuFzOpdobkWRzj6pY0J7XCJlAMVfmqCRGYi6HLvMiXNY4UQxtklrOBu5uAlauYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917844; c=relaxed/simple;
	bh=6m7Q5lsHRIFKOoKrleqjLIJ6+kDbq1lu6FxxjXXJuvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zz9q5lYPiF8LKPQvefZkqoo0+Sw1JwjU90IWoX1dm44pbrSL6POjNPe064jaazATxvewXywwH5Ry7WawvM+Hhv0kvLf6RuQGIYNSL2Z93UDLENXN/tLZ2EfYZE3Qcdav8tm0dUl4u5bUPdbDVjaigVgmsDx212v0hHVVP+y577w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTe7EP0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTe7EP0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D403AC4CEC3;
	Mon, 14 Oct 2024 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917844;
	bh=6m7Q5lsHRIFKOoKrleqjLIJ6+kDbq1lu6FxxjXXJuvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTe7EP0r7R1nHSyCXcQY+T8xSdExlhGXlg+u8rcTtZS4GndjIoHri9lPVYn9F94q4
	 Xh0cw7tSoUpfNoXnzUbqVdPq5FFhCU5uJUFHeaO+lVQi1m0Su140tDMRgLknaws2oM
	 vPc6CnJHz0BVsz6aHt4HB19CsI8D6cEjxMWPU2KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/798] drm/msm: Fix incorrect file name output in adreno_request_fw()
Date: Mon, 14 Oct 2024 16:11:18 +0200
Message-ID: <20241014141222.793207609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index c4ad70eb1d923..c73eb07afb0a7 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -418,7 +418,7 @@ adreno_request_fw(struct adreno_gpu *adreno_gpu, const char *fwname)
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



