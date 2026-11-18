Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052403;
	b=Gi5LInvLFfkO3erflWWx/0uuxDcZSNCSP4AJw8Lbn7+XxsgwRRRI35fewD4S0fDhBnMq
	 dfp+zLVI+0YlTduuMsFgIiNsMP88sO4LJHiSYOQkvVpI8siauK9iO7yyCJpR3hQPPKC9X
	 Wn5zLi0L49VDPJQxeKitWPf1GZfb4SROVjSQFbsfobxhwMp/OU9kb4nNo7v49PZt/JGG2
	 J3kYVlyUxofFOvChoGcKBZzjzHu/FVjPBhyfDXomIT7QQpX04f6ew0pXICnc+958rgmEE
	 xEbvqNi7dhFfPAxOm0Lw6m4AW4F5iUJ0in17uR4zx5Z8ch5hAvbUtVAR/8VcQV48GKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jAQCgsfqJX1HDa9HHbjlXyteeBCcU3TmmG48K6zI8yw=;
	b=lejyJfR3t/QWB8ZeVOIYt1+phZbYIhYxBYHXZl2DXRddfLbrw0OeVvR1qDXCgHmKNYnV
	 TqXkEaUc16wZH3MpSUlXHR1qfeVdTbSBXPZ8dtO9ajeZmsV094WxOek/pjhApz/seO9d+
	 FmLB1E3FoPY+F+HT+IadYA55G93v3Cg2xDtYy0EBnvHEQWfBE0uKDqxO+A+LapeKzJdDl
	 R+GZR2W91DSljkOBKtVchFMYpeNIanr+S42duLXAxY+7323ETIYOxtcB7uiTRYomLW86P
	 ZgAiwBb3k1HJCEdMpybACdaQA0wKHOplS/YPA8g/fMlmZzLinAKxVPgD1bc6DUI0vyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4lfAvqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212A3606A31C;
	Thu, 19 Nov 2026 01:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4lfAvqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FACF1F000C4;
	Thu, 19 Nov 2026 01:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052403;
	bh=jAQCgsfqJX1HDa9HHbjlXyteeBCcU3TmmG48K6zI8yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4lfAvqG9ZEeIyByPuJkXC67TAhsvw0ZyxMQ69kzFafG5oVckGXd7ZrVRg7nDHsF2
	 btq+JLFUegL5aoocFeSYmoz2dSoXT1rN04EMytH4+y56G4ZpU+YAbnk2tlXtOs085v
	 MsuUYuaaoe/CYrGaDn0ZmL9fauUwYZ8FzBmImWXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0524/2214] media: go7007: unregister the I2C adapter on USB probe failure
Date: Wed, 18 Nov 2026 15:36:40 +0100
Message-ID: <20261118150032.049571258@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14165cd16fa7c233aec6a407b56b304e7a283911 ]

USB probe failures after I2C adapter registration free the backing
go7007 structure without unregistering the adapter.

If i2c_adapter_online is set, unregister the adapter before releasing
USB resources so that I2C client removal can still use its callbacks.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 59aea928d57f ("[media] go7007: don't continue if firmware can't be loaded")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 6a0733c5925fc..ff479d6495c45 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1326,6 +1326,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	return 0;
 
 allocfail:
+	if (go->i2c_adapter_online)
+		i2c_del_adapter(&go->i2c_adapter);
 	go7007_usb_release(go);
 	kfree(go);
 	return -ENOMEM;
-- 
2.53.0



