Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041807;
	b=vm8o5EWECAVrWbr/43mA40ub6N1LkYHb8aTDpLN8yRP65s6kH9MV0p79pgokrjUAVrxi
	 re21lknSynt1DebYskzh7ESTIztGM/LKRXLAigynDjwGcBiDnC1iQ+GRlc5cCnC3JTs/L
	 zDuaAUdksJpIaFbDZsYUd1huwWM5HGnXIqXwqYn+O4N9VjVNR0NRXB2YvO6AQOoF0E78X
	 yBNX9bnsXN6SrwIRbt4eByRQzxsZ7AtiM2jsASoa3D1xffKP8gIhn0yCIdg17zxoa/rpI
	 yMvoM1k8RxVy9yELjWiG2hlDcUowm8C1vcdlbiDPDbO0Ml3hHqB7wn4pMvpSsqDRb/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ed29m7aE+olh445sStA0fNuOtJwjC0wyHzJL9EMCxHQ=;
	b=CV4VbWLsGNKbeh0EHHdCnBzpyGuEB5fAGfZXaqI8c4mM2+9F+kLQjUPFDOBeko/gYfHX
	 CoC3+4l4AzmRENRPGRlDhYBJmJXKrq+eRMxcnTmKNmk9wdqyxPfPEyBJ8O0DFLj59YEH/
	 67EcY6YA51g1h/9mH+SzOrITQHMki5yYa2K2Lo4j6W2hBa5WeH4nfgwD8Hog3rdkzkhCf
	 eGiHjztRHzSafcAZJu0bfNrXlhRVn9ptCBIXAxKwv0nBj8BDUhjT3E+PPkmQJW3DtTSlY
	 5zrcrJQ19IgMMetaU3o6A+J510Fanh6mPS64L87Be29Z/ohX3f8JufvzRsrwijB+hEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9IW88Dz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25B606A325;
	Wed, 18 Nov 2026 22:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9IW88Dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22601F000C5;
	Wed, 18 Nov 2026 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041807;
	bh=Ed29m7aE+olh445sStA0fNuOtJwjC0wyHzJL9EMCxHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9IW88DzckS3DbvX+6fZ/axepUqsYoK2nujrcpfvE9+EwG4K2t0LNsmf91bFE2/7h
	 da2hTsQdtLnzu7FDtSvwprllnC3DJK0VjXNa3X7HfVW+IOnSV0Wr1ERl1bAMeR9T7o
	 zVq166pGUWK7xlHp83J+l0gWv9vEYjGQZtvN22ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2946/3318] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150448.713379836@linuxfoundation.org>
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
index e6d806591bb13..6c6624db5cd40 100644
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



