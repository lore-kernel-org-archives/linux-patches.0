Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061704;
	b=LjVeWIoypACFrJguFKC/S4XcY3lWXWOAizyAUBZjzYe4uAAjyCkVBw7ypCQkyjyp47Rq
	 zocfIKUuBhI8h3lsuDfEej6NDouGMRewiRkF/qfDuVwWhKslcm5XeLpHhkUT2YulITQjr
	 oNaKbE+CsvQiPMHoRGfEsxf7UE1G/46udMjYMcowMU5PSVjQGiACpmrFVTHjAq9LEWZXA
	 vEOgrlnwLth0B6KLkwuiXUMsWPVm9WNOURV9Y96ff48nF2prpHzCmfCZQ99zp4eWAc55A
	 ZzhV+YAHVhdcpZkaCJB75UPgqQissLjbd8bnMYtJIowSzMAcukrSxE3LwtNIKZQsacg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1oXSFvptcb5nxVx6snS63IwWWVNZ/Yd7EUcTGwqoJ/Y=;
	b=W8gSToO1cWuaYnQzGdwZdkJluUJEFoYKFAj7L4/JD2JXcF9R5q1p294Wg1EkLnHe2+R/
	 eK/HptFnqmvjpg4OgZ8L+mmpkmZPvojj3IrV2BUxXhsovTriItazVHIV3z5bUP8EJHcnN
	 +oxtAgHW8CNMTw+W9HBkelkKsaC68ZTHXu8b5uZJ4ok9XWmze+E9Y95WhQbWFgACdOgdC
	 kFd9QX3faBYBdKiMMyWvT+62X0Rjt8ScVIkUUcWV1AXg8uxP52csv2263Nqz3BS1077F/
	 EDU7BA0vjKKXp8ORrLyjry9rL7iLm1tFc2aqiOTPTRLU9CSfpWJvNlgZ9ev9O76roPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E/soi30B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C228606A330;
	Thu, 19 Nov 2026 04:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E/soi30B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E79A1F000C4;
	Thu, 19 Nov 2026 04:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061704;
	bh=1oXSFvptcb5nxVx6snS63IwWWVNZ/Yd7EUcTGwqoJ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/soi30BZGl+/y2jd0mOcR0vdgq4C8bc3iD04DeQintec2U9GWw16MyphniVZEpWK
	 LLdjOBAJv+0z6oWsYWXliewWI6t2Y5qyCL473gJPcbpqYVEHNRftg6d7xZZHOSTXD2
	 pvAV3rA577IMm3UX/k/U8gcOiirxHlMfYwDKeRtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1649/1848] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150028.766437701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 98f82f4613e93..15809ca665ffa 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6419,12 +6419,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -6463,6 +6465,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -6508,6 +6512,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



