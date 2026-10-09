Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393ED4C6507;
	Fri,  9 Oct 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557256; cv=none; b=GXXjUYduxt4q/NTWJkeKrjOOGwJp09zEBG9StuHc6HUjhHHhjnHzwxMDrFGWYtdXk8SEt/C0IaH25bErcJQQdDaw+x8ONDjUzdIPRekyxKBmXCNEhG4mgq4DiFLj0OxDFMJNe0/bKDw0SJ//vKzPeoI3EW+aCaHLbayQ/V8bXeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557256; c=relaxed/simple;
	bh=NeETFWheyB7ID/zukNA05SfMm8mlTGuxM8oR5Dfqexg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLVQOssAR/Jf+sRL0YOSvxm/PCGyk7X9x33oliSw2bDSqCk3Md5e9XETv+5I+CwSpIhX62guyjY09sv1Y8pKWNjR/L29QfqDzWVR313PAy55FPh6Hhy2TsKpTFQFAdqzpYicqRlLTLhYTCjh71sP6p+V9/ugYkPbH5o3+zy7di8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNGLInwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNGLInwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A131F000FF;
	Fri,  9 Oct 2026 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557255;
	bh=r0ycKaomwTKKUa6w/pWJnTnxYZjiuxIPS+a06LfoHAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNGLInwrAOvh5CpSs+vRGnx3sxDGdkmpz9za+hZ0ic054qhJe3S9fmY9kTpFDMGD2
	 Ug9QCAEGDI/MTOvQIOoP7OK66DkQYWyPKvd/xY09qTIrKxEEIVDJ8/YjFH/Wfi4s0B
	 FFpY2d9r6AO3wf+FNVAP/dEGmH0fQrF9M32i//bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/403] drm/amd/display: Mark DCE 6.4 as not APU
Date: Fri,  9 Oct 2026 16:12:13 +0200
Message-ID: <20261009141001.008382678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 3a52d587d1fc8e8bf94ba1b07374f7ec91aaffb4 ]

DCE 6.4 is found in Oland chips, which were advertised
as low-end gaming GPUs in 2013~2015 and then have been
sold as low-end workstation GPUs until 2017~2019.

These are not APUs.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-3-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1072aa811ea1e61d5f763e4ec1bc6d24bb61f14a)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context for missing dc->debug and dc->check_config default assignments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -1306,7 +1306,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 
 	/*************************************************
 	 *  Create resources                             *


