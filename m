Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029926;
	b=xboUovcpBskRg5FSqYa+wk5/T3kQjZA9m5FVNE6w7+/3FBpVc3s6yasPeYbKMN7IPRqZ
	 laqgf8e0RlRon2EeO4PiLRPvXTk1wh2mhunoEHg7x1IgZZAb/Q+fU3Ehu7mv7GJu8yhRK
	 GPI5xobG1hnOlQpTZfp8bsofdV4z/5eYlBeqjoeQOldGZSnGCUfYrRn0V61Hl9WO1HG7Q
	 95Eo8WSrgnxc5JhbAsngr3+quZrDEHNKBSrfgixmGSCOsTuM1hAIJUSideLFCJnkj+tsW
	 gIIL50Aj3DxZNZ9fbPJckvMgWAWo8Vm8z6pUcR/U7vSg6tuoMkf712K7bLyTAX2MGyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oFc6GVhJQOn6lZIA9cBD/MVnWr8VswJxOncHJLKfFHA=;
	b=UcnPaePsUAHb/IVz0MyssRUFYzQL+pVQ3W/6Buarn9qW/9nV5jOrCB8nEPdMpwnVeCuL
	 qv1tKHjsJKYn/6sr21W5yo9o9CypjHapHC1O1+UuqRtUZm7kuhpR2KUUwMVoLvkDTnYd/
	 wA/KgTImuE8t03buChvRQ6XP5/dQlM9lSHEcRXMSEzX5lv97IWJj0jnEdO84PBsV3nptN
	 xIJWulsQZnBpY9rSjP3cSiaHRJVjDn2ZsYL12egQuYu6bX07ccQZgmNKfT9puumUQUaF1
	 LW8WDEM4Ydj/xiyXwt4qwWWveT8SDJI1xXQnZgb0O1105ba3prJKQIw6UE6i4Lm+DBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9VXM++P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8882B606A339;
	Wed, 18 Nov 2026 19:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9VXM++P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2801F000C6;
	Wed, 18 Nov 2026 19:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029926;
	bh=oFc6GVhJQOn6lZIA9cBD/MVnWr8VswJxOncHJLKfFHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9VXM++PLtZN6gPSe+ywntXzGp0fn/HPTxCTgBjUEek4Ux8ooQMM79xEKdkYlubao
	 2WZtxf2Ac0vsK0wYgmp6i2T3fBkG8UljPxPVEGvvJFSydCxz77jypW6ow0wH5WToBf
	 SasSkuINZJFBK50UISwza3G0IwIpOAnljyXs8loQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0524/1756] swim: Enable clock divider only where appropriate
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118150030.001074968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 3c02a14c89962c88ed0abb3cce4101021c63149c ]

Some models have a 16 MHz FCLK oscillator and others 32 MHz. Put this
information into the swim device platform_data so that the driver can
correctly enable the clock divider. When this is enabled incorrectly,
nothing can be read and failures from the Error Correction Machine are
flagged in the error register.

Cc: Joshua Thompson <funaho@jurai.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/483efa2f8ac6beb2a2d4fa2d8b431cb1a8b560c7.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/config.c | 31 ++++++++++++++++++++++++++++++-
 drivers/block/swim.c   |  9 ++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index d26c7f4f8c360..da2b84c4b70ce 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -986,8 +986,37 @@ static int __init mac_platform_init(void)
 			.start = swim_base,
 			.end   = swim_base + 0x1FFF,
 		};
+		bool fast_fclk = false;
+
+		/* Models in this list are supposed to run FCLK at 32 MHz */
+		switch (macintosh_config->ident) {
+		case MAC_MODEL_CCL:
+		case MAC_MODEL_CCLII:
+		case MAC_MODEL_LCIII:
+		case MAC_MODEL_Q605:
+		case MAC_MODEL_Q605_ACC:
+		case MAC_MODEL_Q610:
+		case MAC_MODEL_Q630:
+		case MAC_MODEL_Q650:
+		case MAC_MODEL_Q800:
+		case MAC_MODEL_P460:
+		case MAC_MODEL_P475:
+		case MAC_MODEL_P475F:
+		case MAC_MODEL_P520:
+		case MAC_MODEL_P550:
+		case MAC_MODEL_P575:
+		case MAC_MODEL_P588:
+		case MAC_MODEL_TV:
+		case MAC_MODEL_C610:
+		case MAC_MODEL_C650:
+		case MAC_MODEL_PB190:
+		case MAC_MODEL_PB520:
+			fast_fclk = true;
+			break;
+		}
 
-		platform_device_register_simple("swim", -1, &swim_rsrc, 1);
+		platform_device_register_resndata(NULL, "swim", -1, &swim_rsrc, 1,
+						  &fast_fclk, sizeof(fast_fclk));
 	}
 
 	/*
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2c3dea0b24fe7..645db47c827c6 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -806,8 +806,11 @@ static void swim_set_parameters(struct swim __iomem *base)
 		swim_write(base, parameter, mem[i]);
 }
 
-static int swim_floppy_init(struct swim_priv *swd)
+static int swim_floppy_init(struct platform_device *pdev)
 {
+	struct swim_priv *swd = platform_get_drvdata(pdev);
+	bool *data = pdev->dev.platform_data;
+	bool fast_fclk = data && *data;
 	struct queue_limits lim = {
 		.features		= BLK_FEAT_ROTATIONAL,
 	};
@@ -815,7 +818,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 	int drive;
 	struct swim __iomem *base = swd->base;
 
-	swim_write(base, setup, S_IBM_DRIVE | S_FCLK_DIV2);
+	swim_write(base, setup, S_IBM_DRIVE | (fast_fclk ? S_FCLK_DIV2 : 0));
 
 	swim_set_parameters(base);
 
@@ -931,7 +934,7 @@ static int swim_probe(struct platform_device *dev)
 
 	swd->base = swim_base;
 
-	ret = swim_floppy_init(swd);
+	ret = swim_floppy_init(dev);
 	if (ret)
 		goto out_kfree;
 
-- 
2.53.0



