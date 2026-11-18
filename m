Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018143;
	b=O+NBODJ/SOM8cwoQDBgiutvq8VXwMSkOlOKAiFcGonTNEthuiz+c+sR0dZCYslpaMuy+
	 Nyoyc3mnELVPNdGQSts1tV8lrmsu+7/5rYkVFOLSxILgAf1SAJt26x4K071ZtOuTYfrtr
	 IMRbYex9KG6RJm/HkSpaUAIbeV6xsAP/8pWJSiUvIY4NtewACqelkcUe1Aq7eiibN3nP/
	 Jn4tMjiSzRDq9MVoRr0mZPIycvPnIGEWSQttjcxzw9ZXioKDrS52wONx+SjUeGm9nmM5z
	 kbSNCIyEY9EhCuyXseh7ohUUYdvjVU5xOTAYLs0UksVXboZMbVHm8ksCkuip10f/frg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s8xOp4GR/0NkQF14JHk7F2Usr1JPwHAUEGJAgqV/qwc=;
	b=fM9bAUw5FDiv+n4IVWQh3B/7CrOMnP+eBtw2Pfm7dNr2Rzkj/gSuMH0iq71pTLarVUhA
	 dkbSH8oW4jLXVM6Hi9SdArxFprg2sTMa17H6hUcSgX112tPEB8LtXbcI/HnRLNkbBUvfg
	 yaKerr7vGpV8sLUTqyVzTGnY4+OrrgusoFfqvcUgq9PUqUqOejY1h5uyvxxOgX9amcxsZ
	 tl+mYeXguip6GtYzyCozLrxW0qGJqRiGgRy/iX/370EeC7EvsFhw/qo/9w9hHJiw3RIeu
	 UFyjdZ7l6uWddY2Vgn+/q75+CS8bo5IpIFnoorMd3S0qzk9n/EG9L/uGVPZ16ynaUDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rEWP/qEX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A576606A320;
	Wed, 18 Nov 2026 16:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEWP/qEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E155D1F000C5;
	Wed, 18 Nov 2026 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018143;
	bh=s8xOp4GR/0NkQF14JHk7F2Usr1JPwHAUEGJAgqV/qwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEWP/qEXH+KEh1dQqd6Cc4oKcRav1E3bchbvvH8CGl5bnpp4sdddjvWjNh5Vn26cX
	 or7+996piPq4r9Rsa3/Gn69q7guQUVe7izbaKsWLWp6nt4WCF/U7GWKxrDisvFYqHi
	 SDrFa1dgi5rr27vCz6j+YJCcFos4ScN2cQy5TaoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1121/2651] ASoC: rt712: avoid duplicate reset in io_init
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150328.366375272@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 923ff8155ef6e83b73b852300d50f2053b969552 ]

The codec should be reset only once during io_init, regardless of
whether the system performs a warm or cold reboot.

Fixes: 4c9854ad3cdc ("ASoC: rt712-sdca: reset codec at io_init to fix silent headphone")
Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20261001090219.797880-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index 38052cb19790e..a4b3dd11d36bb 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1952,7 +1952,8 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
-	rt712_sdca_reset(rt712);
+	if (!rt712->first_hw_init)
+		rt712_sdca_reset(rt712);
 
 	rt712_sdca_index_read(rt712, RT712_VENDOR_REG, RT712_JD_PRODUCT_NUM, &val);
 	rt712->hw_id = (val & 0xf000) >> 12;
@@ -1981,7 +1982,7 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	 * if set_jack callback occurred early than io_init,
 	 * we set up the jack detection function now
 	 */
-	if (rt712->hs_jack)
+	if (rt712->hs_jack && (!rt712->first_hw_init))
 		rt712_sdca_jack_init(rt712);
 
 	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_SW_CONFIG1, 0x0001);
-- 
2.53.0



