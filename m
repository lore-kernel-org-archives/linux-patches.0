Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208320;
	b=lAFpTwO0fcZ+tZRCBrXUXyVymd0vk9xdsOfGSdvdzq4p32Bqe+b2wbIhUZv1RcMum3F6
	 /p16rRb9W8aFrypIw9MhHhVFCXZGJK+02ovATIvI4kALzeyMu0KnNlVcdWdO9fOIwmZ6y
	 oMwBJRF/Mco4yWlcbIP/OmgKr65U8WNEN/+paxA5qKHSM/qBVaX3k4BoWJu+ynp5Ek+Ne
	 sT7vl7J9V8g6sf0FX+xpoZBluntDZA/5KJ7BI5w1PZSaxymfccEcM4v0CXyLWyxacr+Sr
	 2bswnvbGJUJ1kvXH4CZ1yAGWX486BqASHt3tug0mLKQsJoy9TIQHHwYNfw8m6gRrVCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJx1+UDbSpyOkyftnAR6F2ztWUx1ImD9zrvaw73Q4uk=;
	b=NIEjvNoB0poCTPK7uqe0VoAWS/SRY1ZXaFK8AEv9qSBIkyYPywwLdgnm/eX1/5/Vs4R+
	 gLV/CH4ptGVSLC1kXZDNZHz81pDmYS4x+gh8U7bhhXnFjaUcJhLlL1XbSFUpgw0F/ZRiV
	 ujPYZOV3oOGJLPUMNr6Pth28US/l2hU0Q1z/jHt/p39AKPcgZ6LXzzvleaYZLa8eE1r7V
	 QgAEYgzUHAWLewRwkZxrCoDiINcp55O72UMtv7KDEZ4JlFYyKKVhssV0ayd5WPROGrFQB
	 YwEjOAz3Uu10J4J1Nu8cUtqi7o3YhWUZXYPOsBEDfZks9LM3zgekoE6HqAODeDh24cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaYhOPPC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC1606A31C;
	Wed, 28 Oct 2026 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaYhOPPC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7C91F01825;
	Wed, 28 Oct 2026 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208320;
	bh=vJx1+UDbSpyOkyftnAR6F2ztWUx1ImD9zrvaw73Q4uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaYhOPPCWlwAKa1Axdm7dhrnAvmoVg4mV0KKX8pG5n6M97BpWdoAcluKaDycy532Q
	 E+57zto5/InViFo4jYBD0US1P0KGXiNPy1QnVc+cLd0lxJ6T8DdzGOA0Ubex1UFvsl
	 J/7mtJVdXYk3SuTy3WU5XVebWdoxOdiqtbGg4SvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/516] spi: bcm63xx: disable clock on resume failure
Date: Wed, 28 Oct 2026 17:53:50 +0100
Message-ID: <20261028170005.369384635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
[ changed spi_controller_resume(host) to spi_master_resume(master) to match the older API and variable name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index e05f8913ccda9..0c4735f58c6e6 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -665,7 +665,11 @@ static int bcm63xx_spi_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	spi_master_resume(master);
+	ret = spi_master_resume(master);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



