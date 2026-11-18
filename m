Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056178;
	b=L9PQfZxnK9Gepq3Bzo2p612p0zpZjGj4/YXo7K3FTPIcNsYe/A+/Ko5mvhCx7e0SMoVq
	 lWvTtGBriFXJaqJdxIkayHzXFNfrf/7vVk3/NBjFPIbtWSZhR1GvIH1ylAcutb5eeEBmh
	 ELq0Hc9pfEa7rdV9kBD7D8NymVy1mklmAAvnBH+jdKIKV0LfpwkS0SlP9OLZR5qmxTQUX
	 OCrB4iNutDdilIVa+IY38oXfz8bWS9hnnzWWvUH+wxAPg1s0yXiq+S1rYpQ9svL6GiKmN
	 VhiAR+R1w94E37n0BIt/c3VF3r+hfXfeN8H0w0rREMLqBBaQyu2XELDn+kllQZF3XQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QNnbG2zbwBTyaLmFGwC0EudVhjeROYFFwumtqKdAqtY=;
	b=xnyWT/8aqZyuXxYX/6PIYMsGkyWiKb6B2Quo31WqRT9Y3rDWmXQgoxjqT5rmdR6Oxiks
	 L1gkN8xE2kmdv43a5vhLkVmR5v20pgOvZgmVFk76It9o1QFLdMgo1zCv4hqz0VSxpjXjJ
	 IjKQDkiWb9+SjwaIP5uNLKVMIDQgm1ndbjEJTwB0mEjwJi7TwqkXoO4365BfndaGZUE3i
	 yoVxZQRJRTCFWuJOhcdwEWD+pMsoysO/4zBUZmWpwMGJ4sVyx//Fg5FhTB7B1u9nURUy9
	 +PGvucYYI8OcDFymyWj3cb8nVruvzpxThagz1kGAyqQX0OjCcKI1/6FUsdnfdukx1zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkUnqLU6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0201D606A338;
	Thu, 19 Nov 2026 02:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkUnqLU6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5252A1F000C4;
	Thu, 19 Nov 2026 02:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056177;
	bh=QNnbG2zbwBTyaLmFGwC0EudVhjeROYFFwumtqKdAqtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkUnqLU6alKQVosIx2P68AaiBL+L8PLld4Vv0wqMI7CNIY+dCnmqNCeb+TH2vABA/
	 XIXHY/pjmo6dJjEoUfAyfXO/YlbKB7SiaXZFIaew9C1OQPMwQpP6ukopDiA/W49v/g
	 vpg6zCLF72RxhQcloxqKR/wjeMg497ZGo0Tk0DvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1894/2214] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150126.952815544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 85e56c3bbb7e8ea4626f8653afaef0d79d9cb7ba ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from imx_rpmsg_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 3c00eceb2a53 ("ASoC: imx-pcm-rpmsg: Add platform driver for audio base on rpmsg")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-19-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-pcm-rpmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-pcm-rpmsg.c b/sound/soc/fsl/imx-pcm-rpmsg.c
index 933bac7ea1864..a12d9fd5d808f 100644
--- a/sound/soc/fsl/imx-pcm-rpmsg.c
+++ b/sound/soc/fsl/imx-pcm-rpmsg.c
@@ -274,7 +274,7 @@ static int imx_rpmsg_pcm_open(struct snd_soc_component *component,
 	info->stream_timer[substream->stream].substream = substream;
 	timer_setup(&info->stream_timer[substream->stream].timer,
 		    imx_rpmsg_timer_callback, 0);
-	return ret;
+	return 0;
 }
 
 static int imx_rpmsg_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



