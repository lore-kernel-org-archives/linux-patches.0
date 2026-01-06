Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9C433CE8F;
	Tue,  6 Jan 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721016; cv=none; b=na25VpcD2XR/J8fzJnrMwbS7HpVcSpEh353MlToFUqq71wNpwoZFwL1hFqJHM1hTqqHnt5WSAJjZdG+ub/GKmAg5qaHSfE5spYMePp9VXTbnYQCztHVElGBetqBr2ugVDeimOEt3tK1k6OiNb1d6kn6KCrNG+P1e3ZW6+HCe0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721016; c=relaxed/simple;
	bh=LaZxMl3vxOluHX193vrM5DXAxsrSlNl94meHxlowkPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdcpAraxL9xz2YeKg3sEycDa+5T657nZW4CEFFv+CdUB3QEh7nzD8eQizi9KYcmuZgNxcqB2TXMKW0bQ5Pm6R82kSbWfQoD4YdjpMp+mswJ9frSb4fdIgYtAzWpcesYl3ol17Q+gFZ6Rsq8E0TNR9G+rR+YiyvTShdviG4ArWJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6LMzo6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6LMzo6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF31C116C6;
	Tue,  6 Jan 2026 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721016;
	bh=LaZxMl3vxOluHX193vrM5DXAxsrSlNl94meHxlowkPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6LMzo6CagdRoYnG4Wo2TvQO+DL9XtMHgJYJotVRjz3UdvTYWNZXKmAOpdN/GPxnC
	 Un/ohwS895F+DgKHoTR+bDZJYFoHgALkLW4N6VEnaeXi7JLjPtUdk9WLTkFp6v6pyo
	 augr3hv527kbLt8khnrV0aMaMJjnUfKg/s4GDBsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 410/567] media: vpif_capture: fix section mismatch
Date: Tue,  6 Jan 2026 18:03:12 +0100
Message-ID: <20260106170506.508348415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -1602,7 +1602,7 @@ err_cleanup:
  * This creates device entries by register itself to the V4L2 driver and
  * initializes fields of each channel objects
  */
-static __init int vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	struct vpif_subdev_info *subdevdata;
 	struct i2c_adapter *i2c_adap;
@@ -1809,7 +1809,7 @@ static int vpif_resume(struct device *de
 
 static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
 
-static __refdata struct platform_driver vpif_driver = {
+static struct platform_driver vpif_driver = {
 	.driver	= {
 		.name	= VPIF_DRIVER_NAME,
 		.pm	= &vpif_pm_ops,


