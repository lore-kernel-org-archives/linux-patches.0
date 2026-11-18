Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049823;
	b=kCeOLusyzJMBSvo/pJMIua63z9hpbrHchXywST+OiaEPc8EDwrT0epJzX3+ahfNPAniK
	 BonJGgPThMAHERsBePS6mx/uOYnzIw2J21bq1iuPK3oi1zcAq9VLUAFXuL95Qyv3zh2rM
	 N4x6+xdLJUCffSeqRhCT5F0lS38TXi36inUwkUW1rAr5l1IHp8cBL9ZPRbcapwkzKNPvX
	 E7TtbeWfyVyGdEfMmByDgbLzI8wQzw5yXAZ4zHQ08jmksij8YNNjns9isFfaIXEAWvTFW
	 mQH91WxS772W8q0Yc3pJ7QfdbhJDmdmbzrWxj0JPnnGW3vos0vPzcS8joEJ0YdzOr/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=spwyPbmtiF5DHGOlY7CHc6tzzR8/vTewWo2AnO7Ld9o=;
	b=LflqntInNfL7gyinMcTONoh7pX8PbkD72uvMuCZBG7l2eIXp+Axha/kIHNNcgeA6HCj4
	 UHIjfn6AlD7Z5MMXh00MNJof+kMFnKOnxI7GkcMiLkEndDr0EV/4DsypGBzM55Pr2zNHF
	 TgDdYXTby/Gg36xlxGzW8CeLfVJ6r73XLvT4VWIGgC0BMoGzHDcuIFmVNGrUJd9qCJu3o
	 wyIZ3567++BabqkE72u7Np9caYRkhE1VVFXzR/Y0ztqmoDUeiZ/274F/D1msP/Qy62Sr4
	 HCy5wVWMLxGquCK+A2370oS2GyObaMaTMC9jH1ojog/K1GMWTKNXg4SZZfhLw3UvvBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4+AZvUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C51606A320;
	Thu, 19 Nov 2026 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4+AZvUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE731F000C4;
	Thu, 19 Nov 2026 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049823;
	bh=spwyPbmtiF5DHGOlY7CHc6tzzR8/vTewWo2AnO7Ld9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4+AZvULB6GiQdldpqs9vyujC2HsCmLthapzYTvLrje+Lvv3B61d6Uhj0IQR4Gqib
	 tWmlZE31xIoFRrBEG4ME+LUMqS7kWn9JcjWGbfoT1dZ/nLEPmJF/37RuDdx9uZp/7V
	 RRvR8FiUfuDBurPe858B2c3bNY5hOIjh17LzhAtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2487/2857] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 15:58:41 +0100
Message-ID: <20261118150331.111270577@linuxfoundation.org>
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
index 69040c96e0e39..d7bb1193132fe 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5462,12 +5462,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -5506,6 +5508,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5551,6 +5555,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



