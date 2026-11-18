Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026974;
	b=kyZ4RiugdEQNZ0MfJ7eHEcyhebPB/d4qlKSKwM9SNn/cbvalU1Si7Mgi8rh6l4k1N/NF
	 Ol6w2aOcXL3+k8/8rhrMiUClzp7hNHYrUuKy8v0g2o4mH4ukAH9a4B1rEgkji1YeMT2n4
	 iFVCWiHKDasa3T8RWAXVL03nkY6AmOAg5r1lDbzfhUiE628ikNigOxXpfLEbT+MnK7FNQ
	 eCB+qM3D8T/8+3caJ4FrnxUtsVsaysEApgWeFPggS+Da4eOpAT0NDhE1s5L7RKJDUKLlf
	 2meOLmS9zE3Hn/+z1IdAFtJumJ/XcP99JWOlS1GG6KvvQA2b7oMS8Res6sm3iIyHhlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pnS4HjE7OxTmuaQy0UfGb24DFUwc/3RPz3WSpG0mclU=;
	b=gTkXXweGeEAKwrDgb7bGuTH+911fELG4kGHlscksu/E9c45NnLlU9uEWbRDhTj6tY/zs
	 N1GMr38mduHVlgIsyBqHhVr2mLGeH0gqHc154DPw1I+qP4UApa2bpLtU8U355ksG4Tyv3
	 npM2zzc0IFOBBeJ/w+xmAJrHhELEZ9LagLgP9qnFlpj3kCl3SIXwdcmD7tD5NiASSePVi
	 WRUl9ExNRyaz5KcDatQxiEfQVwNAygWE9WKcVhy5n8pk4L1ipuaBMrOIfbNfPlRIDSbDq
	 KjZektEyP88yAMYnyBx12NDQM2L7+RgB5EmgaXClK9LOxorb4ZCu4qQXBqNc2injQKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEEXPjiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9125E606A31C;
	Wed, 18 Nov 2026 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEEXPjiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F791F000C4;
	Wed, 18 Nov 2026 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026974;
	bh=pnS4HjE7OxTmuaQy0UfGb24DFUwc/3RPz3WSpG0mclU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEEXPjiIFC8oWfLls+bW3hVcB5F8LgQw5QgM6AF52OX85drbiJh/M1Njwzb44Afyn
	 93Lkg4VNzdhvsmaIDWut8bDRbpj64v02y1NwXBZ4XNGyS0SS5fiqw6hCWCAFjGaTsf
	 k+o2Sh6SQvdozPRiHDKYaVzAZPHEY/0k4LrmoN2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1625/2151] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150221.070689029@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02fd68f2e7028..50ff9ba3ac871 100644
--- a/sound/soc/soc-link.c
+++ b/sound/soc/soc-link.c
@@ -161,7 +161,7 @@ int snd_soc_link_trigger(struct snd_pcm_substream *substream, int cmd,
 			break;
 
 		ret = soc_link_trigger(substream, cmd);
-		soc_link_mark_pop(rtd, startup);
+		soc_link_mark_pop(rtd, trigger);
 	}
 
 	return ret;
-- 
2.53.0



