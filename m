Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93F653F69E;
	Thu, 17 Sep 2026 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664923; cv=none; b=WUvUhhabkc2iVHfx1LS3nt41e7R1JrDS081xhbGEueDDuhNIBypV7vtTWM3TQRN6IagAj4rk6wrRtyy0WMCdOAzhRSK1EcrMxYFMTnu4yNwUaGeAGzYI468Ocb2K8YLUt5UF/Y9XBxqUwjIoWELvX4oqiXVeKY8ipRiVo12vbW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664923; c=relaxed/simple;
	bh=y4t5uJ1wKVfIX2q3gBpbV4FrKTCTtVU2pRVkft224JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jxZLCEuhe6OHvmQ4mKV26u7Pje+SObYD3e6YY7GmPjAidQHwtFibjsPKEBrVOJNADVx3/kRZABegGX+sVCCAOouGDckDKApf+V6ETYSbjyTFfB2do4NFrnUsbz1kV8jtZCmY2X1j0s9ay9LDYpc21//dqonjYfvIbPPLJHzBT0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL5DnSP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL5DnSP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2051F000FF;
	Thu, 17 Sep 2026 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664921;
	bh=+luRIE6PXNuOZStb4/FX7YzsxTaTIrX+xvMBVBhIm+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL5DnSP4/rAPANJymZzHGtPl7Tcydb6efqoqf1/al/YeRAdXjy83LpM+30g0S81un
	 hbYRlL3QBYofXAqctfOffraATNW+gI6RMFpee/Y+RyhODj0g2JsRFyL6jxpUu0WUVh
	 /ShFALNqN/5tXeGd8eL17XiqAQhBrHl7+2dFhAMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0533/1250] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Thu, 17 Sep 2026 16:05:28 +0100
Message-ID: <20260917151606.385060461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index ea97276358c0a..39928eb71d669 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7690,7 +7690,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



