Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD0B3B1B4;
	Mon, 17 Aug 2026 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976941; cv=none; b=TNDvy0Wm06eEvOJrqYALfWvOD2l8+MchYDBHxr9LX6yRhK+pIfObQLvpg2mgZVLzIr4gQhZ0ZXWAzztGSRe0yrQCsrMSdYtibIqdLjjnMnwBfrABjEODYpod1yHHnWrZ8sOeIfuJNmH42IFVD73BrPh0XUEz9X4X5IDRzU6j394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976941; c=relaxed/simple;
	bh=t7zxxPRdbPDGljFF5UW1SiOtwzWZfa6kFUCzXgJBwDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5T48VfQsjTMHbhDQjufSY2A+eU0qrUDqFKEJxiFRL9gGx1Zexd3PPwcCzgv/qcdafWAiyAvPtWvUaM8KxMf6GdwD2bZFQ7NA2eI/nL6ftltLyhWO2tK/BNYP3eTb0aIyC2Qf+NSxxx/cOmMV+MVT6TQbLfWY7dht0GjgZ+AYyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWBIFmML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWBIFmML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6241F000E9;
	Mon, 17 Aug 2026 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976939;
	bh=2bI4fByPZl7rEvgI5Q/4X5+8E1Orrajw/ONwkyXPU1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWBIFmMLrK8NKaZBEZAnMtMUTgIT+M9yT9rH6nzAadVCZ2k5P4ANDpjELbX2aWu//
	 pRz208zGMpsjs2B7XbZl+Yb8xZvDGsNL4+mkNU5ryJYaKuwTsGBq+FjrYOx+X8QTe9
	 FvOLEWHwb7AdQ7+UIgGFhJmEHluhCa9UOIVgC0Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Paul Kocialkowski <paulk@sys-base.io>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 158/456] media: cedrus: Fix missing cleanup in error path
Date: Mon, 17 Aug 2026 15:29:08 +0200
Message-ID: <20260817132546.265224020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

commit d99732334aaf33b9f93926b70b6a11c2cef3de39 upstream.

According to the documentation struct v4l2_fh has to be cleaned up with
v4l2_fh_exit() before being freed. [1]
Currently there is no actual bug here, when v4l2_fh_exit() isn't called.
v4l2_fh_exit() in this case only destroys internal mutex. But it may
change in the future, when v4l2_fh_init/v4l2_fh_exit will be enhanced.

1. https://docs.kernel.org/driver-api/media/v4l2-fh.html

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Cc: stable@vger.kernel.org
Acked-by: Paul Kocialkowski <paulk@sys-base.io>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -302,6 +302,7 @@ static int cedrus_open(struct file *file
 err_ctrls:
 	v4l2_ctrl_handler_free(&ctx->hdl);
 err_free:
+	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
 	mutex_unlock(&dev->dev_mutex);
 


