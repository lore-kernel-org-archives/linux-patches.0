Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822A4D5AB;
	Mon,  8 Apr 2024 13:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583514; cv=none; b=PXJPLQqvykRjJpH9wknyRy1f/WRFk6z3pXALn0pjhIHsl+DhPjOaKN5oiwilkd77lhXrZ0jiI8YmNsG37ck5mHAPqP5Kvdlgf78I5j90QD3WmyRIDsuHB91FLtt/Hfyp9lDUMXB2i8myUTziOxeX8fhorOrAguG0py1/OxedJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583514; c=relaxed/simple;
	bh=Dpp7LAsEcN+Ma3rWxwOoqIVJ1vA631uCVcQdvsKSR2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2GXjHClceJVW64zn47Ku+J2fGGbk62kDDgaG3u1EE+djSeLw+imbzrOaQTc88K841W9HNfeq2jsOj2Kk+7wrCISDcAE6Ik28iRU/Nc9JT3O/6nrQNjLrN4HnI4U/+2C++FTbeiJtjwQZc0yC2D5w97WJjSiDA/NkDehTGcfpYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SGryCgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SGryCgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0DC433C7;
	Mon,  8 Apr 2024 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583514;
	bh=Dpp7LAsEcN+Ma3rWxwOoqIVJ1vA631uCVcQdvsKSR2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SGryCgJOUKSVWJqAt/qQMDeSn6uER79+kn0lJ86wJBF5dhjtc61zejw2EjjcYW6s
	 2XsE+PhnPEkPfaySZnhRAd7Sx6bmNGBsFa38/XkxNnSvODRdcrSZAvjy59SBMJmH43
	 A8Q70seIQpMADrBUPyJH19a7y0nQpkGCxrlnlnWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 255/690] nfsd: Add errno mapping for EREMOTEIO
Date: Mon,  8 Apr 2024 14:52:01 +0200
Message-ID: <20240408125408.852827242@linuxfoundation.org>
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

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit a2694e51f60c5a18c7e43d1a9feaa46d7f153e65 ]

The NFS client can occasionally return EREMOTEIO when signalling issues
with the server.  ...map to NFSERR_IO.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsproc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 3c5e87805cc8d..406dc50fea7ba 100644
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



