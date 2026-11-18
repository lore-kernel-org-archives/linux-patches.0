Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058058;
	b=fGft8B3rESyzQxtl0kvJx1vFo53idAlnz9qnXgYIxlpCudx7xjIYx3GgC4l11hNkZAFL
	 kOUb0vw8lxJtHKAfG6NVwXcoeBJi6iUcShi1Y55D4NYOYq0b9krt8OFFhhGCR2iWqrdcN
	 5HykDd74vs6t3iCeoixg3ByCGoR4+CoHzDxrkDsp6mjWalwq6/OPYI8oNUBC7IsBBaB1S
	 3PQtZXLrh/NuUDJJK0Tr7EQidn67kNR9vHMThVP2WAesHR/umemBcycW4HoG3xQ9e/Heh
	 3l7oIyfnNhVtK0U2btNgj4zWamsvHv6cTuUq15ROmT1HM0JXlf9IEDwfIiDoagzRcZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLJYDFLu8ObzteznP0kxCxn4aWxuAiOO14F0AgIDfRE=;
	b=vbZRy7rQ+6VSxQgXH67sX3PXUVqiEMTgf7iiEtdF1LTQTN/xddRTZf+YE8pO/5b1Xxmc
	 XvYu2zHTfm2F+1FKfQiPy0Fx/f1pcbmvxMJrjujZVYGsUADjt5NyG7N1NTFjockc//q62
	 dDRWo1nHaQMOhZeZk4E6xVc16FHUxIZYGjTtH7Qou87P3m3W5b11LBpA1X5hv9/O/GGgg
	 d2iiivV/mGsvOixi+O4O4uQpV5jWpJrKaHXU5sLt0OAPZZdbYAXJHQpWVO/gt3q7fAB0R
	 kmFdxTBbjFb3faM+6fHJ4M2NJ7F+3jEOdzHdinEwe+YYp7KkdjLRfH3n0TJy7FfFWTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkH3U49w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E3F606A325;
	Thu, 19 Nov 2026 03:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkH3U49w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2481F000C4;
	Thu, 19 Nov 2026 03:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058058;
	bh=VLJYDFLu8ObzteznP0kxCxn4aWxuAiOO14F0AgIDfRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkH3U49wnFaKjVRcISLGqNGA2ThbGn93DCd57+IjuvEi0tlcHr5vbO0R56ZzLI7Fh
	 eycCqThMaWz0e5bpNsUi07l9PGk40lnqlDuX74kngpcD2gOoVeSVW+MVHuda3hGejJ
	 muR+9ZGCqPP4aT5IpEP2ma6+UmTe06T/edC0Dcv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0348/1848] media: streamzap: Add missing rc_unregister_device()
Date: Wed, 18 Nov 2026 15:39:46 +0100
Message-ID: <20261118145927.259109583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]

If usb_submit_urb() fails during probe, then the error path is missing a
call to rc_unregister_device(), which will leak various things like the
input device.

Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index c0a0ed15efce1..4463923728169 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -405,6 +405,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



