Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C15F1591E3;
	Tue, 18 Jun 2024 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716570; cv=none; b=qpYhP+bShFtxRhP+cZs3aVeuDaBdz5jLOAZZoooKjab7lqSjSkmvvJAPiRP3CvmokUe9lV1Kp1mB7CSsgHgd+wATg4yyk3X4dGYSaNjY/mi1xDDby8x1ZYAxgRWcolll77g93pTIEWXuFE1uMMAum8AhEyAO5iZ4UR/8L14JFSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716570; c=relaxed/simple;
	bh=oPtwlcYmmIeK1rxJvspAZpbGpy1ThnNV4Anh04qG1t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbib/QATtkgS6TacpWXa6ulkxZ3NssXlTTY78qHKtlIa/xs0LkXQtrIBdP8ZVMbqfJvEQwTkJNYJLH7QDCi/35ihldAF+iYN0yTlNhpPOykeDEVQsEFcSyopmjt9jaUe1b+Kp5EXgg21nBm4dOL3b45qGwHJox+/L/qCuuuVEUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiGufWhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiGufWhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5CFC4AF1D;
	Tue, 18 Jun 2024 13:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716569;
	bh=oPtwlcYmmIeK1rxJvspAZpbGpy1ThnNV4Anh04qG1t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiGufWhMDm0BLYBuZXPvy2N+1d3cFKZC4deWr8aw8cFYkSROfVFt5dBLDX+oSLJMo
	 JhlMVTMyT2uci5SSXfb9IFsaZ3qPMDZ7wBiwjk9mIn3l3nQyEwxldtGYiHFQ7SaK8C
	 wnvTphmcvjOtFVWfVKZARdMoAO88M50MgJiVQG5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 657/770] NFSD: Pack struct nfsd4_compoundres
Date: Tue, 18 Jun 2024 14:38:30 +0200
Message-ID: <20240618123432.647455360@linuxfoundation.org>
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

[ Upstream commit 9f553e61bd36c1048543ac2f6945103dd2f742be ]

Remove a couple of 4-byte holes on platforms with 64-bit pointers.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/xdr4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 624a19ec3ad11..8f323d9071f06 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -732,8 +732,8 @@ struct nfsd4_compoundres {
 	struct svc_rqst *		rqstp;
 
 	__be32				*statusp;
-	u32				taglen;
 	char *				tag;
+	u32				taglen;
 	u32				opcnt;
 
 	struct nfsd4_compound_state	cstate;
-- 
2.43.0



