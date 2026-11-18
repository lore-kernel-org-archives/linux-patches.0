Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058262;
	b=Sg/Y3+/ncJdZi6s0C8nb3DWy9DoOgNorqD10QtZ2lDRycgBbGImi33mEw1L6SCMLouwn
	 e51eTVpbsZPmNv7EVAsSKkEqqj8eiAi4a5t8xGSLvVXVs89v/XISUfdBN5d8gyY/JTiEW
	 hWQ6lLGfQihiROmdudB2UyGbwTjy3x4M9dF8qZum0UBHt11mWwEo0VcwlEE3QFS8EGfzG
	 45ksQ+iDU5iK+N96S2lLwwExLg9dlW+wqcIumEs16+nIp0bU/URyR3yPKmMIFieCHu0W6
	 bb32aBvYx4b22ZnbseiE7KzNuay05a8/9j0tKsaSB2jQBJlfc3iyTffJkWqQLC0/79Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+IS2CJG68VenyIm7y9xKEEIsHK0trHcfVYhkALU+5ww=;
	b=SnaZjztJYDi8K76ML6Da7fJidwYa1yzqM+iPCytcXIU2l6u7XMGJUOUJ2bWENyasBwRE
	 umPheqGuO306WqSIfjvqAuog9/0C1kLNrqNop9Ij0K8wW6RrasoX7mbwNxxEsSapnVWCN
	 bLhUDH4VTROaYeoTtikjgukNLmhUNxnxm4hqQXBlnQuIXPv2hpchpPeZ/P3YWEV3NmAp/
	 smL0/iF/ShKloBDGfyfAr0r9zEFbFcqSt4OQRjLCEkpwFg/HN/dxMU2euhbACPLUYlUbB
	 /pQh4aFF3ruHJJiXYmoXtGIp3WqSzEQL7BwIarTz8wuTUFYjEgVwBQ17noJEBWe5qSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzgi+5dd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57672606A325;
	Thu, 19 Nov 2026 03:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzgi+5dd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C221F000C4;
	Thu, 19 Nov 2026 03:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058262;
	bh=+IS2CJG68VenyIm7y9xKEEIsHK0trHcfVYhkALU+5ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzgi+5ddigs+Ojc+riJMI4+07GnGhQkq41zRcjM3qW2ZkkkWmBZhx8khpfmtwMK1d
	 8W27heSwsUbp9yl3HZoRiRWTBPGlD9l8AVgMq0J6hNNMWkHH5CZtJC5AccRxjjgPcx
	 6ddSxeI9zT3pbSPW4wyhmDg6VzfdQgzipix1YjdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0423/1848] media: go7007: unregister the I2C adapter on USB probe failure
Date: Wed, 18 Nov 2026 15:41:01 +0100
Message-ID: <20261118145931.842497576@linuxfoundation.org>
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



