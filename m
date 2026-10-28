Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214521;
	b=mbUFyoMruxjnPL7QesuxHSGU6WV75l+bKxj7GbXSVG38tgVzk0iiwVN12cjxDBiXyaLj
	 KUtRF2d4K+ffQxPVwFktICdMju1Dy1jKjzDiM6aWbb07uvoQRgzttMRGCNFCQIx0EbYL2
	 /Ej9QT2om0Fpy77rF/2YlJNX/xjOdE+zlo2DH68juN91guoWk4vrifW46IYr4g300/bkw
	 ZmQS9I95edFIioHARleXYfLf8sCpYlSDEXBNEdNMv+UqRojkIQhu+kVa5NA49qn6OLywX
	 zJ6/YwKN1xl/JR5T1pnLB3nXEmAVOdgwZB3DH1iKxJh9U2LdnV34S0JcjkOJXMQekGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m1bUcdxq2kQOzZ/BRawFkWn/xuH5VHI7MRtjUSf15rM=;
	b=1kP/MGwCH7WYl/+t5YetIGJWDCmU7MVvotLps72/FXq9UVKA6BWmIShwezIJrlb5+V/I
	 NtCbfjgsAI66vVZwTZszvzyX4LIsYq6VXh5uN0kZ4vMvM0fzfHOXreMhvEO6Zzp1AWZYt
	 xetrRJYOTaL5sXEUkOFHCoddVHdsdAsrnVCKPnFNhiEaC/pcB0T5ub/sZqolW1n2xP9kh
	 W9WQANBO1CqcyDDywOyVSMScfTMlBRb5Yl/U8vdMk5U7Qv/E4bkfL7adJL5GjyAfDa8Hi
	 9rco0l8wAeOHFUyupAnHZEq2XuS4YM9MBdNt16iKt8jdse4t6a9tOyG4PK2YSrOgePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvGaSwqv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15860A2629;
	Wed, 28 Oct 2026 19:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvGaSwqv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC4F1F031E9;
	Wed, 28 Oct 2026 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214521;
	bh=m1bUcdxq2kQOzZ/BRawFkWn/xuH5VHI7MRtjUSf15rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvGaSwqvZU4V7vlLSDAgdewwkmllD2cbK7Wkj1sjIUIGgez1qYW5Qp+HoYwOFy51I
	 wHRsyHkWe5sStGlfTx03HbrA1fm7YSaFgmr3VK9U2WNE5xe+ombdfcRq4rgfXpGRCP
	 l6rImNr1O+h7wBXmYEvtQy9Fp9y38UvmCrTBhJ2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0887/1887] ASoC: Intel: avs: Do not share the name pointer between components
Date: Wed, 28 Oct 2026 17:49:43 +0100
Message-ID: <20261028170519.605484974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 4dee5c1cc439b0d5ef87f741518268ad6a95b23d ]

By sharing 'name' directly, tearing down components may lead to
use-after-free errors. Duplicate the name to avoid that.

At the same time, update the order of operations - since commit
cee28113db17 ("ASoC: dmaengine_pcm: Allow passing component name via
config") the framework does not override component->name if set before
invoking the initializer.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250818104126.526442-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 9d3c0ea99a298..b61f753a1c60a 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -879,7 +879,9 @@ static int avs_soc_component_register(struct device *dev, const char *name,
 		return ret;
 
 	/* force name change after ASoC is done with its init */
-	acomp->base.name = name;
+	acomp->base.name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!acomp->base.name)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&acomp->node);
 
 	return snd_soc_add_component(&acomp->base, cpu_dais, num_cpu_dais);
-- 
2.53.0



