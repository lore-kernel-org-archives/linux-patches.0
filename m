Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C0F14076D;
	Tue, 23 Jan 2024 01:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972020; cv=none; b=FHyhwFy20DoFLVqDnGJNTrS0e88J/ZCo65fPuhmclBIKeCnuB4zNyuj5TuD/1sVM/IkSWG8OeXI2nH1BeMdVooGqbfR7/c7HSOM+bnh+Pfa1jLMg5TrtYMcFdSLtj3uqI/LRy1dlF5Fx4rgm3q1nov9b2wM/lCvzDZwIsh8nau8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972020; c=relaxed/simple;
	bh=ywTn0/C42hr1G8GKR1Soau/qHM7ZRjlC4fOTUZCC+v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsdyg6LgBGbF8xQfkKLBmOXP1AKcHYHgiHvrmDlUNprxJ5An0Is0yoQYlNggm2GowTBH/BOdZo4pm1oASibPpXnbpN5MX0l4GEkszmAgDjHah7zGBoF5W62V9jgTGKQYS/AXUauOY7WW5Gr/5PaVSez+80+mHC3YwyabcrgCFtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/IfxMf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/IfxMf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6F2C433F1;
	Tue, 23 Jan 2024 01:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972020;
	bh=ywTn0/C42hr1G8GKR1Soau/qHM7ZRjlC4fOTUZCC+v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/IfxMf/oo5jisbveTpVrUfsUnicuOqaUiihwDk28zRBaLYtGEkfSantVQ70n0lOh
	 Vib48hI8kZW6ZjO1uqmh1wx1tvt+lsdAKDueEjMGFnCsy1ktoWwLG8N4+HzaGXh/Ww
	 cKpWjGBASqOrJAByJYkO7+EfqNqwocqhAYqQ+vFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak R Varma <drv@mailo.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 391/417] drm/amdkfd: Use resource_size() helper function
Date: Mon, 22 Jan 2024 15:59:19 -0800
Message-ID: <20240122235805.308729869@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Deepak R Varma <drv@mailo.com>

[ Upstream commit 9d086e0ddaeb08876f4df3a1485166bfd7483252 ]

Use the resource_size() function instead of a open coded computation
resource size. It makes the code more readable.

Issue identified using resource_size.cocci coccinelle semantic patch.

Signed-off-by: Deepak R Varma <drv@mailo.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 02eed83abc13 ("drm/amdkfd: fixes for HMM mem allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 88bf6221d4be..2d011daf5a39 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -1038,8 +1038,7 @@ int svm_migrate_init(struct amdgpu_device *adev)
 		/* Disable SVM support capability */
 		pgmap->type = 0;
 		if (pgmap->type == MEMORY_DEVICE_PRIVATE)
-			devm_release_mem_region(adev->dev, res->start,
-						res->end - res->start + 1);
+			devm_release_mem_region(adev->dev, res->start, resource_size(res));
 		return PTR_ERR(r);
 	}
 
-- 
2.43.0



