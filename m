Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055349;
	b=G0GXeLDY1H7lbOyn3evSttjOhh87Q55L4NUOwuzK+2sjdYiIVK6faEJi8SM9TTT86SHC
	 En8f6+7lSguUDlyMb4Q2FtiNEA6yIo4VeV7QFO+DCVqdzIZ8lMRlj92GhgOu/M6l4q6Ti
	 6YSRAvv+TNEFI5ny0f2LiVa4B8DfS9a51AiI/fr2ZVbhdlbeh4RGZ/OAOKINkMicDSZ07
	 PuS2vdieCv+j+cdD6RWTYF8EHiUru2f+PMX6Sj9cEedCfQCKS4OmThUCm0/PxLM9d8Znx
	 hhx0hzd+Am9f7sx88wpkrMat7ZHMucfdYvABBcnW1e3HNNNpCm01N7A7UJK97bTD54g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w69jVkl42uXHomb2Rxb2IaJ0spRm+5AQXCgMWJsGapU=;
	b=pcbbp+Nt7mH8Bm2QpOE4LdEkMg+hX40WOFU4MahoBzV1WHurV8rH5kF34+XUASqbdWye
	 IusURvk16kx2QLn+gjNNV3XqFFo32Zi3d8p6syZ6KJsZvvgA4aaikVNfHK4EtZLVD4Mfc
	 vFuoB+rOIz4U7/Jog/IPMmISOgMDVR7mfpz2+FAmQFIcDFeGvis4ZCT1SfpVm2uUPhbNn
	 JmVIUJf0trzVtqKdv4a0fozlzjSMYxAY7dDrDx2EheUpFi6UpFyswGxE+SRpyn+g6dGuf
	 OlQxQLpEouuLLcotMDFa78l7EmNJ/52FsHSO9s2e3jDvYkHNC0ZLxFUEiA6P5w2C1yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tjjzh4vy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22597606A331;
	Thu, 19 Nov 2026 02:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tjjzh4vy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799761F000C4;
	Thu, 19 Nov 2026 02:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055349;
	bh=w69jVkl42uXHomb2Rxb2IaJ0spRm+5AQXCgMWJsGapU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjjzh4vyH8vq7Lyi8PFNn9/zNqksbuU2RMyzzhDQh/QzKcBy2ApP9raquDkXWIWjo
	 Nxdrakh8jTjH6OJAzRX6HMBcP4249u2OO5mhnG7JnB+HIaOKz9pJVOUYzK6W6UiaBD
	 GG0/7qJv6qr5U4JWFUg0CGArTWpNK93rqiQQW1hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1549/2214] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150114.086431273@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d229695f2162a41bfa614f175798fa56a5f1c969 ]

In flash_fault_show(), address of uninitialized 'fault' variable is
passed to device-specific .fault_get callbacks. This is not a problem
if such a callback directly assigns the value like rt4505_fault_get(),
but results in an undefined behavior if callback just performs bitwise
ORs like as3645a_get_fault(). So just initialize 'fault' with zero.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260904054437.461706-1-dmantipov@yandex.ru?part=1
Fixes: 7aea8389a77ab ("leds: Add LED Flash class extension to the LED subsystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20260916161607.90106-1-dmantipov@yandex.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 185e17055317c..56a29ca6f4a0a 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -188,7 +188,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



