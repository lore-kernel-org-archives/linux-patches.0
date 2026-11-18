Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055009;
	b=mZ62dZdPa0dCK0CoSSM+mJy5xo0IhUTINjg7sYEw5EXeRR1EmCtAZgIjhE1ATN4E82/y
	 SfPkldNImkpDkl55PzJnH47D9rGQTyIPdJtwj88q2wi1ddJDMmFPoAt1b6QaWcmXx9a3u
	 sZxqj7RWCJAU+mA/kTsjzB/j4oFfwiSaDpsSc3zVlAJHM16uyd6oMJWtn9TIQUsTIpMnP
	 dXJK8l5P0M2P9tGrZ+6Jq7+cnKq52rd6t2WnwsspGT8kyev9POgU8SBP3on5QyfMnS2m5
	 iJqRNUF8e7tTWI2Wf+MTDn6ga/gJQ/+FI0uPZIYfQo1vi3ayygsocs35JiBTMuZDC4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2di8wiwTz3d1gGM18vfvCK5/8LsflUVNaz5ylZjj+yI=;
	b=r+pOYyawkzqzw9ubjkzVorCtsBE2N/JMye5ztWOXQwC+m96IZIpyqF83f/vBJfNneSnD
	 gHs9IhSYEdYCefYn+idiXIxFLOylfPoxhBpx45ocKwJVUb/2Y3FuYuEWIzMNk+Dh7DXbq
	 9F4D7YeAvaUPsDcGz36W7xSlAqKY2ClhxESxviU3dxBZ1zKaPaCJgmXWTaktRqiOYg6WC
	 ViT174m3pjjyTeZJHICGC7rb8PEWPioIzPfkrCbCDHfBuy379GzNd+1pFK+nLbWUsxtS/
	 bZaPQ7QLxwYkH6ruO7wOQGq6ZS+jH/QrubGgTicx6KzgGekOKhkosDR66y5LLWKsfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zl2MZH3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6B606A320;
	Thu, 19 Nov 2026 02:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zl2MZH3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71AB1F000C4;
	Thu, 19 Nov 2026 02:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055009;
	bh=2di8wiwTz3d1gGM18vfvCK5/8LsflUVNaz5ylZjj+yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl2MZH3uAYuaHZ7iqnEjnbgX8wDp5793jax97RndtYcwauhHdk30CNo1Yo0ETicrV
	 7ap3dUBIruTGHlBaGT9C/oqgxYSvCv2Kt8i8jrPc3krm+Rtklr7jW6GDOSaScsBo5i
	 V0ImeIvDh+FW5snSxZyt5xJAUuuFGy4YuvVPnKYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1479/2214] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150110.322076926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0a6cf2b7adcbd362039e9d282f73aff3f24022ca ]

The fw_cdev_event_iso_interrupt and fw_cdev_event_iso_interrupt_mc
comments refer to FW_CDEV_CREATE_ISO_CONTEXT, but the ioctl is named
FW_CDEV_IOC_CREATE_ISO_CONTEXT.

Correct both references. The misspellings were introduced separately
with the userspace interface documentation and multichannel reception
support.

Fixes: 7ada60e36764 ("firewire: Document userspace ioctl interface.")
Fixes: 872e330e3880 ("firewire: add isochronous multichannel reception")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260911222807.7673-1-kmehltretter@gmail.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/firewire-cdev.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/firewire-cdev.h b/include/uapi/linux/firewire-cdev.h
index 5effa9832802c..75fe7db52b6b4 100644
--- a/include/uapi/linux/firewire-cdev.h
+++ b/include/uapi/linux/firewire-cdev.h
@@ -211,7 +211,7 @@ struct fw_cdev_event_request2 {
 /**
  * struct fw_cdev_event_iso_interrupt - Sent when an iso packet was completed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ *		set by %FW_CDEV_IOC_CREATE_ISO_CONTEXT ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_ISO_INTERRUPT
  * @cycle:	Cycle counter of the last completed packet
  * @header_length: Total length of following headers, in bytes
@@ -271,7 +271,7 @@ struct fw_cdev_event_iso_interrupt {
 /**
  * struct fw_cdev_event_iso_interrupt_mc - An iso buffer chunk was completed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ *		set by %FW_CDEV_IOC_CREATE_ISO_CONTEXT ioctl
  * @type:	%FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL
  * @completed:	Offset into the receive buffer; data before this offset is valid
  *
-- 
2.53.0



