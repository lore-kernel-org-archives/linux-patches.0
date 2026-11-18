Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020538;
	b=4sbUEcpnP02U2CxbVklkEYtUYHw/A3bcwIeg74kSlejgG8rowgdonjUWbH4rnOeWQeAn
	 NOUYnVRFGpo39uERhgjDEM71michqofbpk9wPwlXbx6oyztVDYb2Nz8si9A6RnLQ1b5GH
	 czCwY2yMD/bqsHfGz1EOqvPUIwsomWB0+Q3cXfo20XKWvfw8ey8Wd2wxmu/mTz5RS3Yny
	 ASdOYOY+PwrCU8ycUH+hNMoYF7MSv3AhnSHbpnxf7cJlbwfzlrNwS1VtoHkt207orTLcn
	 4L9bEm7K4aeHL9ej31Nxi3B0FvED/z/amA/i+BZmosDc9qqzie0dgKGlw/QNn+YMcYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ddpjNLz5yTUOYUVr5XfFT5RZ8rT4D2KyG39LSk4HhoU=;
	b=s+59VmEGfCDZSBZKEXp216PF4ROTNQ5s1ux191xChnysvMVjnk6eH/YwzR3NAL3m0htp
	 uzrBUT8dTK3JwmKfcSavwbMbG5dXPlaLW4hL0UbKSjXipxmWlvLKh0Z7gG7mW35PVKgnJ
	 8hgyv7g4lgvW+9s5d33TwA7B5gtEnsoYBX1qHQ+9/LH8BhzL2zzKNeSL8iF15UJGYbHgl
	 1ITnUDU0Sq6IAOjcZc2sv1L6nQkkLWYvzVou+iNl2xhEtcRanpuQuqtj903Gxamnut617
	 LfmDJl1Xbx57t/9WxnyD8nmITQO2hjekRtYdlAWgbnubtq6HXQqusIdLpsGWYX4Cyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/df1qWF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C8606A31C;
	Wed, 18 Nov 2026 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/df1qWF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE971F000C4;
	Wed, 18 Nov 2026 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020538;
	bh=ddpjNLz5yTUOYUVr5XfFT5RZ8rT4D2KyG39LSk4HhoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/df1qWF3Oy8BkehOcT895Lhtgavw4wioppI/XSNCYIj8/jDtqqITWFrSQiX95A34
	 JMHuWnZq8VqcaY2oLV6ZiyaqJxCykEX7EWcjO0ni+DYjPVPiK4Fa7AY9n+EhoymTNR
	 FAKuFFG5kQ1MoyxRXEJdZwM9UGR7dOPEgcIwOgjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1987/2651] ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger
Date: Wed, 18 Nov 2026 15:53:47 +0100
Message-ID: <20261118150357.908850796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



