Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363792BAF7;
	Wed, 25 Feb 2026 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983078; cv=none; b=tM/YnkgATXzpr4wtC/NkP5SWOj3kSsn7twwMUHl5nmNo7PfXbd6Egz31vqBnFYcHHo0MPO9++5dloWJBH1De5doR2ZzNPIQl+pHVWkIeaKELnq3Bqkqni64usafVRFbCwoLT6uA9HNYtS2e/2HCDydEK8m/ooPOhrEYaYe9cFfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983078; c=relaxed/simple;
	bh=DJCPTLfju+bv+EQmDMu6RMxO3TLzCzHx/28g/Wt7Qj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKp9GGPIRkAJB/HWtjKvZZX2FaL0YZ2KE92V5VQlOS4pPZLTGSJzsMp6VsPmT4LDxR9xOuwAMe5bSzZHymHvnrA8yfIlfLMmZ55sWu2/Fq58P+EKUDIE3uJORT8opb1VQLqwW/vwCjTvuDy27b7aVK20vcs8fZsBrTwBqAtEGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpTAaTLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpTAaTLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE1C116D0;
	Wed, 25 Feb 2026 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983078;
	bh=DJCPTLfju+bv+EQmDMu6RMxO3TLzCzHx/28g/Wt7Qj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpTAaTLgIz1Vvoy4a4SZEV/BrR3hEfg8BRz8MAnzzeefvmFS55QVsvKiEDlVgrRLi
	 cy8aDrvhqq90mNS0j0xaGmb3TJE/j51XFzqpzMZ3z8cyXoL1hwdwi0x1Zh7eCYdUk4
	 n3fizJY6lQebejnzJPbpj3X6NCLn7Spb2I6weGXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 239/781] drm/amd: Drop "amdgpu kernel modesetting enabled" message
Date: Tue, 24 Feb 2026 17:15:48 -0800
Message-ID: <20260225012405.570983038@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 8644084a74a4573278d6f454c6638ccd5965f4e2 ]

The behavior for amdgpu was changed with commit e00e5c223878
("drm/amdgpu: adjust drm_firmware_drivers_only() handling") to
potentially allow loading even if nomodeset was set, so the
message is no longer accurate.

Just drop it to avoid confusion.

Fixes: e00e5c223878 ("drm/amdgpu: adjust drm_firmware_drivers_only() handling")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 39387da8586b4..83567ade84298 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -3172,7 +3172,6 @@ static int __init amdgpu_init(void)
 	if (r)
 		goto error_fence;
 
-	DRM_INFO("amdgpu kernel modesetting enabled.\n");
 	amdgpu_register_atpx_handler();
 	amdgpu_acpi_detect();
 
-- 
2.51.0



