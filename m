Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C24E221D88;
	Thu, 12 Dec 2024 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018242; cv=none; b=uxl4Xhx1Xzq5W6G56kVCyZsqWH5sxBBNUv+FWlk5UcNIU4+OLli8cNMEAlrWv4huEiKJ+g4/OGABfIEhDuX88DXmn3etbngs5S7KODhtauRaK2RffEFfb3W825BBJNqAxNI9ozNhjLYjGcmzLjMC7PV3nbLNgCv65l9h6iV0pEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018242; c=relaxed/simple;
	bh=Q4RKRNLv+9UKKSwFWVsWbAIthjJMiKU2im4fjtblZUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZ1UeA1QYMBUgK264PQJvnIi9Sp11ajx//wXBajcBqwvzMf4R0/+9LAJpWmIl9NIgbGh8nMpU7GODnKMdPgualWhL8jBq/cJucoRiu+z3xufl2VpeQV6+6bwljdFuQbZJC/Bw9PA7iFq8cVqHgBb9PsCdffVbrcO43zzA+075XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx/D9yqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx/D9yqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BCCC4CED0;
	Thu, 12 Dec 2024 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018242;
	bh=Q4RKRNLv+9UKKSwFWVsWbAIthjJMiKU2im4fjtblZUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx/D9yqHDF395VsVg/l4rEX37jfiOCKBV9kUlXA3iXeOzsTYlgx8eIegCCqdlK5g5
	 6gCf6c9jLGfVIHn3l8NEvwqcTmVFKLqUN0Oh2fAVmya76mf8A8N2tTIIre4eUchefi
	 muIIB7UE4SanTCtqd3soUW5NSeeGE0sQu1NjAKc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/356] drm/amdgpu: Dereference the ATCS ACPI buffer
Date: Thu, 12 Dec 2024 15:59:18 +0100
Message-ID: <20241212144254.055148768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 32e7ee293ff476c67b51be006e986021967bc525 ]

Need to dereference the atcs acpi buffer after
the method is executed, otherwise it will result in
a memory leak.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 12a0ac42fcfea..8b2f2b921d9de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -798,6 +798,7 @@ int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
 		return -EIO;
 	}
 
+	kfree(info);
 	return 0;
 }
 
-- 
2.43.0



