Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056294;
	b=vxEhiYcRDh/ICnP+AqXbwP8gTXG5qu9FsBS+QRtptDjWOiUDcGNdFB+Kdr47jqHYSEr2
	 SBKzWaOTDvn2Pkn/dk/YmArg5yYf/62PTX3qaLIMQe+lkr913yY6RJlSndF4ZhtjSTgfW
	 /BmpkKmfpvw7sb42fKOFyV6U9NPuVkI6++YGkFyFfdkMSfoNCECgASniPOBWREQlpr0xS
	 QRDeshXoAGjaRJ98EY3f1zF1kzJ7i3vQyYi4u62Cy91XPdsQ2jNtFgUdRyj8UJn4TGojo
	 y8x9/875B8T6tx9VXeqNQJdBO0J2Af1JDe6VSIzr3E6LBhLesWj9BfRA4TqWn7ytbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qBCZQpYyyhdhIKuzf7vndwE2H2l1ojyxiqCfBkeP7sM=;
	b=ETpAlBZ26Ola3p5T7CS8Dhm/EeROSNdojeW4jVjbbrmVCH/vgBD6eQzed6Pl8aSOk7tA
	 xzrcltB6GaaXafyoN5hN4sPXoOmuubtj/mjuXJsBtHbv5g3/njuXdmlAJ1mMouaUYX6qQ
	 Q5m+qC1WqO3JIIiPVQWuliLBW0KEWEIMUQD7yClOJ2LsAV5Q1tlIqQx1kSDS5Kg4y7GJw
	 0E6bYY4MunV/OrcGsJ0zud6on+eZqzlCqXAAf2o9/F70JFZtdJ7badNL6XqvhI28qfFjF
	 T41O7dKtiI6P0cVY6zD8CZjQ0WxFN9zTIXxX885C1wRGi1GH5mEXVvxjNFYDX3VLrIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubjPh8xK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5816B606A31C;
	Thu, 19 Nov 2026 02:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubjPh8xK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99291F000C4;
	Thu, 19 Nov 2026 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056294;
	bh=qBCZQpYyyhdhIKuzf7vndwE2H2l1ojyxiqCfBkeP7sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubjPh8xKkHfChUtZjslW2b3w6c8x8GYFNqDwtAlryOXd8UfY2EnurhlhyPSpK2gab
	 n1VPo0SbEgXYflwTO6gY08DXeGdhJV0UztO2PI81PMO9NQPCuzg664Nuk9D6dHh/e4
	 6YDUe6uOV/YtgjVAZQpHjijHKFH7wWYriD/iFA/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1935/2214] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 16:00:11 +0100
Message-ID: <20261118150128.403399545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a25a134087861..3d6bfe6c000e9 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6385,12 +6385,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -6429,6 +6431,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -6474,6 +6478,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



