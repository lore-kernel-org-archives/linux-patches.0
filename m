Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E9A1DF246;
	Sun,  7 Sep 2025 20:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277313; cv=none; b=gLZPMGfSUuI0v3XWKCHmNS2mWNCGzeKieQkFz6ij/YgugC25EiOSNzj8LxHbrS/1kYFSR/dVZCFeUvsRDDpYKVtUTtLg2O6LIYz/B1M8WncFhZ31jqhYLiojGIRjSGW4Qg4471uJb4+DbM2iNp/j/kP3KeS8YVcmmzrE/7s5VrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277313; c=relaxed/simple;
	bh=s8URMThMXg0l2TlFwH7dImnMLOYsEIV2q//fxJ4UETI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQN5ThIwMz33UUF00cQ4lfQAToScStcNoZENA3OFdklreyDY9rnxEwSp+woAhtj1IAGfJRBQwtBALIoe3Ey7q+yxve2WLKfj8ChJDRt07VIw2WfYhaA8+AKPnvJ5gDT9VnpHZ/KLPWVcZvWic89Hv6NKSVPD2QSTK8mfjFw2rEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs9ycltV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs9ycltV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B961C4CEF0;
	Sun,  7 Sep 2025 20:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277313;
	bh=s8URMThMXg0l2TlFwH7dImnMLOYsEIV2q//fxJ4UETI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs9ycltVLodEgFVFTjxZRSstOMJVweESSZpzq56ixD061eGK6dauUX6OIBYUVLSXW
	 IwwyZcMnOOeXo/Noe7vRnFATGvrhnELfx4Z1mVu4umSATXl40b1/mq8K7QEoEi+Ulj
	 maZpe+ay754u3ItOi0udj8cIaxIEcA91/MyfsPMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/175] platform/x86: asus-wmi: Remove extra keys from ignore_key_wlan quirk
Date: Sun,  7 Sep 2025 21:59:07 +0200
Message-ID: <20250907195618.452768856@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 90ad0045fec5f..8f06adf828361 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -654,8 +654,6 @@ static void asus_nb_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
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



