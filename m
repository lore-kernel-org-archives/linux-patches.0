Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1225286D4D;
	Tue, 17 Feb 2026 20:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360852; cv=none; b=OxrbydSwRpBf2V35NwrLQY/98x3xgf9KIVBkQc/jwCZs/cAGNEBUTKaKH+juDFscODrdh1wzcRToKOkxD1Oxs+PEE8l88/ioCGIpNj8GHNnspdhkeT4Tm9m0l7mmTf1pt48uz0dPL81cMiRg7ag9yGHVDWkecSyKvDuCxwidnrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360852; c=relaxed/simple;
	bh=fU0uyYb/Rwsdk80sRpFdaC9gjm/ZEhw46wWUSgjgyNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr17wwL3rRq1AzObPnLn+LJP7aa+Y5NFrCuyuAOwOP2ReXXaWFW8rungyVjsWh4fDRhExnl6Fa3Vw/dl2EGrJGlP46xnGeukugwki1PBmLfQ47CiNZZbgh2s0epljqTgxttRfp6+AHLPBK7xawqiar9WAVc3K81dnWS8OjnwjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eU+Oz+93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eU+Oz+93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F8DC4CEF7;
	Tue, 17 Feb 2026 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360851;
	bh=fU0uyYb/Rwsdk80sRpFdaC9gjm/ZEhw46wWUSgjgyNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eU+Oz+93OPDQ0zyIUiCjXLSUWL3MHuA60YQl3IirmjNd1zXC6voO1lUYE6VTnwqBO
	 M3S73LqSDHQygzXeunq3M2dRY6b/DL+LFZd167ANLEZxcazjerC9o5HYL9duc/MTsV
	 a3Eh28FPcZpBTqSnQGrnKk+6VkrAUlZEUvcZSYt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 32/39] f2fs: fix to add gc count stat in f2fs_gc_range
Date: Tue, 17 Feb 2026 21:30:54 +0100
Message-ID: <20260217200005.443068543@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

commit 761dac9073cd67d4705a94cd1af674945a117f4c upstream.

It missed the stat count in f2fs_gc_range.

Cc: stable@kernel.org
Fixes: 9bf1dcbdfdc8 ("f2fs: fix to account gc stats correctly")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1998,6 +1998,7 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 	unsigned int segno;
 	unsigned int gc_secs = dry_run_sections;
 
+	stat_inc_gc_call_count(sbi, FOREGROUND);
 	for (segno = start_seg; segno <= end_seg; segno += SEGS_PER_SEC(sbi)) {
 		struct gc_inode_list gc_list = {
 			.ilist = LIST_HEAD_INIT(gc_list.ilist),


