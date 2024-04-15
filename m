Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185BB79B8E;
	Mon, 15 Apr 2024 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191888; cv=none; b=AT0L4/4FtToQSzbGK8cyb3YAcgdFj3hkJhMgCtnLwlT6ts3pRvdE6oMO+kvAWqmJkgBleubuJu0aTXN8dP0CVNSaB7ba9DRDkEc785hBqEQp/e+1kmiN4KsBQOOw65cHKWBb+RVqD0L4DaQgnsy9h5fxqRS2QgtvW3IATaNc3fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191888; c=relaxed/simple;
	bh=XnbVCDjzgMjHvLbIEIob1/3phkRMheXS4pNFTRK7SLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/Tekl0QiKy40ym7Xf3folKZXXHeWI/o3GUwjfN9TNWK6CODUSjtsi0Jugl1fhJwqvbps/rYmf4t4Nc88Pr1XpdLyIVJ0s5YiTLcOW6y6cRiwHqJ75Nrg2GkrqtDG+sgZ6ei1a2U8BDbKPUOOSlmTyUGdcOMGRWitk2dOGiAzjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWOaaW1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWOaaW1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9619DC113CC;
	Mon, 15 Apr 2024 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191888;
	bh=XnbVCDjzgMjHvLbIEIob1/3phkRMheXS4pNFTRK7SLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWOaaW1KE90goZln/QYstvrWqMYHCrwYJHukBYsQl/wSGk/ThLg8TKr2/Ycj350tv
	 aUgg3FxexQoCgIm5aKCFzyM+0GAQDudDwV9YE0e59AxF/F3uQCB9NDgVgd+lECc1K1
	 ewy3cVrjhcNgfTHUpcnBDZATfqNVnRN/6n1f3lNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 118/122] drm/amdgpu: always force full reset for SOC21
Date: Mon, 15 Apr 2024 16:21:23 +0200
Message-ID: <20240415141956.910078126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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
@@ -449,10 +449,8 @@ static bool soc21_need_full_reset(struct
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


