Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B69721CA1E;
	Mon,  2 Jun 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873780; cv=none; b=e7Zn2R+L6kR5E5NCFf4uEt0RAMAyRfkvJpGVGcbXY4T5CVqesYhI3ST4Jj+yucZSWcyvq3FGrA5c9GFr/SY8E+GTW/hYWI6AFMYHRuT9X1dad9TrLGBQSpRphc3ErrqQQboLEHeQsCMbi/TnTqiyHIiJCMAUiJB3qGyI6VsMER0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873780; c=relaxed/simple;
	bh=8omp5pvSIUUhOfUr77BiNwpS2/zoXLMNed4juKEJyHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EubMHfq6J0uvDmMgFHb5YGH+o/O9HU+hKc5WkzukwiqE6KEKyXIgZxwFWqvQHpd3v+6h6wu+yn1WpGdzNphNB3dyugTJCv/DM6nsS45SG4FlTjL0Pfpt0Ob6XajD80kiiioVF6Rul/m+PK9H+H7a9ts+W+sYqFqi8bCRGxEQkYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPNkfGNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPNkfGNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F146BC4CEEB;
	Mon,  2 Jun 2025 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873777;
	bh=8omp5pvSIUUhOfUr77BiNwpS2/zoXLMNed4juKEJyHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPNkfGNcxZotrC3zRAg5dNUbUnE447Q2V2V6csh6mtQJlWjlGAdiumyq54cAvkChJ
	 csVGKwFQrDvTWywUBYrFHOkY7VXaltwuAjm4gyBySaSoZ468B7fcJ0uJLSOmMfuwFb
	 cv/TmHXw2JZQNS9Dy2zA+HFJR/BZH5I9jsV+VmSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/444] drm/amdgpu: enlarge the VBIOS binary size limit
Date: Mon,  2 Jun 2025 15:45:13 +0200
Message-ID: <20250602134351.023999673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 667b96134c9e206aebe40985650bf478935cbe04 ]

Some chips have a larger VBIOS file so raise the size limit to support
the flashing tool.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index a4ab02c85f65b..ffa5e72a84ebc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -43,7 +43,7 @@
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_atomfirmware.h"
 
-#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*3)
+#define AMD_VBIOS_FILE_MAX_SIZE_B      (1024*1024*16)
 
 static int psp_load_smu_fw(struct psp_context *psp);
 static int psp_rap_terminate(struct psp_context *psp);
-- 
2.39.5



