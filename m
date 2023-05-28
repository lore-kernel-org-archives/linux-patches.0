Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31BE569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F250C433D2;
	Sun, 28 May 2023 19:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302444;
	bh=O3j7g6JWYh3v1oLc1FhvY1bk2TxbE9Pxyss+EZQBQmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDYpKVLGnIDqx4Ru0EyV4ZLUP7fH/hyKHIZNHeVZBG9Ufr5P4G5DFHdHrUY7+RGJY
	 5uvybfgoA4CJRzUDUmwNnbDRFQ/1ay4ZhAtHlrVaHBzgg6QN1inNYCBa02C8y8Nbv9
	 NYSQxijfJbayUeO1qVZtVsRuQeD2vd4z7J4J6aKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Epping <david.epping@missinglinkelectronics.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 126/127] net: phy: mscc: add VSC8502 to MODULE_DEVICE_TABLE
Date: Sun, 28 May 2023 20:11:42 +0100
Message-Id: <20230528190840.325244085@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Epping <david.epping@missinglinkelectronics.com>

commit 57fb54ab9f6945e204740b696bd4cee61ee04e5e upstream.

The mscc driver implements support for VSC8502, so its ID should be in
the MODULE_DEVICE_TABLE for automatic loading.

Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
Fixes: d3169863310d ("net: phy: mscc: add support for VSC8502")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mscc/mscc_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2656,6 +2656,7 @@ static struct phy_driver vsc85xx_driver[
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
+	{ PHY_ID_VSC8502, 0xfffffff0, },
 	{ PHY_ID_VSC8504, 0xfffffff0, },
 	{ PHY_ID_VSC8514, 0xfffffff0, },
 	{ PHY_ID_VSC8530, 0xfffffff0, },


