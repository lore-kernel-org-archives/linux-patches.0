Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C021E4B1;
	Mon, 15 Apr 2024 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192107; cv=none; b=cQurYS/42gt6mXa0C+leQR3xlV7uAkLLZMg0ymjXLplCwFR19+vRiGeEbqvi+0/RrVo87pw5wMiqDgChpRzhrI9CYrSEghc5IWdnIWFEzo8cvfShb0NVCK2CsEDcoPP9zWOj7KgyumJcxfo6vokLWyEk6Ir5lqXMvLMUByAFVa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192107; c=relaxed/simple;
	bh=gHIMn7qE45zii4OKtPz6KS1tlDBTo1l/yIXCMxDv+pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0z+ZTHh1aQ7GvKK64nqFBncBQJvvzMUzfmkNa64IAwdC37sGNSXHKA4BBk6osI8u7/hLFwgJxLIUo7iBD0LTswGXumK5Kh2NpBSrGg4tUV+hUhgw9xN2pT33IqwUOiuufUg98V2Yf4XZa3L7bl9Y4RM9y7oIPETmAwLJZ6X3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gksk1+oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gksk1+oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF61C113CC;
	Mon, 15 Apr 2024 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192107;
	bh=gHIMn7qE45zii4OKtPz6KS1tlDBTo1l/yIXCMxDv+pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gksk1+oIQd1fsepNDCH6q5ZHMpxv1QgtmMGjsjvvsQglD6S9Bg1nBlSMIAlG+osmM
	 8PBjVxiLJXESUvhmM54UkV9t3WD7FpzpNdJoG5ICXJdcIvK3orx7gVkUHHRBkBQkVz
	 FE7wljNalLy9Kyab5D7/vYISZnuT1FFxhnPyoMUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 68/69] drm/amdgpu: always force full reset for SOC21
Date: Mon, 15 Apr 2024 16:21:39 +0200
Message-ID: <20240415141948.217878630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 65ff8092e4802f96d87d3d7cde146961f5228265 upstream.

There are cases where soft reset seems to succeed, but
does not, so always use mode1/2 for now.

Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -460,10 +460,8 @@ static bool soc21_need_full_reset(struct
 {
 	switch (adev->ip_versions[GC_HWIP][0]) {
 	case IP_VERSION(11, 0, 0):
-		return amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__UMC);
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
-		return false;
 	default:
 		return true;
 	}


