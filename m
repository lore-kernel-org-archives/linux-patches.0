Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6005C18C331;
	Tue, 10 Sep 2024 10:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962872; cv=none; b=evI47PCKqFbXymw00MKPIPwBwZNmvsM+WEPYUpnxkIHXtcxgQK4fk3MvcXnSFrOmwyEhWpWyR2BNHcY7vM7kMIaC6Ge9f4e+dRwy01tI51Lr2f/IUH5Xmsr7IFSsEILC77HIbAN/bFJUQVnXd9Mj6ppwvSe4StpO6uf9Y2GQT6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962872; c=relaxed/simple;
	bh=Wr+SzdIvNrXuXiP0MF0itxeo51LqNaA/gCPxHBWUEsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab9hFLkfxSnnANea0GH4Tn4saWR8IBIvPk7R2HfETa3YQ581h+5Jb4gQVafQdT9ZYZl4L6RweM4Hs74lc2bKo7s7BgxdCC4Z9QH54TrfC48nGhxL4ZL42rBupMcDhQiIjverm74OmC7/xRl+h3tuj0Mqsko6jNCleoPrfLJtTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIZCi21l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIZCi21l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0316C4CEC3;
	Tue, 10 Sep 2024 10:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962872;
	bh=Wr+SzdIvNrXuXiP0MF0itxeo51LqNaA/gCPxHBWUEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIZCi21lXFd1JqQK+VrxHeqKQobejzVwZtrrx9Tgl7VNp7/2QXndIZv+DQVE2EY3F
	 wyPpFEmGBQmlkXhKdEmzZr2aLuo1W6oxKe6g79Hu0oOXPfZtGUrXvg94YUoUR3hfKS
	 5Z+36QB+Abg130UKfSdl9LvC87ksUBUhTAJPQISA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/192] drm/amdgpu: Fix smatch static checker warning
Date: Tue, 10 Sep 2024 11:31:23 +0200
Message-ID: <20240910092600.404961357@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit bdbdc7cecd00305dc844a361f9883d3a21022027 ]

adev->gfx.imu.funcs could be NULL

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 1f9f7fdd4b8e..c76895cca4d9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4330,11 +4330,11 @@ static int gfx_v11_0_hw_init(void *handle)
 			/* RLC autoload sequence 1: Program rlc ram */
 			if (adev->gfx.imu.funcs->program_rlc_ram)
 				adev->gfx.imu.funcs->program_rlc_ram(adev);
+			/* rlc autoload firmware */
+			r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
+			if (r)
+				return r;
 		}
-		/* rlc autoload firmware */
-		r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
-		if (r)
-			return r;
 	} else {
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT) {
 			if (adev->gfx.imu.funcs && (amdgpu_dpm > 0)) {
-- 
2.43.0



