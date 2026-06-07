Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443A4329391;
	Sun,  7 Jun 2026 10:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828377; cv=none; b=piUxeTM3qS4uYL/cNE3+8UJFiogUoqWh5tJJZ/OQZchtsxL/98Jkz5ipzNJRIZe9K9iN9xwM2dJPSBAm0SaTFF4X7boe/UQI9Q1Yl7O4BuDt/Zdh1ywWZ+6DMODPN7LXRUAE3ZlYqa/+PRDGV2nfSa0FGe7GVfgpMul+jHqztm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828377; c=relaxed/simple;
	bh=OQkwks1lOXlO3AC0mQ96piCtPiyWRroDy6lrVQW2HuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQflQeWZ6QrQhTMF29TaMzvt+wG1ZJ1pWWuGqwuAWvdk59Hhj8NAMLvIB3xdeuludFT1KmUpImWZJaWfWZ/2vntH5i53AJUSZtDqWLEFQO22NRQMhoPzvfKKuzqT9eHwRq8iL2+SXPOuqWY0xDAwEFI/abnEgY4OtG/BhtsckvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wga/JxHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wga/JxHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544201F00893;
	Sun,  7 Jun 2026 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828376;
	bh=/CBEKVsBr8lpzMxCLMgwmWCb6oHTzRGfu1Gtxgu9IgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wga/JxHMCHvPGSsAYJsLh31tDLQS7kW7ArjVMLduJYLHqGjonWVAo+tOYGHBsampi
	 WqImQLm5CkeKRVXXgrBUN11yG7zIN9o/jk5nZfQf4a95qPmVf49Sm+8i6ZQVlK2b4H
	 2xvCj22RbaxAZ1sSkDAE+tq1k24L4ksFRgyIgrvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 7.0 158/332] USB: cdc-acm: Fix bit overlap and move quirk definitions to header
Date: Sun,  7 Jun 2026 11:58:47 +0200
Message-ID: <20260607095733.880953763@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit 5eb070769ea5e18405535609d1d3f6886f3755bd upstream.

The VENDOR_CLASS_DATA_IFACE and ALWAYS_POLL_CTRL quirk flags added in
commit f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10
INGENIC touchscreen") were placed inside the acm_ctrl_msg() function
rather than in the header with the other quirk flags.  Then, their
values (BIT(9) and BIT(10)) collided with NO_UNION_12 which is already
BIT(9).

Move the definitions to drivers/usb/class/cdc-acm.h where they belong
and shift them to BIT(10) and BIT(11) to avoid the overlap.

Fixes: f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen")
Cc: stable <stable@kernel.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://patch.msgid.link/20260522091357.1301196-1-guanwentao@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 --
 drivers/usb/class/cdc-acm.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -114,8 +114,6 @@ static int acm_ctrl_msg(struct acm *acm,
 	int retval;
 
 	retval = usb_autopm_get_interface(acm->control);
-#define VENDOR_CLASS_DATA_IFACE		BIT(9)  /* data interface uses vendor-specific class */
-#define ALWAYS_POLL_CTRL		BIT(10) /* keep ctrl URB active even without an open TTY */
 	if (retval)
 		return retval;
 
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -115,3 +115,5 @@ struct acm {
 #define DISABLE_ECHO			BIT(7)
 #define MISSING_CAP_BRK			BIT(8)
 #define NO_UNION_12			BIT(9)
+#define VENDOR_CLASS_DATA_IFACE		BIT(10)  /* data interface uses vendor-specific class */
+#define ALWAYS_POLL_CTRL		BIT(11) /* keep ctrl URB active even without an open TTY */


