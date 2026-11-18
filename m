Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026502;
	b=BB/ZGzlSw9+xjyKWRDw0SAL9zyxqihePgAbrArIJyAXALh9zef4l4VJgzlGP8DgIP7Qw
	 Y2NhnicNit0XYuTMaFZsa4XZUHH65RvUFdKVOeBBdq3ZmnKwkeGidEZoA5XRPtTM2/J5M
	 ztx/Nt5AksHWtMWG5Kxbio8YrIRHpy+O1YIQd2rP1R3rMkfyLfEEKRi+Ex+/OwgQXkGzr
	 bCiZtkEoYhZclP1qgybvDK7NFpEo3SCR+x5MDV8kUaYbLtv1gyXKD264leHWs7qhqxlFj
	 71anCI4DPmZRXAr4Ugjows/28llHKBCn6qPw50C7bEhNKLzhPa6Fv3xz4jM0bK7MERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+fSp6obXmhAHYWUpnJdaMh2ePl3zdRQBW9yHEc5QHY=;
	b=Skd+oZuR0CcvyjbwCZdO1Ib4yFSWgimVzyrw8l7kTrruPE98TXJnB07Pw8pd7jaz37gn
	 nT2BEDVX8mhT2sReAhk3kqY18+/WTalvdJWMZ5HOOFU32IBK4PETgj2EeAeK9G6jmjGI8
	 zSi09wwPUQ0/lgnj4GDYFUA8SX3lXT9wfTYkhC6GLEn078JkO26TkoaXE+Qg+To00YGH+
	 QrJAzyJ7bhPVOCJP7rwJLbzLVvQUB2CB4l9VKX1x5iMnxBvr/qs5Ggxwn8ubwbpmDqff3
	 s5asbaF8n48QeqZ7mFNiu1pOEzXPlZropczRan7Hm0VSrfTrRcO3USFFgNwlpWwn54A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjR5XHVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB62606A32A;
	Wed, 18 Nov 2026 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjR5XHVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F51F000C4;
	Wed, 18 Nov 2026 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026502;
	bh=v+fSp6obXmhAHYWUpnJdaMh2ePl3zdRQBW9yHEc5QHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjR5XHVmq6qgcjb5ouw69+oW6BbOFj+36wlALnQpLRZR0v9CnW/mYSA0bFSe74XWO
	 v7xwDtylD5EoPh/kYImWt1h1YajK6KoL07wHEgKQyC8Jp3VV3dknJ/B/nWMqpi3tR9
	 BEvAuJLG/qBheeh2F+oI4emI9W1si3V/lVKzUnw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1457/2151] ASoC: intel: atom: Fix .shutdown() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150214.987013699@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e3bb575811042ca30ac9b7b4dacc74aab8efa512 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from sst_media_open(). ASoC only marks the DAI as started when
.startup() returns 0, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4889a8a73f65 ("ASoC: intel: atom: Use __free(kfree) for stream pointer")
Fixes: 6cc0f4e63994 ("ASoC: Intel: mfld_pcm: move stream handling to dai_ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-20-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 2feb09f90f8e6..d546915534dc9 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -355,7 +355,7 @@ static int sst_media_open(struct snd_pcm_substream *substream,
 
 	stream = NULL;
 
-	return ret_val;
+	return 0;
 }
 
 static void sst_media_close(struct snd_pcm_substream *substream,
-- 
2.53.0



