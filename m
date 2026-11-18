Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016938;
	b=f8hyfuaVSqyfnQaORS6SGe25Jt7hTno7HlDlb2gwjmCLuPaUzn8sWQ23G7AeRuvUEfSp
	 ZKI8XQZhWJzoUAA5KAU2ghoFUaRibVeVpVFI8Bo3lyydSCIudCcOpIG0V2x4y2vM9A89W
	 S80Nz9WLC5F0G4biU05AbGYdEI/eQJXNL7gtVZi/wi/ge3a1A8OXNK6fawJ3Z5/sC80UF
	 jp8ZHzcBLrCQ/38P0+fiL+IRtKU+lPb7eM1KxRuKVwRGdnBJzNRJyJS8XDbMZQhwUBZZB
	 yAuXVULrbtLWf6lpKkYeBJu8pTQYjNxlHqxu8kKpBSF7XOB8eJYeXjCE0avmhjXR8tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQmu9NxN7BpqrYm/YdBLUrhrTPZqWCe8u9yG1sTQyhc=;
	b=ji7k9yXsoxgJsacI9cIX50HwTUO6RlGW/bzZK/ct5GvojqAkVOep60HJB52KOm4O5HFM
	 keFLDAHxdTU0C4Wjk9iPRj1U+wWO4EYxyT7JoYZOEgIf3/fnAI9Fr9+ethug6kIKGrgLK
	 mQnHytS8yOBqX2Iuwj1EIX5rlvQWjCiPqRI6Km6ZDOyjUSY7xFF3wF0ClqgFXBJ0U8uJB
	 1ERl2bwPlhNWDXuwvyXx2PtNs9ocOBfcNFNbvNIi9DJe0k2Qw/4rUnB5PWDhuIRHsuRP4
	 i9TH10Z5rWHv/OgODtS0OC8mRiIBhtkRwGTYQ4ETAzG3z6Nb7A6OC2jOyMcjEo6gdlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XG48rt/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E021606A32C;
	Wed, 18 Nov 2026 15:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XG48rt/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681571F000C4;
	Wed, 18 Nov 2026 15:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016937;
	bh=dQmu9NxN7BpqrYm/YdBLUrhrTPZqWCe8u9yG1sTQyhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XG48rt/J4oe/0E5HhgILdnSHSq/PCnR/eQP3Bq+MzJkhpdIVkmZQrU7MX/WRri1aJ
	 ZMxsu3xjL85wm0mY9/beTAZrRO8BYzGRaXGZ8fsMJ5dbHSjk5ja8t7Y5VuZzGZHlow
	 9dawt51Gquz3gQzoySEDLYF5jgCTri5z5o8i+AUg=
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
Subject: [PATCH 7.3 0707/2651] swim: Enable clock divider only where appropriate
Date: Wed, 18 Nov 2026 15:32:27 +0100
Message-ID: <20261118150313.279279522@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c0033f885ed4f..b745cf20a71f9 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -984,8 +984,37 @@ static int __init mac_platform_init(void)
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
index b8384525fc9ab..1ade5c497e10b 100644
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



