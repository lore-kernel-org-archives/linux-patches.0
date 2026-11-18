Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056413;
	b=n8iZxZJFMIgyKDjkZSlg2eKx6kCxHeEEKtQVFBwjlU3WdKF/VXj3kzk6aFbLB2D4XjJB
	 whfz/vSgMyLHbJ04H7GuO+7AMgNkX3CD6N+UxLFMxs5sWPXWfop3/UobaLfgKvyRMTr+Q
	 XXziFOZeV1iCY19hrPDouIFZ/kNiar3zrbUc7iIppvTNX0AkPMvLGeZQgauSCsd3mpIce
	 vBCt+RKurY1P2nKOoHO8VPKypLt1Jrwmr8ZbeLyd2wQQcQaxGtrYOSf0H/+g9lKLBgItt
	 MzCPYTLw/4GyEDRztFWm64D9JzF/v8fZBlfZ0D58eBF1Vu3XeL/jom8AiN4y+Du3B/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gKqI1Ypvhn3tmgjofGRkj9qsJbPRuEl4dqrCu7DqK4g=;
	b=HYMFUNTZoghh/UGqke05QKlqj5ZbUsJG/yYLZRx1WvcnIyucZYPPlDu392qJ0SFFoc/J
	 5DfEa7xnPvqQSZHeiV4tixNPjbnuPR7Bkv1d+fT/dbzhRDWHrXByK5puwSOwjM05OHEe+
	 KShWvQpTH+OFLX7fdPaiANjjdHdRQ1D9cGqwshsF6jPt01Lh7oCW+8l3j29UE50ygfHxv
	 BjgTK3q6mfB1QN2Hig3rRO1VavOWcs9NN3o0m7gkLrokDVQBZXEaSv5phhHsAM5ybulk6
	 ARj/jsXUeE3ubCipyh5QDmp17BSwVoIwUbDmbrrAhAmamsemJaLCeGl9jlQcIsiuSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwv5Nq5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EC606A325;
	Thu, 19 Nov 2026 02:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nwv5Nq5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DC71F000C4;
	Thu, 19 Nov 2026 02:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056413;
	bh=gKqI1Ypvhn3tmgjofGRkj9qsJbPRuEl4dqrCu7DqK4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwv5Nq5nFY5V301J423DZYqP1J36cQl7efmmPGdP5yTraMcXd6Y8T3A89fWN1wo2b
	 QWR04HMSm8DwyW95EJEW2gxsUEeS/2ytGTY7qr2X2R2LE6qtwrYoKNhwznATsF2oK8
	 0uEB51w3o0WMn87UzJJ2RJWOUbo4X31FNLZrvs4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1978/2214] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150130.008257400@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



