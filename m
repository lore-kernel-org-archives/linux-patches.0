Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B98F2D94B8;
	Tue, 11 Nov 2025 01:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824062; cv=none; b=iI7qAR0iMCTpjSasYKAYHHacbO+3bEDr5Qz4lD1RnlRB12bViybmGeMORyLwC2STqp+qbDid3Gb2JU2OGeSiYsKLh5VPcPXy1RUxxwJzxsBRuQi7PY0yu86Q2M4CaaKN6fLiho9ykw0dOaB6pdYJjNrFi+CAkRLHtdFRFl/Hpgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824062; c=relaxed/simple;
	bh=bGeQSNz22sBqSjKheL21K89EW1g5WLghscdzRbKzHHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qy1wwFGdhZkuwt03TtHlgjSLHjecoVAAkTO2mZ8IRorTYHxqNyBpx6Nay4YVzh295xrBl/wFo2hObWWUeYjrBJWqiPtio/axB+UtjodoS6hA5abxGK2UiAaHcOJHb5+tDjyei909+2U3WxkLDYZgHDtec9fAJ4av5XEHa1FwGZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAXdvau8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAXdvau8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE63C19425;
	Tue, 11 Nov 2025 01:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824062;
	bh=bGeQSNz22sBqSjKheL21K89EW1g5WLghscdzRbKzHHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAXdvau85lFpUqQL2+4pFPFKmdc5/IlKrJV5Mryn0s0ZMj6I0V9Eeq1Xvkr+HqE6+
	 X2AdQ+Wiroj7iojXFaR3qH5fuCxE1eEUNtLJNB+Z8eMdQ6o1KExMoI8Bqa1SpWq5g8
	 p4irz9odPeejrvZUaTYVTj5jSGETx73umTwfF+Qk=
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
Subject: [PATCH 6.17 429/849] drm: panel-backlight-quirks: Make EDID match optional
Date: Tue, 11 Nov 2025 09:39:59 +0900
Message-ID: <20251111004546.805467404@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 598f812b7cb38..b38b33e26ea5c 100644
--- a/drivers/gpu/drm/drm_panel_backlight_quirks.c
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -50,7 +50,7 @@ static bool drm_panel_min_backlight_quirk_matches(const struct drm_panel_min_bac
 	if (!dmi_match(quirk->dmi_match.field, quirk->dmi_match.value))
 		return false;
 
-	if (!drm_edid_match(edid, &quirk->ident))
+	if (quirk->ident.panel_id && !drm_edid_match(edid, &quirk->ident))
 		return false;
 
 	return true;
-- 
2.51.0



