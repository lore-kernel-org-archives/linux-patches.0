Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B96515CD70;
	Tue, 18 Jun 2024 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714785; cv=none; b=fEug4A7v94BPWTuXlGUEUnzRd/xyvZwTj1P8j6XOoF1zlZgSJRIDWx2mYgTJh7MU62MwzEvDrSeD3ssVaBzFNzdvz5qKJPx7K7IFFqXhV6so7ysz1Jz8zGA2TFsZ0RAms1zX6BC3zGjymgX7f+uW6sfNQRAJlHy5tyazLsQG0XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714785; c=relaxed/simple;
	bh=WBDIsF92jZMHugahD6lw7JRpatjinJ/1uDl/gBo0gxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrAY1oKFsYOI1FmhJaogo4NsU3Ioe1AMHmrVfEgS9ycLDH0VRgIJ4nZ0GtF/la4SjQgLdH+xJfaMvyxxhQoJ+JJyuypEmoFTiFsc5eVfNIsl4+Tk+48BA2hGgycoXD7vZpcUySd0iA6kNI3Q6f8y9BFqQcqjf7NJRKvIjrSxyFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEECekXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEECekXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CECEC3277B;
	Tue, 18 Jun 2024 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714784;
	bh=WBDIsF92jZMHugahD6lw7JRpatjinJ/1uDl/gBo0gxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEECekXhquFhhx2GbvW0Z7jaPDWPP5yvIzfhUc4rvaPETvxL2FdA/c7lujUhbCBMy
	 08omG7x67UIMqoVfg3LndJr29C3TQTa4s8brtBT5OhozaDBmdl54H2BJpUeBVWoHhH
	 wJRXpnXNaRLhsOG29KAsKJp0XnTGU+63Dx3jAsRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/770] NFSD: Replace READ* macros in nfsd4_decode_destroy_session()
Date: Tue, 18 Jun 2024 14:28:43 +0200
Message-ID: <20240618123409.986134868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 94e254af1f873b4b551db4c4549294f2c4d385ef ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3e2e0de00c3a7..7a0730688b2f0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1678,11 +1678,7 @@ static __be32
 nfsd4_decode_destroy_session(struct nfsd4_compoundargs *argp,
 			     struct nfsd4_destroy_session *destroy_session)
 {
-	DECODE_HEAD;
-	READ_BUF(NFS4_MAX_SESSIONID_LEN);
-	COPYMEM(destroy_session->sessionid.data, NFS4_MAX_SESSIONID_LEN);
-
-	DECODE_TAIL;
+	return nfsd4_decode_sessionid4(argp, &destroy_session->sessionid);
 }
 
 static __be32
-- 
2.43.0



