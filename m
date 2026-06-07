Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88D62D3A69;
	Sun,  7 Jun 2026 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828607; cv=none; b=ZeUWr9gFSv3YKb8Q5zcqqNb1D/MZdUJJikVMZf+OdjGCRp+4L5MpQy6jpmvNiiyMxWA9sKHZZ0YuhlzPkmn7+2Ev/9u03BMqXl4LG+RB7SQDmT5VRHLrGTcsnM2SygyX+OneyBMZvVL4SskjPXqoAIpSQ/+whLBSu6KYDw+wOAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828607; c=relaxed/simple;
	bh=XmTqDzipjnZTkgD4HXURzYMjPi5OPXTmjYwNo1AayO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/AU+Vts5WO6IevOxe4v/H8Yfkc5nu6uuTxLDcjDtV/uW2OgOkU9zV6w8qEStRvM0Wo+MkFOv1wOaFATIIS7ugBkVUuBXLvUoxKMC/GNvZpKxQZuICNV4/emuhM6WS7/8WwksNK596g6LYcrhtDSXVbTtDcG18KYTiLEX675gvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hha94LIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hha94LIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C4A1F00893;
	Sun,  7 Jun 2026 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828606;
	bh=rbBD7tFjM/OE7xbJ2adxDHvOxzCWgHYFhmK5Ndd46uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hha94LIQfwmYgA74yNtLG5UFfGJgto8vBleE1vUzB7OOt63e0JB2ITB1alXiX5AOA
	 8DPo2Mrk09ld6DjUlOwbVJ6WsK5uqCesWFiC3vbSW0Ug3j6PP1ik/uHhF5egJqmcIu
	 dFGntnf9anJ/7fWy5HO0QgKkl1Ejyqkpg6kt3LU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.12 151/307] USB: cdc-acm: Fix bit overlap and move quirk definitions to header
Date: Sun,  7 Jun 2026 11:59:08 +0200
Message-ID: <20260607095733.270202187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


