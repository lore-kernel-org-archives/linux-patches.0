Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035346;
	b=iDnW9/NPKKWkJGSIsdXqywL/fw4HVPzeaaP2vj1/A6qz3AlL1P80v4m8XqZ3RW8CXrD3
	 zt0Z+0r2QQ68On5s6nXISIVW2QEthx87b8mdiCHdPfDj8oSpm1IDUiQl+qkuowium2n+H
	 JJPG7DyvRbu8uchgs9ho0yfKZa7KPsh9yhHh8tx1wpQ7dbbxv0gbmAP0EUI9lYtYzApVE
	 SdkUYFns3unPu+wEY4Wwi6c1n3Wy9X7YRdgiyOepWfwTtPDY+5D5hZrEzpA6RLPv78hCe
	 434ASHLtxgPztJKWREzIx/AN772An7OHAhOdTG+CIuJA8jrCQQEDhKLV7y7Ky2egRMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IZ6vNeNNnQs1Msvvz2snkJhidKFU0PeN19BnIkYcAQ=;
	b=QVM+C60WIemAQDI+S7/4qS+BnlOHOoL0LAPrCxBp0gzxBWTqQI6GozCSzYifFpHlBcf6
	 8nuBHdGTQSgLu1VezEuKcDiZoHpIdYlxOlioVp1RqauWlMMULzf3kUQjYsxVDRhCnceKB
	 UyPYBdZx/MM7if78NFQl8EqrB5lyH5E7RbwuIFMCBZpjmS7op7mtpcVpU5em4fvA3/fS5
	 hLG/mp2tsnMftbNywVm6Oti7LoIrs8ofKJgxqF+nJN29X/7CvzmJ+6JeNx+jPG/Mtr1Nh
	 7Xyd5iT4sHs0Bts6HcMkFIw2Qa4XsGAybNjbJSUsZDqA4azQFQC58Et2G8fQzEIwW0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCQw4UXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7D8606A320;
	Wed, 18 Nov 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCQw4UXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730081F000C4;
	Wed, 18 Nov 2026 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035346;
	bh=7IZ6vNeNNnQs1Msvvz2snkJhidKFU0PeN19BnIkYcAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCQw4UXMbar4SJE6lM5T4+b5OVJdFIaNQfHvnzV/P8ndDW8h8QiY2ud06XVnEsQIr
	 bXyxUbGXDbu8LWeC50usCDCtMcrG3k7m0dPKYaeDsRCURr5B/HrBCE6lABd0xbqfFj
	 Kwzo8w91iC7ZJoMKF7nL8rhiG0h+XJdxDt+XSySw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0671/3318] xfs: dont rescan ifree and icount when frozen
Date: Wed, 18 Nov 2026 15:21:33 +0100
Message-ID: <20261118150338.261618997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 18028768415e3c05ab7edb22d740e2f4dc52836a upstream.

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -380,6 +380,11 @@ retry:
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;


