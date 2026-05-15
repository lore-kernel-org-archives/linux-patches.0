Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722323FF1A2;
	Fri, 15 May 2026 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860234; cv=none; b=nW6fnE7LKmnvh9KGWk9JWSHwNKkA+3rbT/5761WlGgXoHquVGvuWiA8Q5knmQ0L1elpH+WJwX2i2+iRcytcr6JLEsvkp/R006pPxRKsWF4Cc9VxLZXZ2clAif+kENr06QBifLDm0QrQllOZXjpP4/jRNwPQtMUYtYPFJzvhx0/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860234; c=relaxed/simple;
	bh=U6Xg3p6NSHHHnjp/c4SF2wJy+lhhB6f48xPL7cj0OqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ4KbX/qVkmohrI//VHnN/2uTzEKlAT00R0H680IiS96ToZDM+l9oRPD/DVlyWZMisO+/RUMYJziGJqst7vhAKFd1galyg+x1Uz9DV3ELUxiwb9Djx5KiALweGzOzjg7z6k1aR57yJd1/cWKSb//TMeDLq5KtZeyCIXZ/vJ7fvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J73nOsEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J73nOsEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3620C2BCB0;
	Fri, 15 May 2026 15:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860234;
	bh=U6Xg3p6NSHHHnjp/c4SF2wJy+lhhB6f48xPL7cj0OqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J73nOsEzFDnOyRI/UCAmOjQbRO5DHR2itnukf7RQ2wZst2gGBS9ZZhQIQshXMQHkT
	 WUnSbohMKLWsaaVMgKXMrOz4Tv3UtcRFSzSIpdqoU/SdLL0vf2tfMgGtotqOVebWOL
	 2ONtNNYIQmO+y+hm6jQnv6jx5dP3sZ2g4sDCehIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 011/144] staging: media: atomisp: Disallow all private IOCTLs
Date: Fri, 15 May 2026 17:47:17 +0200
Message-ID: <20260515154653.750083467@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
@@ -1371,6 +1371,10 @@ static int atomisp_s_parm(struct file *f
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


