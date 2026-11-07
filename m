Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061717;
	b=oxlGvOSRCP/B4o12P/Ge7Dj9J7QdPK+Z2hN5ehlQUMwIiBfFvtS1CKGFIxVLS2SXoNp4
	 0LJ0s7ljg9ut7TotO0ysGGdQ9TO8oUt4e+Iy7JVylbbllTqMLNJ+Padh0kAdjeT8WLTJE
	 Ge+hJeKBqTPIuVSP9NmHN+V0CHMbjtCPmsMa7ZjQ8amMJzAvVmQWisGd2NmD0clPKgq+L
	 YkxzfQALb93qdvJ7a4oACz2fvp5X8/6CXcx7zQmFHVRHoNvPr+0WMAaDKK7M4kFd9rON3
	 jxxGBd12DB1Nmw2DCpkhXrKg2bq5y54fAPkrMCTkAttU8kB6Awhje/wTcXcf+9wW/EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hy/qhTnMpci1KFVcNni7vICYOaZpwAIInsQHsOiaKzA=;
	b=s/QOHIZXIhEHzz/P48AbnSEANY2cq1eDdju1+5D3v3DLGywGKKFhaziLcNCCE8XLLehG
	 mfQ7zH4IM3HrsRozGFK5q7D9skPtuCzP02BGxoj7ybK8MSY+JpzcXu1DD1q47BLvzzQxu
	 jXnJhrv1kATCYbgar/2vpxdFKUVZpCMb8GfSdTIepzHhmx50Kc7h7PjQG+/KCot9jeVDF
	 I6CftxP6osJRSespk8fX8JQGsfXioYll8PUsE/wwKG0C6OUsUBA4ChNcVpYI5SEprc+ni
	 knnvKxOrZqSDkvNfkzhCswaVk3SoXywtqBf/xK1CO1G3eytY2BY73Kpe06QeOHT3iGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnLtzIVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9D8606A330;
	Sat,  7 Nov 2026 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnLtzIVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640F01F0089F;
	Sat,  7 Nov 2026 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061716;
	bh=hy/qhTnMpci1KFVcNni7vICYOaZpwAIInsQHsOiaKzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnLtzIVLS9+ItUiZHQjHfA7h8hNzcp/2nODq2wVXUskeNqCUGDZfrWv3Oucq7HIvv
	 jUK3RH36h0HLEw7qyYlA/3msfztKOvP/U6FoMVKE8Yog6NEMrmJCl3SjkkbMas+dZt
	 vGXt80JfdFprtXuFV626RXU3AwtaybTkxR/WQq1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0762/1536] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Sat,  7 Nov 2026 08:46:18 -0500
Message-ID: <20261107135018.934490285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -6977,6 +6977,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


