Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059539;
	b=5qAWBB7DV/fu4dX73dyUnsE3rcMAa1v1DBIZqHWl/FHX7NVY6LOFUgCmXKxf1eYM1H/0
	 BN7+UZRntbG15Z0se9Uwzab6NcAOaAJN6X/Iuei97h8wmvbgUBmCvAsj1fy8V1hVaxM+V
	 j+PYF+/gY71bYrHRcd+CmYGcuk2522Yzdi2XGTEyzXqtQCZMS8Jh9BlGqz8Qflj13lMbS
	 m27ut7PM2QWFHEojf+Pyf5AZr1lwS9YhZrzn8EAxUPNEUyU/nwmgGMZvBt0tSdlvTOVGy
	 jEDzGns5RvJKcNpNQ5KrCJNaUgcCG/lImU4z87ujpwJaZEEPRYyJhGct/ve7b7UsPbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QlcubVk5gbdoxqBRUMMAK9mqI5IryMHWRG+kty0yiX0=;
	b=Z4CI8/R7qWOfw/gs5/YWJBRw2lerK78/wJTlv5g1cBtigPB9pr8yD7cCQh52N1VHJjpD
	 gWT1mJ6SMMDCarYle/5WYDBwqtFejFdqQVlK7Q3A7YqOwjUS2s5H/MR5p9IfTHTT7WdLL
	 iDXUC8dI7X9vLgXfO8U28QME0XM2HiA8v2TXJGrW8/O9IDRv+fE3+EdL0Kp+Q/Yk+SiL/
	 R013bTGGwjTg6p7LE+cFe+RGLWR5Ym7VnUKgv0BlXCkxRDDvvcroMHfYjfENYR+msfBJU
	 K8MtjZCkQFaYCiJcGfG54J5d5Xn4DdkkGJbVLR2zr5c2A7Qh5n2XE/fTI1gQIiYXlEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5e57QAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F4E606A325;
	Thu, 19 Nov 2026 03:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5e57QAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78D1F000C4;
	Thu, 19 Nov 2026 03:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059539;
	bh=QlcubVk5gbdoxqBRUMMAK9mqI5IryMHWRG+kty0yiX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5e57QAGfnxAH6iTkGTYsBIi5v1YaZJxJmF3lbCdRe4d+b9Y0GSm5W2nVVB1kOciV
	 1T4FLo0Dpsk/aR5UZqQ4kibo8IA7H1J4sc7YabwJn0/J9rfOt07Wi3fW0nzxRO8JRj
	 SSWgs7aD/ohBX5jG+/DJToEmN8XX4suDsMPmwJMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0877/1848] mfd: ab8500: Drop bm disable parameter
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118145953.114328285@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a98688d2ddfe274cb7c7ca3c6b6afbe9f844ffc3 ]

Nobody is passing the module parameter to disable the
battery management portions so just drop this parameter.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 5bf2ae8b131d ("mfd: ab8500: Fix child device leaks on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ab8500-core.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 4cea63a4cab73..bad4cb684da36 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -122,12 +122,6 @@
 static DEFINE_SPINLOCK(on_stat_lock);
 static u8 turn_on_stat_mask = 0xFF;
 static u8 turn_on_stat_set;
-static bool no_bm; /* No battery management */
-/*
- * not really modular, but the easiest way to keep compat with existing
- * bootargs behaviour is to continue using module_param here.
- */
-module_param(no_bm, bool, S_IRUGO);
 
 #define AB9540_MODEM_CTRL2_REG			0x23
 #define AB9540_MODEM_CTRL2_SWDBBRSTN_BIT	BIT(2)
@@ -1256,14 +1250,12 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (!no_bm) {
-		/* Add battery management devices */
-		ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
-				      ARRAY_SIZE(ab8500_bm_devs), NULL,
-				      0, ab8500->domain);
-		if (ret)
-			dev_err(ab8500->dev, "error adding bm devices\n");
-	}
+	/* Add battery management devices */
+	ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
+			      ARRAY_SIZE(ab8500_bm_devs), NULL,
+			      0, ab8500->domain);
+	if (ret)
+		dev_err(ab8500->dev, "error adding bm devices\n");
 
 	if (((is_ab8505(ab8500) || is_ab9540(ab8500)) &&
 			ab8500->chip_id >= AB8500_CUT2P0) || is_ab8540(ab8500))
-- 
2.53.0



