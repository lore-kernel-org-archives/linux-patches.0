Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023165;
	b=OPsPYriPQ7qsmg4pPpOhCkf4ZwGm7xOLUYHzZthwkHR7JFmU20jLMkvQ4MkfUHUGqcPT
	 A3dTd0e82Gil/1UGDPfgQ326xecCPgjF8pJS0a3278ey+i9nr95QMx+07gL3B3BvkBTmp
	 xFeVoYp3RgDXiXwR6xXTfdnRMiH1urTOb3ax4/k/3DHsuCvdWK5slyi9DjmPt6CmLSvkz
	 CtC8PEZ9/qjSU1NlKIvj5tjaRF6IF2wFP9MLy/PWQV720QGjdWm3h/0VmdEoG6exhRvEA
	 ZiYFqLreYMmrrKIdmtPtU9zOOsg3Br9MyhJiQ4WpkStKswR6eh2+nJ/tr31Q3iCCsVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWLIDVsK8Kk0suKEP4MMGRqkpLMSEDcIrWANJ1m1UhM=;
	b=OHWgQ0ZcA3ytyKPkvB/8MxJP/HH0KA0BsW3mFHigDSmAcAXkEa4FOkdjpEQKalHOR9HD
	 vU6JNyHokqxZa6CdKKacZqVNDQd/DLPGfKLvafX0jBa+OYo/j++Tx/yXbx2y0p6n1P7AS
	 PzpmMuLNj0vMermK8eGNGwQ8tiInidzVgFGju6ocwcaI9G7IlUNDezlstuiCsVXUtacDU
	 sfAlbzsPEyjxvKhHTFjmBacctOmpL4KEsw0/57iuOp29RNTfuGyxjVENsphTQnvI5f7Uu
	 ZHgPWfQnCY/oi4CQrEGxUztWHDLViF2pP8FBbkn3LjjJEj71NC0z7If481NpHFaX9og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO5S7yIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD1606A336;
	Wed, 18 Nov 2026 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PO5S7yIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0B11F000C4;
	Wed, 18 Nov 2026 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023164;
	bh=PWLIDVsK8Kk0suKEP4MMGRqkpLMSEDcIrWANJ1m1UhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PO5S7yIhp82gt/zih4zoJMo7xmCxzCxTvnxzazUQmN1ppQH+sohCo5ZH+rHTGFYzi
	 d+bFuiinKomE/CS9UesYdte1DgpWtwueEG/A3rhf055oywN4LnGc6vhZBZU0BtuVLU
	 gE/4/beUBy+InIqdVzrblyHRWa+6ALLQSn+WaqSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0271/2151] ASoC: fs210x: report register restore errors
Date: Wed, 18 Nov 2026 15:33:26 +0100
Message-ID: <20261118150131.726379534@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit aa7d985d85529049fc8c39c168b300f59de4fdf8 ]

fs210x_init_chip() marks the register cache dirty and replays it after
reset and scene setup, but ignores a replay failure and publishes
is_inited. Its resume caller already returns the helper status.

Keep is_inited clear and return a cache replay failure so the ASoC
component wrapper can report the incomplete restoration.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 756117701779 ("ASoC: codecs: Add FourSemi FS2104/5S audio amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-5-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/fs210x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/fs210x.c b/sound/soc/codecs/fs210x.c
index e2207c53c50d5..ae00e942ad027 100644
--- a/sound/soc/codecs/fs210x.c
+++ b/sound/soc/codecs/fs210x.c
@@ -608,8 +608,9 @@ static int fs210x_init_chip(struct fs210x_priv *fs210x)
 	regcache_cache_bypass(fs210x->regmap, false);
 	if (!ret) {
 		regcache_mark_dirty(fs210x->regmap);
-		regcache_sync(fs210x->regmap);
-		fs210x->is_inited = true;
+		ret = regcache_sync(fs210x->regmap);
+		if (!ret)
+			fs210x->is_inited = true;
 	}
 
 	return ret;
-- 
2.53.0



