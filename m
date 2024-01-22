Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98046141981;
	Tue, 23 Jan 2024 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972067; cv=none; b=DSg7LcM4akysNTvi+KG2CW3p3w/AAAigr/o6+mn1u1qX2XmmtFmhzD29eEEPFDOCSPm0/u9NioYntkwPpCq6e/EMf2fMn/lMmvZlufxLRYJr1kbzEGTMgraiwjvvUHppj0l7u9ZHcO53mgHour8B54Ys86EyDXtK8W5J9gPcaN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972067; c=relaxed/simple;
	bh=GkGh2WbgHVM9KYGQ8KuOKpq4QykSbjLn2T1gJdLkQwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7RZ1GfpI+hCDQV+kcD+Z3SZUTJeMMI3aX78X9rC1Tl+y3TT6wjT0IiyopOih4+NbAlirhiMG/owrl6aUTlPzyt83Oqn9al9CL0iugGOkDs2K7pdZPH5cjLQrHcCU1LbRCKVE2qL20sOOOZkMbxF1LkQ2X1KQKOe05sz4krkJ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVpzRDoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVpzRDoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59473C433F1;
	Tue, 23 Jan 2024 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972067;
	bh=GkGh2WbgHVM9KYGQ8KuOKpq4QykSbjLn2T1gJdLkQwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVpzRDoLSM+O6G5+XwsrrHmwvdy8xffDnNfVjefsnsinWRdlNsIxRKK6M64Gs7QgR
	 42uhfgPioubtXRPMXtYpGfhE543GyDCXXbuuIcu3is0wOdzmuVyVysHN4P+5HHdVzm
	 Ijkz9YMHPVX3RskoWdlw66V3X/S0w5SquJSOZfsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Lin <CTLIN0@nuvoton.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/374] ASoC: nau8822: Fix incorrect type in assignment and cast to restricted __be16
Date: Mon, 22 Jan 2024 15:54:27 -0800
Message-ID: <20240122235745.013588391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b436e532993d..6ffd0f5e3a60 100644
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



