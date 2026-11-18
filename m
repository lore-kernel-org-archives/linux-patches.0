Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056175;
	b=mtv8asH8/kQEYXcKkvS/dEXEFvtriRhpvDr/XttqTHaATZZ4cKC+6g7SQzH3GGHTdUyv
	 GpX3qyRpQF8I4Y/86VtRP/5Zf2yYMI3GVg2vDXyh+a9twSp4b+u0b/XuLGaD4djgB1fK5
	 IbotJwp0lx7D2nqC4yJOlimTzhKNWjq68FikSV1AaOmHiULOcGo0ZVNDow+eXk/gZ5EEu
	 vriDS7NEJhqhzuIVzlf6GDTX+RZj94FEtGUx6ltpB7PMv2RgghK8pvJTthR1E1h2qdljx
	 hsLrYUVJkwODCKSX+Io2bb0psTmq3TK3/5Qgpd7WLVah5+lcqjm6aqcjM191tnSA3gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8oX/A4TMjnlvhqHKB7+8wPuWoZo3JN8+V/kyqAEPrXg=;
	b=TCUs+SJDLH13pEOyBPqYfbtRid7ZVVZC9evLcBXmOAhhwp3XEIjGJV/zpJ5y5k7r0nAY
	 Plf6Gvw58ECsC7ne6mszJfRH/6rKwCkDM0YuSkF6x7e3vY3KAofPaPuiIcvCAVW8N9Ydf
	 pYs9TRwQBWteuOS73u8xvt92Hc06q3inPDWAaUCkGwHhWCaWEsYm9bkTU7PUTHEw2tWRT
	 KTLMIQQ6u3WBjJaEZb1tl6JbT7TLr2JxmY4sFJO1YYG+ZuGC0eMeAB4fA/WY1y73BYBFC
	 TehzKQHuhcqbxPbQStCLDBVyohOdi7eT68MxYIbwXMoIOHr6uDjA4OkuZEmRsn6iHFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhWQn8Bx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A350606A31C;
	Thu, 19 Nov 2026 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhWQn8Bx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790BA1F000C4;
	Thu, 19 Nov 2026 02:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056175;
	bh=8oX/A4TMjnlvhqHKB7+8wPuWoZo3JN8+V/kyqAEPrXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhWQn8Bx6r9YykbhZ1kF6aCKrRCHD/RfRoqjPSHWugmBQgF1tyqj0Cu6q5ib47CKX
	 TKlKaScARjKb1TaFUECyPqH5m/V+7LXl0wktzkpVyCV+F1DL2u2zL6nlQkVOBvM76p
	 rF7gUJ+RJRxndX5wnrR82o2/OImEDRSnJbrkuJCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1893/2214] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:59:29 +0100
Message-ID: <20261118150126.916178913@linuxfoundation.org>
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

[ Upstream commit 50aaca643038774b6779c911c4f96bc7e0d607e9 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from atmel_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 92dfa6198623 ("ASoC: atmel-pcm: split into two file")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pcm-pdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-pdc.c b/sound/soc/atmel/atmel-pcm-pdc.c
index 3e7ea2021b46b..df5d5e8230203 100644
--- a/sound/soc/atmel/atmel-pcm-pdc.c
+++ b/sound/soc/atmel/atmel-pcm-pdc.c
@@ -295,6 +295,8 @@ static int atmel_pcm_open(struct snd_soc_component *component,
 	}
 	runtime->private_data = prtd;
 
+	return 0;
+
  out:
 	return ret;
 }
-- 
2.53.0



