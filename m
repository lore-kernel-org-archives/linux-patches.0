Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026695;
	b=ahNzDF2lobEA6YuiQmIo8bY+iDiCCsLKX/BeRtp7LWTDX0Ai1GwvZ3JIyg5rxYQD/kqT
	 10r8BdoGaxFVlTnqHQMSz1cl17C75qXwPKVxRnciNmyofAen8vJYSCqVy5qdSgNiYZcwQ
	 rjGhM3sN6QpdqERfLA/QPPHPesUjcOtYCEfkFNINeQiCULh3d8vjnhFRJCl+viu7febPR
	 2ep1WjdrJ3jnkVN21yvk4hCDTNdmCvUdY+4RrQ4HydKdinaKxQpGNXH3VZbec9c7VmOQ2
	 sFlIot4Di86oily3kA5+QO0KMg3GBRazSUpMKV63YBDljIKOiCNXc1V0fpSh3hHt78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lc3ZD4BSAPJewDvDDWMDSCcAFqbzRtG/NMTY4Nd2MFA=;
	b=yQ3lPWXrf+g74Z4WFIb021fODfiRGsDT2Ln+FVG2VwPThWSe/QYoHwRZCg9fEcpXK7ib
	 gKi3KNxI6FAH3LMW3TWyR2NyInBOEMAEKuxjYrR5d9Ub+pYLOS0PpV1dENbbt3ahc4lPr
	 58Iph9IYX5AMRpaMVLDignIWJdkxR3gSRZSogEA6fLSHYcLa8yZw4ja2tPQZDPHo0wUvn
	 k5A3bESUeRvUnAxcB+EXDLmCrjFPdXxmuaFzYH5KNPD0S8HSDpmj8uhh7JQ9zTmfuTIDL
	 ZIy7/wGw5jJAs+GmYI/fjQx8ejCLbHbG8Dg5oOw0DJxueTVpswVYeq2rPMT+Y7QnXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqXlTnDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A35606A31C;
	Wed, 18 Nov 2026 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqXlTnDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0911F000C4;
	Wed, 18 Nov 2026 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026694;
	bh=lc3ZD4BSAPJewDvDDWMDSCcAFqbzRtG/NMTY4Nd2MFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqXlTnDEWj68gFOGc/9Z3w4CFJZLd2gHVHm3MloFj2t7RZVldQm7gJTuYfL2Nw8fj
	 krvehbkqTKGTiq6QVyrz4uSFprWb/p9GdWD1vHc2GWARHoEwuZGkJxzBT29jOagZDW
	 zziWZqHEarsvzEnOKte5Gl3p1U0Fj10soYLJSJO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1527/2151] Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()
Date: Wed, 18 Nov 2026 15:54:22 +0100
Message-ID: <20261118150217.452796089@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 67d4b6430ba74..2df5d25bfee60 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5458,12 +5458,14 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
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
 
@@ -5502,6 +5504,8 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 				__set_chan_timer(orig, 0);
 				l2cap_chan_unlock(orig);
 			}
+
+			l2cap_chan_put(chan);
 			continue;
 		}
 
@@ -5547,6 +5551,7 @@ static inline int l2cap_ecred_conn_rsp(struct l2cap_conn *conn,
 		}
 
 		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	return err;
-- 
2.53.0



