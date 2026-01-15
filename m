Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5E3C00A5;
	Thu, 15 Jan 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498560; cv=none; b=g408SIqeoi9ZDDT+KUJOCEo+cRS1wR6Su/UwXVJDCqUEznt6EET6VUZiqyvQfEb3srKRKQPuBSBeSZ/NB5taGA1LvZiZ4LcmMJDLkoF+GiFAgmlSdsOzKN5Z7Np8yTmrNQ9U/6C9KDB/OCA28lk+i12UA+JaS4QSfPC2HUw9TQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498560; c=relaxed/simple;
	bh=JIVlCRng450I/8LeGCFXaMFenfMqzO7vMCMOzZ7xuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJF99b4eS2Nmv4V9UmB4D2hbroaMFb9ej7vaKM29cr5TYgyhW0QDy7IgM85LS9t5Jt2lmL1tpImsxLuTaiCd+vpKgE6MZI8iQHC44mTgxrEx+V+cKhJvy7Mf1Z5KPxhDx7hb0ba3/JVsxs9h8lTeP89uozq7MhC2ud21wDiiVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi93e65p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi93e65p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D52C16AAE;
	Thu, 15 Jan 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498560;
	bh=JIVlCRng450I/8LeGCFXaMFenfMqzO7vMCMOzZ7xuFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi93e65pystN+GsZC9QZwrZRb8bCovgchDGGYQrIyFqDwk1Ee0wA8xl0CvSNoNBhe
	 UyHqZ0fhvm7NySE3hS55JQYieiI2ymRYcDUFKHb/CTmjF+rLXQcIIBUtw2ATXcZriZ
	 wk0PARzZORgSmQ8Ykuzs9UEOFgJDZ+i3Rx8TAf+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/554] media: vpif_capture: fix section mismatch
Date: Thu, 15 Jan 2026 17:48:43 +0100
Message-ID: <20260115164302.820793218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0ef841113724166c3c484d0e9ae6db1eb5634fde ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/davinci/vpif_capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1614,7 +1614,7 @@ err_cleanup:
  * This creates device entries by register itself to the V4L2 driver and
  * initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1817,7 +1817,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= &vpif_pm_ops,


