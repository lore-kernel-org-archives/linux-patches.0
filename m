Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBF623F417;
	Sun,  7 Jun 2026 10:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828201; cv=none; b=Px3xdop3hj7C1rQWDKyEJzY+awoPrO7nzbzQ5gxZsfAmT55UbrhbmtB/ffEwigbcO+1VbVfgbS9QbNWRN3xR5vpLcQpPMtGj6PYL0gcH34ZT+wmsCBMLqlRtgdAcbCPjRtWvKbSy6/gv93JVSOT7ModE4vk+RlS0DGwW6oXdtDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828201; c=relaxed/simple;
	bh=dYW/njfu0vz6+N10XF3jf1TgWJTMrCXYEs3umZZYd+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfDy8RopZbU54/UwWdkympAsL1gRWUEAmD73Mj6b9UEpW1zkxlXcz4ucZ+QMvbTvp62aIcFemLHEgU9+22w9RAx+KeqAJx4hZw8oMqKEyC1LGBCHsZQU6vMZFOnPEK359CMIoxmd7gRz5gOT2+vSMvbvT6Hyl+JPthD3UrUfeK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HWgogyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HWgogyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272E11F00898;
	Sun,  7 Jun 2026 10:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828199;
	bh=rnYRJfSIVcm9wsvqiZ3lX8Jx2LG5GBkMnsUB5KeOvMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HWgogybGz6l0C74BPqKxbMvfQJrGGMGlRQffG3Q730S/RjjCn7S/X37wkAQirJnT
	 H26TmvPTcEd6n3b/jYz/5gu0ag3iC1+mKgUiD89Wo8/zHOyc5iolxoO9RglaAFIKMx
	 x5i4AQUTr9AhJQU5uLJ7jvwHNYL1dAnbE1Qg969E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.18 140/315] USB: cdc-acm: Fix bit overlap and move quirk definitions to header
Date: Sun,  7 Jun 2026 11:58:47 +0200
Message-ID: <20260607095732.745855308@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


