Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062944;
	b=hFTJa/NTaXeIWzGBAviSElpCmSWrXO6xBoxvXWjZ4MDRXr5fFhIPB8sFEvthubWdy00o
	 0Aba0ludvJr5D1A2E2xp2SAtgkfnQvwYK4spBUME5rGBS4t6YhDgE1uNEjhz/pzd4Ra4i
	 ++xxfrTcBHFHhOhkHyPIL5t2U9slN9zhnopcGK2Dt0sx1KoaZmc8scTdBsynFeMYErGf0
	 isu92MoeILSMtk2Xffx0G0r9q3TDJvsqcNGgmGk0fBtvMrhdlDfOd6X4qwcksBKzhmPsP
	 K2WFNgGtmB+vcbQCWFpx3DxV50c12WtiQaLfLxrYjsP/9Z6MaunFkqzrpzVwP2/+c9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qItGR8KpPUh/+jyHrgII8jRfKtSYoTWN3YELX0NJjyM=;
	b=CKYlZ0vhbBHR9uyAOVnywl04AwaKR9YEGwG4pbgCr+NK5qKgyDNVALdTLi5EOWfeRGyg
	 pfr/wEFAN1hBiQPC7J5nxTyiWq5bLxBWO4KVW6xYYLFTaKrC7FaZb+5i2DQDWogBnI0oD
	 0xgRNkFTSjCU9IwV8yKm8mCFMGh5VmGY5c36Jcy5yUqY3J6kl7O65ydKxM6t866DbJ1Md
	 nlkl3fRU9JeMU0rijOjQKWfzrzKyX3SfEjAtSZBaKK7auK9F8hCEbkjpwtFwYrGV5s3+c
	 oFcuDkrOTU5dHwGB/BZfVyST+nrS70GbetZiUE4+WE14+tEnfgrarwolEodBmejv6Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohgyKJgh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C179606A330;
	Sat,  7 Nov 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohgyKJgh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAFA1F0089F;
	Sat,  7 Nov 2026 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062944;
	bh=qItGR8KpPUh/+jyHrgII8jRfKtSYoTWN3YELX0NJjyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohgyKJghwsGHMz67cN4I6F1XJr+yjYY/YMW4wXsa7SkWfsBhTGYYKu3uoo2ISB5hE
	 IQ/RqHnOofNCaWfQYs4gwMl1pSTmseYLdk/cFL0vpSaHxQDusT6fH0FesoYvSvd3X9
	 FvLE26SqigbvxIk9fhfPV7ZD/szh8x+tYrQ0QYXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/869] media: marvell: manage the MMP camera clock provider
Date: Sat,  7 Nov 2026 08:48:12 -0500
Message-ID: <20261107134859.088134344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell/mmp-driver.c b/drivers/media/platform/marvell/mmp-driver.c
index d3da7ebb4a2be..4c31b62751a12 100644
--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -269,8 +270,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0



