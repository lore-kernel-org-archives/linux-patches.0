Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F177D3B47E3;
	Tue, 21 Jul 2026 22:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672918; cv=none; b=hBJVq0NyvZMIVlTGNjbIgapXV2c5PHDfteKa7guTmzm4dtmu7kUBAy20mQbHkApYLf61k5YqIqVuikJKFTY+4Yw0N1HBZy2/hpfPNuaJinBo6x9nh3iRLtm2YZqYXjVAeywWHxkdJvGZqXqdFBGFOdr/kreEZv2PIYdFdJIJqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672918; c=relaxed/simple;
	bh=HKNbiOCOQIsLxrw0z2BmtLjf3SF+6W9gWNMiuHdzb5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZkNcBjt4EDRrf5Xmy26BFP5n3moMKZfrgj77+cFlb4BSn9AbZbel3heh8waA0fGAhnocCTXwjCF1xmkPLhE+xr+v+/ZJib8OHlZu4o4I3EPSJsP3LpcIIaxXI9/RuNQafFnZwVeYtfaQop3JqsaXPjYoKl8SyRUNTY//XgN6+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htyUFbyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htyUFbyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF971F00A3A;
	Tue, 21 Jul 2026 22:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672912;
	bh=LIjzmqNibaZcw6z7w+ZnUcT6g85OnEcLZ6cwIlfBI54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htyUFbyWpxms++T0EtyWlU5n/yaAYXotSJkTmnkYF5hdoRuSRpDgZTNdxOfEzXXsC
	 SnQG/jVpkL5SEcUPatYGPkgJo/AP/c3vKzi4jHHN+TVezcQ/hn3h5M/PT7SRTx9W3R
	 7c2YXJc2CTT3gZkVZjtjfV+c13UBG3aBJXhNG4ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 803/843] xfs: Remove redundant assignment of mp
Date: Tue, 21 Jul 2026 17:27:18 +0200
Message-ID: <20260721152424.129379074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f4901a182d33d05a3b7020e2af97c635f6c47959 ]

mp is being initialized to log->l_mp but this is never read
as record is overwritten later on. Remove the redundant
assignment.

Cleans up the following clang-analyzer warning:

fs/xfs/xfs_log_recover.c:3543:20: warning: Value stored to 'mp' during
its initialization is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Stable-dep-of: cc9af5e461ea ("xfs: use null daddr for unset first bad log block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3579,8 +3579,6 @@ xlog_recover_check_summary(
 	uint64_t		ifree;
 	int			error;
 
-	mp = log->l_mp;
-
 	freeblks = 0LL;
 	itotal = 0LL;
 	ifree = 0LL;


