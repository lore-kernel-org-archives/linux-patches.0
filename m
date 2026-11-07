Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061723;
	b=Gll8hcPc2kIr4VyHPYS3IxD+Uo5oDw7hKe0Rji8sWeqQCexikJm7+99TRCCSghDStbSe
	 Hs1dQr0alqZkZcRiKak2/adGfk1CPrmtPvfkEg9ikrSZq0BKEWYm4oa8ybp2218eShOFY
	 ZAD4+PM6ToTE72b4UhoPSsTJhm0ROF8u7MsfZ+tL4zb86HmF+Rfz0Z45tgFR8gz6W6E7/
	 yDbNvLI3Hnzj9PZULFLv/sc5enOB7ibPt3HooW0ZOuuwbK452/2VpOinekjRLAP3PJpC4
	 8BSJ6H7aeGaHOy4vTAUTv0wyxWPHp6sn12Dz2IDX1X2Z7GOa5OU4ODtt93Lf4Ap9zYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9ABCziN9ztcx5O9jwJLuNvyWhuQ0H4DbcCsl42Dbvo=;
	b=hwygG55zRCQeiX2K0Sx+CzM6WQ0quOv+gra5U8X8NJXXzVMr2Y+IUouuWPeMrcY7h1BV
	 +nVXfl6Uv6vx6a4IeY3wsKoIMUFvbppRMvSJW18zTBfOyWWP1lgOXbxiPW49+xSCwtCKK
	 oZrXqgl/9NtZKzwotW5ttn/clixyuHsBWp5EaIbJAoHneFt0WEkkQ8vMP4lxvrSYwHlDu
	 9Nth+puKB4TLbyq3j9TQb6H920H5jYmKRHv7eqfLEu08noY2JaH0AzaP1zOPkJwJRltmj
	 MSlrYrPUn+8vBQU0EyZwD8mPUHH5vy/Ye37o3+OX9lLqakWz22oBJoUOeJHUMDgB22g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6RQRnVQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36272606A32F;
	Sat,  7 Nov 2026 14:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6RQRnVQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91931F0089F;
	Sat,  7 Nov 2026 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061723;
	bh=G9ABCziN9ztcx5O9jwJLuNvyWhuQ0H4DbcCsl42Dbvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6RQRnVQ2m6NZbOpNvTcQ8IY3i+rxOzAw+Vyp0l/eM8QanOya+BnX8xAaUO8R4DAV
	 mswa6d+Y4f8u95yK/WqPJL31k3HfDSxhjBuurwhQt1lSPwPNNM1y1bSk9f8HzQ50ZJ
	 7W/mgmBtqX7w7QLXvB1TaAm9BB39sQIEAV/yeAR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0767/1536] NFSD: Fix out-of-bounds read in the rpc_status dump
Date: Sat,  7 Nov 2026 08:46:23 -0500
Message-ID: <20261107135019.076453684@linuxfoundation.org>
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

commit cbea14890783fead76f878caf0775a62a42049bf upstream.

nfsd_nl_rpc_status_get_dumpit() loads args->opcnt and
args->ops separately, then walks ops[] before rechecking
rq_status_counter. A COMPOUND that completes between the two loads
runs nfsd4_release_compoundargs(), which zeroes opcnt and points ops
back at the eight-entry inline array. A dump that already sampled an
opcnt of 200 clamps it to the sixteen slots in rq_opnum, then indexes
iops[0..15]. iops is the last member of struct nfsd4_compoundargs and
rq_argp is allocated at exactly that size, so the walk runs off the
end of the allocation. The trailing recheck discards the sampled data,
but the read has already happened. NFSD_CMD_RPC_STATUS_GET carries
no GENL_ADMIN_PERM, so an unprivileged local user can repeat the dump
against a busy server until it lands in the window.

Sample opcnt and ops into locals, then finish the counter recheck
before dereferencing ops. An unchanged counter means both came from the
same COMPOUND, where opcnt cannot exceed what ops holds.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Reported-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Closes: https://lore.kernel.org/linux-nfs/20260823113255.3417-1-prabhakar.pujeri@dell.com/
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260824-nfsd-posix-acl-ownership-v1-1-090fffc608ec@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1657,14 +1657,29 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			    rqstp->rq_proc == NFSPROC4_COMPOUND) {
 				/* NFSv4 compound */
 				struct nfsd4_compoundargs *args;
+				struct nfsd4_op *ops;
+				u32 opcnt;
 				int j;
 
 				args = rqstp->rq_argp;
-				genl_rqstp.rq_opcnt = min_t(u32, args->opcnt,
+				opcnt = READ_ONCE(args->opcnt);
+				ops = READ_ONCE(args->ops);
+
+				/*
+				 * Finish the seqcount retry before
+				 * dereferencing ops. An unchanged counter means
+				 * opcnt and ops came from the same COMPOUND,
+				 * where opcnt cannot exceed what ops holds.
+				 */
+				smp_rmb();
+				if (READ_ONCE(rqstp->rq_status_counter) !=
+				    status_counter)
+					continue;
+
+				genl_rqstp.rq_opcnt = min_t(u32, opcnt,
 							    ARRAY_SIZE(genl_rqstp.rq_opnum));
 				for (j = 0; j < genl_rqstp.rq_opcnt; j++)
-					genl_rqstp.rq_opnum[j] =
-						args->ops[j].opnum;
+					genl_rqstp.rq_opnum[j] = ops[j].opnum;
 			}
 #endif /* CONFIG_NFSD_V4 */
 


