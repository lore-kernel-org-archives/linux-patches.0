Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044567;
	b=CsjKUUnDU4m+vGSmvmInIdi0WGXp+v8IrA85oAGA+vj+CgtqcUdGKL8inKieKnwl+3so
	 8lRnodwivbovqb/67uxYrT45O6r/aXivVUG5mDqhJ9WsMxF36yYXoLjUye1FTJVbePLQO
	 NDISPph7wPTyLsBLLNp7I/Zngu/zAvYoVaAzl9Y366Kpcmv8qi+wgTXMU3nzNjsOmfrQm
	 o2fWuu2wtI84eVWVCnbubohmg1C91GUruMgnY71cMDeKsvPxjLglAWSFEYxjAJpuMfYEj
	 ko3N4ssaDXOcOPrW5rSKZBYGk9tWRLUT9M76OCeEjVCMe/zRrw6srckSSGCB+J1aZBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqwR7WwU4WiwkTlg16UcQSQFwK464UFYXAYMYxriyls=;
	b=oUVV/B0N2K8Ynky5HPvgP5tdosJF4Tcy66pk4YX+N2s2Nrm4xZzQ6mzSFEixsaKeSNpz
	 uKSrsTkQrWhFIH5qR2eWEsnoLMWfniI8A5CavPsJQbM07v5vE0nBQqw2IJmxM/MSvG6Nh
	 3EwW342lCj11H+5d9mzq7wOuQ7vJPQhyBWkmfjlaIqX+Bw0KfA6n66e+pVmSde/Grozs+
	 ApC5nV9EtdP5/36m1umZG1HuvLcvsDMIuysrvoYPYBUE/fa02uuKfJdChRdZkVbCd10qQ
	 9o/vKga8jcP2naJ6bmranZzYetaPOBw0g2IAgNGNRMo9oVt0qFpYas+RIvi73+m/FGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZkJ8M78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA91606A320;
	Wed, 18 Nov 2026 23:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZkJ8M78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A491F000C4;
	Wed, 18 Nov 2026 23:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044567;
	bh=MqwR7WwU4WiwkTlg16UcQSQFwK464UFYXAYMYxriyls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZkJ8M78AnUhcs6MRKO0KPa2EXmrhPCUAzuHWSN2tYsjZcYRrlb/MWuk7/P+hl6Si
	 IvbkEpXRg/AtxupytTLV33kP2EAqruQiJPeHrgko42auqRrmAR+QW1tBypBb/3tuTA
	 FlU/oQ3bwgrHiGdgdTnXelt1P2fQ+AyJvFcRBwFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0611/2857] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed, 18 Nov 2026 15:27:25 +0100
Message-ID: <20261118150223.490824742@linuxfoundation.org>
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

From: NeilBrown <neil@brown.name>

commit ddfabbc7840891e09cd500ab97c9cd36b650ec24 upstream.

When a file is created with a v4.1 OPEN which requests
NFS4_CREATE_EXCLUSIVE4_1, the request can include attributes to be set.
However when the mtime/atime are set to hold the verifier, the other
ia_valid flags are cleared, so no attributes requested by the client are
used.

This code was originally written for NFSv3 where NFS3_CREATE_EXCLUSIVE
never includes attributes.  When it was updated for v4.1, the fact that an
exclusive create CAN include attributes was not handled properly.

Fixes: ac6721a13e5b ("nfsd41: make sure nfs server process OPEN with EXCLUSIVE4_1 correctly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717093001.1972119-2-neilb@ownmail.net
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -356,8 +356,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
 		iap->ia_valid &= ~ATTR_SIZE;
 	if (nfsd4_create_is_exclusive(open->op_createmode)) {
-		iap->ia_valid = ATTR_MTIME | ATTR_ATIME |
-				ATTR_MTIME_SET|ATTR_ATIME_SET;
+		iap->ia_valid |= ATTR_MTIME | ATTR_ATIME |
+				 ATTR_MTIME_SET|ATTR_ATIME_SET;
 		iap->ia_mtime.tv_sec = v_mtime;
 		iap->ia_atime.tv_sec = v_atime;
 		iap->ia_mtime.tv_nsec = 0;


