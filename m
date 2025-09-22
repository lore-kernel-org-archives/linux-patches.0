Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA362820D1;
	Mon, 22 Sep 2025 19:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570005; cv=none; b=UmQuWJfk1D9+F8d6u13OfBPW5o8ZaXPIBLmJjPSHWitpJ2Cj5AJD/xnHC0gmlu7le0W5srNNOgX09R0IPX0Hb/em78nwGPeXbWfg7BzOIMNoZNC/Gf/bVhqe9nRs4sETGMnoucVeNUCsh1IM62qbayuF9fV5MzTooS9A+yEw5f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570005; c=relaxed/simple;
	bh=OV+NzmVSAT1uP6WSR89vyvHvrvwRRAYvh2XJXB6pGno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=am4bYlfNVMlmtJEknwvhYcie1qEVaPLwr8ZvvJ74LlbwB46nf8/s8ghxab8xO6Zqc37Twu6tyKDbnTUkWvHoVQlUvsrHFNZVUNpSHQAENHDo9sLbQYDEYrF3jyQ1Jr5pNqWa0EhzRXHCWikqezM+T2Jg5TVKdiLCQzQTzHULLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8TCuHs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8TCuHs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585DCC4CEF0;
	Mon, 22 Sep 2025 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570005;
	bh=OV+NzmVSAT1uP6WSR89vyvHvrvwRRAYvh2XJXB6pGno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8TCuHs3wHWn4DtC5qdQ+1V6wJB21fC2mGXMuRPJ8HRSXkGynzlKHMb7qkXsBrsUB
	 j38+OQUemnk71B/BTNEyJhC/zHwSOkFuOrBTZmVO+bhoChqJHfKtoTDT4Z3L/rs00j
	 A3YdFpQhk08hWP48zyXfP+cBwNybvcyKmiDZuKvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandra <rahul@chandra.net>,
	stable@kernel.org,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 086/105] platform/x86: asus-wmi: Re-add extra keys to ignore_key_wlan quirk
Date: Mon, 22 Sep 2025 21:30:09 +0200
Message-ID: <20250922192411.154472252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

commit 225d1ee0f5ba3218d1814d36564fdb5f37b50474 upstream.

It turns out that the dual screen models use 0x5E for attaching and
detaching the keyboard instead of 0x5F. So, re-add the codes by
reverting commit cf3940ac737d ("platform/x86: asus-wmi: Remove extra
keys from ignore_key_wlan quirk"). For our future reference, add a
comment next to 0x5E indicating that it is used for that purpose.

Fixes: cf3940ac737d ("platform/x86: asus-wmi: Remove extra keys from ignore_key_wlan quirk")
Reported-by: Rahul Chandra <rahul@chandra.net>
Closes: https://lore.kernel.org/all/10020-68c90c80-d-4ac6c580@106290038/
Cc: stable@kernel.org
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250916072818.196462-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-nb-wmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -669,6 +669,8 @@ static void asus_nb_wmi_key_filter(struc
 		if (atkbd_reports_vol_keys)
 			*code = ASUS_WMI_KEY_IGNORE;
 		break;
+	case 0x5D: /* Wireless console Toggle */
+	case 0x5E: /* Wireless console Enable / Keyboard Attach, Detach */
 	case 0x5F: /* Wireless console Disable / Special Key */
 		if (quirks->key_wlan_event)
 			*code = quirks->key_wlan_event;


