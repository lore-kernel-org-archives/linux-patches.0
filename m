Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060616;
	b=5PR4UNMwWd8EybA7ORlJUffwTtJDN+JVNUlkdi90XrTWMlCg+7CISwjtY2OkyjwuKRb0
	 RGH9LmkVu/CAj/OQenOE5/EWetxuzCFtzgB/y3kIz6H0nq1woste5gkMrkhZGZWQHkLIw
	 tuIBX9v/7yh/UJRAlYzB/C7rVrF5fbE/lIscG20lgHoWjm963j3twbnnRafQTEnswQDYk
	 kW0GO282Gm8epKDdO+fdD3BiVpqe2uSjZuwJr8Y6evyIRpBVdR46++j2y8RgfN2BeWxsk
	 EySDQqrA9lFTACFT6jQa7CStLZK0FrkXpgXneTJLz0ssFNRW0WOBn/bL9/o/3oGtB5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2u7FzxCdTztMJlp0KJy87M9iGfQqIpydYvgYXXl3UJE=;
	b=wA6Ppd0Rp+6x5mmeYUVlscX1CiqGwjrYcaDOOd0Xw2j0coM6V740YtdrURgk+M3X9Tdg
	 lLA4/YaLTSVwu6gHV5sRUz3a4hltQ9NEvJUcuF3amep/NkLP2M1ls13VkIxFI+VdtDEY0
	 gSTS0iUZHopVAXnKWkvs+X+CbjJnG2Sai9vYpJqP1pRdknV54veFQS72m5umVJPyjIAbz
	 GXX3ty3adkzifdlSnyt06xsfUkr1aQ0KgK41lnpjaVPpgSjrk+g06+KDPpz4GwIhHSmEx
	 ALZPh3pQH9Dbnji3+YkJZQk4Tzy3lu37yY/nrHwQZQc9QvDU3IdIsWeKiWBdwYbhePA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPxCoGVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849E2606A326;
	Sat,  7 Nov 2026 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPxCoGVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99F11F008A2;
	Sat,  7 Nov 2026 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060616;
	bh=2u7FzxCdTztMJlp0KJy87M9iGfQqIpydYvgYXXl3UJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPxCoGVsN3MS7C0Y9bPMITWhkSzGEx88KTYSdtxZL7l0akRRcTDzUiHxXVEob+NSR
	 BWAAfikzLKXEFt/q1detAcOuhzvhdWO20MygPdVMESFuzp/ncaBAq1q8h98DolonBE
	 0ueYDZXPKH0Qzq847l1hpzAjnYF8ezQROR9/f37E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0039/1536] regmap: maple: Workaround for another false-positive compiler warning
Date: Sat,  7 Nov 2026 08:34:15 -0500
Message-ID: <20261107134958.760016453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit dffd32eb2b0e714a8ae23f98518ad7152cb06369 ]

Similar to the issue fixed in commit 542440fd7b30 ("regmap: maple: work
around gcc-14.1 false-positive warning"), I see an uninitialized warning
for upper_index and upper_last.

Happens with arc-linux-gnu-gcc (Debian 15.3.0-1) 15.3.0 on an
allmodconfig for ARCH=arc.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260626060427.2548578-2-u.kleine-koenig@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 82d9410591654..2dc6e5d146859 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -113,7 +113,7 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 	unsigned long *entry, *lower, *upper;
 	/* initialized to work around false-positive -Wuninitialized warning */
 	unsigned long lower_index = 0, lower_last = 0;
-	unsigned long upper_index, upper_last;
+	unsigned long upper_index = 0, upper_last = 0;
 	int ret = 0;
 
 	lower = NULL;
-- 
2.53.0



