Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9C33B6E8;
	Fri,  9 Jan 2026 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961874; cv=none; b=StQZOLtunTiGeHVZ2H8bfbtFDlthVGqFhmUPW4dpGUPdhOWifoBoihW5T8MLkXUj64ZSEK2CJJu09AgcD5GWkgg8NrtgITZxMkdtY8OgYGFV5bP04Hznb7VTrdnD9bTQM/z2U5U+8xr8Ufp5YodPYm2r+I0x6EWLmJpxsQIHppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961874; c=relaxed/simple;
	bh=SWleuy6dI590TZSw94eBywe5lIL3ApidDfmGwGghHls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pY/gpt0KcjzJDTu30S69IJD7QZY+X5lbOedb/2vt9t1321DVGvy6ysOGbQkBOGvVyBuXciMxZ6lDJDoJa61sYntikXG7YiGb86iVbJRUJGNxsbisND7aXR4vvgkGkszYLLyy1FV6eUt+yKVLUZcwvUuhvmMmYFylhpDxYPMG3hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZmbYqo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZmbYqo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B751C16AAE;
	Fri,  9 Jan 2026 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961873;
	bh=SWleuy6dI590TZSw94eBywe5lIL3ApidDfmGwGghHls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZmbYqo9ZU8usxUMhdsflGntnOk9McK6tv/tH276BGd5qpmaUri3dVp1pilpzxJG/
	 8K5pR2Gr6LvGHINlpv8ANxULCMW9+G09iD6KHBLpiQ/ZF8djRluoXFXpuKqoctI2vC
	 YPtmk11i4km5mjcMKmftj01rb0hOFkdfh5tlCL4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/634] virtio: fix virtqueue_set_affinity() docs
Date: Fri,  9 Jan 2026 12:37:23 +0100
Message-ID: <20260109112123.656979277@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 43236d8bbafff94b423afecc4a692dd90602d426 ]

Rewrite the comment for better grammar and clarity.

Fixes: 75a0a52be3c2 ("virtio: introduce an API to set affinity for a virtqueue")
Message-Id: <e317e91bd43b070e5eaec0ebbe60c5749d02e2dd.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index eee145cfea6b5..2051295c3920c 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -308,7 +308,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
  * @vq: the virtqueue
  * @cpu_mask: the cpu mask
  *
- * Pay attention the function are best-effort: the affinity hint may not be set
+ * Note that this function is best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
  *
  */
-- 
2.51.0



