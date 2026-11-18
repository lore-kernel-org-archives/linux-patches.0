Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050083;
	b=lK1EvqY4LmI3RHvpjccgHb4FbNJ7ts0uPUhcElSJHvTlP6WN9fs2mnazQUG4wAaJZT0t
	 Dory5z4Sy5vvqzwFo9xe2yVoRigWcWCawtFMK3wubyUPy83Fe+UAd8FIOFQhjyUErrXjr
	 uNvVSNVLjaGlct/gABbmtFxyr61q97qO22sWEm2e4MIKoyC8/WIngeiHIKWBkPU8lJnOC
	 d91UDN+pWSoDHhNPlnQeuEjvpXAvaExvEQrwCLPcGwZkrjSlO9UWL9h61ztRF5SPYhJV5
	 oL+sLSAv0wgUnycfkOJJjXzLdK40q4JR9s/jJlTwkqpNn9N7JxU/Bp/Sy7j9NepUGhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=R4C0kQxOZQwAVukhqG4WrMZU4hifd/A7LWD99Z7FUpM=;
	b=dysqHUA6hbzXYTg/l77gX/zikkqsVCRlRvWB8elFxuXQDdceBMqC8YOnqt/nq6naZf2a
	 HNdTVJflWptSNS4Tjuk4VHU+ar/OTihzh8BSiWiOQ9GvCXTc/5jMVBNtSR2JuFXIvVMBY
	 ioTfzpgcE7MidL4mGQM4cK7jYvb2sM6tQkYx2X6S2nwZYcSn4js1bQ2ACd3p5/jDBSw/l
	 dyGsQNyikD+A0eVArTLS2hIR4rQmvwH8gWpWlHjqux/2euV5U4TL7ei5KeH6rEnIWYHuO
	 WjdsAXGUtBnFsCFlhgHr1TfkuXNy5ktUy/OjupFDLnxRlUJulhgV/Et5wSHYP7T0A3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdRl8uVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037F6606A320;
	Thu, 19 Nov 2026 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MdRl8uVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9851F000C4;
	Thu, 19 Nov 2026 01:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050082;
	bh=R4C0kQxOZQwAVukhqG4WrMZU4hifd/A7LWD99Z7FUpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdRl8uVVoW0Av+LiHhtHZQwxe6QzbZJ0+0+NCAGaAvCYcOX+3r0tA1uUPVHVnokjR
	 1t0lN4rKban0p9F//xyZmy73jaD4i3K+WKAooxc3iur7uPnPoI30V0UT2atBmoq5eR
	 Md00gwBwwF7+GR109q+nYy++c1IVyovDv8lZe9dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2541/2857] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150333.014528379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



