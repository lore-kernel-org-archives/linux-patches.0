Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033608;
	b=j5R5NYtYkK2+cC9hIipC29Al78TphFUR4k14BaHylLULu662EW0FYnoCRZuxUQ51/TGE
	 h7/Y8iW7yPvyaBSgQ6SNmCcDsRiELRIdRDqt1hd8LnPziW1idEU3u3yx3RmuO7KivwEpL
	 kuHeYxZD5ALf8+WberE8ebiIYCqRnYi612WahRW3FY/exNwCAKzvfuhWvM5u+j3BmAq8s
	 O3DNF6+Y6qzd0e/T4otzGS6txXa14IAY/hYfSlX2D6OztV+hAqzY31pJKagbqh59XFmLu
	 qoUCwVlVM7jRjOjJCHmhcFbQpU29LCO+LOyRVEFmTWEH+GxSbQ9CFlEeamGM7hzd04A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TNFHDFM4K1AW3GlNgioZ3tgqwl3n1roSw4ANYa5yNjw=;
	b=fahkud7xA/JvIEgqO/RBKoBP2p0dOtz5QqkXq0MZIqFXZKxfCgc/g3umUdfDtxOHeL9H
	 97sWUI1fHmehthWOpaTfipVk/l+PcYNMQeBFjUF9kcGvFXp+eW1GQ8iRslUqFO6miLewS
	 f2cuZW112lRz16vAF7w130l9KHu0dqFKUkp0TJh9YwfybN6zF2g7Dyiq+SjJHQ+kGzyPe
	 fGk354J92x1ApZCXdylOx7IzwWqEZFyjuCP1Yexr/nfXu0ATi+nYuhwaQhVh1nD7rkNsg
	 IzIkGeJCjQhYT7oJdXq7+kOUiWSjGJcbyXwjuwFQLSJF2dscq4WbzOtnBZAVP5ARYzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uz65gtmk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27909606A320;
	Wed, 18 Nov 2026 20:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uz65gtmk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1A01F000C4;
	Wed, 18 Nov 2026 20:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033608;
	bh=TNFHDFM4K1AW3GlNgioZ3tgqwl3n1roSw4ANYa5yNjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uz65gtmkswn0MJvOsuAnBXPezzADOZWefcMFVzT2zCAknaRSVsAYbPZMAVuhD5D3X
	 oK/mSkiTtzjRVKByS6FkFMGhSmF9WV2aBxbhu6y5qLeVIbJEaO83WF6P3EFD5SMm2W
	 9R8jiCQVXRt29E+IPAtpeKhZZ0pGsPKWda2mAKYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0033/3318] regmap: maple: Workaround for another false-positive compiler warning
Date: Wed, 18 Nov 2026 15:10:55 +0100
Message-ID: <20261118150314.803688585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 86de71ce2c191..a2450b38b8b3b 100644
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



