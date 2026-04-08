Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DDE3176E4;
	Wed,  8 Apr 2026 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674721; cv=none; b=NdWQKSjfdtcgQrzopQrH2Wmq08M0yE2Pup4DVufMm7Da1kh5o0Gc7F3qxIvhzkfXd5pHwmKXC8juzdCxfZKuhubbWth1QEhtiPTpeBd72mZ/SDda8RPBo3U/4B+Nal24hUmRNBlpVsvCFUFdd32VDu877GiaYUY/tm999wXLQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674721; c=relaxed/simple;
	bh=1iuTqwg9wUqi8dWkoOkVr44/gyWOUZrmWMUuX5bA3ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZqc2i7sAE/5FlXMn1lo0lSTtdQkwBtEFhsHlFHAKyAEhXgekC8JcsWbV/B9QrkXiFwVhNz/4rW2cvO3mmjqmxjeKkac+iZ0aYKglc8tNgrxcZyIIfuljqB52XeQdmzgu+fpJLcHGQp0YbPz2+c7mTIMcqvqQAvn2Jh7VKjNvuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKaHIwnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKaHIwnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3718C19421;
	Wed,  8 Apr 2026 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674721;
	bh=1iuTqwg9wUqi8dWkoOkVr44/gyWOUZrmWMUuX5bA3ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKaHIwnpM9pi28ZcALWt6xFdscw+fQGfbN0guUZJ7FCpTwqgS0swAsP79YKGDtk1Z
	 IZrhRoF/2OAbRtouEBGTiKeXBKfRb1fC+ot8Dlbg3PW64EzdMzRpT09wXr228erKDz
	 7pBhzfuKdI5F7fTOBX4NqlPp6cRO0BTXk/MOJ7Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 206/311] drm/amdgpu/pm: drop SMU driver if version not matched messages
Date: Wed,  8 Apr 2026 20:03:26 +0200
Message-ID: <20260408175947.098770041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a3ffaa5b397f4df9d6ac16b10583e9df8e6fa471 upstream.

It just leads to user confusion.

Cc: Yang Wang <kevinyang.wang@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e471627d56272a791972f25e467348b611c31713)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    1 -
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c |    1 -
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -262,7 +262,6 @@ int smu_v11_0_check_fw_version(struct sm
 			"smu fw program = %d, version = 0x%08x (%d.%d.%d)\n",
 			smu->smc_driver_if_version, if_version,
 			smu_program, smu_version, smu_major, smu_minor, smu_debug);
-		dev_info(smu->adev->dev, "SMU driver if version not matched\n");
 	}
 
 	return ret;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
@@ -101,7 +101,6 @@ int smu_v12_0_check_fw_version(struct sm
 			"smu fw program = %d, smu fw version = 0x%08x (%d.%d.%d)\n",
 			smu->smc_driver_if_version, if_version,
 			smu_program, smu_version, smu_major, smu_minor, smu_debug);
-		dev_info(smu->adev->dev, "SMU driver if version not matched\n");
 	}
 
 	return ret;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -284,7 +284,6 @@ int smu_v14_0_check_fw_version(struct sm
 			 "smu fw program = %d, smu fw version = 0x%08x (%d.%d.%d)\n",
 			 smu->smc_driver_if_version, if_version,
 			 smu_program, smu_version, smu_major, smu_minor, smu_debug);
-		dev_info(adev->dev, "SMU driver if version not matched\n");
 	}
 
 	return ret;


