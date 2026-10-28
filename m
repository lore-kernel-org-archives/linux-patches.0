Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209321;
	b=4SQadQEf4Vhr3CsZBGg9uRM6xWc2xnKFtosMat/W2PAG7YxXcLeRs7U5KZCdWZvlThh6
	 DcMZkrtObCD8DnFS2KdREs46aP1c79bK2PXOsQNLcRrNI3XgBHUuRxRmDhoYINda6psFW
	 G24Pofblb9ScZJQFMrOgPjlbnau+B6tUpy/YK+BpNIjX9FyIFaxbd7Tbv4y7OonXaxZp9
	 8izOYWche0xAomfoAgCyL7B8yaFaxikQ+4Ln1nVYZGLbqE81KB6NsDHzYTsyPEwn9GQ7z
	 /SAEsIGtgCi6B/yerjeLBaPV9v0aBGa1ir7FF2VLQEHz9FPK3+b/X2IJBXBb5Fk8XQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c4QTFgHHp6YZcqTEk8C34y7fHJv6iwtbeBmdGEhbDyg=;
	b=XxEgYkRJ4677XF+NhLd2bXYs74cARrslQ4XwFKZmEijS4par657f/hT4V3RJ6LRe/0ib
	 tZS14FZJ8B3uHvb/5vUB+4NGF3SS+RXZH5lZ9CyAb1KZyXjyjjtkKLHxNWpn+SFCfYwF+
	 0eUBBvEThCM9RELZdgRvNUhLEMX5A++TuAOkv4gFI7dGOpz6Dk/OecPxrwrUgi0qpijfP
	 xCYYXCf/mVtVQ0sN15ldyZiZ6H2WxVR2LR7EvPo9PJxnOS1IccQtJOeo0PMLtm23yLZXF
	 3PdWTf7/JI4ltk6t5hILmhVQG8tUt3WgSqkXHEibcnRZpjllOXgMB5xFMuqk/MuU9sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr2xn8G+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64531606A31C;
	Wed, 28 Oct 2026 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr2xn8G+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EE91F01825;
	Wed, 28 Oct 2026 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209321;
	bh=c4QTFgHHp6YZcqTEk8C34y7fHJv6iwtbeBmdGEhbDyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sr2xn8G+OP0ouSma8wXb5MT3H8ajAKwtdEt2iaRzVirqtGfZ2yzxxQA3eCGgHTtT6
	 na8UctdrYVB0j6fDpDCvwDwCNtajScwbtivPTex23bnrXuSkM8ZTleb68o7NF5NIBv
	 F67w7/1O2iitJIv8MB9YQPnNaVVCh3YairimYG1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/516] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Wed, 28 Oct 2026 17:59:43 +0100
Message-ID: <20261028170013.697552857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 8b08b98796d2da103f2432550c14a7c687e72080 ]

The NG Type Switch enum selects between "Apply Specific" and "Apply
All", which is the NGALL bit. The datasheet puts NGALL at bit 7 of the
Noise Gate Control register. The enum uses bit 6, which is NG, the
noise gate enable owned by the NG Enable Switch. cs42l52.h names it
CS42L52_NG_ENABLE_SHIFT. cs42l56 has the same Noise Gate register and
puts its NG All Switch at bit 7.

So changing the noise gate type turns the noise gate on or off, and
NGALL cannot be set.

Use bit 7.

Fixes: dfe0f98b8d2e ("ASoC: Add support for CS42L52 Codec")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L52_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 38223641bdf64..8dbdd9834c4fb 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -273,7 +273,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



