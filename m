Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E22266EFC;
	Tue, 11 Nov 2025 01:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823638; cv=none; b=YSrRVyW6Y6QSYFDfTRVFQodEzP+9LcqaPKPE+lIsY32N0e3SRdUUZpTXp7OVDB5rqBXqvKPPp7rTJgImc9VMAE19FvFHbF6ydNsbTaw5lXNXHy0iFrP+nlZ6I/YKTV//GFo9l+7EhspQf/crim+Gq8mMuiSrk0c80Cqj6goOCyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823638; c=relaxed/simple;
	bh=Dci36EaUYWP2wthdu6I6wpcYZmnyOoUshp81hv3kJyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1jBHo2JlRgf7StiHU6KgmG4f6l3kgxoCkH0X0delljkfzkaIClJBk0xdk6xsvDs1ghxnMVROHV7oiizyhrcasPynv3tFikkv6VtWFnNpMdT+ta8Dq/G711Fs6lCLlfQh67OEQB5jMVOmCWMc/6CEfB+FCclRtICMMGFmDoIQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaBDdIsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaBDdIsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A65C4CEF5;
	Tue, 11 Nov 2025 01:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823638;
	bh=Dci36EaUYWP2wthdu6I6wpcYZmnyOoUshp81hv3kJyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaBDdIswDjSOqDkE9k5QipAmkQaiK6IrED/bTOzECpjvDgHV9fT0eIi27ZPA6Ekr+
	 yN8b8+bKa1+hRLQB+6ug3Ct2eqJ0MhOSNDP3usRlZeO61jHbAZeU9xsWldQZH8AoJ/
	 eOsHAbLJ+p4le42KDbVA80nG8OP63yuwM/NNUD1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/565] drm: panel-backlight-quirks: Make EDID match optional
Date: Tue, 11 Nov 2025 09:42:27 +0900
Message-ID: <20251111004533.423140006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 9931e4be11f2129a20ffd908bc364598a63016f8 ]

Currently, having a valid panel_id match is required to use the quirk
system. For certain devices, we know that all SKUs need a certain quirk.
Therefore, allow not specifying ident by only checking for a match
if panel_id is non-zero.

Tested-by: Philip Müller <philm@manjaro.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250829145541.512671-2-lkml@antheas.dev
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_backlight_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel_backlight_quirks.c b/drivers/gpu/drm/drm_panel_backlight_quirks.c
index c477d98ade2b4..99d8b6b2d6bd2 100644
--- a/drivers/gpu/drm/drm_panel_backlight_quirks.c
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -49,7 +49,7 @@ static bool drm_panel_min_backlight_quirk_matches(const struct drm_panel_min_bac
 	if (!dmi_match(quirk->dmi_match.field, quirk->dmi_match.value))
 		return false;
 
-	if (!drm_edid_match(edid, &quirk->ident))
+	if (quirk->ident.panel_id && !drm_edid_match(edid, &quirk->ident))
 		return false;
 
 	return true;
-- 
2.51.0



