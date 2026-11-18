Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060810;
	b=bvcn08r5nJWogcfmpuK8gdnDCUsfSsmutO7nHXlmmO5gqg+hjqcp4JPgc0SI2V0rjwCk
	 KFpwK6S+fguGPeA8Pp5F8bUStk0RB4HLZBkYArgxvOWfZmo/JrvnuyJJSCklqYbyWj47J
	 4PV5fS70ZHxLsc1GMhsNgClf+99EjdD4QHh2lQSJZhMmEpSSiiMDmrD8c2H2mJDYUxz9V
	 ocRGD4d5ADGfEFlO1lXp+vFQlpdbef3L88d0S1y26MmN3qDhJjZ/+QM4l9EDfZB5Eqtfn
	 3Ey5WWUWn/AubsOQn2V32zZ6XzdbzyDEJv/0yHSnpUytEaD/y5R7329RpaDhNGK4gLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtbm1MM08giTYVSOF6xZi6Vh2mSgKmy56YQybItAd9c=;
	b=ATUkhOX3CrQfrHfICPGgoO2ztrZTN+SJC9j++bBU8yaJc2rO17sJxTLJUP5K3DnnDdqe
	 aPonPzeQnAitb9p6v71SMIRpXKHFpMwk/0Y7i1cqzoUJpgEGn2FVILXhy4r8hZGsggh9S
	 jJ8NLWWemvsrDoVg19lzbgTW0sjNTRDI3CgmcfHour9aaJ2YLChP3E4iGmiEScDq1Dl8q
	 IXg3O2v779kDCrQ9RTplHPlnefmFxe82Gq6s7tYstrqixO18JghBW0eF8YuSZb5+j8X/b
	 7BIRgG1mcfvgbMYWWQmMHOOnWI8le1qO3XLMpIMiYKyMx8YULDtWbm6Jq6Jb0OhzUHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Hn76Sd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85617606A325;
	Thu, 19 Nov 2026 04:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9Hn76Sd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC23E1F000C4;
	Thu, 19 Nov 2026 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060810;
	bh=vtbm1MM08giTYVSOF6xZi6Vh2mSgKmy56YQybItAd9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9Hn76SdjmIThgURRiHNRO85Yr4E0F1/r9FYi4HxsHYkYcsIpbMbhe6J1BwQqqlH+
	 P5Q/PcE8p3kdhBXYKbRaU/0nYls+sJ94M7mdWjZkVUlkr3JpCUcUtvIF0jVVU0JYht
	 U7sqWvSGu0aB30BOImHASxQ83cw+Ihhy+wheGPjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1292/1848] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150013.638282634@linuxfoundation.org>
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
index 6eeb9effcf653..3c24cfb9fae6a 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -190,7 +190,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



