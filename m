Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585386;
	b=WSBBZjrnYB/1UJKXvrtcCT1/k0yefOqRLartb0sXBZ5NQNbeq+ZgbJnzx6RlUXcyAe8O
	 hD0PQcP/OMcdd89XZb61vUvlMISXNIAiobsxg3BOow286KVpHug61wNLRFff/1R//AyNd
	 gmuWIrWK+p7U58gfjoIUod7FMQEolRXz1qsrCbY8FcEMC9rT9uvWhNCD4KYvX0hK1BI/h
	 HDweBzpYldL3PvujGi41pTx+P2AXFSWYoKfvZQanQYBDnrJUuiYQbue6CQJ+nWDjEapjJ
	 0bHCC2EWy/g1Egvb7sCKi3EbpfSs4v059ZS84py9BNaEOiZ8oPa9szTils0t7CV/bTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqeTBMzZ8xaGkFRjpl4pmG0os1iQjoSGcQVnpDmbF3U=;
	b=u6kWVA4jwioe5/hddg70FWIqzDNKBoF9sKgF77zZLKpzdezhDwUlPQFkzEND0OkaXr7s
	 R0u4cm6W2bgobO0pwTJS7QYJjh1zKpfPtEmNOues0RHLth6Bvf1l/BpYk2PqvJ2oS2CdA
	 EBwmVezI0tbOBOISMWl0sG2xgH5nEec6bK+xp8pzOoE4BDl4Zim5njI6Xk/00K8g13t8t
	 hFyndKczkJnkyFrHTv2G24IIjiel6kaMg8EJgzKlVzbzzPAaOwx95LyMEt3BGdESTNHeI
	 XBsCp7yDELDEbox8HmUVQC67VDPyJxHIy8fy/4MNAR+V0oJhjkwa5abC+tjWc7MTdOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLeghwJu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E66070225;
	Fri, 13 Nov 2026 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLeghwJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C221F000CF;
	Fri, 13 Nov 2026 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585386;
	bh=kqeTBMzZ8xaGkFRjpl4pmG0os1iQjoSGcQVnpDmbF3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLeghwJuoOMSMEuzZP4d76qKiSO7m/zq+P3oj+8gV5cqNKZGpLeFcqb8+v+9/7TIU
	 +sGdGaQ82KzYEOXxZupYY8ykdDvAdvlgMo2Iy2LxHxvdPNETbDZy505OiKPbFS6934
	 ISxMWCOEwSnb8r0gRGTXpk73hAg/qgxnwWjWGUTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 051/507] net/9p/usbg: also disable endpoints on p9_usbg_close
Date: Fri, 13 Nov 2026 10:45:55 -0500
Message-ID: <20261113153755.280439192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit f81cdb9164806eb2df1e1c6df402e03bff7dde31 ]

The close function has to fully reverse the state change of 9p_create
(mount) and the potential call of set_alt(1). This includes to ensure
that the usage of the endpoints is not active any more.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-1-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index e2309500a8c74..0b7fcba4a2262 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -467,6 +467,8 @@ static void p9_usbg_close(struct p9_client *client)
 	mutex_lock(&usb9pfs_lock);
 	dev->inuse = false;
 	mutex_unlock(&usb9pfs_lock);
+
+	disable_usb9pfs(usb9pfs);
 }
 
 static int p9_usbg_request(struct p9_client *client, struct p9_req_t *p9_req)
-- 
2.53.0



