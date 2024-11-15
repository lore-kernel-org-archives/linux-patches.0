Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EAC3BBEB;
	Fri, 15 Nov 2024 06:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652797; cv=none; b=NdKmO0UkLQcUJ7fOVfjRsnrUDMXzi3HmoZ3VLHHQ2NwaOasUbqGTV/xnV7fXEssVIRxRsynU9OfwKFDqciffDrb6lXYrOOyPCxNg1zudMP32DPs/tMibnzth9rhOYwqtAAAyBCcLcjAZu1dgOwbNRwigZU3sCfyKIuC8I5nHQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652797; c=relaxed/simple;
	bh=Ny2yRb5vs52NJHY+JtbD1FsF9ucqMWInu1s27G4jp5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTNE7h9/ttGSQrAJ4R4Ygom4+Tj9f9OmnOZHwt0iYFSf5kzAo+5/sY+hIiYa/wmnOu0nFH+9NN30Ol/d2CFVgzXDD+5i33RfPMHllme5e1j9ynOb8aZxDlWn2rsKfuMYCIg7qYvRNDwKTrcDm1wS1IxPYrobsmevlXsUa/GJI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mkx73o0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mkx73o0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C46C4CECF;
	Fri, 15 Nov 2024 06:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652797;
	bh=Ny2yRb5vs52NJHY+JtbD1FsF9ucqMWInu1s27G4jp5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mkx73o0gzkALE20DRtjMTpdfELFpWyz/h/NOD7jqNcWIK8KAIskqfVi0eM/ULXLpH
	 oYxl0Jx61upHr4NfQZgok1NfEu4d5GLG+0vFonduEJMxMgxDq4dFyTkgCZFlamB0zl
	 RJjeXZlp6HKB0TIue6Sf6expJHulk/eCkRyrD204=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 18/52] drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()
Date: Fri, 15 Nov 2024 07:37:31 +0100
Message-ID: <20241115063723.513259824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4d75b9468021c73108b4439794d69e892b1d24e3 upstream.

Avoid a possible buffer overflow if size is larger than 4K.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5d873f5825b40d886d03bd2aede91d4cf002434)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -394,7 +394,7 @@ static ssize_t amdgpu_debugfs_regs_smc_r
 	if (!adev->smc_rreg)
 		return -EOPNOTSUPP;
 
-	if (size & 0x3 || *pos & 0x3)
+	if (size > 4096 || size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	while (size) {


