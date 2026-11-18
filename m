Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041813;
	b=R/Sh+kmcJcgOxI2BNQmJMFOCOqpRwvqPZe3Oh3ZYLpFjRKQ5MJT05LMYQJ1jSsDystRU
	 5tbBBq1V2CFLFtqo+QKQ3SU5ztmAZO/1h3O45nJ2o7xuebFttIOs3ZvdF7paP1P1Ehh16
	 DUKTYLpsxvHpKyuAKkG5B9fjiULsf1tagPv192gb4xGuktflbGqX7XCSDyhl25OjXkCGR
	 K1Jd159TmWvKxDiddBmfj/jI3PP//cELvfCc0fOICUuENF62jvMTshSPUKfZ7/NKFJt6T
	 Oq8Sl5rE8Q8kiE72gFgBZ9U+ELobnkM8BNtufagkyKomRWXhC/n6Bz57bFdbNWIatyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WYPuDxXhQi+QmTpkkGfYpAsYAu3t8I1+BSG2WGAX6/0=;
	b=YxrJ3xcLro1+Ehvy/x5Ppqu3NmtNtQTibpb3kYOCCKFsaZAd95g/vepKo1ap1UVi1omd
	 Ay9vnXE8/olKakV9UPDhDWYmBcCVsEpMjSC7CF5+kb7DTuViAGYZDGeUQuYFKJZma2ObH
	 u72dZMvm+izTeZgb30n91x7iz93Fcy8mO178Xu7aRYA9HeDrjCeXAcEsTI15aT/dTRRxo
	 qDviJqZNTCV2AWYkqUkjIH8EB/kYKYC12vYYd4B5eRQWQNNBhQmHYWmaNjOWoNRi9GTET
	 kOCOPMCQGqVd0sBadUrn01JTOUQOouxcf2ELHGuo2b2cmQ9cCTGa39pv5rEGW2tABvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dgufcT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7CB606A32A;
	Wed, 18 Nov 2026 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dgufcT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9251F000C5;
	Wed, 18 Nov 2026 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041812;
	bh=WYPuDxXhQi+QmTpkkGfYpAsYAu3t8I1+BSG2WGAX6/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dgufcT1diMVhFypzUAr3F2Bw2rRMiXtNZg7iGl3wgk5j1Hk32+MmQk9DUAV0DGfV
	 Bl5qBrjpR0Mf8fqwZfPUVN9+gyUFGaeDCGjWGrxpaBma3gzTeB0cTzRBJnSAqwNrLM
	 SAe2IsuxSlNtWx6PKSI10woSuFDdIPS+0dIy98uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2948/3318] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150448.766393316@linuxfoundation.org>
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

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit fc081cdfc6b370f6b6853cdeb4313f92561770d1 ]

If call to snd_soc_ac97_init_gpio() fails, proper removal procedure
should mirror snd_soc_free_ac97_component() behaviour and call
device_del() before put_device().

Fixes: 9bf5c3d11f1f ("ASoC: ac97: add gpio chip")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-6-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ac97.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ac97.c b/sound/soc/soc-ac97.c
index 4e4fe29ade502..e43f07a06ac52 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -234,10 +234,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
 	ret = snd_soc_ac97_init_gpio(ac97, component);
 	if (ret)
-		goto err_put_device;
+		goto err_del_device;
 
 	return ac97;
 
+err_del_device:
+	device_del(&ac97->dev);
 err_put_device:
 	put_device(&ac97->dev);
 	return ERR_PTR(ret);
-- 
2.53.0



