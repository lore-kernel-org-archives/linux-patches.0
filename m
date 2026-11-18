Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052081;
	b=I0EqdQ+6LMrfsavUOgxuw2DKcOlLT5kw05crCMyEaXh9m1xafWFnieIrquzzwKoqFQqY
	 c+14F2qkiwR+4sKoG095bfdCjVut/rsPtBHrZoydF8TIETTaDFLn46Y+cFInvjTwsBB6d
	 0b3QprZTwcp1dgsQMUaZeeQLOUKW76cBvG3AkvAxBNhMZmYfzhS8PFb3uZjORRPcsyqbI
	 pKuQXHuNf6DcphBIAMI4vlqa0NAbb/5xzAVp0cTVVsdmf+F35FYlLVLFnBYJmA6d5FEMB
	 JfzwD7FfsdjhS6A4RSvNpIfqQBNlWkOShNG9mspO4ZoNPRpA967t7EZQeHL5VwKjV+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X1or3T18PXiKa/JoHsK9PIrvuFwaQ4QfEbPCT2vc1LE=;
	b=kSucWIh8KNZh6BGChQIwkmHJnAWNZFdjMNEuaUIFLOQI7GJbWLlgAWrYC0JI5+aYLYRH
	 4USPBOB2KiLssI2ZR9cS3wwEnSlzt0g/1zCjtUrMWtjmBLZa20A6aMSnIuq9qmKSLzgoe
	 hAt2bbNQb0ldo3c51Gehha4ZgRN/kWC9e7RO9DUpQbMDXkQlxgexbDZAVjIoD4GHGt5YT
	 +vyIqTbo0G8VnYPpOIwTRxVke/4KVQ7KtkaxTCcj0TJne9jxo7V8wApn7MBnVIpMsKNYE
	 LDA628tRoUqfCAKcC3CcnFT4VFgdKBGEsvp8Y53UVtuvTtbYw1b37550f2D0Rr8mK+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQW912vX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCD7606A31C;
	Thu, 19 Nov 2026 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQW912vX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840CD1F000C4;
	Thu, 19 Nov 2026 01:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052081;
	bh=X1or3T18PXiKa/JoHsK9PIrvuFwaQ4QfEbPCT2vc1LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQW912vX+W66wlAy+O+rL0zXctsnVZdaSbE50d+aMb2v/qta2gWcWU4IkvkZvgoCY
	 vm+Ug2zvDCyLICFSjHBSv7YD+Tor1xfg62sGhXDrE1F0ZMrcxS0/lnqjrl/pwFgzlF
	 AvQy5OoVc3TOf4j7sRA+rIMFoF0JU8co7vvJV8bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0437/2214] media: streamzap: Add missing rc_unregister_device()
Date: Wed, 18 Nov 2026 15:35:13 +0100
Message-ID: <20261118150028.545631168@linuxfoundation.org>
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
index 72f83c09a3d9c..eab405662c65b 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -403,6 +403,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



