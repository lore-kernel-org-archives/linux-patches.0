Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618510;
	b=GDC2Ftq8YBN09l3ZiTflljPVCbYJVo6mW4CBs6fNTGhP2MtrTTNSsv8k/QVZfUCPPCnT
	 gtgLiKbkK29rjpMrX2U2y8+g9QEVSL/++xfQdKpnoKLUfSsny+JaU/M4IVnGEOLZOE7Ns
	 nEwc9zsAPx8roIDmgOP7AWp1folNjL1Kp+XbbxYcRYKxVLWvCCx3MWE58CA/3oHLGYLnD
	 6zQLaTzjDDfpoiBcW/kCcfrZghYBvb7elZTugKLrxofDBZj52+ALOwR7INtBqBy3svv/f
	 cnSJiXvIZJj4gy3tPR2GY01om4WZIXusiZOq6bMFRhShDlstjSCFEwvxKcNSSDBk9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fuyq4HTSeo35JJO5IuKH753DpKVV1oSfDK9YaHTEXIM=;
	b=xrlAw7r3PtpDmbiuv4TgJdgDd8Kn0P98+lDMXkk/qhd5YWX+A47EKsKD+SdU8jvdy8s/
	 vBsathGuc5fBRw7UfFnh2B7gNYKSoC441vldsaveLC9ywuaKK4mnm8on7+SkgUUeffpUQ
	 EwSuIFVVi5B2TFSnhxF8LVjJzYmKv9uQrPpXuzwAFjN+h4coyEEoprATF1whk+kZROrdY
	 gdEoM4aPix529d1mh+WmsDKnH5vn5izAcIf/SpV7cGAJ1MzkrN6NI5p2TnQ4qNM7h1uWO
	 IvJY4x3YnP/JMKV1EqgzWTEHsjOubPagYJfZwlR2kPhP/O1n+3DmP6DDz1Gq4AQInNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Fs+nor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CA7606A31E;
	Wed, 25 Nov 2026 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Fs+nor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB81F000D0;
	Wed, 25 Nov 2026 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618510;
	bh=Fuyq4HTSeo35JJO5IuKH753DpKVV1oSfDK9YaHTEXIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9Fs+nor1cBPXhRHBkQJip7/VfUSn2xkj1aV8tzYY6WZ/GPgE87SgC1nmJgeVFdiM
	 XA6HI7/qa6BA7urJu7PvM7WpPy80u6D9kaC/rqA5WHkiBO0petdOsVRLf9GC0+kx1e
	 yrmV5gu3EfUbUg4Ru2/fqm5adNHRDh7Ufa4Vr0AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0301/1005] ALSA: firewire: fix inverted streaming speed between tx and rx streams
Date: Wed, 25 Nov 2026 15:27:19 +0100
Message-ID: <20261125143828.786595340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 64d3a2c8e7bc0d3cf144d71ee2fb357c15b6c71f ]

ALSA firewire-tascam driver uses inverted streaming speed when reserving
isochronous resources between tx and rx streams.

Correct the streaming speeds. This has no impact on existing
functionality, as both streams are always reserved together when handling
PCM substreams.

Fixes: dbd0cf204fe6 ("ALSA: firewire-tascam: reserve resources for transferred isochronous packets at S400")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/20261102033652.1184893-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/tascam/tascam-stream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/tascam/tascam-stream.c b/sound/firewire/tascam/tascam-stream.c
index 4ecd151a46c19..462766946e94e 100644
--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -287,10 +287,10 @@ static int keep_resources(struct snd_tscm *tscm, unsigned int rate,
 
 	if (stream == &tscm->tx_stream) {
 		resources = &tscm->tx_resources;
-		speed = fw_parent_device(tscm->unit)->max_speed;
+		speed = SCODE_400;
 	} else {
 		resources = &tscm->rx_resources;
-		speed = SCODE_400;
+		speed = fw_parent_device(tscm->unit)->max_speed;
 	}
 
 	err = amdtp_tscm_set_parameters(stream, rate);
-- 
2.53.0



