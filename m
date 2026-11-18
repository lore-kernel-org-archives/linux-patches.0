Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036717;
	b=emC+OSv6mC8NzzJdQzt5SWCdSZCgcPe/SYynBrfdTOw0ALSb5Hm0Oo1/vcThGxPgR+61
	 mGhV+l+SMxpeb2ntQxdwmMLn2iaVfNW/lo4JecaxsNOlIrI6arGFqt1vUgkcr2NTQyNsa
	 GvVHV8byzD3sATuxraAz1ieFeTSGFyHE6+XmXaxwa2ZbXGkjpFjLY2tOhfc23flPxOtp4
	 xB1mQNIup209ISkhdUF1DPdN/2t+Xqj8d7bp7DoY2Z0RfFWhGbLi7zgQgd4rptQ5jtds0
	 U9o/8hsriQjT3HAyef6l4v3qbbN5iGT4Og5XLQWDyEx1JhCX+f6k5duuVLB804e3ztA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QajwM0Z64U/BJB2uC9yqVHk0e5PQ4JpHWoTKiZ19ivM=;
	b=ywdGb/TgMqW5dpfpC2T5HA46bPYTAGrjP8kmnS86QJO01QVPu2lD6byBu8DR2XZDzKiI
	 Vp3qwPRxNswax6ouP53irQvabehdd96s5UBYJLVAcDUhrSXgA8ij63lEy+hRvKbQprCAI
	 W2JGYibejFFz/NtU7WGdRQ1KlSJA/KikKiiMzABvpjeu3gwUx7z8ylG/JdN2URgK6YVgh
	 Dv1sRJoyaGdP8Ugbdjlbjp9DUiMAtnUYzmAHUO57KX+AkoOPYu65u7pNYgR+3drUdhc9q
	 8RmU2GEdUhesyLZZNsbOMovV7aQ37PzspmWRu1Q7m43ui+V4hPLUFjNLweBLDzvx9GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is6gpO+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB960A2602;
	Wed, 18 Nov 2026 21:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is6gpO+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BE21F000C4;
	Wed, 18 Nov 2026 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036716;
	bh=QajwM0Z64U/BJB2uC9yqVHk0e5PQ4JpHWoTKiZ19ivM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is6gpO+JCy30gw9omRvKBi4LHZMaymEob5+qm/JgwkmB9Y3598Lx/MBW04+0WSLf3
	 ZxFMU7vJEpT+V3Z4A6wbRTM7Zkaq4n4oqXpvpZcGVDmb21soRtlxi/XJS/5f0KR3B2
	 rFJ3cxI1Yv+/RZD0pJBONLz1248fvKiWrE5wuJXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1115/3318] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Wed, 18 Nov 2026 15:28:57 +0100
Message-ID: <20261118150353.459704660@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit c1398cf11b31a94c27ed810ba69515e0df5ce379 ]

A peer can send a configuration response with an RFC
option for another mode to a connected channel, for
example to switch it from Streaming to ERTM mode.
l2cap_parse_conf_rsp() then changes chan->mode, but
l2cap_ertm_init() is not called again, so the ERTM
sequence lists are never allocated. The next
out-of-sequence I-frame makes l2cap_seq_list_clear()
write through the NULL srej_list.list.

Refuse the channel when a response tries to change
the mode of a connected channel.

Fixes: f2fcfcd67025 ("Bluetooth: Add configuration support for ERTM and Streaming mode")
Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20261007144717.3832330-1-oss%40fourdim.xyz
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 94fddc456ac57..2720325d23ec8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3754,7 +3754,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
 		}
 	}
 
-	if (chan->mode == L2CAP_MODE_BASIC && chan->mode != rfc.mode)
+	/* A connected channel cannot change its mode, as the new mode would
+	 * not be initialized.
+	 */
+	if (chan->mode != rfc.mode &&
+	    (chan->mode == L2CAP_MODE_BASIC || chan->state == BT_CONNECTED))
 		return -ECONNREFUSED;
 
 	chan->mode = rfc.mode;
-- 
2.53.0



