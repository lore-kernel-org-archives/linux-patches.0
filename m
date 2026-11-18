Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053179;
	b=yj726uoDt3YwwQS4LD444FmwKl4jxUvrr5FZoFBtkcPOUSlGRN9sdUxtj/BZO2X91Sco
	 vGZTf/Tdj9evhov6F2ZLzS7Mhw1bTQuo4J/LDHAC4XszhvuULVSMcnfKa95aIvleSDJ0W
	 BjuKmMoSDgigpgPctXh70S1k1RX+mdXXT6lftfrj7VIzDjZeWd/0djEcBGWL009tQmlwr
	 D8o4M3r8QRt24Lj2RGljtCrnLJNolIimFF4VaXkpHhP67ln66MR1cPXHQVypEL3b8gPRo
	 L0i8MF1o+4hnGPdZb296g4vy0FU9g0sIy7Sq4BOdat3oEnp9HcIlE6q3mlLxDkzwagw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bMDwSHSNyt05wddBGSb+0sPz/B1aD5SuXrTU0d4PLU=;
	b=Bqx49k3jiICP/1WtXeSXoLGHzTC6SX7FKOCOFjgk4hqE7H+/Q2t4MB+ZJSWPgkqZtFZF
	 HdPmXFEeNCsH8zLZWb0SizPT6j3QSNBPk0CQyrAEMvT4XsKtyEO9K2/qKCgDYmiBOytRZ
	 sHv5pAFfUhkBY2bvXHtnwibxFFhn0zyPLhQPSNnoAxatnFP+ZPX5H+w2JdYVhMVovNs5m
	 fbb+gH/PQuqRIaAEAhtIlr+bRkGQUiUf7eZJcAQa+oFo4UigSQgtyIn1XxjSgj6yQnnZY
	 VOKia9pFyDCJ6rNjKw+IwAcZyi/nIhBpRUMjotxJU8OV1vHs4QEzQ/l+f2/irh9jVuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTylZzoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD33606A320;
	Thu, 19 Nov 2026 01:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTylZzoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D31F000C5;
	Thu, 19 Nov 2026 01:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053178;
	bh=1bMDwSHSNyt05wddBGSb+0sPz/B1aD5SuXrTU0d4PLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTylZzoPQTiT/lTkRuA3hXGq6UtHvsk4dyuy2FvCAlyk6bMdLiClBfyRalpnghewb
	 dKKPJFvs5H2Pg56BtFtFtWMcduNeMP04B3B3fM5v0nCjmT9yxNj5NUhhE6fI7E2XX8
	 1pSYgftOdUyc02mgwiOndLBTObvyTNhfMLfnUNx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0825/2214] mfd: ab8500: Fix child device leaks on probe failure
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118150044.746992800@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 5bf2ae8b131d4ae9c0ed5f7aa02532645f512022 ]

ab8500_probe() registers MFD child devices before completing the
remaining device initialization. If a later MFD registration or sysfs
group creation fails, previously registered child devices are not
removed.

Use devm_mfd_add_devices() so registered MFD child devices are removed
when probe fails.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: cca69b67b3ba ("mfd: Export ab8500 chip id to sysfs")
Fixes: 9c717cf3fa16 ("mfd: ab8500-core: Add device for new RTC version for AB8540 cut2")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924144355.1604369-1-lgs201920130244@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ab8500-core.c | 44 ++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index cca0aac261486..5e68d51fba575 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1218,39 +1218,41 @@ static int ab8500_probe(struct platform_device *pdev)
 		return ret;
 
 	if (is_ab9540(ab8500))
-		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
-				ARRAY_SIZE(ab9540_devs), NULL,
-				0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab9540_devs,
+					   ARRAY_SIZE(ab9540_devs), NULL,
+					   0, ab8500->domain);
 	else if (is_ab8540(ab8500)) {
-		ret = mfd_add_devices(ab8500->dev, 0, ab8540_devs,
-			      ARRAY_SIZE(ab8540_devs), NULL,
-			      0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8540_devs,
+					   ARRAY_SIZE(ab8540_devs), NULL,
+					   0, ab8500->domain);
 		if (ret)
 			return ret;
 
 		if (is_ab8540_1p2_or_earlier(ab8500))
-			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut1_devs,
-			      ARRAY_SIZE(ab8540_cut1_devs), NULL,
-			      0, ab8500->domain);
+			ret = devm_mfd_add_devices(ab8500->dev, 0,
+						   ab8540_cut1_devs,
+						   ARRAY_SIZE(ab8540_cut1_devs),
+						   NULL, 0, ab8500->domain);
 		else /* ab8540 >= cut2 */
-			ret = mfd_add_devices(ab8500->dev, 0, ab8540_cut2_devs,
-			      ARRAY_SIZE(ab8540_cut2_devs), NULL,
-			      0, ab8500->domain);
+			ret = devm_mfd_add_devices(ab8500->dev, 0,
+						   ab8540_cut2_devs,
+						   ARRAY_SIZE(ab8540_cut2_devs),
+						   NULL, 0, ab8500->domain);
 	} else if (is_ab8505(ab8500))
-		ret = mfd_add_devices(ab8500->dev, 0, ab8505_devs,
-			      ARRAY_SIZE(ab8505_devs), NULL,
-			      0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8505_devs,
+					   ARRAY_SIZE(ab8505_devs), NULL,
+					   0, ab8500->domain);
 	else
-		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
-				ARRAY_SIZE(ab8500_devs), NULL,
-				0, ab8500->domain);
+		ret = devm_mfd_add_devices(ab8500->dev, 0, ab8500_devs,
+					   ARRAY_SIZE(ab8500_devs), NULL,
+					   0, ab8500->domain);
 	if (ret)
 		return ret;
 
 	/* Add battery management devices */
-	ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
-			      ARRAY_SIZE(ab8500_bm_devs), NULL,
-			      0, ab8500->domain);
+	ret = devm_mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
+				   ARRAY_SIZE(ab8500_bm_devs), NULL,
+				   0, ab8500->domain);
 	if (ret)
 		dev_err(ab8500->dev, "error adding bm devices\n");
 
-- 
2.53.0



