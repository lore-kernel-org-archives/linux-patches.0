Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318802FD699;
	Fri,  9 Jan 2026 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960974; cv=none; b=YRAHIoc5XWPH+A2wheOWVrruYcovEi0ie6O14vBVCHjsdsVyxeQo/ge3XFRlj5WHx/JmNlJIm8hu8LeDtoKhu/Y5Bjelfzc7S23Gq4zOAVozpWq6b5UjSF/Ro8uEg5KB+5gmmKzBd3Y723Dw2IeAzncAh842uGyVu16YeodasH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960974; c=relaxed/simple;
	bh=i01GHNC0+647q37ctdhHRUkVSpyF0iNyzva8NIjJ9rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt82JKCa/R6NfaPmwLIB83qotp92r3ATyMGKGyVhviX474fgJSuuSV7tyO09JWyNrBwepwQIpq+qN/uCRo9//OV+ppxanWL51RaLXV9RbQ3tZky2FowKzqfvyIxepwf1kDOcnDMl/vtlaDgkL6sJO9Ucuh8NdLOL+9qqv9iA4NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSDGMBgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSDGMBgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE460C4CEF1;
	Fri,  9 Jan 2026 12:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960974;
	bh=i01GHNC0+647q37ctdhHRUkVSpyF0iNyzva8NIjJ9rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSDGMBgsbzew0Cvm3b1nsAAidPnTj+85pUN63+uJu7DMQsG7fuNs8vq4nJA8FE2iz
	 Mc8x/IulsRiS/wapaJJKfIt6aKQJmJcl+bRJNcZqwe89OVcOVz+Ob12vv5Upo5bGQJ
	 CLhT0kcpl6rYbqrqu3PDKORlf3DTz+t/XNRCJ1W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 590/737] media: vpif_capture: fix section mismatch
Date: Fri,  9 Jan 2026 12:42:09 +0100
Message-ID: <20260109112156.194963554@linuxfoundation.org>
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

commit 0ef841113724166c3c484d0e9ae6db1eb5634fde upstream.

Platform drivers can be probed after their init sections have been
discarded (e.g. on probe deferral or manual rebind through sysfs) so the
probe function must not live in init.

Note that commit ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section
mismatch warning") incorrectly suppressed the modpost warning.

Fixes: ffa1b391c61b ("V4L/DVB: vpif_cap/disp: Removed section mismatch warning")
Fixes: 6ffefff5a9e7 ("V4L/DVB (12906c): V4L : vpif capture driver for DM6467")
Cc: stable@vger.kernel.org	# 2.6.32
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1601,7 +1601,7 @@ err_cleanup:
  * This creates device entries by register itself to the V4L2 driver and
  * initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1808,7 +1808,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= &vpif_pm_ops,


