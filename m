Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025147;
	b=XYjHNVQL9E//ozt2aN492jQ8g5L4LmAEmpPKAmTbhEe51J/1xXzFQDGeOo/5wrvbHd6C
	 jIiqhpbyRskVcHSMaRTUByErouuz3qGWpPBRATSH61WFs8hALfuKGg+fjA5il1bTe1m0D
	 ULj+S45a5/wpQyLlSqHfqLe+sqWvkSHz9YzNMYqK2S9Ik43hEav4oVtiWFHbCbfKYjC3s
	 BTK2x/tdIn/sWUw6bUHG3AsWdvsaB65jmpY+gPgMIsygUPgRmcnyofHmRFwbVufMo137s
	 JyGGye64lp/fn4oK40qMIKftj5krAaN8P5rPtTWas4b3ziQy/CZpEXzoxJfd63wIlVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IV4L8m/fjW6is5LyZjmaGXIUH8HCOOhKxwh3B0vZJx8=;
	b=MMKPF8TBJHMHkLUXOYMJEwH39woWiG4jDP8YL1f99wA3o7S+lX7XZHx5rWYyoETeJ75T
	 9Z8i1XzsGArO6FNf2KYp5b5BXodY2XY0XrQPdMsSXW4VmwK3xnvQ2U5WWFzZpsFWaTaRJ
	 0C890KhnRRWkMlCj+E9/BXPTQttDCSCHdY6JWoHPzX7ttzcXEDR53r+DW2kWORFjTuLFw
	 RGwQFJNerwMmaLCLnHdvyFZqTc0s2U34I/tgQ901FYWCJWb59Jgsl5U+Y0Rw+vS8vxtXD
	 BokWk1CvcoyoxrEPtXbGxGh3vkfRwZ5ah0x3oX/U+UqEgRijt0F0hMnAAJJwOHKUrIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JkZoRdgu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126CD606A325;
	Wed, 18 Nov 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JkZoRdgu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3FC1F000CB;
	Wed, 18 Nov 2026 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025146;
	bh=IV4L8m/fjW6is5LyZjmaGXIUH8HCOOhKxwh3B0vZJx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkZoRdguzVQaT9fxGy5TCVvHLRjvTs/GfDmP0+dL1XKWFy7DA9zCMfaOoeSNhNYXR
	 R9RDRCKFvLRXug0AHnkbI2NO8xxKpUcAwyVadOjVLgmiuB8cPu+X+rfAGFCK/CzLVs
	 YTB2Sl/R87uiOd0U7kFI3kEk0CNQWWzfnfbzVGgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0935/2151] ASoC: rt712: avoid duplicate reset in io_init
Date: Wed, 18 Nov 2026 15:44:30 +0100
Message-ID: <20261118150156.549357718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a799b8aab73aa..37845a454a000 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1886,7 +1886,8 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
-	rt712_sdca_reset(rt712);
+	if (!rt712->first_hw_init)
+		rt712_sdca_reset(rt712);
 
 	rt712_sdca_index_read(rt712, RT712_VENDOR_REG, RT712_JD_PRODUCT_NUM, &val);
 	rt712->hw_id = (val & 0xf000) >> 12;
@@ -1915,7 +1916,7 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	 * if set_jack callback occurred early than io_init,
 	 * we set up the jack detection function now
 	 */
-	if (rt712->hs_jack)
+	if (rt712->hs_jack && (!rt712->first_hw_init))
 		rt712_sdca_jack_init(rt712);
 
 	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_SW_CONFIG1, 0x0001);
-- 
2.53.0



