Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060778;
	b=Dw7VOitmM4eB9zNWuUqA+bpHHPir2A24CgtzvCN8oidHDXcSPxH0thvBvS93q66MQ//J
	 Rsf7v4FxELwKjwbmObmf2WXBgzBDQM3r4oFckRBD0j/PyYonMUpRJL22zJLt+ZnCR8G2D
	 r2zYw0N3KTajlBn7S0KfP/YSBfE/tflZiXwgIIlhx+z6JjwHhdHPIauiognUtxEqIURJh
	 tX7MbNlc6wSL6dQtti5A2SwwQTY2N6F9wYIirUzUNTz30ffTEkmA0TEw7ymGkSqBH5hf+
	 /xI6ibYF82FkTYJSn42PM21Iju7Gl2H9i5/i1H1EV/+58iwGSq8Db8xTSusExcdtAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qy0z66iAc5WbdoXk+C3Q3jw7VB4CJ2LfHn3jeFPt6ZE=;
	b=FXR36JvgOHlrrPv7I2AxOF4nA3YnTA1eERhuqzWb4Q0ZEAd241ppvxHO/AKp7E4+Xee1
	 TNu3Mz16mUaqbu0tr0Mw4w6xP2LjdO/wZ5tn8bziBvZAfIHokaf7m5P+5HVj+LTQ8aEQd
	 x+4rARSUL5uiuyA5TYHRKJbSZG2jU0hRUqMZh40u8YZ5PVrsjdvLqQCUHH8jPrLyljdph
	 Fe509zE6iw52z8FwgX8TOXh/xgjTPttp4Q83U5M9GQiC9pS+CqSr+/Nmu4vr9Wh2LGQGN
	 z6A+X/uifg7YirbkoK9+8nRuk1yVLWsR00BDXpjCskClqHVNFcYA9NGtt+jQrBiFsbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjPMgiNj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F735606A326;
	Sat,  7 Nov 2026 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjPMgiNj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3708D1F0089F;
	Sat,  7 Nov 2026 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060778;
	bh=Qy0z66iAc5WbdoXk+C3Q3jw7VB4CJ2LfHn3jeFPt6ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjPMgiNjmLE8OHTsr7i2nsz1cUrK6R5dVaFp6yFpiyACQVyOqWu/ANuKGsGu4mbf3
	 Qpa8rOq7x8kx73Fs3qy0AEHe6UHiEHiums19JwhvMBEo/B7LNJtD3SyN/iyfirzorH
	 qkde093gDDnVFY7E5rKGfdoBrEYTUE9KetJk3Ov4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0185/1536] wifi: cfg80211: include cf1 offset when sending chandef
Date: Sat,  7 Nov 2026 08:36:41 -0500
Message-ID: <20261107135002.857323443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5a69b8dffd2a1b06e4cc4c9003c639eb78bac4cd ]

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260721053958.227853-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c5df80b547077..443ee72e58e0e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3934,6 +3934,10 @@ int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *ch
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.53.0



