Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E67129A63;
	Tue, 23 Jan 2024 00:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968738; cv=none; b=m7e774hzMimtbcQHUKn/8WsLPh3C8dhKhAWTCOKxIeXg9QZ1w1DKHLHEYZ8YIzeDKlH7QhXhlg+olMwR5S0gDzVlJm4LTm3CDJz2odx8ldOi0lY+fLvLV9mbBKtjO4/rNP25/NhXvlVibxspWmwzFqqy8VWfgw1+kARD1yV+mpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968738; c=relaxed/simple;
	bh=c+p/cOFAacfle0BJQQGuqXZKbApc4rA/jJvSBiYkloQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfXXNbWy3gmRXMJUUhOi8QkOQAyHaizapMweLbtX3hPgWwoT5qZOjYySwFrV+0kpaYxlQ2txGCiS67SSw6GvXr9Ugu2Z9VlnLB5TNaZGeqOGo7JGnpIkUUj23x2qizjw3ZEhabofwfwUm7lBWZ65QJnueypKcbun8fWdZusAvVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GScJ5eR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GScJ5eR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17938C43390;
	Tue, 23 Jan 2024 00:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968738;
	bh=c+p/cOFAacfle0BJQQGuqXZKbApc4rA/jJvSBiYkloQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GScJ5eR+hn2zcQJEJguPQsI+6s+BNf/0MIC5wkbmBiww0C+DDA0eQJAIc5RzkkeEp
	 7A3L2EsxOky7iJWeJr9RWtUqlvqJRrAbsB+tbHTdbtTaP5+dFn0T5eJ6L9NhpaH0+E
	 glG9mgDAPGmVkHjmAOibCM9Vvvp8R/iaeioNbUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Lin <CTLIN0@nuvoton.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/194] ASoC: nau8822: Fix incorrect type in assignment and cast to restricted __be16
Date: Mon, 22 Jan 2024 15:55:35 -0800
Message-ID: <20240122235719.444588574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lin <CTLIN0@nuvoton.com>

[ Upstream commit c1501f2597dd08601acd42256a4b0a0fc36bf302 ]

This issue is reproduced when W=1 build in compiler gcc-12.
The following are sparse warnings:

sound/soc/codecs/nau8822.c:199:25: sparse: sparse: incorrect type in assignment
sound/soc/codecs/nau8822.c:199:25: sparse: expected unsigned short
sound/soc/codecs/nau8822.c:199:25: sparse: got restricted __be16
sound/soc/codecs/nau8822.c:235:25: sparse: sparse: cast to restricted __be16
sound/soc/codecs/nau8822.c:235:25: sparse: sparse: cast to restricted __be16
sound/soc/codecs/nau8822.c:235:25: sparse: sparse: cast to restricted __be16
sound/soc/codecs/nau8822.c:235:25: sparse: sparse: cast to restricted __be16

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311122320.T1opZVkP-lkp@intel.com/
Signed-off-by: David Lin <CTLIN0@nuvoton.com>
Link: https://lore.kernel.org/r/20231117043011.1747594-1-CTLIN0@nuvoton.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index cd163978792e..1450a84df4e8 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -184,6 +184,7 @@ static int nau8822_eq_get(struct snd_kcontrol *kcontrol,
 	struct soc_bytes_ext *params = (void *)kcontrol->private_value;
 	int i, reg;
 	u16 reg_val, *val;
+	__be16 tmp;
 
 	val = (u16 *)ucontrol->value.bytes.data;
 	reg = NAU8822_REG_EQ1;
@@ -192,8 +193,8 @@ static int nau8822_eq_get(struct snd_kcontrol *kcontrol,
 		/* conversion of 16-bit integers between native CPU format
 		 * and big endian format
 		 */
-		reg_val = cpu_to_be16(reg_val);
-		memcpy(val + i, &reg_val, sizeof(reg_val));
+		tmp = cpu_to_be16(reg_val);
+		memcpy(val + i, &tmp, sizeof(tmp));
 	}
 
 	return 0;
@@ -216,6 +217,7 @@ static int nau8822_eq_put(struct snd_kcontrol *kcontrol,
 	void *data;
 	u16 *val, value;
 	int i, reg, ret;
+	__be16 *tmp;
 
 	data = kmemdup(ucontrol->value.bytes.data,
 		params->max, GFP_KERNEL | GFP_DMA);
@@ -228,7 +230,8 @@ static int nau8822_eq_put(struct snd_kcontrol *kcontrol,
 		/* conversion of 16-bit integers between native CPU format
 		 * and big endian format
 		 */
-		value = be16_to_cpu(*(val + i));
+		tmp = (__be16 *)(val + i);
+		value = be16_to_cpup(tmp);
 		ret = snd_soc_component_write(component, reg + i, value);
 		if (ret) {
 			dev_err(component->dev,
-- 
2.43.0



