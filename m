Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026557;
	b=CdTuX1wqkMXLdSo+UFEzvOB5NwuZn+HrdBYwFwvn4Z3vRkYsiA+jM98YYwFNguLuGx0/
	 oZNkZOh6UeQ7luQgSA8kqXcU0eKwPmDBUxsY7A5TRabplY9UPWISs24mI/Wcb30S6HFX8
	 /7pfMaHy+nmljVkbvTsPiapRYiAE/R7Ej6OSwQswvlfhoHL47usIpzZPMBctNViFdKl2Y
	 Pd/KKBq6pCEdrIZY25a2fDbkuTnWU06pM8510/rqJDAaJuIuwvdQ70Mo/P3c6KqLfce6a
	 sd62fsQU0a85Oe4+RO1ZZBsNEaqKu3CS00m5p7LbouJ0MXgi1DO+aZegiafEMK1C0gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wIR230imeBvr56XaVMEURrhuZlQS/VtBHsurtcqSsOM=;
	b=qaUFZqin4IamUEu1qHz6jo4+2RPbJDue35/s+hfbYd5Xu1Sy3+Yslwv0qP5o1Fuqn+xl
	 HMCWI5QuyOBxkuYHlI+TY0mQ76RXidOFEHjUYS7hT5yDkqqsGBmI3Jc5zniYFvi21tjmN
	 YWjM9gRsG/HVwd6E6l3lch9WuKEzW4IquZ/TKggW30VK0aHgsp2VoMAfqSKcC5zj9LDm7
	 f2FpWxJcCUh0ZGg+XPK4Nu6PuAtqLy9a9lgu+d82DwyH0/kHmo5FuBYecA/O9gvWs4jTD
	 Xp1NDpeSt/6rVF1ncGt4dn5h0PjjYPMXir38KLnlsqSUVNpAovgguNcXokraNrJuWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcSI+2Dn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64E606A31C;
	Wed, 18 Nov 2026 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcSI+2Dn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67841F000C4;
	Wed, 18 Nov 2026 18:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026557;
	bh=wIR230imeBvr56XaVMEURrhuZlQS/VtBHsurtcqSsOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcSI+2DnQWjaoJxc8jEfiH+Was7dlqjPGpEEzthfBsfG1d355jhhPRVih3IZBJmyV
	 Ts1T8pHWI9ZWRv/+nWv3FjlCG/O1LMlGmJEaDHQwCV5Fpsc2+X8KRebnUBSwbB79Ww
	 Q5hc6+6UzBcEV6zCrFwvXgFCMeTOtR9hyYq9Pw1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1479/2151] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150215.768270372@linuxfoundation.org>
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

[ Upstream commit 8ff1161ac5aa02f3261e00f07d6212be2b12384b ]

In some cases (system32 and compat64) due to incorrect assignment wrong
value is being reported. Fix it.

Fixes: 3ddee7f88aaf ("ALSA: Avoid using timespec for struct snd_pcm_status")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261013164256.4949-1-amade@asmblr.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_compat.c | 4 ++--
 sound/core/pcm_native.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index e86f68f1f23c1..8b6247b7dcef9 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -219,8 +219,8 @@ static int snd_pcm_status_user_compat64(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status.audio_tstamp_data,
 		.audio_tstamp_sec = status.audio_tstamp_sec,
 		.audio_tstamp_nsec = status.audio_tstamp_nsec,
-		.driver_tstamp_sec = status.audio_tstamp_sec,
-		.driver_tstamp_nsec = status.audio_tstamp_nsec,
+		.driver_tstamp_sec = status.driver_tstamp_sec,
+		.driver_tstamp_nsec = status.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status.audio_tstamp_accuracy,
 	};
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index b1353c3bd1892..7797efb2c8976 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1173,8 +1173,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status64.audio_tstamp_data,
 		.audio_tstamp_sec = status64.audio_tstamp_sec,
 		.audio_tstamp_nsec = status64.audio_tstamp_nsec,
-		.driver_tstamp_sec = status64.audio_tstamp_sec,
-		.driver_tstamp_nsec = status64.audio_tstamp_nsec,
+		.driver_tstamp_sec = status64.driver_tstamp_sec,
+		.driver_tstamp_nsec = status64.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status64.audio_tstamp_accuracy,
 	};
 
-- 
2.53.0



