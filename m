Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179417C090;
	Mon,  8 Apr 2024 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584724; cv=none; b=Zo6q0E2x8XQz6bcHeAdx4YWsLUx6Pk2LDEAmHY+OuODM77sHQuuBBTa1jEa1HqyPcBT7SXec7+EWyhu5V4gr+eJUbv1lpI1y411sZKw5lPxX4mswMrUyrrbQ5M1EP6SLAZIBisAq5I8y2MBRCvsb9yfumYU0O2/ztUTzaJ2DCFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584724; c=relaxed/simple;
	bh=NHRNbZyJmvn6//50Ez9sgxUkodWG81K3WgmG02gXRcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfy8g6lk7VHpKeIvKgJk42lES+VRXsrX3QFMWAT/5BeeAjgsfoh48ZFpbm5TERISla7sBWJJW8qXo3j24mmHv350n6N27rGUXctVzFwMHaTETW8FroYICQYrWBoM5M2NZwX3p8yhPGdZyPXIPIl9A5yg0n7JOs46R3jCOQzsHtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsIH+xSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsIH+xSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96174C433F1;
	Mon,  8 Apr 2024 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584724;
	bh=NHRNbZyJmvn6//50Ez9sgxUkodWG81K3WgmG02gXRcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsIH+xSEhljislq3tCh182n2rErWvmppcwsqGhuQUDpsjvhVwKS0Fjtz8Rt6WuHbJ
	 vk5lurC2ONvWJmDfOBAjPRUs54DQ425f6yTI5r+TXwtG0C85wAMujUh6u43C86agfI
	 1HW+sFpZ8fMvtmz52mYdS5DSkm0WlhirzIRyQcq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 535/690] nfsd: update comment over __nfsd_file_cache_purge
Date: Mon,  8 Apr 2024 14:56:41 +0200
Message-ID: <20240408125419.034041697@linuxfoundation.org>
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

[ Upstream commit 972cc0e0924598cb293b919d39c848dc038b2c28 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 786e06cf107ff..1d4c0387c4192 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -906,7 +906,8 @@ nfsd_file_cache_init(void)
  * @net: net-namespace to shut down the cache (may be NULL)
  *
  * Walk the nfsd_file cache and close out any that match @net. If @net is NULL,
- * then close out everything. Called when an nfsd instance is being shut down.
+ * then close out everything. Called when an nfsd instance is being shut down,
+ * and when the exports table is flushed.
  */
 static void
 __nfsd_file_cache_purge(struct net *net)
-- 
2.43.0



