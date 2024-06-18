Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B445157490;
	Tue, 18 Jun 2024 13:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715947; cv=none; b=Gj1rLFkInQ0pGgRAGKnHrcH3r/1xZ4W+1Z/EhdGBHcatX0u/8uPAPQjIpkgsyH9yxP9ShDUp711p+0HKbkT5jE2Nyv64H8Z/0Vq7p+GlCiXjXLKHxQNsJ+/IRQktSTl83j9r7S3YkfiKPiTg0IHgqmQ1gkt4xJ7rY6VigODHQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715947; c=relaxed/simple;
	bh=KMiozRCvbfo/U16tll1Zoinh17g+3x7ZJwtcxGKJ/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXTBT81VeCozrfqNMg3l9dz/g+GXA+MsBmX4z87af148yUt0FcZlSbFoM01roBzIM6nWUQ+kg6F/ef6tooGSAQ9wQrg4D2C500OZ9rQ66KjuAkqK/cLBgaPhFM5uNq4cOkhx5a7uzMOhxZlWkRGc0FglzhRRsULzbMHVrzw++E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkhpvrJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkhpvrJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C25C4AF50;
	Tue, 18 Jun 2024 13:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715947;
	bh=KMiozRCvbfo/U16tll1Zoinh17g+3x7ZJwtcxGKJ/ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkhpvrJoMfstFGHGnsRMhO3RzF72MuFcnhTL39g6G4K0IdhrqDuOFNRu6UxiY1GAE
	 4VCqRtcqrlcitsrnPf8VL64wI2BkEof2npbJEHnFaVdZa5Pad0vcDug1diOLfaAPqH
	 zHdOpnx3wKAh3StZrMzxlDKjksxOOSprqdClIgGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/770] nfsd: Add errno mapping for EREMOTEIO
Date: Tue, 18 Jun 2024 14:35:02 +0200
Message-ID: <20240618123424.623640465@linuxfoundation.org>
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

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit a2694e51f60c5a18c7e43d1a9feaa46d7f153e65 ]

The NFS client can occasionally return EREMOTEIO when signalling issues
with the server.  ...map to NFSERR_IO.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index de4b97cdbd2bc..6ed13754290a2 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -874,6 +874,7 @@ nfserrno (int errno)
 		{ nfserr_toosmall, -ETOOSMALL },
 		{ nfserr_serverfault, -ESERVERFAULT },
 		{ nfserr_serverfault, -ENFILE },
+		{ nfserr_io, -EREMOTEIO },
 		{ nfserr_io, -EUCLEAN },
 		{ nfserr_perm, -ENOKEY },
 		{ nfserr_no_grace, -ENOGRACE},
-- 
2.43.0



