Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4FC7E767;
	Wed, 21 Feb 2024 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524412; cv=none; b=CMI6HXQRIUfYDrYnSp2XyreORGQJbEVD5ORTwzmaw59sEMWiO79+nraXAYb4OLiwXdgbQHl73CVCmWvi2Z290pnkb9gRXfX71Olp81nFAkR6F2lRGrmY/dkKn6V5Co1Lm6eixClUkHbH/NAqUXxRHscGSIRiYo93HgbewImgMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524412; c=relaxed/simple;
	bh=G8aSavgGwaCY8E+2Q1az6S5YzeqhZk0hqNel1aeajs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBXlfNA+80lvt78zJLtilq8cVuHX9adaGC2j/HXSCXOHEs0HUGkZqsfUn7TTaDfwKqjM73R24VwS8DmpmOs5tf4x8FNWX/ioYS82ri4QPW47bE0NocklC2bNr9hfi13qrSit1YbcZ+WJJlSdem9UuG7LllCRZSKEZc5hErX4bTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKJUL0K/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKJUL0K/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD32C43390;
	Wed, 21 Feb 2024 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524412;
	bh=G8aSavgGwaCY8E+2Q1az6S5YzeqhZk0hqNel1aeajs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKJUL0K//NwelXC9pdfjigdzO2EECCQAHOPepsdqFhMx8blEmBaJ4H+QscJJkz/cy
	 LNVq3FmHlpdE/y8GzqkDzN0zZUaEyp8nZPpcHfneT1Vz5CVgujZBuAMY5ngb7zGPAj
	 SfSQnDjtnoXU2gf6jjjKB6CaFt7B8UHixSb45yS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <JinHuiEric.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/379] drm/amd/powerplay: Fix kzalloc parameter ATOM_Tonga_PPM_Table in get_platform_power_management_table()
Date: Wed, 21 Feb 2024 14:06:37 +0100
Message-ID: <20240221130001.351620668@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 6616b5e1999146b1304abe78232af810080c67e3 ]

In 'struct phm_ppm_table *ptr' allocation using kzalloc, an incorrect
structure type is passed to sizeof() in kzalloc, larger structure types
were used, thus using correct type 'struct phm_ppm_table' fixes the
below:

drivers/gpu/drm/amd/amdgpu/../pm/powerplay/hwmgr/process_pptables_v1_0.c:203 get_platform_power_management_table() warn: struct type mismatch 'phm_ppm_table vs _ATOM_Tonga_PPM_Table'

Cc: Eric Huang <JinHuiEric.Huang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
index b760f95e7fa7..5998c78ad536 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -204,7 +204,7 @@ static int get_platform_power_management_table(
 		struct pp_hwmgr *hwmgr,
 		ATOM_Tonga_PPM_Table *atom_ppm_table)
 {
-	struct phm_ppm_table *ptr = kzalloc(sizeof(ATOM_Tonga_PPM_Table), GFP_KERNEL);
+	struct phm_ppm_table *ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
 	struct phm_ppt_v1_information *pp_table_information =
 		(struct phm_ppt_v1_information *)(hwmgr->pptable);
 
-- 
2.43.0



