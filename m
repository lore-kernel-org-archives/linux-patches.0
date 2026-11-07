Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061663;
	b=DpiEv5TmeNQ2zTfFqT2YKBjEc/RkxyMxp6mTaD7XaZocqDaJgUjAJzg4u6qdVxE45XS+
	 Cv8Xrsu0InUEXLT5y+yWp7xcoKZUwylGEQkTjgqlLV4VInAqYS+C7yx+gENclrujmxguu
	 2v8lhcZMYm4G7s+71CyyZz3JXwTYoVcpZTBPEXkGY5YrSzBad2BynsP9J+UzYhGoC8OB9
	 JOUc7u8RS6HitHNBgUyOwz4cc04b0qmISlm28bLpdtOMgzQK42JGeYTpaYsrIFkV1rdF7
	 1MvEvOptQL7rwCSBzmK8XMthPJp3dl/iNwuctf+QX5MY6d7HIADx5mfnkUXqUmFdATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y2/rXszkDo4jZxWsTmzi+3vN5MFLY/0cuCtgVAshLys=;
	b=AqyuaRpwLbxEBP3jEp6tvoz/qoJwGerc4qou5qX3XajA2vIue92Nt0OjZT6at2wRwC1H
	 vESTlOrwt3Hl0i4UfxvfrDOWZThl2JCpQYhcdTcXmd8Vt9mVUOV8/K81ax0ViJpOy9guL
	 9Ltq2xqm2N4L8r+5F7s0afXSk6O4qQTAAjI1KbZ2bIeNNZASlJ57hsedghEfaP9kgDOpb
	 0vh0rsFsnaeLFbCTUCAdDUC13mv6lpbOeCV5+u6TThVGqGgLeIdvkS/PvqMGLsuHZ5Ps8
	 w9p4ZtEIlQrzlKU9LNTJemqDuaND2J50nP/X1cyWAQOcLeyxqUwpZYU8qEBluQdQLAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16ndOPd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430A606A32F;
	Sat,  7 Nov 2026 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16ndOPd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7334E1F008A2;
	Sat,  7 Nov 2026 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061662;
	bh=y2/rXszkDo4jZxWsTmzi+3vN5MFLY/0cuCtgVAshLys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16ndOPd2G5dFNSXCjqcQC2oqdk6d4AtDo8yxsYb6hretjDfcQjIZmI+a9nFVQy9lb
	 1nyQTvWSZziq5BVaUts+ugRoiZzpBQdCRyagkhJObsFe1b0IhsEnLItYa4yWjFAe7S
	 00yP8QvotYw5eU41ODwgUcnp5WQULFLsdBLx5LjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0720/1536] media: usbtv: drop redundant device reference
Date: Sat,  7 Nov 2026 08:45:36 -0500
Message-ID: <20261107135017.719618046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit dbc6798b80481a20f9aff671bc4d529eae63c9e8 ]

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

Drop the redundant device reference to reduce cargo culting, make it
easier to spot drivers where an extra reference is needed, and reduce
the risk of memory leaks when drivers fail to release it.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: cb705f75d03e ("media: usbtv: fix null-pointer dereference on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/usbtv/usbtv-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 1f7620cd2996d..4925113af9603 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -91,7 +91,7 @@ static int usbtv_probe(struct usb_interface *intf,
 	if (usbtv == NULL)
 		return -ENOMEM;
 	usbtv->dev = dev;
-	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
+	usbtv->udev = interface_to_usbdev(intf);
 
 	usbtv->iso_size = size;
 
@@ -119,7 +119,6 @@ static int usbtv_probe(struct usb_interface *intf,
 
 usbtv_video_fail:
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(usbtv->udev);
 	kfree(usbtv);
 
 	return ret;
@@ -137,7 +136,6 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	usbtv_audio_free(usbtv);
 	usbtv_video_free(usbtv);
 
-	usb_put_dev(usbtv->udev);
 	usbtv->udev = NULL;
 
 	/* the usbtv structure will be deallocated when v4l2 will be
-- 
2.53.0



