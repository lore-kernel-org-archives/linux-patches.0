Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8325527604A;
	Tue,  8 Apr 2025 12:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115962; cv=none; b=BKGOfnTLsuqJoH2YMGSx+OpGmOgzpJKFnHF13tF/TKlYkUXhaDELbYUSc72U+viaHHzR3bec3xI/sGxWUPVcV+fYVFGbIldiqMokZmHMNAHH25W0mouB4LOYaMA9pvnLr8VCzC1I8+edkfKtTheQSYzp90GhFzIO1IepVACBI4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115962; c=relaxed/simple;
	bh=W03f4jkNmNJJjmvA76597EC2jxLyrz1NMpdrTHMaWM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEvzCfWKjcZ1xcZFYHKs/kjv0iLDMmtZ5GkNAQFpI/m9MqHRNR4OpaGtl5ZyRohAHNr1Y4FRs/xTtaZDsdNqr9I/Mm52f6jWojYgEeFQqZpdlA2LUDRQEKfn1DLZgL3urCpc5xg9isw46iiuK9G1A/1j175++1ni/q2Q3rsyZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK8RSHXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK8RSHXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FE8C4CEE5;
	Tue,  8 Apr 2025 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115962;
	bh=W03f4jkNmNJJjmvA76597EC2jxLyrz1NMpdrTHMaWM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK8RSHXD0praWmh30FCUkp4Yft82LUAuEU/dtR2Ju511hDcQ2VU81gtfM1sx3pQGY
	 6v81kW9t3v8odldz+njwo5JkNf7wqBC3ByitjAmbXXSwaPSikOg1WmabZLNKVgor9d
	 L5HQkZOyXCzq1zKJwnsKNJXSuRA8GutuiYEhwNcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/204] drm/amdgpu/gfx11: fix num_mec
Date: Tue,  8 Apr 2025 12:51:40 +0200
Message-ID: <20250408104825.307197426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4161050d47e1b083a7e1b0b875c9907e1a6f1f1f ]

GC11 only has 1 mec.

Fixes: 3d879e81f0f9 ("drm/amdgpu: add init support for GFX11 (v2)")
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c76895cca4d9a..61e869839641e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1301,7 +1301,7 @@ static int gfx_v11_0_sw_init(void *handle)
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
-		adev->gfx.mec.num_mec = 2;
+		adev->gfx.mec.num_mec = 1;
 		adev->gfx.mec.num_pipe_per_mec = 4;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
-- 
2.39.5



