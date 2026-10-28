Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212269;
	b=Mmnf52qZhUz6zpjKlR2SZJ+TPro5WA4fYkKsbe6gJbYfHkLXsozaTOkdZiNfdPDa6HlC
	 QOAjYKgHcv5XV6BxTwp2XpHGX7D4TKsLWxtn2IOp75f/pZB3eQI6P87lOYoAKM9QIK9eq
	 f6N6CB1bH79ECIcVshxrVesF94YEoAQfH4SoJlCkzrSQzIFCcTZfiBnGnD240PjnyIqnH
	 1fpTh24au9pDBUTTRBFsS1jcRSP6lYJVsyfysQPtrYmY3+oC8J3AEFdVRsmCyNKYj7jHo
	 GrEfQMIWSFvpeuj8bWyca73Qz3JEQr6mOaRC+VbrU8FUzgEpfQScd4RpQEoQX3tWD3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HpFhXstfOi+tsm8FTh9ZR6Xq8lahhLAK/J1k1Z7TKY=;
	b=wj8lqvqs0lfB6x/1+fOp5V/LpUvVWv11JS2uW26r0rVyjdsU7FzOT7uxOEI8RPbU8fQS
	 aoLoCMwi51M9VfJN5o3p/Vk/tluJOPWY/DyEFlgfeEbnoEI1j4/uxJsedaavz2PLgNPwu
	 Ak2ZO19BmyOY3+T/5g0YD9dTEewWjPbA1+YPCTWmk5f+z/pEn5IHihxFi/G/ObFyeA337
	 dp+lGjgfsFm0HA8qIXknia5c+IoRVtZOh5scynJgJiVIpxUFKeyE/7gTQTyTHjNOlvq25
	 ln9MKgif7dbKrludAFh8fpCmHyOQJCurhPwbwct5n5ObVWS9hEGYkI+63hwqdNVGC8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjVLgIvN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA501606A31A;
	Wed, 28 Oct 2026 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjVLgIvN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B201F01825;
	Wed, 28 Oct 2026 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212268;
	bh=4HpFhXstfOi+tsm8FTh9ZR6Xq8lahhLAK/J1k1Z7TKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjVLgIvNZN0EY09Qzis32LvtRhQOwQDwapzE0gVn7cf/CnRNMkQdIygg0snNRqP0o
	 PF3HhEa3nhVXYGmW9O5/Ivk0AoG8tYbhwoPr8+YEpGd9/j5u/dUEsHHKQFmR5Ha/Iv
	 pTgQgz0iBWEWgzSPd7MjiW4CF47KWuq4e4a6gUsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0096/1887] spi: bcm63xx: disable clock on resume failure
Date: Wed, 28 Oct 2026 17:36:32 +0100
Message-ID: <20261028170501.419326948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac ]

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 80a88d38ec00d..cf0456f41a379 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -669,7 +669,11 @@ static int bcm63xx_spi_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



