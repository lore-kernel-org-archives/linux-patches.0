Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057245;
	b=lnfV4eg0yUSgYyuMzp0KfuzdqPRhqq9SZk1Yy1Qz0Gx4ns+usxVYSlGt508bemgRXV1V
	 1NcAT8aXOk7z1KJYQZDZbUEZBZmNV/5AXIxxhet0bVtAdydSpZSm194gEix72XbK2tIx2
	 gbFOmufMXgeCE8zezajeO94kbCZ9vGAREgV3JbH5AvO4as7qWpgW7dT7EYBB9hliLymVw
	 6psX4GDmmK0LA7O1Z2rx3WqR5pK89COMQwhvly1IZFVpWULnOZSEFdKaG20oJDQuJVI7o
	 FBW25SDxYL8gNoap+B/cgcPm2iEx2fvQy9POhaYAT59jSlXt8rAPg5cRmal+N6ApwSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmEoc2HTnlfKSGRXSUm2HaFG4t+To1G0bbl17oTEnmA=;
	b=mH0uh4zYH4012DKnDHG/J/rwBnAElQZv7vcds4+RnTl31fjjfNnl5RoqeJnjLyMM9O+L
	 TJ2HpvIN0F56yDSb9+P2Pq3aBDlBfROxK5Dx9SFCCmx+Jf9GQWeu3+WsXOEndgIbfrvXK
	 VyM3TteAqx0lk8oavkrlIZAHoBVULcH54O5SHoCHr/Mj8XrLWdjlmkdkFrGOHz1IgVsdr
	 kNrKnlE7aAkTzDvJVVSQDn7xri+uBMqDRIXZZ/LlZeMFiQZuVhSy8ePSSg4gaTPkn9a6L
	 R6VYMc8RrOXy9NcSznnuVMzH+ioUqZKnxmiVW/CC5ozJFtmosBVj+RL8+q1oRIOlpWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TrEacBxc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5718160A260E;
	Thu, 19 Nov 2026 03:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TrEacBxc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECA51F000C6;
	Thu, 19 Nov 2026 03:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057245;
	bh=RmEoc2HTnlfKSGRXSUm2HaFG4t+To1G0bbl17oTEnmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrEacBxcVhozcy59DUUZI9lfa9MpFmkoln8kb2QslC+DRNUfepo/dN+lEZ4986STH
	 ySQ4dbejvT3D06I0vo9mVMaSs4ks1ne6WOMKql9q8rUvj5sl3Bomu2wis6dNJf4i4K
	 RiWWP3ti3qPuBr5g/nSj2qKrQFdTr+WIVmsdh+hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0063/1848] media: em28xx: dev_info->pr_info since dev has been freed
Date: Wed, 18 Nov 2026 15:35:01 +0100
Message-ID: <20261118145913.789061277@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit c132b07f7e5853c0df35a9b94b8e204cdc6afdef ]

In em28xx_free_device() dev_info passed &dev->intf->dev,
but that device can be freed already.

Just use pr_info instead.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 883eb10c4ff66..d05c069b6e726 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3459,7 +3459,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



