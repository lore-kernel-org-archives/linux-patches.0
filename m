Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049694;
	b=dk0C6JIlmdQmz8DIPrrDoHCzYW2XB7X4GNfP7lCoL+eIMb4fiQSmQINOVxvewAn/7JXd
	 DGpFwWStl+3T8tZ8xAlZ/ChEmIYMzu+G0NgmoWSAk5lkbc8lmF+vJfEzX3gAIFsTASbBu
	 Wzi4N0RWI5t9QtjeNpkmmpvuZqP1WfuS/TTcSWkcFs1B00ahnQ7T6TJjJR4HIDm0d5m2O
	 tgbC8lOT7vdQKaaQ12UK4VzWM9xB9IesKEKcDk+Bnj7Uy1Y4DQYB5Ii0Pjv6kXqT0H3d/
	 nDpNXmiFnzMYKdD1XP9xiTp3g3SOOC48W9RSAPKYNLK6G8w7x55luDCFm79xjZJAv3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=shDSbGSCWL8Ca9iAJKvkgQFPxa6Yh4mRVpGj8kJkp84=;
	b=42pZK4VMf1PmS1X7/DIpucd05dSehIhEKyLmc3bIA1HQtPeQJo3BQVFXpyV8ap7QXBSy
	 TGMYL54Txg0Oe8lompz2/sqiJVX+j/ejBKb95DNeSsp2IPab5u2DelPy0jnBhbDWJ2/k9
	 FJNdvmlKjT5Sh4IZ7skyOzkK4HqJ3vIdY63rlsD38+ythYcHIvapQwE4dUkdFi7sRlcZz
	 VOybpbUKTGI98b/8dy44eHQ18aT6wFmFAAlW5mx+y5I3HwfOrWfvHT3teHvwUjFvJ4Xz+
	 Epocdq2J0RJFX2VQhpE54GF0/m/+6iyZI3yY1OhTUiqcMC3mEglchHQG8+iV8/+2e9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnDC7CfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F81606A31C;
	Thu, 19 Nov 2026 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnDC7CfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633481F000C5;
	Thu, 19 Nov 2026 00:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049693;
	bh=shDSbGSCWL8Ca9iAJKvkgQFPxa6Yh4mRVpGj8kJkp84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnDC7CfOfD+YVARUs3+Rlj4gVdRiZKcLvqlZt3/YzFJYly+6ZSmHE4X3kL1AFylxY
	 OUHxon+bjZ0TJb7b9iukqrVaJsmQ71CPGTpOhLNLGIqLxAz8llPSIPcfWNqz9mZXEC
	 1MVcImLlE7E0rEPk7o2mRa/ZcNjZkvhqzj3MB8IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2442/2857] ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150329.495725939@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 85e56c3bbb7e8ea4626f8653afaef0d79d9cb7ba ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from imx_rpmsg_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 3c00eceb2a53 ("ASoC: imx-pcm-rpmsg: Add platform driver for audio base on rpmsg")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-19-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-pcm-rpmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-pcm-rpmsg.c b/sound/soc/fsl/imx-pcm-rpmsg.c
index 933bac7ea1864..a12d9fd5d808f 100644
--- a/sound/soc/fsl/imx-pcm-rpmsg.c
+++ b/sound/soc/fsl/imx-pcm-rpmsg.c
@@ -274,7 +274,7 @@ static int imx_rpmsg_pcm_open(struct snd_soc_component *component,
 	info->stream_timer[substream->stream].substream = substream;
 	timer_setup(&info->stream_timer[substream->stream].timer,
 		    imx_rpmsg_timer_callback, 0);
-	return ret;
+	return 0;
 }
 
 static int imx_rpmsg_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



