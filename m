Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D3F1D545;
	Thu, 23 May 2024 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470844; cv=none; b=MsokEQRq/eAUM9/UCIYogzyoxm2TV1RpjzZ2vuSq/1/+E9vWniCPyp26ESl7Pp1VkAGHkt9ZEI7v81t0awmEKXtXp51D0qx01a8nN/1s8MKKBeqRilVruklsNiqdsfg0WI5AIefkg5bSXkE0Nun+UNLwrVH5JCz3Z2JJ5qMWyAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470844; c=relaxed/simple;
	bh=EpKvlF2t/AmjL50Ob+xS9/WCSeqm26KCKqJZiebMbgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9mxyUQYoikusPrVLZl91CBxxbPA/jSUi922sFVE7IZGUaly/TBnSY6vLqCjE5fQrrGO2jFIOhNIN+Itde2PRsQnUSiKQLkaUqJgz86w5gI2awgL8Qn3V6HdVMqcUe0Un8c2ZeuInzdsGB6g/H0IqZzL3g6EINeYF/Y9O6miewA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6/SG+7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6/SG+7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB87C2BD10;
	Thu, 23 May 2024 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470843;
	bh=EpKvlF2t/AmjL50Ob+xS9/WCSeqm26KCKqJZiebMbgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6/SG+7U0TEhsLjj2EonI1x/dC/ETI89LhIGps/GgtRloATMw18p8o7WRZVVxUGjt
	 +hDZDRvUmOamLihulDy3p53N9O2iPKFBOdLOucGQZH/NKy4JqmPb3nD2gwLen02fxy
	 sFTGxZCR6ukZU8vwaTnYie/2Ta6JzdZKoRHHioZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.6 089/102] drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()
Date: Thu, 23 May 2024 15:13:54 +0200
Message-ID: <20240523130345.825503429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit b8d55a90fd55b767c25687747e2b24abd1ef8680 upstream.

Return invalid error code -EINVAL for invalid block id.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1183 amdgpu_ras_query_error_status_helper() error: we previously assumed 'info' could be null (see line 1176)

Suggested-by: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Ajay: applied AMDGPU_RAS_BLOCK_COUNT condition to amdgpu_ras_query_error_status()
       as amdgpu_ras_query_error_status_helper() not present in v6.6, v6.1
       amdgpu_ras_query_error_status_helper() was introduced in 8cc0f5669eb6]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1025,6 +1025,9 @@ int amdgpu_ras_query_error_status(struct
 	if (!obj)
 		return -EINVAL;
 
+	if (!info || info->head.block == AMDGPU_RAS_BLOCK_COUNT)
+		return -EINVAL;
+
 	if (info->head.block == AMDGPU_RAS_BLOCK__UMC) {
 		amdgpu_ras_get_ecc_info(adev, &err_data);
 	} else {


