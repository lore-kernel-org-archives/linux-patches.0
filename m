Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041621;
	b=nIrHEgaEDd0YPYT98exh2xlMPGIiQJ5gzNwGQwtAk50vq3DD13YT0dJXmaJ9CgDLmJiT
	 f7ic0RXrMBlznGOgQe2vgGsHz+kKJM4q77xO3+UAdW8ExZ1tX5MtUy0APPKfBaAOA6mKl
	 g89V1WXwVI7zk4wdWzbl5ULI37l5uKnPsUsyDiFhx8qcOuIGK4pxKrvrby2p2g2IarML6
	 twgrU9EzS0b6yzKe7xODxzQt4IvBRrMk4YpRE9QmAChH71dHtAU4kLVGlhJRJvqJA4g7p
	 o3KqcGZ/XoiN61BPnQEVV9/8JAL/4uH/9Ku/yftCjZM5fuXktO0ef33OD626Arnxsyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YSOMZ4sTrnGS2rYv62T+sh4lBBv7cFVhmIUw30TUXU=;
	b=NKItuDaghEgeOINnNyn4uf+JU30bL1xfuOCni+aAqh1OrfJAuK++p7acCwK6CBItYkV4
	 6vAGnZyD7C+4WID+EPgxmUIr8tG7HXJjmtB+vxp+5F0+Lv/lzLva03QdI+kRUBnXrC5Yx
	 WvgAnzg7ckM+Nvt/qfOQ3543LkLLcbETaYGLU07FHL/4i4SDY8NSgH/Z81VEVPcYLtJHK
	 myhbG4s5L0Pie7T7t49TFX0ISV2WOAUHm4PBV9PKKBs/Q2lo+8JkHNSADzA3CAIfh85//
	 KMw2fdPxnhfAZ4nh6IB0kKRss5c2cDbl6UOMj7plgYTnL9h+WU6kJvQ9BPsWdfe0MMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/lkq7Rz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA786606A6C3;
	Wed, 18 Nov 2026 22:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/lkq7Rz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC2C1F000C4;
	Wed, 18 Nov 2026 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041621;
	bh=/YSOMZ4sTrnGS2rYv62T+sh4lBBv7cFVhmIUw30TUXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/lkq7RzA42K4/CNst9AN1kiz0EuwQREvYYsP6Oh8eG+/FAg0x+dR0YxLeAxzyYSX
	 cuNPZ+pWOG5a2faXoRPm/BF21KZ45ISPJBcW6OqAz088I0OWxxb6Gz+jHCLDmxRZDe
	 NV8t9x6RKp1vBmmR34+bA9+feiQ/mTvXgsPBkOAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2878/3318] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 15:58:20 +0100
Message-ID: <20261118150446.879551539@linuxfoundation.org>
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
index 3c3a377673936..d6dfcb197365e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5387,12 +5387,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -5431,6 +5433,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5476,6 +5480,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	return err;
-- 
2.53.0



