Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB2317160;
	Wed, 20 May 2026 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298823; cv=none; b=luLatMrzj+r4H7KbTtLNiRA2xgotDBOyD8iCCcfUt1+lPewc0hOrdGEPZ26JUEasuqE8XOfE3b3a1InXoI0bRywHAsrO6X/kkOsYPXmD67sN9Q2IhAH5xiqZaFvpUPSGVJK/1R41n/MwILTyhX/I/rZ49ecOwU+W503q/bbnMls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298823; c=relaxed/simple;
	bh=7MJHbgUBSjqmKQJQK6Tb5ibNBs5dCa1tTYPvzL2wS7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ih15pzumhBt44+NYIXRhoBDZmObjaCmvNf5g0m5fEaHXiuTZcHTIHNXrkmR04tbF6joHCtPFUsLkq3Z6EtKnue0j0fjmMSJiJa1RrkdmgD4sjN5DCu3VDpTW76gfLap1HYEUyY81aL7bCsuKbqMSMu9rHM+wKA7U8JYPTejbuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQchkfK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQchkfK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1241F000E9;
	Wed, 20 May 2026 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298822;
	bh=b587e9xhdHljWk+3AcucTgwf8MXxaDzT6tkQOQ/I8c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQchkfK1MFkQoCQjCz7EhtHUGXSZdbO8As8r8lNUwIX9UqySiTPP7wL1Bbktg/ZzP
	 x6melYi4iAzIB8rWlmBewCFMtcvAoqQLvjSHu4sgU9g4gi6m1LdMo8k6AzQPjko7f8
	 Z26SuOlP7j2jEE8sWhRQOUc7BhAlfUTVfJofDZzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/957] platform/surface: surfacepro3_button: Drop wakeup source on remove
Date: Wed, 20 May 2026 18:16:53 +0200
Message-ID: <20260520162146.027157301@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1410a228ab2d36fe2b383415a632ae12048d4f3a ]

The wakeup source added by device_init_wakeup() in surface_button_add()
needs to be dropped during driver removal, so update the driver to do
that.

Fixes: 19351f340765 ("platform/x86: surfacepro3: Support for wakeup from suspend-to-idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4368848.1IzOArtZ34@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surfacepro3_button.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/surface/surfacepro3_button.c b/drivers/platform/surface/surfacepro3_button.c
index 2755601f979cd..7c7622f8f8716 100644
--- a/drivers/platform/surface/surfacepro3_button.c
+++ b/drivers/platform/surface/surfacepro3_button.c
@@ -243,6 +243,7 @@ static void surface_button_remove(struct acpi_device *device)
 {
 	struct surface_button *button = acpi_driver_data(device);
 
+	device_init_wakeup(&device->dev, false);
 	input_unregister_device(button->input);
 	kfree(button);
 }
-- 
2.53.0



