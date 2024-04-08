Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605522DF73;
	Mon,  8 Apr 2024 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584268; cv=none; b=qcJu+E4FVp2h9+sYvWBi+izfEMGBEkDWTKUg3+tiAxPyDU9zeltDd/Mgp+uMtscehxIZVW8Jsy0eIGdxctLqHJeqOnsDQ32L2/F0u4x9zu9PTf1o0sJgMUql/YOfwms8/Fbm222/2mKSM98MN5FK+vbBWcFBaRh90DmB+TDR2Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584268; c=relaxed/simple;
	bh=/FqvC9lrq4YilYtr4Cp1M3nOkM+4r/dGomhsRCm7+Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVjTBKkhMw+OnU6ctAk7Tef38XBawPRwN/zseR/yENNTvMZtskoEUJstOfZCRiL7sRllBQk8aKM+Mwxa2Ipl9SsV4hmc9UcHG7EBLB9YmjKCuyA2JB6h/Jj3YsItygrq93EutP7xfRKtfS2lhGq5Dau7U7oh5/tJcCJo393tQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuefOFss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuefOFss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87A8C433F1;
	Mon,  8 Apr 2024 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584268;
	bh=/FqvC9lrq4YilYtr4Cp1M3nOkM+4r/dGomhsRCm7+Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuefOFssM2dgO7vjWNkbnbRqb4D08pMxguKM3IwAAHf32r8+/YqDZGZ7TrXp7ZmEA
	 LOlDAMDf8xkzbUYxk2O+W+jU8FUmVHTLobbeOLNe+fK0h+xWtTlFgqoD1y3M4vxcDQ
	 dfvGB48dRE1kzCndhfp3TZZWMOevnyfDunAnlGq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Kirch <okir@suse.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 379/690] nfsd: silence extraneous printk on nfsd.ko insertion
Date: Mon,  8 Apr 2024 14:54:05 +0200
Message-ID: <20240408125413.275915032@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3a5940bfa17fb9964bf9688b4356ca643a8f5e2d ]

This printk pops every time nfsd.ko gets plugged in. Most kmods don't do
that and this one is not very informative. Olaf's email address seems to
be defunct at this point anyway. Just drop it.

Cc: Olaf Kirch <okir@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 164c822ae3ae9..917fa1892fd2d 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1519,7 +1519,6 @@ static struct pernet_operations nfsd_net_ops = {
 static int __init init_nfsd(void)
 {
 	int retval;
-	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
 
 	retval = nfsd4_init_slabs();
 	if (retval)
-- 
2.43.0



