Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E93757FB;
	Mon, 15 Apr 2024 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191507; cv=none; b=NNm2UHibiCHCo3QWr0f4xUNZMF/i6PdltiUWQa82dLJlMqX0NjAW7rvsRxuGmQ+pvjHXkv43QKA6xhz3DWds7N4zbKXV9eSrZgRyrY9hEnr0wpRxxzCwLICBoamnmqg5t196nx96i6SL9JraGammYReMTS1WYpTkVYq7exfclGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191507; c=relaxed/simple;
	bh=usJLt4axeKYWFqxayiRD1gpqamN9+qxx4tJOe34R9vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIdIY6EydwWRP1tyK7FZIYb4rtPPGm9m8a3tAgI/GdN0RFMe7IjROCnq/vyLTxDDOlzrOlVHtV/hgd0wMkjbe4cLPfadaP81YUZKrVQmTIMeR7YZB547R6BFJijJ0nkGqVxx1J/bGzPSnNOciTjnWOEdczAYDQyOkhNW/2LksoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx/uWeoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx/uWeoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947F1C113CC;
	Mon, 15 Apr 2024 14:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191507;
	bh=usJLt4axeKYWFqxayiRD1gpqamN9+qxx4tJOe34R9vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yx/uWeoZCwwpS2bpGKmDpO++cPZOqEmH6c6uqZj3We7Xb27E1kFWRSJWTanjSvH2c
	 iyZb7e1Q1+nnFqjIMp+n1WNO4yA0s1w3toc9J0EvmuNN9i/UzppGsNE4X/foeIg5N5
	 9KCmsoZIQuwvU5QkXosVvwml1d1KLqz0vPpqsVfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 164/172] drm/amdgpu: always force full reset for SOC21
Date: Mon, 15 Apr 2024 16:21:03 +0200
Message-ID: <20240415142005.333138988@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -450,10 +450,8 @@ static bool soc21_need_full_reset(struct
 {
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(11, 0, 0):
-		return amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__UMC);
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
-		return false;
 	default:
 		return true;
 	}


