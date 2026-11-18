Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044548;
	b=sL2jsWzB7frMfsyXK5mea9BjjYjjpCRvzF29tX4dBm41zSnyGnqnKP/mZy10KBsbDBY2
	 9+q/ny3WE13mF+ipdQrMEiwvlhQBX4pgJLqaD0cbkY9zQGk/eJvZnawTSLn8sG0ubm8bZ
	 +u1FDvJeZdGXekYIeM0WMZtmJO5MaEdS2gJ7xUC8UNEsCS5PR9MkiXqisZ1uY3zOwxASR
	 qrO6SE2xkRqLuJhGjb9h3a69Z8q8xdEhb4mBYWh57V1Dl2gqha4L3CWTS58DxxENfjgAS
	 Awo5pNJ2T+pVqYCteMu/otSvDxm3cNAIl35z2zOE6N+r5T0KaRZbhdW447S4rODHedQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7YEvFkyZBqFsGOWD0yCi+DXgdDKfF+WhexgX5B+a3s=;
	b=GKohs5h7wOept/QIYTIRJDd6R3OZ+MgQ+J/gqu3oTj9lFmQcQMacniTs3hukIZGZiuA1
	 Pdo/ggjGEkHWhXZPZLcBu1T9BucWfMTtSyaHo3z/4sh7yx+z/HPwkUd4XKW4cl7BBPtjT
	 DTCzoq4q2r5O+deXMsP55NrcBuGDokGTPlkGKiToNq86srCuD2ugmUBAitP9guaziKvRR
	 D8CFPD7+wOLtwGRBq4FOxWVSOIkL5P0VLqmLUj/4ZS3c7Elt1WDKRwI9MajqJZFWYEqbK
	 dHTLjF5AeKjQJ8lwNxqSNfxJLqLDa1YRUYl7EHedvP06ab1GYk9MFBXYakOZ+rI0RoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtueQhV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153A6606A325;
	Wed, 18 Nov 2026 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtueQhV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0101F000C4;
	Wed, 18 Nov 2026 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044547;
	bh=x7YEvFkyZBqFsGOWD0yCi+DXgdDKfF+WhexgX5B+a3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtueQhV6R5v/ruEV+8pm34X5uwW5Sw9ytwTY/IThCfr28+oWO8OdgiZnJjMymz+gt
	 juW/tcVTDJFt3AbTct5SJcz6aAWFIV3/6Pqh9Zy/scsXf+oVMNpcmTb1+hDCDXyF/T
	 i3pPzv2AQ70qgVMW22C4lB9yEPB8R6jXYri5Q/v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0605/2857] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed, 18 Nov 2026 15:27:19 +0100
Message-ID: <20261118150223.275007120@linuxfoundation.org>
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
@@ -6463,6 +6463,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


