Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831637;
	b=si7dQH2LEuG1sC1+IXyl/lK39jE73Xv9e1pbP0UZxSZN2wDnti82DvX1xqo4W+ImmdUk
	 QSb1jbBVNIF+7LvfxhKxbHra2P+NLWdhDFStm7z7OfojZCo4GC/UhoEyNZ7WuL9gBz8dG
	 yGYuhbY9K0foOj0T7qNIzP8ckJ+IOQHhSl1+XCgYw8qvxE4B+Nkn87o5/oHuNNLo6PCfq
	 nNf/d9Zq9y7JRnDF95ek+mWoJFe6xDWYnPAfIK7qyGwG96CeTB2fSGeipqOWnlUpWdmm4
	 ZHTDflxV47nzVhWp6uZ3QOxVh3SZgv7WaC+VxKuBXCBc10NfrARDVo2uL0aF1vvHZCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bDj4rL1zSIqMHCKlu/KLMDk9HlW/RZlkCfrgBacVpHc=;
	b=ZI0TGcRK+6+CHgx38MVtflwZ+tETFuBt82f20UE/4PKo5x1xONUjUP6vF+3Vn4a84oba
	 EutLI6mv1AylxuyyTKj4TM5vxVXrkmjL8EK8zalyHYgI9YCdUag1CWMTrVBoYgWlMA7XA
	 NRL9IA4ORueJ563hxP1haQnGfkOV1ZfhqgE6qlQPplrgjGew25ffv3whVCKnRgkgZvww9
	 vQyoNdAmm8BfxG6vI66nuDqCmjgX7VHiv8dVyKAOfF/+Mc8rBCdNbHP/+HChlH90aSJxw
	 1fTgeO8zTCt/fzpUK1CRLLT/ZEAPzzWeGzuksMDScX89IdJ/NyeNYqAhuR5k1ToiAHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgDhxUl+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F99606B2C6;
	Wed,  4 Nov 2026 22:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgDhxUl+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6CC1F00919;
	Wed,  4 Nov 2026 22:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831636;
	bh=bDj4rL1zSIqMHCKlu/KLMDk9HlW/RZlkCfrgBacVpHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgDhxUl+PYBw3p3Mv+SieNXpazm6w36EtPpSSxLuUKR4+HsMnFpoRAzBr6t9WRGdU
	 M27R8R//yXqbhHsd9NjWIJPg5rOqDg56Ik/Xa7z0jUqv4zOt8uygFNBB8AtA4l4JOh
	 Qnm+k3k6u1UeVOP/xqXasjDWGwMpJ5QsaioRHeTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0825/1005] media: usbtv: drop redundant device reference
Date: Wed,  4 Nov 2026 16:09:18 -0500
Message-ID: <20261104211106.446642195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



