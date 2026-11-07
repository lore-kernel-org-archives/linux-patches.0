Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060689;
	b=0yFWbu4L2ULsJTM5OmOjF1qa8KFpSmOB/WqHs6/hp3S5LAWkk0riiQlHHN2tymmFLjz2
	 uXYJKpP9mlINfpeh+DT+LCkB2TOpulYYqZiuRDSq7lPMxbj3PMnswS8hqqSUe9M5KCFSA
	 sLH6tnGBnYtqKi0fZzYbTq+56Urmu5XFYR9Hml+C2cMasd58hQyUNc78YHWHHuzNgkbRf
	 DAdrgqumzryF0dBtKwBTrmvfZtb9WoeRkEWqEJNKNONtI8TwQnB9Khhk1VnCR62wtYMzf
	 mfhojoUIX7afLhGVa10lSuXm9BUWnsFy3NZwxoJ/p+RnWywvlIKtlMnIHWnd984++Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+a/biSEiPdh+YFwR4AyrLNuStA2pd3iVeht4ZigUWgQ=;
	b=xQgkB81NbGAEM+sAsvvXU0iltWhLj9aEFaQEEggz0qwkPS5kFnaupvuxah945QYuskct
	 oz2pfF4y6A+RHiFv4vNYw4H04DlHHzGgCqZWguoSH86L4ZBVZTBu9UGIdH2Q/IdnYR6BU
	 5FVCpbmC0iabgszS79kiFfMYmuQvbVpTivTDX2+01n4qo8bDk0FfS1wCy+pAwMb8B0f+R
	 djG/AuC57Qhi8lUH3GbNIgjUX0Qz4R+6ZjWwGfyWDF3BB+dxO+8lb8GBdiipsk0GFtE9k
	 3K40Al2ZAZpLN4d8XrnWUf6VIvw7TDdnxgpG8Xr60zBrmvbSNNhUcJDu9m4uUcozqCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Typdcj5P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE068606A32C;
	Sat,  7 Nov 2026 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Typdcj5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C11F0089F;
	Sat,  7 Nov 2026 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060688;
	bh=+a/biSEiPdh+YFwR4AyrLNuStA2pd3iVeht4ZigUWgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Typdcj5Pga0U8gnw/hLPJ+lckA2A3BFH+mMb33jqF2y7K2pA7N7T9nxFnefeXt2vB
	 yZ8yojRJKJBtJ8HqRuhzcN9XXubbOFixt6kFz5tC1whHtAUP5N672TLnjGrO0/tfyj
	 nsDfFdXE8/Fp5Qeevzwgbba95YVwqYD9rOf2BUc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0118/1536] media: em28xx: dev_info->pr_info since dev has been freed
Date: Sat,  7 Nov 2026 08:35:34 -0500
Message-ID: <20261107135001.002583975@linuxfoundation.org>
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
index b8e207443770e..af2c06a05084d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3556,7 +3556,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



