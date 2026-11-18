Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044513;
	b=0g5dm3BldVdXoDfcF+8TcoOY1ixJ8oifjm1mDmxmDSJ2YwXuWClEXjikmyDLa8bZNuKD
	 dhpG7lE0kJ3QH0FxbqmIDP+dwjtDM06sMAJWu9g5wdISZUjnqC8ka6GFUHOMTZq7tTy6+
	 pYwDO/B71YrIKfoVxJ9dtCXHLbJTUOlErYx5i18O+0dPN+Xrq3o4V58IpuZffMxaWP1x6
	 F/BtROB3RsAU7t+VWeS4jHbyDVXUXISSlSDS21SHPUX++9jXO/k4WPWmMzHsGI0sMmPjg
	 C4uYSr+K+ETJ9geCzMPcXobIusRmbV6K5Kvv2fiS/u7zf6QfcAMe2gUPqb0/eR9/dCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oddJmWcP+KI4+7e7tko0o+YO5vqg7CAft/ee3gu8zX4=;
	b=XUDB8sIEyg4gZVyFZGwx3Y11FQ4+O6zrItVKO7pZis3d/Oy67G3P7s400xhGnDnkuCF1
	 ROAiIvZGtKgQNsiK6JeUhD8qOJa1FtwwOWFMHAWgMSBE20CEbMptLhlfmeUAXmnuWUMOE
	 jO4uS37Tm60aGkx1dUmlNAS72/jlYhqDDGp57eHI20jDDm09QEGbbD/4X6NeYWytABGIS
	 2C+C2BCLCS21ktw6nkKCQCAyKtfSBOhvX9HmDFGhK8oXrnSdK9427KmRLshiALMRy5qQq
	 Q0YShkA2ugrJHN5jvEUm44dBPcBa5YaZss7kO3/xH3QP7cRcMMG08ucYAJINMb9i7Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJOYUTK6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AB60A2620;
	Wed, 18 Nov 2026 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJOYUTK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA11F000C8;
	Wed, 18 Nov 2026 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044512;
	bh=oddJmWcP+KI4+7e7tko0o+YO5vqg7CAft/ee3gu8zX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJOYUTK64rLIB4hLBaHhTp1WA7GyrNFOibdWgCdXDEjLw8BOiMt0jjt1wjGY6Y3tz
	 WVdXbBidEx4Qf2K0hdfM1gFws7crLPMVjsL86lcbp6yNp/qSwxOcLmoVKEYxlUUwRU
	 MUnstzf1SVPqa0hyJmhvaHUBu/cxrMgRUrgfzTVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0594/2857] xfs: propagate errors while checking null siblings
Date: Wed, 18 Nov 2026 15:27:08 +0100
Message-ID: <20261118150222.874609801@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e5bde75a816b3549942f4b09a8bf09006b7ea9de upstream.

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -236,9 +236,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 


