Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040157;
	b=hw980i75r0I8T3BFb1NMV3HcsRkGnb87e+rcz+cYub2NZIrFGEOzbWTjUrC/Bakh81eU
	 j/Q6/hkZ9NnD7IrAk7nrJfD8dVDr67jN1e8w41rXTuR0CWKAjv+odcddoYbAQu9wuez3p
	 swg2dvo3ov8HT5xUL7WMz7bDoWuQiK+BQ5j2Ckx2aUS2rUduJp5DfhBfH1zQihSv/PKi/
	 Yte8k2zQaydu0hNpA8UFCpMLhSI8gbbLxKBCi237liVGFiUEuRUGCLZFXETfk2Eh7TwwA
	 Pf6odJI6BAMV/vl4Q72FXez5YxxdSwi2LIFJlRsfnDFU7pPo2FkbthN9ZK1aAn23DeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ta2vE186QItfvUq5jOzOMCYA78UPosrD48My+6wKEjM=;
	b=yEUYwv9eQj3bJTGsXxymco8j8gH62JAGfgWMmVx2yKX2lYkQRm6n2At2dwsxzpNgj352
	 LQn+BPdOnxPHnlRdSk06ppeW1srd4hsrMp20pytBn1eozAxeGXAAOXJKFcxiock739wCC
	 qt+l4sAE+puNK8fBf9NqwXlrWouaLCYmfc8qmLwPnhqERoxdZlTr7PlxQ7yLnRfND2RZG
	 qYbnUoNGfhCd9uR0QdFvdsi1FbUxZExJSpy2ct/7DsV3PG1Ut/CKuKwknMz4B34X1cyxC
	 9qnnVIqZxOR2pTm7FFvnsouQUrb41Wm2XieFE9r+arSNAzPX3UA50C9ldCBnC+77hrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kSWi34Ud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450DC606A320;
	Wed, 18 Nov 2026 22:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kSWi34Ud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE681F000C4;
	Wed, 18 Nov 2026 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040157;
	bh=ta2vE186QItfvUq5jOzOMCYA78UPosrD48My+6wKEjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSWi34UdF/d99RMANiDR21/uyzfYieJ9kcbryEDwPh4cBfrbmKZYQrI0bgfU/adRp
	 ZbbNMfKPtPw6ebnMyVhkMgYgWMOIfKhEzUJ5dqGJsZyh9cld2UaiXc0n70Pue+BbVl
	 RLhXIpDQg34JwWNrsXxU6vM4TSjZ7AOtMVoksN7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2355/3318] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:37 +0100
Message-ID: <20261118150432.247908019@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3a9b5bce85a1baff95463a2bb021efac64bcf83f ]

rt5659_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-13-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index a061028a16d82..8b0691cd66bd9 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3704,9 +3704,7 @@ static int rt5659_resume(struct snd_soc_component *component)
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5659->regmap, false);
-	regcache_sync(rt5659->regmap);
-
-	return 0;
+	return regcache_sync(rt5659->regmap);
 }
 #else
 #define rt5659_suspend NULL
-- 
2.53.0



