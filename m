Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831807;
	b=2T8OkdsWB8+xd7SwovWQJWZTlQ0vvY6vE3q4oVgVG2UTGNf1u9isQqCexp8K+aim0Vpm
	 M8griXQLIeU7ERhMv+H5JW3VP0ju0Qx1/gGjj84uqHDm9XYGNHDh7AmjKi59ivn0QD90l
	 kHhEWxe5r5e/0EYXV0jpoUz7VwxK++mIOiILISRxzKpeS99JHOzBvltzPsQIHoOcjvY2R
	 FqLa/382P25lzc+v6tI/wAWC+3Dfas9T6ChoXFkdI2Nye6in8RNA7vNx0iUX8D6e64Brz
	 KvIvKLkVx6xXLQcH1c4M9YBRIaf3haW9evpEPRqC4SvDX4n1x5M49i56RKaMlo7JD4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pQ0gst1wcA2dORMOR/6u5OoiI6CpJJDfaliz2x5F+rA=;
	b=Kt7dSa1kpqsXYuwAS3kfeW2o0gEmCGmAhOatJ0IYP7RD/CIstTWd/ecMq3L205/K9EX5
	 6X6m5gBqeFrDi30yTicwYF8O8hgObJ9Vnuwt6GTMDEhMO/9kdw94Zqmuw4f9Px1jY4fLP
	 YuKUVJo76nH8KaTlLZ2zQavaGLyKuWS9psabYodsZW/BbwfKTPyWPnN9Xr9WNAo2EZryN
	 4ceRrQMpkU4o6lHQnkDU1oNm1/Yr+zxDU4wPvZ0YE8JC7q8NXCz67dyPU5GvOjQNs/M3A
	 qME6LulpQ7/qg1mSuxv0iAobe/8ZsRhPwi3YpppEID/dbUNHjU6+7eqvwSjSq2Ax/cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=le81ylpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B2606A851;
	Wed,  4 Nov 2026 22:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=le81ylpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48211F000C1;
	Wed,  4 Nov 2026 22:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831807;
	bh=pQ0gst1wcA2dORMOR/6u5OoiI6CpJJDfaliz2x5F+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le81ylpGIR2rn1f+vt7wk8CbVj/RR+jV9ARJnIpyhZ5YCVIKBrQSYMOb98Ny0J6yg
	 UBZAvViDSejfNXThboW0xLxpeSZdqGaXFbtTPsZSawvsWPIag7c7EVSBQKcXAfejJo
	 n6+eUZPVZtrqMsy5PhMRLN3zwN+MHD0ov5MtVXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0888/1005] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed,  4 Nov 2026 16:10:21 -0500
Message-ID: <20261104211108.099937795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -7281,6 +7281,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


