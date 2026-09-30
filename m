Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D76B3F5BFC;
	Wed, 30 Sep 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784768; cv=none; b=drzjUlsT3Y5Tgys9kUYDkH+/J9UNvhwqGFCrDKxZO1tghajh/gydgarfb5wGT1s4WrPPUBUGdEx49D803lxaSaPxKzpQlK5hmGG85+aF6aLfDf1gYj5eCWi7g2WNvsPWYydK2mt+Vp3WqiLEsOEXiveS8ZrkBIKuOh9bVQW8WWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784768; c=relaxed/simple;
	bh=oMX2B8Y0pk/ES4OG3opYDCaM8fDzhKKCGlG2UB3dx5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k72QAJ/Q54geiDdmQntnjoJTbqY8leCO9ICZFAg5Ex5BUhY0SLvE44YBYOuxIw8iZfeuK/OZxUnYJGs4hNYS7c/WnggZwm8KpdudF0kr+QNfxBs/D4GbYs1zR3JlmKMaDwyOh4/bnPA1qrDwz3lVWobuyJUy6GBheBIWbiPy+Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxCX3v1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxCX3v1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EA91F00893;
	Wed, 30 Sep 2026 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784762;
	bh=98rqMoFqByx2Khgysy19lNnFpHwZ3s74+Hi8A/OzWxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxCX3v1lbD2qz8dcxn2ao3NL0U0Qgy51rdedJU+fwogSd0JUvKJH3xoXnJ88dRHIU
	 Bd0BGZCtS2YUllP0D+5J5YnFrKKa21/KaHb+Kuoqq3Gyyps7Sd7BU5sVDZ3pafJr85
	 1sTX14hXw9czIuIxObVpoxO0o0VTDZEsQwC6Dkjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/982] drm/amd/pm/si: Dont schedule thermal work when queue isnt initialized
Date: Wed, 30 Sep 2026 17:16:47 +0200
Message-ID: <20260930152422.622882312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f71585ae68498..be70e2b6376a8 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7670,7 +7670,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0



