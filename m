Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21111AD41F;
	Mon, 23 Dec 2024 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970249; cv=none; b=NTY9OzhNh3SwtvSz9c6i4EDPuxQPk8b060k19wYKEzJSnvksq2Zz4G18V4rwPd93pM6se7Dzs0KEiKRKDzM66qwYTBJWOVCDWVvbo6g82DeLydxanIFbfvKO+GyMJjlq5rndnKVaH7qR/4ZvIE5Abe1pveHo0ywVwL4pGQBi92I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970249; c=relaxed/simple;
	bh=JYB4NhxSfMsUA7X+sOkxieBJvNW1BawlFz9qMBXNCbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fytKmwr42MLHG2yCWeLyVQUeyNHmcbv6WDgoywzyrHGPV3aA9paFBLZ+wG6XNBjclW57J5g7StnrO15CTkHWQBkvjhIQL6amzPCiDn94ntDHCnMaxo0/YOdV20myW0+DlgCV15+j3+BQ7RB4naAuP9EB6kfMzar5vDBap5Av8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRtUY7ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRtUY7ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622DDC4CED3;
	Mon, 23 Dec 2024 16:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970248;
	bh=JYB4NhxSfMsUA7X+sOkxieBJvNW1BawlFz9qMBXNCbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRtUY7oxYIEq4sMd+RzhpOLxSZ04NtEeyC8NHSis7wW5w6KxZP2E68VlnVlx0wetk
	 Jf55JnL/posTC3pSfzJj4jH9DT7kkjBN3+rBym21pg6FKx52I07+Hm9Fkl0gpTrZQr
	 anzuYAgzh80sZEfdMxjPVl8iRQt5RBKCaaj/lIYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/116] xfs: convert comma to semicolon
Date: Mon, 23 Dec 2024 16:58:17 +0100
Message-ID: <20241223155400.619801931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 7bf888fa26e8f22bed4bc3965ab2a2953104ff96 upstream.

Replace a comma between expression statements by a semicolon.

Fixes: 178b48d588ea ("xfs: remove the for_each_xbitmap_ helpers")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 876a2f41b063..058b6c305224 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -705,7 +705,7 @@ xrep_agfl_init_header(
 	 * step.
 	 */
 	xagb_bitmap_init(&af.used_extents);
-	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
+	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-- 
2.39.5



