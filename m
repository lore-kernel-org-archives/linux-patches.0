Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213269;
	b=vy6LAZc7TOL4veLMuVWRP2gOPTz1wbcm1FwKVjhvFIHSgfJljSRPqyYl7Abz1xFpwFar
	 D7oiPnqjJcSFgWfcZSqJwjN2AUsoF71DBgSi9Cw8D1teQWQY3hnUc6gI4BCaGewI1z8LU
	 knxrkwwoG2pcNLBkMyLkFMmTudByfs2ghYWgb0Rv59Q20tQLAFPNTC4nftNTwIhFPuDq+
	 JHw78oJuF5VLyOlKnszHrvXWTfuAq1J0SaMt+nmJPkxvprPsgtPqtdhrgoUimw+iTUBPB
	 wKIurKnvNkmh9UH9B8HeI/u36cEL2QcQAlqWESf4f+a0k8vM0dWkX2Ofj44O4XJiz3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g8YMVCkirb4GWRqYZw23PYK7jURrdurBI8ol8DUOCCY=;
	b=lNwAka4espX28iIIMUYRWkC5Dzg86T/4rumkwZWQ0hs6VFNHKFxUuSrfCeNl5cof+vyu
	 IAXPBed3dSMujz63I/MdO07nlTnzvMEH4qaT1qUGFgT+0i/uzirxAF8xsYuivoftH7lT7
	 5DgdUowih+W/bnfBVHeFuUYyyZDSSXEQ97kSUcNB8z06kxTkUfBnHuIQpxMUEX5kln60W
	 bWn1d1b8N4RKxfeBUONaB5wDclTYnv8aQgjIQclYRCyg5eaWVoaUE/2+1BOtQQ5wDhhgS
	 UxA95wDC9kEHin4vZSR72rjJKgPhzkCoZFhqIzh2KKIwpf/abK0EZkVRdGCWV3Pkkig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vHcNPzB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E799C606A31D;
	Wed, 28 Oct 2026 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vHcNPzB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FD21F01828;
	Wed, 28 Oct 2026 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213268;
	bh=g8YMVCkirb4GWRqYZw23PYK7jURrdurBI8ol8DUOCCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHcNPzB34jTp3VRbCfvGNn6kxGfn4cU1wGJuqJxqMFk0c1ZugGwzITU854pVxaPj+
	 anGGbMgB4k52y34obzOx3xpam1eWWF5+dZi05zgF2yvCCUL/rYzprb4uJTJDFNCwKj
	 SJkmq/Fh1ID66BZCDUoPdyWxskrXTS4MoBkyx1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0447/1887] sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Wed, 28 Oct 2026 17:42:23 +0100
Message-ID: <20261028170509.402320068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Hui Peng <benquike@gmail.com>

commit 538b529509c7ab0d909cb65bb7264edca1788d30 upstream.

When an SCTP stream output extension structure (streamoute) has not yet
been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
variables params.sprstat_abandoned_unsent = 0 and
params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
bypassing copy_to_user(). As a result, when an uninitialized user buffer
is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
success (0) without copying the zeroed stats back to user space, leaving
uninitialized data in the user buffer.

Refactor the !streamoute check into an if-else chain so that when
streamoute is NULL, params is zeroed and falls through to copy_to_user(),
copying the zeroed stats to user space and setting retval = 0 once before
returning.

Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on a
freshly created stream: on the unfixed kernel the user struct contains
uninitialized stack garbage; whereas with this fix applied, getsockopt()
copies zeroed stats into user space and returns 0.

Cc: stable@vger.kernel.org
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Hui Peng <benquike@gmail.com>
Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
Link: https://patch.msgid.link/20260930044611.204739-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7520,11 +7520,7 @@ static int sctp_getsockopt_pr_streamstat
 		/* Not allocated yet, means all stats are 0 */
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
-		retval = 0;
-		goto out;
-	}
-
-	if (policy == SCTP_PR_SCTP_ALL) {
+	} else if (policy == SCTP_PR_SCTP_ALL) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {


