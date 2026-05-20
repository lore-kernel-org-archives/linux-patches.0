Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93C331220;
	Wed, 20 May 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300447; cv=none; b=gsz2xMs7keS3cTAhnp6HxXZBgP4AacUPhZcBVlSLMS/lqfvRRAr8uGSGQJeab4g0zRKLsiLCTZNtR6QmaU7/g12LY1CfUGpw4QBVLjs3sY/+FL8J5XBtxoarydWI6suLY3ZcYlksE/H1NTszm2835JoYby2foUvM5EUg/M0pCG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300447; c=relaxed/simple;
	bh=gsyjhKBrBHIkTTrSgjF1Z1U5yMyVblG9ttfJzIodz64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWebp7SGsXGL4aOiUOncjfXVhmBIvJzbp3ZAFQnG3zjoxVXkHvrfcQ4LNec6uE1Hbt4CLVAbn1ArngCHBJmKJNwWc16GSdAMFUNrIAF8c3JoKSR1g6wVRcE9mWysw0F+7nuEHZVN+IQCYxxEmWHjo7lm9G0x+PgV50EGk3tAG7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc3uJ0S7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc3uJ0S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69A71F000E9;
	Wed, 20 May 2026 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300446;
	bh=f2iKAybO3VIGeU14GfeLQK/6vudEkx898gHr9zggxuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tc3uJ0S74MwkDx865WepUBc3Mrd+Sk6wRvJvwnVRtyACR3bQpOUPOC1M4EUzMlAWA
	 AA9TyNl4rzZgYH6J99xr6e3eGV6tyHN8g50NReXwKA1uXI6uDJxvTs6SVBbEeFJMry
	 pywjWF77bIN6VSMHRfdx7S5MHMs94nwBxHLjnOuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/666] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Wed, 20 May 2026 18:16:30 +0200
Message-ID: <20260520162115.080070646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit d784759c07924280f3c313f205fc48eb62d7cb71 ]

There is no AMD GPU with the ID 0x66B0, this looks like a typo.
It should be 0x67B0 which is actually part of the PCI ID list,
and should use the Hawaii XT powertune defaults according to
the old radeon driver.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 71b1dad34926e..1d99b4f9bc03e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -245,7 +245,7 @@ static void ci_initialize_power_tune_defaults(struct pp_hwmgr *hwmgr)
 		smu_data->power_tune_defaults = &defaults_hawaii_pro;
 		break;
 	case 0x67B8:
-	case 0x66B0:
+	case 0x67B0:
 		smu_data->power_tune_defaults = &defaults_hawaii_xt;
 		break;
 	case 0x6640:
-- 
2.53.0



