Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DE436BCD9;
	Tue,  6 Jan 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722166; cv=none; b=NOMRE8Wznt2zift9GMWiwpj3AK29OWxt/np29L8f3eMM0tBotDYNnL0XWVvw3AhFKG7jk4ff41rVSzu/AG55YDknPqt0Pom1zBk9VRoktgHDdVWaavlQhlxqjK1+CGqLCBMrMxzRNyBrJi6QUG5UQx3zjAZ6bpb9QNA95IoqqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722166; c=relaxed/simple;
	bh=Tk7odnUmrmt3cp3JNVBrtMqOGQ53IFlaLj5eVZ8ItgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSsZRfGW093RhGXsnK3Nwlbmi5xcbxEwEwk8TAk+IfIc9Eg/gk/yh5KZEHYNPZ61kChHgCmj/T3YpvOrXR4FgI9sqz71gACv/eLvpTtH185Wjs7Wv6JICFICyGSmsCUy9/2Qs1Sqh6YqRg1dsh+wIJBsAjzO+35YPwL2wXIKxTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6XlFUIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6XlFUIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7220C116C6;
	Tue,  6 Jan 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722166;
	bh=Tk7odnUmrmt3cp3JNVBrtMqOGQ53IFlaLj5eVZ8ItgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6XlFUIJq5V1FmrIQIU/8LyV7atUKbx41i45k7HEa91obY3tF9J30265S6L8DhZA+
	 p+NxWSNME6D7jhviKGWJyohdOhmEFhWjnYWVDdau5XBYrGDMekq7ebnW/+Tepqa5MX
	 mLfbNQgSV8E5maiBoqCpBaVyx+1wpheIDnu2z+Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 184/312] media: vpif_display: fix section mismatch
Date: Tue,  6 Jan 2026 18:04:18 +0100
Message-ID: <20260106170554.484948926@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 59ca64bf98e4209df8ace8057d31ae3c80f948cd upstream.

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function must not live in init.

Note that commit ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section
mismatch warning") incorrectly suppressed the modpost warning.

Fixes: ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section mismatch warning")
Fixes: e7332e3a552f ("V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver")
Cc: stable@vger.kernel.org	# 2.6.32
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/ti/davinci/vpif_display.c
+++ b/drivers/media/platform/ti/davinci/vpif_display.c
@@ -1214,7 +1214,7 @@ probe_out:
  * vpif_probe: This function creates device entries by register itself to the
  * V4L2 driver and initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1390,7 +1390,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 			.name	= VPIF_DRIVER_NAME,
 			.pm	= &vpif_pm_ops,


