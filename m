Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051053;
	b=i6/30ZMO4DLRgeRSncqE7H30J6kSTZuXxlv3l+fwhvXzPKOROHgZDQyaAWl0tbgC8a0L
	 2cukS5mGsL32WIQW7fmm90WeVN2rcohE72x0/R9ZVTIPvCCtJwJeB0rv8aNAV7FiXd//O
	 6r9qDI1pKp2UebezkWSBAcTZRmiEv3ZWriiNyIQq1l37/NpIyqG1l8ZQKo5iIAZfVK0Xi
	 BcERZpL7GJ4syhrPP4VCQB5D+jYrEAWPONXtsBF1mq9dbTfvWEndMul/NYNnasGQgbz0C
	 Db+uQLgDN9+AoP4fSb5XLS8jMYq3dFKiMN6q9HAaZzO5XbuauwquO1rHmtg0zghx89g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l80Te2InAYOfuq8QJHicoMcK6SJnHg1HOpRLzrVzltM=;
	b=p1RKpxpaVmpR8YbSMeokKNASzS3RICFo+NvTMMeGCiLDk8AX2wjR9o3z1NDy9qWtbpqo
	 K2ZI1+f9CJD3b76q1k/mKHYx053EtLSt3q7e7XOCGVvVXxwrz4telc8Rl3NjyI9C8QI/C
	 BmNaXKnMUBsR+/o64Qg5ATSDHkcm8yUu51KZE4ukW2vzKrgHTn2032OEOzosD4B8Jkww3
	 xWhDuAvIXygtNKF0yFcz6Fsw9UPhfFFD3ryyolvFDQHd35Z2DBtrz99FAd38vXQZRY3EN
	 aII0BcDiTR+urkpuh75TEsX96nd6z+AO6jX9kkBmoJ9eDejA8mIUdh79L+6bOk7XNIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d69K+3+I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FABD606A32C;
	Thu, 19 Nov 2026 01:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d69K+3+I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3BF1F000C4;
	Thu, 19 Nov 2026 01:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051053;
	bh=l80Te2InAYOfuq8QJHicoMcK6SJnHg1HOpRLzrVzltM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d69K+3+IiPHKXHtJFzK1zQDtgKfHlOiBrnEQtUt3jvjw9ZtCpzmj6WIjJfv8kl9dN
	 BlWbqBRq7cdUkVZKeBqqmenCPeje1jYgl5sioHaIBqbfPI2Osfl3apZRND7cJKZA0r
	 iwBvwDSejr7649n5thg08LDfqnOXqX7pJXdUqbsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0071/2214] media: em28xx: dev_info->pr_info since dev has been freed
Date: Wed, 18 Nov 2026 15:29:07 +0100
Message-ID: <20261118150012.828659210@linuxfoundation.org>
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
index 9027660b0fe64..1af36627ff617 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3509,7 +3509,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



