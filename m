Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09FD4CCDC1;
	Wed, 30 Sep 2026 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782789; cv=none; b=n4OBAWnVLa5Z6u8rp84f2myDFSYP4HQVw5JcY3IbCC3cG6/swkX3G6Zc1uUHWiuC0vI/VL9YKqRcotg8RlKhEIp7aOgLxMDNWZ+H2i7M00cikAj2oRaxVimY0qcduR380r2NQbwWO+lzmMLjPtdUbdo4ybe/VVVLLEtaJrDfwzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782789; c=relaxed/simple;
	bh=zBVLMCq1aOJw0THdp4dxL4JoUwd+wwC1ed5gmq3VV7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3hi5FyFEqtEkbQ08Dg3l4YmWbOtnBmJOMvRjCCaMmT9BoAD9HnzeErJXDyHEC1ycfadYLD9OfZdGx3BeUWnAESbtE59NcRjvBucfI3p+I+58nGY5nSGAmBPhg0z1W/vgpRQn2g2NP7X8sNgf9AXWgyEAUHXrJJimR6ClCkWxcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnBtkN+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnBtkN+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEB1F0089B;
	Wed, 30 Sep 2026 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782783;
	bh=MqW4pHhGp9CxqzuSanarxI7x5y/3BEChGp6hpwlOEWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnBtkN+mLszqaU9ZIK7PmKH1JVW8S6u2JG9OgTMjoU3s2zpfSgHfa4JczNXto4Aqn
	 VkNAjnNFa51FjiY0WV6+Us479Kk5NI8jYGjLsxBIxF8Jz+ZvxirIG0TGa3F+bfjCDG
	 ltbmpfWREKrlHaGt9NHlVB233IzhHNckKrto8buQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/595] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Wed, 30 Sep 2026 17:21:02 +0200
Message-ID: <20260930152351.374486839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f8922d5a946699fc2bdc7660e6778bd6726bf8b8 ]

When DPM is turned off with the amdgpu.dpm=0 module parameter,
the thermal work queue isn't initialized so we shouldn't
schedule any work on it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd018d36171a695952c6d391471c279c9e05c8b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 6062bfec0e04f..f4bb4d2c3f77b 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7595,7 +7595,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



