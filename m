Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEE224EF62;
	Mon, 24 Feb 2025 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407823; cv=none; b=BLrvXFJd036/vgDfxlv+qYnq8xTgpxpr212d8KgvEueDASfPEi5jzmbF9MolkiSFYBVkCgTN5wuiN7dpgpBdx9UwByFgEba94NnkrknqUFew44OV8MOu9vqGYAYRMlF23P0YgVCzwKJdzvkUE2rxObNUmdQCT6KZJfuGLfmgTIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407823; c=relaxed/simple;
	bh=2gYAjBp1A+SkMw3qDZYabhadMmRMtiPFmlrEq5bS5fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knYV5lkONdS05Sh4L3UHHHor0oWwsMeeoLXuFA1xLRTHwBNgXmkKAIM/ocAr0B3Yr632QVbPluzPgv5rCytpphm6vSd5JwboGsikiPXa0eolSrQRMwVe2TYg1YdOExRWv7rR7WpS48QJOvW1CyTLpxQ9FFR4rtcCAWfU3dvYmL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYulucDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYulucDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E334C4CEEF;
	Mon, 24 Feb 2025 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407823;
	bh=2gYAjBp1A+SkMw3qDZYabhadMmRMtiPFmlrEq5bS5fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYulucDObM9SC2xfgBpKOg0Bt8uWCMq3H07cM6g5f5dlPv39/6xuv2lKotccVg3Nd
	 EYt8eVasLvbuNG70u9xwWGf1uN8B4CcWbhqVJ97LyfBK3/vFsi6N/A2e2iB50wWnHi
	 PdhDiYbsQWdC3OiwrF+A/wU6ZL+zkA5hEaD50nXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 002/140] xfs: assert a valid limit in xfs_rtfind_forw
Date: Mon, 24 Feb 2025 15:33:21 +0100
Message-ID: <20250224142603.100295780@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

commit 6d2db12d56a389b3e8efa236976f8dc3a8ae00f0 upstream.

Protect against developers passing stupid limits when refactoring the
RT code once again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -288,6 +288,8 @@ xfs_rtfind_forw(
 	xfs_rtword_t	wdiff;		/* difference from wanted value */
 	int		word;		/* word number in the buffer */
 
+	ASSERT(start <= limit);
+
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */


