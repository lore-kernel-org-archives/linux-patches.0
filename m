Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015135;
	b=lcaYRCo/znEq8S65n8y9nRvEfnHTEplhlU08C73c6InB+kHPzdWFIRMLkl+J/ls8XQMZ
	 igTk0vjV4Fr0Z91ZNCXKJfDtErnPH/tZyZWGES7Zld6WvVCiRfb58ue7ykuntzmFgCk+Q
	 LM7eDWtKmYl0vLG2rd8oX3/inht0sDy+/2mqUNJGPR+xREYke/suVijoudONGWnjtOwYO
	 I6Vo/9egerlh+kMveZiE1nrOrEml7Vo+zqKG7qn+xMfy5IbWuhKefFDUCYuOI/x46oasj
	 8FTBbRkiTFujwB/CSXPOeAGa2jW2dhKvo/04T/XEO3DFbbHhWxif7aTKoHgFhnsf2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6JMED5yHTJFH4Fi0HYoWdq4YwPxJyZen0Rq6wc41aFM=;
	b=DmSXVNuAYvzEbw0mlXAguc/mwWatQYdf+g9yAp15Bo7ChiWSjhUj2UFuy2k2sycyog3y
	 Mm09NJ2TaTZoL3uGDc2TOH3LkmRVJS5t/8N2iNEfSIGnBHgFTnVRDyXpSLT35uL4vuMUh
	 HNuKNeu+Cz5QBs9yIqpncJ4wJUAiCDHaOrguDxUyhzlutqrkghmKwoaujcWSjYkrZQjLX
	 j/Adx+P3RMl6hw7CbgGW/+zuLxrq9L3ITEysmVB0kDhlvKyRHs/zQKVpxv5uxcNw15vbv
	 uu2ojKYiLcG87UbktKU/3w9/MuO4UiHE+FeIdYqJzF2LQKGoy2V1az4dthIrrGURGeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAdpTEVZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A579606A320;
	Wed, 18 Nov 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAdpTEVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22201F000C4;
	Wed, 18 Nov 2026 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015135;
	bh=6JMED5yHTJFH4Fi0HYoWdq4YwPxJyZen0Rq6wc41aFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAdpTEVZkbNQ1YQ6NvfO5AQsDvJxKiOLsTbbTGOuTrCNdaKhU6h3+5B1kqJ/BmgbJ
	 JlRVT9JoCefW9eevXkkhfTAQBjPrxKkYS2YbxnPcYVllrwujS+yUKZmqvrtxWsQoOy
	 EOSR0caSNw++flWZPhOJHKIw95C6ZdL0fWC5KlFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0064/2651] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:21:44 +0100
Message-ID: <20261118150250.245365342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index b51c307788110..0fe81d259274e 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -78,7 +78,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->base.dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



