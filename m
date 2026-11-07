Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064346;
	b=2qAvZ8++GkefKJqEOsOmFHB39SLlXxDebY8jX9W9EYbMscuJNnpZ8D+OkZMzOIuSWu5Q
	 yiSJhVWZWQgy33gxEGMspciUAUIxcQQnXEBHto3b6qd4obLDgOTw2++MeWxjPTnlurrjh
	 1NjDG44zw+whA2x7o2kwNBCDwVa0cknPZ7WMJAlB/5/OruEs46/Rn3pgjuFhgGfUdtIb8
	 0S0P/kGLcsIqBA8G/rSPZSJolkhHKaSuBzZzi9ch3hW+8Mu8/VBbYwXmxki/9RnAwal/x
	 bjmu0WD8dx14Y+KcTgDn1/iawBPvcplINQAiyRQ9ys/xbfH23sER7dHETxtmV0KbiMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PF/Q6MvQSpJBcxHqHOJ7SjhJn+092b98OFdl1uag+U8=;
	b=sXQb4+/nuWWUeBUsrqU8UmuNHd39hmJj3fCdYWPUfsMF4q3T/GNxEsRf41LHlxAlBDVB
	 qEG/fzly1LeYNspTnPKPBbMqwPFPknxlWR8b1T2lCH56lWE3yvGDfnOK4q3gSK/RX7Y/R
	 PtYFOWvhqecXjRCLYwGkk+IxF4ReSDpWH1IGyw06uRnNlTAxi+tyCs4U/mQVfqqZge/UV
	 MQi6vmB9HflLO4EmxwVTLiRko1AX8wC4z4cp+G87lSge42okftyo/BDXhR4WHA3/KezuW
	 OXBaM4KPALq9WR3oG6/VM/B7YpA5HpSZrr9XD7i7VKOvWgmSgr2NIHjSP2MervsVhxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfTaOu+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4967C606CE6E;
	Sat,  7 Nov 2026 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfTaOu+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF3A1F0089F;
	Sat,  7 Nov 2026 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064346;
	bh=PF/Q6MvQSpJBcxHqHOJ7SjhJn+092b98OFdl1uag+U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfTaOu+nvbXhseyLviCqqrQJ2Qwj2qY35dWD74B/mqu9ACwUBEgfhE1x1wxYrmud+
	 KwTqBruAcy6he9d90lhpA9L747CvV0a3ViWfoogJ7hiAceJoEoks8fBT42vmu4oTxZ
	 TJbSr3Cfc17Xvr/zwaGPBx+nwkFUBTOXHoghdsbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0431/1257] hwrng: amd - report partial reads in non-blocking mode
Date: Sat,  7 Nov 2026 08:45:27 -0500
Message-ID: <20261107134951.389026883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e7f5ce911efb2017381f28bbedb6243a74a9c285 ]

amd_rng_read() returns 0 if no more data is available, even if some data
was already copied to the output buffer. Return the number of copied
bytes instead.

Fixes: 85962d2248fa ("hwrng: amd - Convert to new hwrng read() API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index dff80daae5877..ac2d257793bf3 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -80,7 +80,7 @@ static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 				if (timeout-- == 0)
 					return read;
 			} else {
-				return 0;
+				return read;
 			}
 		} else {
 			*data = ioread32(priv->iobase + RNGDATA);
-- 
2.53.0



