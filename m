Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061564;
	b=jPEhEeiVuDvj1WBziRxrytrbnFrW3Im2teNL1T2+qk/JGHEQYC4G1AakVWiTCGUFrcqk
	 KFTEFadA4pQk3c8qWWffP7F7HUcFCBoMBY7CfIn4x4crj3dIiXzB1vYOTnwJQLc8Gfdij
	 9R19SOvO/w6GQ0btSRPH6Z5CrAU7Y86+QKhqTOuMTYvjwlOP/26kf4ARJOOOy4QIHPwzW
	 0MkXpYhGTJXajJLU1NTDFr+p+9Qv+nOMDgbtOn0VPDvU+9UAsq7xKE8j3DmyIJiUaFDM0
	 cbvzlbMtbD+ePta+lOwj6V8LFgjFRtywxj+7dCb6+/+qS3nhBi1iyfCUf/h/YAJDHTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXoZ+zVVyg5M1YNHFmfGEccGxyrpxlckbffQIOJETeY=;
	b=CVVX9v0/uw9wSUc8yBbTDTQnjTi12h5ThhALbqUCwYNpjkcwAbBdwfk2U556wJY8HT5V
	 FDtPI0ltvbXD7+FIBwX/QxFYQJPcUVYPKi7pf2C1BKEQKDYTD67KFvZgEypEaSyQZM++L
	 FBR+G3wCjgkxP80INDLx7Gms/3MR04U27PoC+iu8AzD20Ae04HW1O+UU4hw4dQngMhWfz
	 lu94fnRyvhSY0+mzez1UKsxAf5vPKJf2+vF+bJneE9qkcruEp/fyOKEiLGKlMdAAtq2Kf
	 WEwGSTXSt0R+jDM4kNfmwYXBdCzFkEmAa1NOR+k69+obNFHbjDbETK3JZ0hsLsp4Efg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IA2RhHN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3506F606A32C;
	Sat,  7 Nov 2026 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IA2RhHN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D4B1F0089F;
	Sat,  7 Nov 2026 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061564;
	bh=SXoZ+zVVyg5M1YNHFmfGEccGxyrpxlckbffQIOJETeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IA2RhHN604iFEcS94PLGjmQKXNvoJU7FM9tMeJi8jNTxaesljwwkAHS6snYI6Dc90
	 3VbAIb+cfpxGyZSybbVgPAN96dV3Il0c1AB9c3mh9gw1N5/+ei/7uFie4KwT58B2aU
	 v5T5CUaCfcEAFYg792K2acD9tpZbaNSJj7MN/Kaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0644/1536] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Sat,  7 Nov 2026 08:44:20 -0500
Message-ID: <20261107135015.619237883@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 3dbbbc3cafa2de377d9b97af4e35b8b6b5282047 upstream.

gspca uses vb2_fop_release(), but gspca_disconnect() only unregisters
the video device. If the queue owner closes the device after USB
disconnect, vb2_fop_release() releases the queue and invokes
gspca_stop_streaming() at that point.

gspca_stream_off() calls subdriver stop callbacks and
usb_set_interface() through gspca_dev->dev. By the time the late close
runs, the USB core can have freed the usb_device, resulting in a
use-after-free. This was observed as a KASAN use-after-free in sd_stopN().

Use vb2_video_unregister_device() so the queue is released and streaming
is stopped synchronously during disconnect, while the usb_device is still
valid. Since the helper takes the queue lock, which is usb_lock, call it
after dropping that lock.

Fixes: f729ef5796d8 ("media: videobuf2-v4l2.c: add vb2_video_unregister_device helper function")
Cc: stable@vger.kernel.org # 5.10.x
Suggested-by: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/gspca.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1643,9 +1643,8 @@ void gspca_disconnect(struct usb_interfa
 #endif
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
-
 	mutex_unlock(&gspca_dev->usb_lock);
+	vb2_video_unregister_device(&gspca_dev->vdev);
 
 	/* (this will call gspca_release() immediately or on last close) */
 	v4l2_device_put(&gspca_dev->v4l2_dev);


