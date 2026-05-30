Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFD481DD;
	Sat, 30 May 2026 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161083; cv=none; b=eHkag+gtaIvmB1niURsl2kbkeHKDfLM1q71aB4mphcGKUDN8GOHVmTO9OtasKYhyvJpYjLLOudEtzP8f1fupFXT9JK5M54a5azO1i9Z5PYWvqFdrdckNNpfLQ7xkrJvDb+Sv9bePFwL2A+7128S2DlqFSFDLBJg2/0F/tpl0g5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161083; c=relaxed/simple;
	bh=KBRlM2WzTpRkgy28tAjx0buOuoYz/+q2kWKflp2P8ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbg44JNGzkdh4gHa8uJ7cS1bM0TVpkJNXirDLpz+BBd1us+oCrf02TpxEDw6f7YiCQVDB0CZCYcgV8uIcjPUsps59NM0FIT2Capi2jBaRhUAuDI7mqIv+OiaUeDFtywfr+Ps3uDG7cfVq3iAZMXx4osadM1Ek4Pw5oGY7ifpRPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvTdgk5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvTdgk5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD71F00893;
	Sat, 30 May 2026 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161082;
	bh=t7k4JAzBgJgmcYGa+j5PGSLAiVfuuXQ1B4Pg6FyLcrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvTdgk5pI2KrsI3UZWDeEd3cznp9lp2aHdVxSrzf8+jeeatqvN7++//M+LQgrPzgc
	 OtfXV0s3dPLLvYD+mRi/BsFElVfPPFhMmPIo00j5lEnogtacy4jfd/RTtYrbAM9nsN
	 JfXuIpnFZj2dHfEdznDaZEeh7cKczdis+eAkLYCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 520/969] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Sat, 30 May 2026 18:00:44 +0200
Message-ID: <20260530160314.712704891@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 20419da731993..a43753f11ee96 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -246,7 +246,7 @@ static void ci_initialize_power_tune_defaults(struct pp_hwmgr *hwmgr)
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



