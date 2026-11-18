Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055837;
	b=eQyWtw6NXWKWPkOfGLo5nnGjkR/Y/2qwkquZvvd4EBXygrjPK+8OUvicuQfa/FbMomEb
	 N6/e0Yn+uS/zUsfG/pIN/iFWx3VYE4k8yhuL9oISyglP1L1n+BCuKSrNzkcLBd7vFjVRT
	 SkDi6AKkavUTPXUJwcULv/3ai+MKD7N2hnGUy2NYYM+5R8dfaZgeU7xbkp2JAiG5AsWc1
	 djE+Acu+iLcgLjZCCPk3vq6l1iU9bO8A6D1GtUApUcwhEX3RjPojMGgaObWOiplUAiTs4
	 8u5hBHqibMYE9sed75vtqdZ+At2CCJUbFynzFnwN9OWM0bLyoLtvNwzRAd9sw/oyMTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WZTngzG3+F0MSPfI30lqwOAJEv1VLuvGPDNDRvCyk8=;
	b=EfvqokfRAkLMkCp4BZpfuuudMY9EhOGRaOYVF04chSydlnO61hwAlpWFrcJ1WlM8U5cZ
	 ijoQuhvfhNLZMyanb4HMm5HumM/pI3LJgFR5DyUtstbEcQYjVcy8r7cAioFjw3TLdtK7O
	 rie+eMnUefhaTWRvqlMnX/iqsqfEbEoQRslj1NVnX3qOUAdCSDcywzJmyMFItaKgU1mUW
	 bA4LQiP4YDulo8669pFm90GZO1RpRTd/kqVGuEgcAkuBJwo+JVPxTUVFZsGigvqZuCZlS
	 yoheiVSd0/nPZPtR1MZAE54MedzWVsXZCfw7n1z9kbGnARBMdpI0OWStH1Sr6RpA6JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkbpDRaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC06606A32C;
	Thu, 19 Nov 2026 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkbpDRaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA9F1F000C4;
	Thu, 19 Nov 2026 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055837;
	bh=3WZTngzG3+F0MSPfI30lqwOAJEv1VLuvGPDNDRvCyk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkbpDRaIQ56Z+X/+ZU0fWu4JaIEqeUFQs6cY0OqFyrQEl6k1dOm9bOF5F0HfAZbTw
	 7jyRnwU2dJid8HWVQmRdeMlvAYtr8ng0kJb66V7ztYr3e38N/TCc4G+Q7S3NG0r7Jq
	 i95NzpGI8RJSfyhGXOo8logLpY2qxkHI+RXLEI+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1732/2214] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150120.967641439@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9a98f7e955d35e0831fb179e88e98cf9bc0e001e ]

rt5682_sdw_remove() cancels jack_detect_work only when hw_init is true.
rt5682_update_status() clears hw_init when the SoundWire slave becomes
unattached, but jack_detect_work may already have been queued by
rt5682_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work object is initialized during probe, so cancel it unconditionally
instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-2-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index f452245b210f6..6e3620ca8df00 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -719,8 +719,7 @@ static int rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682->hw_init)
-		cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
 	if (rt5682->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



