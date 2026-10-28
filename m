Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210553;
	b=NNMJ0z1kNEbtA+i/HyBa76SaftMTacm3U4+Hzv9dC3em4kWsDsYNgFXNeZf1OLOvQFD6
	 kKskaBeoqLAiZrVBDKgbOTzXsAOOnMUeU2v8cKBwMLvYurOFH5B5SwMuA56Q8z/1PZwN6
	 cD0k02h0vHS4clWlAFtxW8Rrimuj6pcDFzCf332qpznspHYhSqreoDQvUHHgLNacvhVNd
	 Ymwu1zCkeX8iLIk+Mv/d9Uv6/kz9rRTMZN9dlUJ+UhqYNIDF5OJYj7fOftcOwWQCPrTZx
	 v0qVsuV/2NvbZCdBrYY+7yIgXVzOs9B1QVeliBv8fqk2VUqs1CIXJjA+ofNKLnq4uVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNYkjPRE3ve8Gmo1IpsYkVvWxSrpxmT4/CADq6p0tPs=;
	b=M9GVUkAqzMbqPrnA2K6GuQmKfJ+eUXH1F0PWqHHCdsN2It7+9J9VGrwcC2Psq0WczwDj
	 S0vC933o99Xy5Bk1TxZfJfra3oBkjToR+argqCsz2s7cfDDDpnH6f2JLD0Gcxn3gQxjtJ
	 +1wogmC/ooWCyIawyJ9k2fU1GqXYledFK+loYr9UbkyDR6nXRqZbi9m8BPndjFP0u2rud
	 gWGh/uiv1KdexTpSMFbNmrORvdz7l/aqpzo04S6FTTheuXAHRjRTIhIRZepLTzDVXgHoc
	 u0DbYX7t2X2ScnAcXTLWKBjMDRjywGV3xxQYir0LWgvYQayyc59/shDTJUsz6KsxcZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZw2b5Ws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D1C606A31D;
	Wed, 28 Oct 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZw2b5Ws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977001F01829;
	Wed, 28 Oct 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210552;
	bh=CNYkjPRE3ve8Gmo1IpsYkVvWxSrpxmT4/CADq6p0tPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZw2b5WsslOTPrqix8udcpeltUGL9rDpKBb5pEDJsbG2I7q0lCgwAutq4xEJ/CO/C
	 GCPbP2TqwSj3HI3R0Om4/gRo+TIlcPLlG15ry0Vr02Wy+9xvL770a9GbuEhRhkAmuF
	 F+26EDo99YYF2QNmQsoUr5SrpatRVVdTJObj+ceA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Ou <oscarou@synology.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/571] lockd: fix swapped arguments in nlmsvc_match_ip()
Date: Wed, 28 Oct 2026 17:53:32 +0100
Message-ID: <20261028170009.569296749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Oscar Ou <oscarou@synology.com>

[ Upstream commit b9060689f49dc663e9a3d069c4a65ff63a836e66 ]

When releasing locks by server IP address via /proc/fs/nfsd/unlock_ip,
nlmsvc_unlock_all_by_ip() calls nlm_traverse_files() with the server
sockaddr as the opaque @data argument:

	nlm_traverse_files(server_addr, nlmsvc_match_ip, NULL);

The match callback is later invoked from nlm_traverse_locks() as:

	match(lockhost, host);

where the first argument is the nlm_host that owns the lock, and the
second argument is the @data that was originally passed down (here the
server sockaddr).  This is the convention every other match callback
relies on (nlmsvc_mark_host(), nlmsvc_same_host(), nlmsvc_is_client()):
arg1 is the real nlm_host, arg2 is the caller-supplied reference value.

nlmsvc_match_ip() has had these two arguments reversed ever since the
unlock-by-IP feature was introduced in commit 4373ea84c84d ("lockd:
unlock lockd locks associated with a given server ip"):

	return rpc_cmp_addr(nlm_srcaddr(host), datap);

Here @host is actually the server sockaddr, so nlm_srcaddr(host)
dereferences a struct sockaddr as a struct nlm_host and reads garbage
at the offset of h_srcaddr; meanwhile @datap is actually the lock
owner's nlm_host but is compared as a sockaddr.  As a result the
comparison practically never matches and locks are not released for the
requested IP.

Swap the arguments so the lock owner's source address is compared
against the requested server address:

	return rpc_cmp_addr(nlm_srcaddr(datap), (struct sockaddr *)host);

Fixes: 4373ea84c84d ("lockd: unlock lockd locks associated with a given server ip")
Cc: stable@vger.kernel.org
Signed-off-by: Oscar Ou <oscarou@synology.com>
[ cel: fix the misleading typedef parameter names too ]
Link: https://patch.msgid.link/20260617075738.1151797-1-oscarou@synology.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c          | 2 +-
 include/linux/lockd/lockd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 9e2a67bfd0702..bba701e1a6089 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -493,7 +493,7 @@ EXPORT_SYMBOL_GPL(nlmsvc_unlock_all_by_sb);
 static int
 nlmsvc_match_ip(void *datap, struct nlm_host *host)
 {
-	return rpc_cmp_addr(nlm_srcaddr(host), datap);
+	return rpc_cmp_addr(nlm_srcaddr(datap), (struct sockaddr *)host);
 }
 
 /**
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index 70ce419e27093..d6034b8bbb7dc 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -265,7 +265,7 @@ void		  nsm_release(struct nsm_handle *nsm);
  * This is used in garbage collection and resource reclaim
  * A return value != 0 means destroy the lock/block/share
  */
-typedef int	  (*nlm_host_match_fn_t)(void *cur, struct nlm_host *ref);
+typedef int	  (*nlm_host_match_fn_t)(void *owner, struct nlm_host *ref);
 
 /*
  * Server-side lock handling
-- 
2.53.0



