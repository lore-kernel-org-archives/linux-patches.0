Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C7820E00B;
	Sun,  7 Sep 2025 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277877; cv=none; b=U4pMNVf4UzRQ0GYsS5tTOs4xU74CbSYEreNDD5w1vX5KHyUKxtoeVHrXm5yCiG0U4FroKbOc1RNLtuUlz89AaxNExaEwyIvEFDeo4KA78qAvwJJZ4qMH5qK3kzQ0rFAgoHaTwk160ZGCfNsAf2EG3qSkp6ECDSY++akY0DcJTK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277877; c=relaxed/simple;
	bh=unVAgJYxw0MfuPYzvw6wz7owK1+ZVEyRKdP/JIcF4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5zrRrjdms43Yg4/Vk8YUW5CUI4yUCmQZFxhGSmzasSS/oXvw3MSP+1bl1szzT5qbh6Lcpm+O5MrIr0e9qm1aVXidHJnYEeBVEJYfhHk6xKd9nqEYn+CB4VovImiGCQgrXtwoMebHJ+QLWthsfiMGFtlkJRCZF9xc51otm8bg0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3e0QM1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3e0QM1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F3BC4CEF0;
	Sun,  7 Sep 2025 20:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277877;
	bh=unVAgJYxw0MfuPYzvw6wz7owK1+ZVEyRKdP/JIcF4L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3e0QM1itkWoN1lU3yy9F5G6vJZh+tI9YLNsohAhUUbYZSqpxOv5xFzAFncbup1oT
	 UPCpe52pZ1xy8Ap/Njh+uYBzLNLO39AA1+LAs8yfR0hGVHLE/bY01yfWxdXyPsxtxT
	 rdEPWgxBbi4ZPpqDUls5c4wxssvLmNOluNwVazio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 150/183] platform/x86: asus-wmi: Remove extra keys from ignore_key_wlan quirk
Date: Sun,  7 Sep 2025 21:59:37 +0200
Message-ID: <20250907195619.377343277@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit cf3940ac737d05c85395f343fe33a3cfcadb47db ]

Currently, the ignore_key_wlan quirk applies to keycodes 0x5D, 0x5E, and
0x5F. However, the relevant code for the Asus Zenbook Duo is only 0x5F.
Since this code is emitted by other Asus devices, such as from the Z13
for its ROG button, remove the extra codes before expanding the quirk.

For the Duo devices, which are the only ones that use this quirk, there
should be no effect.

Fixes: 9286dfd5735b ("platform/x86: asus-wmi: Fix spurious rfkill on UX8406MA")
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250808154710.8981-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index f84c3d03c1de7..e6726be5890e7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -655,8 +655,6 @@ static void asus_nb_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
 		if (atkbd_reports_vol_keys)
 			*code = ASUS_WMI_KEY_IGNORE;
 		break;
-	case 0x5D: /* Wireless console Toggle */
-	case 0x5E: /* Wireless console Enable */
 	case 0x5F: /* Wireless console Disable */
 		if (quirks->ignore_key_wlan)
 			*code = ASUS_WMI_KEY_IGNORE;
-- 
2.51.0



