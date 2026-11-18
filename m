Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032108;
	b=ps3oT1LnXy1SIzhi+ozM5qdKP0X6YWWZ9h6dqZPY1t4C4MEhZqugtCFeuUAK89lunMhU
	 +8sboxVscQ6HjIbrnE4pmaZ8E9tv2JLd9Sx9SK30pn/d0iYLc66vIfjgDzRsNarl1GEdC
	 jtyZA4oWABiqUpCkoSOiA7ElKveOoIorcRisJ90KQV48bsU+5EPI2XL8qrSw3sC68mmFN
	 qdWOqkPYxcZXUZYZZ6qXT3DDtzDSMGJiUVI+MMdlHV8pdZn1kAAFaBKKautTFxQwG0uRm
	 3s8Ye+j2WlHFhE1a/54qy412caadCiSBPZ3Rvbl7drCTL1gVQsIARBf16hxmgQnAqRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CJ86QqWJEFaxn4IMHpnpRSiSdJVGFEsxuG6Pwi/xuGo=;
	b=RzytfYD/O3rccjmk1zBkSRPfq3A0j/X1Btb+GXs9Jy9bpibTCn/fG2LbSg0MjZsN/RFw
	 0vxLii7unOw8QcmJzw5xYUAAohBs9PGk+5TAgvaM4fLJYKt7PPkBQmY3yqYjphjCKkMO/
	 +DHv+q9omuYcwHcYcZWfcRWaRpCTa5dgHQK7DSoZQ/d7bMx4alR8fp9psaA/Nyd8o3PLy
	 SdvHvVPkTYHJeZ2tsPCvPLrEJSTMcf76xoL6UX3n6m4qOb3qgxVp6dNn30+FZSqCJ+TnD
	 waNJtWCIq0w/8RfUbu6GZwf6yi4iH7i48SMWpazUH2AC6qEE8LCGnjF7adTAR5CpcqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFV8+niw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05451606A320;
	Wed, 18 Nov 2026 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFV8+niw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556DD1F000C4;
	Wed, 18 Nov 2026 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032107;
	bh=CJ86QqWJEFaxn4IMHpnpRSiSdJVGFEsxuG6Pwi/xuGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFV8+niwNC+9m+B5DckBuK1fUUxe9j6Sanit1eeTPDH5JgCwXGBLQk5XKNnEPCnSR
	 beUmhrfFn0GM66D+y4y3v3VTxU5K76iJBRUGLg54OWWKOwlbX09eRc761cxZmMZDEh
	 HJsCX1ACKiVLU7Ln7Rs+Uf9y0c/MuD7lfqrkId5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1296/1756] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 15:57:03 +0100
Message-ID: <20261118150101.122975461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 7ef99fcfbbac20ebec10d21a37aeaf8321de7829 ]

When snd_soc_link_trigger() is called to stop, pause push or suspend
stream it should call soc_link_mark_pop() on proper target to reverse
operation from trigger start, pause release or resume.

Fixes: 6374f493d93b ("ASoC: soc-pcm: care trigger rollback")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-2-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-link.c b/sound/soc/soc-link.c
index 7f1f1bc717e2c..cffbd669d853f 100644
--- a/sound/soc/soc-link.c
+++ b/sound/soc/soc-link.c
@@ -175,7 +175,7 @@ int snd_soc_link_trigger(struct snd_pcm_substream *substream, int cmd,
 			break;
 
 		ret = soc_link_trigger(substream, cmd);
-		soc_link_mark_pop(rtd, startup);
+		soc_link_mark_pop(rtd, trigger);
 	}
 
 	return ret;
-- 
2.53.0



