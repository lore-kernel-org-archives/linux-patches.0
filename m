Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035396;
	b=fI3fZokuGvBYdJVfSv1Rx5kH8CqNey+BTEIUyUw6V4cjjkeXRHyKm6RdRLzT1ifiBEN0
	 hOEoW2+Q1HpeVnKuKvi+s9v/dd3FBxTznf4HDi55sZuJ0F7p1EOcwyn03EMe3crBlR8Ro
	 5+4e71ITaQorKp5rEQqn+s+tnb9KCAT2oNqOt42ET4qHvLCbveqJKdF1tMG9zN0aGFe4N
	 inCnP9ZIiQpYu1gOdRTrS/6FNDNG2Xmagncg01SSa6kJKvFi3hYHCNAgDUM/639YD+hNT
	 Ax9GnkXu6NY/iGcTYhZTZP5j7NCJr9OjGJ5nZxoqyszxVdSjH9yovFtgioP5b8R10zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNrNjHN6EzxXaKO/xMr63qKF6pfZmCe7CGKYy0eoFZs=;
	b=nst6Yf/1q2yC67OQVDZ4ywXudSMr87hVNSTVJlP8jXTTM7L5gaXVHoqS+QCe9BWxRALP
	 ruyvwI7kN/pyuoKU9kczBqcTMlE3+2TpCX3UNY5Xd2fVf0FIrt9xS+6xxSingI18i2Nm3
	 4adi5IaImlvi0jAwG/HC5G64+P4pM8pg8S/WdEDnGKOb5T0jYi8gjsjXy8H6942VSaVr1
	 v2MzqmB7CeTkdadiy225DxIodToHXP5Knk6e2oRnXhaYhP7swx4oJ0Ew5h3PehGbMe7as
	 cNpg0WU+XAXngQdf6sEgqSHBDMVI9htEX5GEO1LdH02ij4hFwT46JJAVXHYM+Uzglrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+5+yxxK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C560606A31C;
	Wed, 18 Nov 2026 20:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+5+yxxK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827061F000C4;
	Wed, 18 Nov 2026 20:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035396;
	bh=lNrNjHN6EzxXaKO/xMr63qKF6pfZmCe7CGKYy0eoFZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+5+yxxKp1Cb2NscrVIN+xfKYK9EZ7PhLjhQlMO+c3CBvxUOvTZyk6fqULphbiUp3
	 OvaHfSXcEgMbmbeTUgkXFBRUgjRHulXcBky4qSnA3R8sQV9kjhZMQRUtxm4eatiEsp
	 L23JOvllIQBD2P2S9bPjnwsiB0xsBBso9qpjd65A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0687/3318] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed, 18 Nov 2026 15:21:49 +0100
Message-ID: <20261118150338.834261982@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 95ff0c079b9cab91f2327beb4197a3bc48c71f55 upstream.

deleg_reaper() sends CB_RECALL_ANY to every ACTIVE client holding
delegations, but CB_RECALL_ANY is an NFSv4.1 operation. An NFSv4.0
client's callback service accepts only CB_GETATTR and CB_RECALL, so it
replies OP_ILLEGAL. The decoder maps the unexpected opnum to -EIO, and
nfsd4_cb_done() marks the client's callback channel down.

Nothing brings the channel back. nfsd4_run_cb_work() sets NFSD4_CB_UP
only for a minor version above zero, and the only nfsd4_probe_callback()
call site an NFSv4.0 client reaches is nfsd4_setclientid_confirm(). One
visit from the reaper therefore leaves the channel marked down until the
client re-establishes its clientid. RENEW then returns
NFS4ERR_CB_PATH_DOWN for as long as the client holds delegations.
nfsd4_cb_channel_good() stops returning true, so the client is granted
no further delegations.

Skip clients at minor version zero.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260817-recall-any-keep-count-v5-1-3b2cffce701e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6498,6 +6498,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


