Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5FD1E2834;
	Wed, 25 Feb 2026 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983618; cv=none; b=PxA8jlEeZoe9E05jT7JlkE9C2JRYWzWCCUyRilHbYDppVBS1rqgfbyaMPvM0E75m2AwnPT4wk5DPS5SWZWs4HFbClawAXCcmeOZTpxeVodBoeUkGq7f6p9kzvqY+GqPhlfRImai382sdqb8/xe+epH2rajF9q6j301QK0n4t0gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983618; c=relaxed/simple;
	bh=8ES2urm8JWDC0wYiDBuVe4B3bTdwqx5WULP50NhXjA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saHhaCsweB6N9l+I3QGbd02oThshpLDfO9S0XnSpD+kK0ryzo/pP8/ygxO3Wk1s3kX4a62+gLQrrQ85Cn1lXX8SkRe4wUGfZd2bh/s1PfUPREXTjkmJvHh2/6iO11OLyDHtny8i+bLwpeohzFqXQLJpAHwsry0RXP7d8p9a7jbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNQv3Bio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNQv3Bio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCB2C116D0;
	Wed, 25 Feb 2026 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983618;
	bh=8ES2urm8JWDC0wYiDBuVe4B3bTdwqx5WULP50NhXjA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNQv3BioAbWGnpCsEz3A+XZzYUAPdPy1XnjPSn3tU4dV5n2fFobUl5XsCsPXjMveV
	 hZfLBTkMAzaP7G76jVBBT9vzqPx4bztfUMSagk2gzBiMaeeVR/aeqnsbCuMC5OJg1p
	 Z5pcDxuQqH59SsK8C9P7Dp+MRGh7zASIy9Gu8COE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 712/781] drm/amdgpu: clean up the amdgpu_cs_parser_bos
Date: Tue, 24 Feb 2026 17:23:41 -0800
Message-ID: <20260225012417.209120416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit f025a2b8d93358467b8e8f4b3a617e88c5f02fab ]

In low memory conditions, kmalloc can fail. In such conditions
unlock the mutex for a clean exit.

We do not need to amdgpu_bo_list_put as it's been handled in the
amdgpu_cs_parser_fini.

Fixes: 737da5363cc0 ("drm/amdgpu: update the functions to use amdgpu version of hmm")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202602030017.7E0xShmH-lkp@intel.com/
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index ecdfe6cb36ccd..dac0b15823f2a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -892,8 +892,10 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 		struct amdgpu_bo *bo = e->bo;
 
 		e->range = amdgpu_hmm_range_alloc(NULL);
-		if (unlikely(!e->range))
-			return -ENOMEM;
+		if (unlikely(!e->range)) {
+			r = -ENOMEM;
+			goto out_free_user_pages;
+		}
 
 		r = amdgpu_ttm_tt_get_user_pages(bo, e->range);
 		if (r)
-- 
2.51.0



