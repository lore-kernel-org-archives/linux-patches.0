Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA19D3176E4;
	Fri,  9 Jan 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960977; cv=none; b=OmcJpUu9gqUNTaL1AsNz5yEnCrb/01x4enQebxfswVivM30P3neIRGhuw2yTl3lMRvnWeC+Ib27HwytsjMNWnyBTYrXSbnhpPwVdH2BbMuqsrext7J8dp3r/D4BvIrQx9aBB88lHPiERju3vdT4UBmZaagV+79852BIR4wytMCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960977; c=relaxed/simple;
	bh=WmQEYcrp95zfwBEOu47X/oL1yRUx0JIpLKDemc0ONuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mvg4YEOReCIk95TEz4zermc305nn9v2C5BRP4Om+HLHtnxPZhnT0NXFa6mq9W/bJr0rpARFqsI89JjN8kKoppL9+ZjptYZd8a3TUtmQlptROvegfJo2I20aL7Rx8CwtMbnXgIrypNH91RH5N5VwFCH83osVPI6AbeYjNyIUEgxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayUpJGIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayUpJGIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A629C4CEF1;
	Fri,  9 Jan 2026 12:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960976;
	bh=WmQEYcrp95zfwBEOu47X/oL1yRUx0JIpLKDemc0ONuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayUpJGIce6TQbW1U+nLQqluCZElzL1jjIpGuN7Tdrf+jXb+c5W+EeTKTxdj19Ul8U
	 FcF83Op3xqZ59RiGwyACNPIKxUPauD3P5+3b7PCPGmmpvOi8KYy8fxvzCMb0rTz//u
	 vYUCA5dFeUy9rEXRN8d5Es7yxoHeK5moIg7YRlFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 591/737] media: vpif_display: fix section mismatch
Date: Fri,  9 Jan 2026 12:42:10 +0100
Message-ID: <20260109112156.234141280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1215,7 +1215,7 @@ probe_out:
  * vpif_probe: This function creates device entries by register itself to the
  * V4L2 driver and initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1391,7 +1391,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 			.name	= VPIF_DRIVER_NAME,
 			.pm	= &vpif_pm_ops,


