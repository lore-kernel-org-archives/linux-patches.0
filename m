Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020372;
	b=5a1v8Ul29O6/77bzuvfluZpd0W/WtJHGIy3sBe1ZRwgrd/6LMSMcvZSvPzmxHPPMCybt
	 YZSBaGl4gh4RrSt0VCn/4Mc20zwU4ZEerf8ATksybTL+7IYu+97nniGsOYpM9TeNZu9jM
	 R0VIc+YYJLGqOGf1ePaS+wbyMIcUmU3ml+bVEh/z69w0z1jcu8bvM/lZHYQMJfKwn4NlD
	 RI/Z6E2sYTqMLfgw6rtADijHluKYjPBBep+MnS5pj8xM9MUODgCgvQw9ZpfFqIXxdZKt2
	 bPIrO4W75xT+iiAlrhfyEWj/sZLoMl15t6/Cf/Few2H3i53o7yYOZFYHoLgMtl8CPFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RRtZpou3aDsdTPM77wkRU2BtBC3DMF1ndVe/ObUH/ug=;
	b=KTC10gJolLb0wWGPrSlPZ+owmBz0NlFOXHYwHfFMNeOSS0AediFB8NY0K0ngTkIInUPv
	 ocI5tszv7LDImX8Dnv1hmnvN/rXwu7HyDxkWWY3517H974oxgrY/FSxiPKi8mbh4fkVEH
	 35K7nkdfLDDXEZYFuVeV5KFpvqL/BSLq+fVUmrme5kwUQFqE4WphZNbDdBC0smcxrhrlR
	 p4hRE4pPFB3ff6R9XBlAy5PmcT1OXXJeQLJYQOnBI5euBaLxL84lvG8LwcG6pMaXDcJGL
	 E3ppOCBr8CGlPnDD88SGQfAeT7YwBF2u7OSIGWzX4fUheiD6pjlvleXMMB47H/MeqqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CXr/3Ga9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07D1606A320;
	Wed, 18 Nov 2026 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CXr/3Ga9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2D31F000C4;
	Wed, 18 Nov 2026 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020372;
	bh=RRtZpou3aDsdTPM77wkRU2BtBC3DMF1ndVe/ObUH/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXr/3Ga93R4bpkgt71gYHz5b3k33KpEA5CZctn1cIDMu+SyjhtKRkkYCP7M3OBkoM
	 BKv2M+BB/S5b10UURpXsPIjp54TA/Akd1Ta4mbT3XXJVrHnnU3c+OAtTbk3Za61isv
	 0hZcfqR5VuNxZ952Ys7YSV7L0sol5rarHgHrTR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1877/2651] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 15:51:57 +0100
Message-ID: <20261118150354.514582797@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8fc38a9e02bf7..d694c307543a6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5502,12 +5502,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -5546,6 +5548,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5591,6 +5595,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	return err;
-- 
2.53.0



