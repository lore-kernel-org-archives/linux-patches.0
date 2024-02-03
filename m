Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE8FF9D7;
	Sat,  3 Feb 2024 04:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933431; cv=none; b=G8fWWXXjZd1pRH6ixMuTHpdr3gdwu2v+bAXU4npaNsNWtGFL/8Rz827s3FjvINqU4DJ4UjoAxACOc/Us5lsm6w+tAPBN0HaEMEzMnaNQAAVwVjWRzq+XAdN22EAlEi7IsvLZvksqYIQMnrQuvtvksGNBjymwSBWvWcksb9loclc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933431; c=relaxed/simple;
	bh=iJhi77fL3jfbtlOSsCzF0AlD8dAt5APMlQrZJCc+XPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htoQ98Lu0wgIS9jUMzqXiNJfKkl5RKeoJUCKuiDRYh73d++t2RO6zILRUcZBM3bM0L+0yJLWldBs6y+V4wuPJtvDwBOcTKpkTRPtGgCU26KpV+QpbGiC3Hexog9CginJFbn/0cohPN2uxHohSAC+R352DICoR6Cm+OAFEyV8NFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSlK/otw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSlK/otw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3785C433B2;
	Sat,  3 Feb 2024 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933431;
	bh=iJhi77fL3jfbtlOSsCzF0AlD8dAt5APMlQrZJCc+XPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSlK/otw4GwFAGRO7HUH3RlIG2TvLQIT4lKz0sgVs7infQcQm6+MSuB+3Vy6dZaAK
	 zyq2uTXryfpLyPXBfKQOH8ItF37Xkr4ObC3EVW33bEIaO+9wf4HKZLtbwbAgEXgCpR
	 KskZQ29XJmVarsNi7j5IBZxqYddMjLKh49rSjFzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/219] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Fri,  2 Feb 2024 20:05:33 -0800
Message-ID: <20240203035339.136631135@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 6666ea93d2c422ebeb8039d11e642552da682070 ]

This patch replaces the hardcoded quirk value in the macro with
BIT().

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 81c8f564cf87..9163fd5af046 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -47,8 +47,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
-#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
-#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
+#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
-- 
2.43.0



