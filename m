Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB520369D4C;
	Wed, 20 May 2026 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295252; cv=none; b=uot0AN73gPX/1H2vuenuN+kXSb+dFUrSnneR7IhVZ+Cqg/skA940vefW/8aERgW1VRIPn2TbZ5kGCmXnd+QwwG7NJVkYDfdJztt1h/cTqU6D1IVmI3//0iUjIz1aZ9BppSVxFmCWGP5JGpIPYGA2XgbePxy8+BJsYRtgTEiaxO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295252; c=relaxed/simple;
	bh=BX07HNckEOPnV9s+kGodCIpHGvKvrkQCankdSodny3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTCS3jqL0WchaKVjAdNOC5DZ0w1ypxdQ4LFbZDBM4s4+bPGTnJl1/7cTuBwS7y0gUbzxor+NgYo3kr9KKw6GPoRuMrJq3DmQvvajEzKPaReoHystC6qXz47RDGlPugWokSvKJqUx+UY12OSwqfb3BY+fVOj+ysDs8meF1IWnWZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avRqsPa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avRqsPa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A90A1F00894;
	Wed, 20 May 2026 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295250;
	bh=jkaTfqcPOiOisR58HxmioQ+OqTFZiTrklsAqS6dgm6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avRqsPa563ANnQQZZ77g0tgRCkUmUA5IrYlwX8UkjFH+1W3MxxNF3FZCC1gPEZ1qZ
	 lzd6lDjCNiLpUwuxsf2Xk1W2AFJLg84ltqvRemFoQFZFEwmwSAZZYflR6/kccaWAYO
	 S03VCbywRU050xeIpKTRS+6fegSLWzfsTq9VdWVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0341/1146] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Wed, 20 May 2026 18:09:51 +0200
Message-ID: <20260520162155.918526807@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index c0a04fab3ceca..b5f6a5da6549d 100644
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



