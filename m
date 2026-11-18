Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060844;
	b=axmeuvrxZombOSnKOPdGJQXGAeW6NblcZxZ8f+murW4PDSiRXysIOSLnZYYyCHuiLeo4
	 bDVXZjwR0SrFumAzdJDsZB1r4kh8o++V1nDBNrZWZcu/pv4/SdiY0kQqEcEFlSz22qyR8
	 kKnjzPjvtITyhIf5V9S/2jHnZCt13MLaPkBNGs5L5E33mckL96pvXSY11eP8BJVuaczak
	 ex9CfbMWUqnjMZfGLBLpCma8qs33JOf3SSq+WIzfjn9oiG+XTDLNNpYVw/v0ZXZ2w7Baq
	 w0guYXDSwG26TrgjA4TEaVzJcTTiupyRoNi07EKxuTVyKLtMf9SHtcFYJa799ZOVMUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jX6KdVMTMBYelBRq0LQZPkYlq0pFOMVz+iYjp1Mgjp4=;
	b=l9u2h9dTRZjw52v6eOMdw6fjJGQBZeyp1wVgW8IFqtGmcWPTntJsbra/cxwhyr7S3iG9
	 GouGYRe/lkzioxJt415Sxswyi3YCYGubdpA8YAdjbIxPE4oUoA0gOQRXFfE/uTIDEMgDW
	 yOuYkJw20N12u5eHPYihLBYppD8v59G3GcRyLaNEeI87vpk+ufKLI/uqzOCE+OCWXxhz+
	 ZTb78dBr+kWjAREDSpruGcHUDqFdrR5fdkU5l8CQTQipGriowiAmwgFf+sY1bVNcxi1LN
	 e9P336kDJnV8WcTrNN1z6lSICz3TloCdHRSvcO/4KjZFhMkZHv1uNZQeNn2oOBJKm2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lt1y/BPq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C60606A325;
	Thu, 19 Nov 2026 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lt1y/BPq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B35C1F000C4;
	Thu, 19 Nov 2026 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060844;
	bh=jX6KdVMTMBYelBRq0LQZPkYlq0pFOMVz+iYjp1Mgjp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lt1y/BPq4rpGDyJXwfCJqEzIFx2FjlrMN05iisEGTnl304QZmwSSkKwGIwiR+6kfb
	 AdXGRiM5jn+UWUy+Ka3kMVNlH5df0In7Dx4iJ/K0+aEhrDpHhgyPyOzhD7EbFGVSqC
	 qXecTPsX/VPtil6b+sUZULX4tx2tE/O7vu1eCH5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1345/1848] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:23 +0100
Message-ID: <20261118150015.979527279@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index 098ecf13814d6..a359a53421e9d 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2051,9 +2051,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



