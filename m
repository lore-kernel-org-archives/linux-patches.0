Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6935E35C181;
	Fri,  9 Jan 2026 12:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962787; cv=none; b=mu8oehP7EUGmM0S5b0kANHYw3OvNDbvKW+v43JY4uX/Egt0r0EbHC4uL+CPp3O/ZWLaOEuDWvFuVgYxuMGwAfTW0O3hu1V4pWt98RMZRlctnwIvwVv3AFuqrGut3n78+PE081gv4e7D4U/mhelhnZptpVkXKp85lesy+HIMWlSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962787; c=relaxed/simple;
	bh=CjuhRLC+RtHLka8zWkIbIgRGJDSGYaEN86G2qlRsvuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaeDnvksUJ7lE0+QnePRteCAjLOInHScD7HGM0Y182RA8EkTypOm5jFrchns6M/7Y8rvJesbb9j3GiaU2dJYS5lI35uFthgyfb4C80qb4I21yZ5qf1fPqMqwjxe9Z2wlzPTtOh0ZhKc9Bl81s9EgZA4d3lLn3bG91niY1OK4cQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbwimvPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbwimvPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEBAC4CEF1;
	Fri,  9 Jan 2026 12:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962787;
	bh=CjuhRLC+RtHLka8zWkIbIgRGJDSGYaEN86G2qlRsvuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbwimvPuLwUIKwRquDBi6xW1IaC5zBmUe68MsmgXkv4tPxbPqfzb9ZcxFAA9051gm
	 xq82IgmnA+3KuDWgEdGYbiy8BKOcNKtWqiIfvi8wKG7NXbcIHhIiNaeXYhnhWrS3RW
	 4N2Egn9eojZqKFk+aEj8AjyyqqbAK2HTIXHZl0R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 486/634] media: vpif_display: fix section mismatch
Date: Fri,  9 Jan 2026 12:42:44 +0100
Message-ID: <20260109112135.833604529@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1393,7 +1393,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 			.name	= VPIF_DRIVER_NAME,
 			.pm	= &vpif_pm_ops,


