Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70313B9D91;
	Fri, 15 May 2026 16:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862395; cv=none; b=UpR9zqWb/hOjTswoFOooYdzriUG/6WMIVPt5DZaff35/8TIVbNKZqFsOWJTxOGLL05121wCjnZsgodAyYHHEKrGbi72GXUjp+tmT3A9CujE3wJiVcjFllu2j8nGc7rR7lxpMAFx9R1+y9GyAGwHktBSm9rt2ey9bZNQrLbZO9fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862395; c=relaxed/simple;
	bh=eVZCS8HtDIhbdBFxUctAn2QNipdvIzdxOYgGxWdiIC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjTEgImuQuvI58hoxL/59Aae3Greb9zh2g1fz0pty7ppqOJthhvWtM9MY3MxojNZRltWDadwl+QxRZ9DPWljC/PG+p2b+grbhpJzwETfBxSI5Ca2RDVFUjj+i7g7ivx0PhFSdjP4vLNmRA3pEYVDblYex728J44U3bK2wdEJyEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKYB4gFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKYB4gFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F347C2BCB0;
	Fri, 15 May 2026 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862395;
	bh=eVZCS8HtDIhbdBFxUctAn2QNipdvIzdxOYgGxWdiIC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKYB4gFQNXxSUass0rRz1v9xC0+fVbCHoJ3JW0oPSZwZqlQ8nkwISlD8j08XW+xZO
	 qfvpRZ/0HXnkR7/QKDJPsc+98s3lRWTIoH9A6J+Bors6UoJCGx/dj5DsZfuXGI+KEJ
	 UjPiP7phmvqNtwQcU3QtR4VIdFCrXpaDMy/oGjVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 031/201] staging: media: atomisp: Disallow all private IOCTLs
Date: Fri, 15 May 2026 17:47:29 +0200
Message-ID: <20260515154659.207387803@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 2b7eb2c5dc72f0fc954ac4aa155f9e285e937f7c upstream.

Disallow all private IOCTLs. These aren't quite as safe as one could
assume of IOCTL handlers; disable them for now. Instead of removing the
code, return in the beginning of the function if cmd is non-zero in order
to keep static checkers happy.

Reported-by: Soufiane Dani <soufianeda@tutanota.com>
Closes: https://lore.kernel.org/linux-staging/20260210-atomisp-fix-v1-1-024429cbff31@tutanota.com/
Cc: stable@vger.kernel.org
Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Fixes: ad85094b293e ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1356,6 +1356,10 @@ static int atomisp_s_parm(struct file *f
 static long atomisp_vidioc_default(struct file *file, void *fh,
 				   bool valid_prio, unsigned int cmd, void *arg)
 {
+	/* Disable all private IOCTLs for now! */
+	if (cmd)
+		return -EINVAL;
+
 	struct video_device *vdev = video_devdata(file);
 	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	int err;


