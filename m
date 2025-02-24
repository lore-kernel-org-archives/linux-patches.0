Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2233E1624D3;
	Mon, 24 Feb 2025 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407813; cv=none; b=QOXrE35wTRcE6+sGsRAPfmocmHu+mLSCpn7tLYkYKQIjCxicodQNv2+qho4XDMZbYFJyBFEMRIsfg5QieyJg6C2BChrnAiDrtyvenoAwdm3FusqNSbXvUI1XEZGBP/q9yKLxcUW+IvMsNr6rn5pAwHm8wWyGA6BitHiSe/kH+7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407813; c=relaxed/simple;
	bh=Ds6k4LA48e/iO9G/NPyJC/DI3jikaYS2WgcP7qOAg4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8uc8pn2Mgs4UqCMp+5yH+799aVbu89B4XIH1HXzyjfsGs+La6ZsHJxoOaAWwBRP05eFNB9dSLD7v6FXVv4EeOcf51XmfxLXHO2gSZj4Yw2p4HOXiu+tTLSB0LkKzWyNmCLPfDE8U7S62MPcWL1GxaDTGGd1vey5n1xMfuEHWKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDt9sl1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDt9sl1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D06C4CED6;
	Mon, 24 Feb 2025 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407812;
	bh=Ds6k4LA48e/iO9G/NPyJC/DI3jikaYS2WgcP7qOAg4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDt9sl1WJ0ZtigPh+DdnXvigutGlr57OO6NMidD673BRSknUWtKvSX0qdregf1YmM
	 02jmR8RXXBwCRNmyNFsl5f81NXb6p6ZtjEXkJdbRCGM2GUOOJb5EqlfGIE/dljhbNw
	 qMurk9xOoZJ8ZCA2OM2RJugZr3ED6qs6stYDEPdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.6 017/140] xfs: Remove empty declartion in header file
Date: Mon, 24 Feb 2025 15:33:36 +0100
Message-ID: <20250224142603.682689808@linuxfoundation.org>
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

From: Zhang Zekun <zhangzekun11@huawei.com>

commit f6225eebd76f371dab98b4d1c1a7c1e255190aef upstream.

The definition of xfs_attr_use_log_assist() has been removed since
commit d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c").
So, Remove the empty declartion in header files.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -161,6 +161,5 @@ bool	  xlog_force_shutdown(struct xlog *
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
-int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */


