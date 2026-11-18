Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043072;
	b=sDtJanbm5GPFiOv7o0KMpIRABD2IjqSqBA0pk7MyySjxvLNCla7NFzFa4mVhKYwmUfu4
	 yZMVaiIYjRuVJfI+ZNhlEDONrv7Yw9P/1oXmsNQEwxmCLkjcNxNLXEjwIsVufnhk4Ob3h
	 8/whWb/Ef0gPQ9fB1Z2IZReeWLVuVtQwLYdbrjhyR3x7Ywly7zuTDOPavjMDVrwR5V3t6
	 zlwe2c90TUMEU4mZ3Q8lGIREZdp18LZumCvJ5Bshn4KOLjnDiCXa0/7QByesd2/41EMpX
	 EMX1PBnIjpdzBar0ZWPM8jszT7TiznvTqZFuuh6m8Xvn5BIxBlA4szAuqpRl+Ob3MgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lx+6pRasz0R/aWiw2qfqXxPjt8/F2yiiGcUW+GpdBA=;
	b=LYda17r1LKgU2IXbO0+9Kgu7ZSfiK788h1In1f7NpwrwQZfhWag7B3D0L5mzIoovvypP
	 gAh1gzGvF5AmUbsbyNmrcK6X0QlRfDWwYr95DTKx1eBRs7lJavkwDl9ZZDhGnodKozcKK
	 BT2savm7UfCmQniSDhmFsjwlgcqBFEOQ3r8py+E9UpkJ77d15JO+lurjLvXA4y2u9zwMU
	 pJi3Nxnsbb5wwcjKp6zQofKEqxvRUvBTQzwQfI8RkQWPwKeAzpQxhtg/RzakJvIe+BnHO
	 gCWr4gC5/aBGO2zs+TTG9zpim1yJWFzVksVoZ/Vilat9YHWVh8OkkV4rZvJ6tg0BT8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxWRWIAO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A90606A31C;
	Wed, 18 Nov 2026 23:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxWRWIAO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E574C1F000C4;
	Wed, 18 Nov 2026 23:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043072;
	bh=1lx+6pRasz0R/aWiw2qfqXxPjt8/F2yiiGcUW+GpdBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxWRWIAOBMjkv9sRdyNy1046+SnFVuweRGz8MqcuUIj71Lc2gPhSxtYoteHV7HuG5
	 KoW3kNCMWKnvH0OyyAoCbkuezuO032CwAz7SstSlN54DZAuxA1iNgZRsMSOh3amZPK
	 +CAUMAnFdQhJag13QEWRU3KEc+DeSo1brQzEqa+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0080/2857] media: em28xx: dev_info->pr_info since dev has been freed
Date: Wed, 18 Nov 2026 15:18:34 +0100
Message-ID: <20261118150204.174128075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 62887cf6afa5d..a835084914802 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3504,7 +3504,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



