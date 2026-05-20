Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A24139B975;
	Wed, 20 May 2026 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298121; cv=none; b=TXS6Zr59Ro8kUoU46XFd2fV77EVgyxw6N5+yMu4MZcbXJixNG4FYlkzHLbG5VlWuOFqaw5Xaqb9cgJ4G2mIoJwarZS/4DX5/6hxQEG4ZJYuCc9gDJ1yIHaJ4oCGIn3sbrBnRXp4FY+O4HhostDIs5sxHYKV6HeFjsK2h2KfZlb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298121; c=relaxed/simple;
	bh=mRjBJgKkb0uChn1Smt/W+qjVrbv9py8dXI4wpY/KKyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZarjYfCYPND/QHAPTvYori+4nhiKI2BnLTf2bLQFebbQORCl2YlA9zSVnYlWzeiatmmmQuc9HxxSo6o/CKRmMX4O3B4UBhkmHt+zkJb5q56cQaRYrquKag1hFjKEe1Vh3glZtWe+0PW3MaDti31rmsw5wEvUcG3cyLsaa0JvCDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYPtuLYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYPtuLYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0310D1F00893;
	Wed, 20 May 2026 17:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298120;
	bh=HoTN3LbZe+V7cpEizBGsKNM5Zyqm76XsvGMcEIHNtOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OYPtuLYEYTafT6/zkPluRYY0Gwac89I94DtHqzPuNr/+GslT+30eF6OOtUr/BuWz/
	 O8trzOVOciFfc49JlByXioa4bjG6dAhkMt9BLbxFlvIMNnyC5VAO9YH9y4Idss4FPt
	 G/QobGsBk3X8XCKMWxn3VnsP2lUjat71tdIWIRg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/957] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Wed, 20 May 2026 18:12:26 +0200
Message-ID: <20260520162140.247399771@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



