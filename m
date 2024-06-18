Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497BF15216F;
	Tue, 18 Jun 2024 12:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715144; cv=none; b=hWDHX+XzAUXK2pGiuUGYcG/9BV9uSGR3gstgxq4GZ48eo474GpeDpSzrDkUlV0fjpd17FZMhF181YT8VFNTNUwCMGOm1drUlrwcJivsMUu/QuznvNE+dm6N/AOQq19OIF78Fe2i9zo586vVFYVg/jgqaHevIK4SsEObOsNcTKXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715144; c=relaxed/simple;
	bh=6QnkmdvuqGrA+3lWlwJnywH2iWFG+MRsxLaHOhUbrFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB5cStbYSzqmgZt+/TIdJiewyIAGSlXg7eEqQxAd1bcD5FH1XVG6K/iaKjp4uXnDVFFmUJJG+OF+/7yfSMKG8OEPVomNef1BsRBaBCdzGNrNTC2bsnTpwwhpK5dO3XtimwQm1kysWuswNQv+5UFIFfYiaj4Ft3v3N3zw90ZTw5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMirq10S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMirq10S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF03C3277B;
	Tue, 18 Jun 2024 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715144;
	bh=6QnkmdvuqGrA+3lWlwJnywH2iWFG+MRsxLaHOhUbrFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMirq10S4M5LusOHOeKswLpeSreHPt9Neg2GE3MbN9Ilvu9IcxsnixeE4JHUGJT+k
	 D+9l2i58zmqbfiw1Uhszf9WOpau/CZXXHKILaeos6fd449lQHNsFMQSslSxTtjujR9
	 t/HkQ+Pp9KRGT364ZGQI1uZ66V8c3Ho78KtxcxUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/770] nfsd4: simplify process_lookup1
Date: Tue, 18 Jun 2024 14:30:31 +0200
Message-ID: <20240618123414.139875804@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 33311873adb0d55c287b164117b5b4bb7b1bdc40 ]

This STALE_CLIENTID check is redundant with the one in
lookup_clientid().

There's a difference in behavior is in case of memory allocation
failure, which I think isn't a big deal.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e7ec7593eaaa3..3f26047376368 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4722,8 +4722,6 @@ nfsd4_process_open1(struct nfsd4_compound_state *cstate,
 	struct nfs4_openowner *oo = NULL;
 	__be32 status;
 
-	if (STALE_CLIENTID(&open->op_clientid, nn))
-		return nfserr_stale_clientid;
 	/*
 	 * In case we need it later, after we've already created the
 	 * file and don't want to risk a further failure:
-- 
2.43.0



