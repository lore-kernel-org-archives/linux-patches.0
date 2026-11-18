Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031900;
	b=p/9f0iuhuhrIsM681G3wVxN69KB/X4r+nXQS6jPQIbht5B4SdDXsYMqZA5SFhO9lWxHv
	 Vo8CkOHapIXuggrTOeI0Bin3HesbcifoaofiRnyfOxPG2IVy+TGM8mGxifMj9vglyOUtS
	 2rTTkmpUczQIIJ/Cpbg/Z6jAQielb2oetKu7nkUM9DKb2eW+2ywBR1H/6hmAVELEXrquP
	 PaVO7QRQ5YU0v+H33JDbQdiDci8JbWHwK6/swSJk3lCeWcPgsvAoABzjcCpk4v+gX0jk4
	 HEJPUjECN90HHBQv3ccPgM4urFT9o4geQ59o2Rfwi9Kksc0AQlj4qre0x3iJe9xZY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cWCnpLCI2HBf3JXjZw0IWajka1C750iafg6IPbKBPc=;
	b=0R5goYs1hs4htxrGtWoYPxAweubGUV/GdTWzw59NyQuQz99y9y6RA8JzCKD7kmOPtH7I
	 DELbhy3Ctv6SoNFvliM16LZ471MB1ffD2IlqPPVaKJZXgxTqmf3zIYQo3eCWYHQKcLngC
	 cwgyoStStsPuihbKWy1IRAZALe4jeHiHKcaaSiILHbIW59ebx6vLsC8juywx8IMqQHSZN
	 7yoq9WMb7/IbW11e8DP9YdUyDpwUnmD6MW+QU2yO/6MSTd2YaYARBw0p8a/yfr5dICfNo
	 tM2s9CcnK5C2WUyKP0LOlykfDlIjATQpsHV/P6khRHhKpgzrp4C5vkFuluy39NSgukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0J1tzw8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B060A2603;
	Wed, 18 Nov 2026 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0J1tzw8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EE51F000C9;
	Wed, 18 Nov 2026 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031899;
	bh=4cWCnpLCI2HBf3JXjZw0IWajka1C750iafg6IPbKBPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0J1tzw8ZxsZ4Yzr6FNWDd2cw2VS/uIM2LNrsrksUZWJSMQ4kGSKmnyji2Nc8PWtl
	 MCie97isgvGsFjT8bhxOyncMnceN6Vns2PiZp5Z4WSboWQD6NGSX4BIookNV1TRWLH
	 shyzaaqOyPGHpLnC2+0IVLTalTssbcBnPLNTrfMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1220/1756] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150058.406993082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit b508a2a2d846ccc4c8f691e4e3dfca6f97dfe85a ]

l2cap_chan_del() calls l2cap_chan_put() to drop the conn->chan_l
reference.  If this was the last reference, UAF follows.

l2cap_ecred_conn_rsp() iterates chan_l list and calls l2cap_chan_del()
on some members, without holding chan reference.

Fix by holding refcount while using chan after l2cap_chan_del().

Since orig is looked up by dcid provided by remote, it's also possible
orig == chan, so reference needs to be held also after orig use.

Fixes: 41c2713b204e ("Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp")
Assisted-by: deepseek-v4-flash
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 053e676fa7863..bab8caf18f204 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5433,12 +5433,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		    chan->state == BT_CONNECTED)
 			continue;
 
+		l2cap_chan_hold(chan);
 		l2cap_chan_lock(chan);
 
 		/* Check that there is a dcid for each pending channel */
 		if (cmd_len < sizeof(dcid)) {
 			l2cap_chan_del(chan, ECONNREFUSED);
 			l2cap_chan_unlock(chan);
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5477,6 +5479,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5522,6 +5526,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	return err;
-- 
2.53.0



