Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039368;
	b=CyEqdMk4IMpXUV8z2qC79hfmJ9jCgvGtq+I4HaycwfjA/wZABRxpzk5OYeZC5DkW2eVT
	 asAIr9RYl/Y6vdYFYyvxRUAHTMnzw1EfGFp4oPJ73pT+yWhqSX91mKc1bUlFqheZIv+pt
	 7FSu9jqFxjJs+NtC9Tz3vUPFHJ5epx1X80EPQG68p44WmSFRlavuYQMazCjgwDTj3L7ft
	 At74cBIkwfqA3u5i34DQ1k4bAJsd8JZ8uq8QD/8SS3Vb59qq9YJ3fWL0YiZ3VMAzjsBx2
	 ta3EL97JeAHTWevPF0NK5ipy1qnhb4z0jB2WBmWoSToD6MJmR8TlIHaKbLg92Eu+hNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNt+0a6BqemaMn2PAAJxrqTWq3L8noZ60NlrySY59VE=;
	b=ki6Hqpjd+qQpzN9NoReBAQM5ocrfhG6x3rSVPdborH9ppEvdDnMyGX8mry+MQhk4vdOB
	 GBRL74//sh6ZhnKczyoOoMQECHcdAubRHKLdgtgNsagtUo6NI5gI9Cngd4xi5VvPyyjYQ
	 R6vnzUQnRUPNWDGGdYy8mf/VTn2s5a2UeYolbe5jOBSUKI93TuUSv5IdkQXBXLWayJWv1
	 qqAZGUI+FUuIeprzlpTrkiDfDjfGVlmEpqpG0SxODROnDHmbHiO5LtyWCwsSCdfRoRRNe
	 pQJEZBA4pXVZZPOIfSrbE+fYhtkJosIJ50RZgdPJ/6SLNXk216FDxp35PRDqi3ONWmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rFTNP/+7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F80606A32C;
	Wed, 18 Nov 2026 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFTNP/+7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA561F000C4;
	Wed, 18 Nov 2026 22:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039368;
	bh=CNt+0a6BqemaMn2PAAJxrqTWq3L8noZ60NlrySY59VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFTNP/+7+JYRNwRoAaVv405gRG4CJ0AlKSrQqXQmo9JhdKJHz8eRdLG4fvvdVyL4u
	 EF2WZxf7AVH01yWPVg0ejO+qroIwuD66sn4nu/QefVYAVtB4xP9gNhmQiPnDW/3MKM
	 6umQDz8UZxivSb8FfLVePPbyQdydVd4zUx+8hETE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2075/3318] ASoC: es8326: report resume restore errors
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118150424.334437075@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 349e94679968785803cc32c1d2e41e000e8afd5f ]

es8326_resume() ignores the status-register read, the direct clock-state
write and the register-cache replay. A read failure can also leave reg
uninitialized before it selects the reset path, and a cache failure is
followed by jack IRQ processing.

Return these errors before later resume work. The ASoC component wrapper
reports the callback failure while retaining its best-effort resume
contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-2-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 1d9d4c81f39e3..d2ed0f41af4b6 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -857,18 +857,28 @@ static int es8326_resume(struct snd_soc_component *component)
 {
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 	unsigned int reg;
+	int ret;
 
 	regcache_cache_only(es8326->regmap, false);
 	regcache_cache_bypass(es8326->regmap, true);
-	regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
+	ret = regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
 	regcache_cache_bypass(es8326->regmap, false);
+	if (ret)
+		return ret;
+
 	/* reset internal clock state */
-	if (reg == 0x05)
-		regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
-	else
+	if (reg == 0x05) {
+		ret = regmap_write(es8326->regmap, ES8326_CLK_CTL,
+				   ES8326_CLK_ON);
+		if (ret)
+			return ret;
+	} else {
 		es8326_init(component);
+	}
 
-	regcache_sync(es8326->regmap);
+	ret = regcache_sync(es8326->regmap);
+	if (ret)
+		return ret;
 
 	es8326->jack_remove_retry = 0;
 	es8326->hp = 0;
-- 
2.53.0



