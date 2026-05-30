Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CC8342CB3;
	Sat, 30 May 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164094; cv=none; b=FgQsz3EEdApUDtpRCI6/0dQoIz4Wk0iUXCtPdUUK4hSCurPD1Eviv4KTGg4my9cmRBbS/O6ftWxm2Q8koDvmhaQdWUrd4bM9CyrjXOAaxKUw9/TB6mlMwiLPBOJH0WLqaL9b/38JIuiTt+6I20DhrmpLj5k5gx0Pmevxp7EfljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164094; c=relaxed/simple;
	bh=Ey0MNAcvASQkqFjJ3dIbQ2/nHEkMxrmRVpstgHYa5Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WKNgTZx2ZzQkA/bS6+HcmXcEYcj9Enu420posZIRIdfGYTIrDXu7zuAcHjMbPlFoTHk6vAkT6gUuGFtUh9RYo1eCHqTZSQ85Wijm73pfhhfMA70LT4cP2JQjXZfUmsHHnvzEImLnAkv8V4jpZgqPrlAX1h8W+CdLoPcNmQ0i2IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiGU7WCd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiGU7WCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D271F00893;
	Sat, 30 May 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164093;
	bh=/C7cRxUqDv3fUDGKhiFPHEQDEC1Z95eyNtlkbRTSjGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiGU7WCdtWqdwwOIWBTdv+8Qh6RQqOpwRW7saTjJUVsTt8b9GrJJmLYGaSrM4kKEg
	 zE1u8lbmaOT8I9Gx+kQoFNfaO7/2kC05wGWH/eQ5cd82oWdbOVDFUuQOewr2yTcn1m
	 Ul2AdZv2+GicBAuZd7db0fjWx6SugO7Ikrosu0m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/776] drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0
Date: Sat, 30 May 2026 18:02:46 +0200
Message-ID: <20260530160252.067355944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a6d2c6256c347..f898d596c6516 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -244,7 +244,7 @@ static void ci_initialize_power_tune_defaults(struct pp_hwmgr *hwmgr)
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



