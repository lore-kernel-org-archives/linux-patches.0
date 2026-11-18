Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051839;
	b=5hn7VfJbr4gDVpwwJAq1wvcWvgxh9F7Imt4fMNWOMPjWY4xT6WVnsLlvMCticV4bxGOK
	 dU6n9EXvqEWIQLUFoAuT8nHBpH3/89FoP9xrQlKj56006+dQUylX/DScSBJwaK1vpY/4c
	 8XK4UcmEZYak6Nw+KJ5v01xrsRo26ajasyRg05jE6H5jRj7wC58Ujto4jXKUMzUXRdg81
	 sRaXy/QHVQqD/NkHB+A3Gsz5uD8VIXEPLoKuLPxl6nqjcXvSYg4Ew3X4HwmnAxh94AGMh
	 m2b+u8Hzb9BeE+bD/EqqkJ2zfclQgwoWsO03E+mjKKHPYbAt21oI+nJvrvSm57xN3TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tg75vE2EWaTM4Vua3CbiS2dM9nhm7NdspvtODzjl1b0=;
	b=UgXWFxETpybdPVnYq2RoleXpldVzIRhE+yuXA5PJSCzKPvv+itDUDh5uQp69M+IOA92G
	 P6uz50hO44enniUA5hmL9s36fn3xyRPWxC5bqautulT/qAWLJRPa4l1Fbc5AsCGS3dft+
	 BeYP1+e1ypWb/97bRxcGaFcxo88OHi5bHsSYmpbU5GtNQAOL6Od/UNeWip3wh/+VFf/t5
	 dV7kNC7AqWKjNIrI/tNeFZzE4ljELDREujrRz3JOMsq5Pwmq7q7MqCHtRa07/HMuDfC1J
	 dYlaY1jgOFRB1aDr7rTQwvHon9wlO34oE6YTrQ2MvRkJZSzKiqjaUbZu5V3G4kvbaLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vlnwOS/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA95606A31C;
	Thu, 19 Nov 2026 01:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlnwOS/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9101F000C4;
	Thu, 19 Nov 2026 01:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051839;
	bh=tg75vE2EWaTM4Vua3CbiS2dM9nhm7NdspvtODzjl1b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlnwOS/u9F16UbnVX1/RxnARfbZ0rnIiEtDtg3eRif/nGVa16Rq8qDHmQklFtnsG/
	 9CTz5Eq29aHfSe7LoLBlT/0w9keEw6QlMavGcraXbL6NGoM+DSutke3wMvMzBizb6C
	 YlTOvV3XXYDySV1hN0dCrtAbAI6DIW3ncnI1FO1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0349/2214] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients
Date: Wed, 18 Nov 2026 15:33:45 +0100
Message-ID: <20261118150024.663307752@linuxfoundation.org>
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
@@ -6394,6 +6394,8 @@ deleg_reaper(struct nfsd_net *nn)
 	list_for_each_safe(pos, next, &nn->client_lru) {
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 
+		if (clp->cl_minorversion == 0)
+			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
 		if (list_empty(&clp->cl_delegations))


